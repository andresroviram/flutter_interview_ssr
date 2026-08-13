# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project

Flutter app (users + addresses CRUD) built with Feature-First Clean Architecture, Riverpod (no codegen), go_router, and Drift/SQLite. Runs on mobile, desktop, and web (SQLite WASM). UI strings, comments, and docs in this repo are written in Spanish; follow that convention when editing existing files.

Flutter version is pinned via FVM (`.fvmrc`: 3.38.9). If `flutter` on PATH mismatches, prefix commands with `fvm` (e.g. `fvm flutter test`).

## Commands

```bash
flutter pub get

# REQUIRED before the app or tests compile — *.g.dart / *.freezed.dart are gitignored
dart run build_runner build --delete-conflicting-outputs
dart run build_runner watch          # during development

flutter run
flutter analyze
dart format --set-exit-if-changed .  # CI fails on unformatted code

flutter test
flutter test test/core/result_test.dart                    # single file
flutter test --plain-name "should return Success"          # single test by name
flutter test --coverage
./scripts/check_coverage.sh [threshold]                    # default threshold 60
```

Web requires one-time asset setup (downloads `sqlite3.wasm`, compiles the Drift worker into `web/`):

```bash
./scripts/setup_web.sh            # scripts/setup_web.ps1 on Windows
flutter run -d chrome --web-port=8080
```

CI (`.github/workflows/ci.yml`) runs: pub get → build_runner → `dart format --set-exit-if-changed` → analyze → `flutter test --coverage` → Codecov. The 60% coverage gate currently only warns.

## Architecture

Three layers per feature under `lib/features/<feature>/`, plus shared `lib/core/` and cross-feature widgets in `lib/components/widgets/`.

**Dependency flow:** `screen → provider → UseCases → IRepository → RepositoryImpl → IDataSource → DataSourceImpl → AppDatabase (Drift)`. Domain never imports data or Flutter.

**Result pattern (`lib/core/result.dart`)** — the spine of error handling. `Result<T>` is a sealed class (`Success<T>` / `Failure<T>` carrying a `Failures`) with `map`, `flatMap`, `fold`, `isSuccess`, `valueOrNull`, `errorOrNull`. The conversion boundaries are fixed:

- DataSource impls catch Drift errors and **throw** typed exceptions from `core/error/exceptions.dart` (`StorageException`, `NotFoundException`, …).
- Repository impls catch those and **return** `Failure(<matching Failures>)` from `core/error/failures.dart`; unexpected errors become `UnknownFailure`. Repositories never throw.
- UseCases compose Results with `fold`/`flatMap` and hold business rules (e.g. `AddressUseCases` enforces exactly one primary address per user: first address auto-becomes primary, promoting one demotes the rest, deleting the primary reassigns it).
- Riverpod `FutureProvider`s unwrap the Result and `throw` on failure so the UI can use `AsyncValue.when`.

**State management** — Riverpod without code generation. Providers are declared manually in `presentation/providers/*_providers.dart` and wire the whole chain (`databaseProvider → dataSource → repository → useCases → data providers`). Feature state lives in `presentation/controllers/<topic>/` as a Freezed union state + a `Notifier`. Derived data (filtering, sorting) is computed in plain `Provider`s over the async source, not inside notifiers.

**Database** — Drift, `schemaVersion 1`, tables in `lib/core/database/tables/`. Platform selection happens through conditional exports in `core/database/connection/shared.dart` (`connection_io.dart` for FFI, `connection_web.dart` for WASM, `connection_unsupported.dart` otherwise) — never import a connection file directly. `AppDatabase.forTesting(executor)` exists for in-memory test databases.

**Navigation** — all routes in `lib/core/router/app_router.dart`, exposed via `appRouterProvider`. Entities are passed through `state.extra` (a `UserEntity`, or a `Map<String, dynamic>` with `user`/`address` for address editing), so path params are not the source of truth — deep-linking a route without `extra` will throw on the cast.

**Shared widgets** — `lib/components/widgets/{glass,shimmers,animated,filters,pagination}/`, each folder exposing a barrel file (`glass.dart`, `shimmers.dart`, …). Import the barrel, and add new widgets to it.

## Conventions

- Tests mirror `lib/` under `test/`. Mocks use **mocktail** (`class MockX extends Mock implements IX {}`) — no build_runner mocks. Repository/usecase tests mock the layer below; datasource tests use `AppDatabase.forTesting(NativeDatabase.memory())` with `tearDown` closing the DB; widget tests pump the widget inside a `MaterialApp` (plus a `ProviderScope` only when the widget reads providers).
- Interfaces are prefixed `I` (`IUserRepository`, `IUserDataSource`); implementations suffixed `Impl`.
- Within a feature use relative imports; cross-feature and router imports use `package:flutter_interview_ssr/...`.
- Validation rules live in `core/utils/validators.dart` and formatting in `core/utils/formatters.dart` — reuse them instead of inlining regex in forms.

## Gotchas

- A missing `dart run build_runner build` is the cause of most "getter isn't defined" / missing `_$Foo` errors — generated files are not committed.
- `README.md`'s directory tree is outdated (it lists flat files like `components/widgets/glass_container.dart` and `core/utils/filters.dart`); trust the actual tree — widgets are in subfolders and filter models live in `core/models/`.
- `users_list_screen.dart` is dead code; the router uses `users_list_enhanced_screen.dart`. Edit the enhanced screen.
- `database.db` at the repo root and `build_web/` are build artifacts, not sources.
