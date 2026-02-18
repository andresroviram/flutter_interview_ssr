# Sistema de Gestión de Usuarios y Direcciones - Flutter

Sistema profesional de gestión de usuarios y direcciones desarrollado con Flutter siguiendo Clean Architecture

## Capturas de Pantalla

<div align="center">

<table>
  <tr>
    <td align="center">
      <img src="screenshots/Simulator Screenshot - iPhone 17 Pro Max - 2026-02-05 at 13.12.37.png" width="250" alt="Lista de Usuarios"/>
      <br/>
      <b>Lista de Usuarios</b>
    </td>
    <td align="center">
      <img src="screenshots/Simulator Screenshot - iPhone 17 Pro Max - 2026-02-05 at 13.13.14.png" width="250" alt="Detalle de Usuario"/>
      <br/>
      <b>Detalle de Usuario</b>
    </td>
    <td align="center">
      <img src="screenshots/Simulator Screenshot - iPhone 17 Pro Max - 2026-02-05 at 13.15.58.png" width="250" alt="Formulario de Usuario"/>
      <br/>
      <b>Formulario de Usuario</b>
    </td>
  </tr>
  <tr>
    <td align="center">
      <img src="screenshots/Simulator Screenshot - iPhone 17 Pro Max - 2026-02-05 at 13.15.34.png" width="250" alt="Lista de Direcciones"/>
      <br/>
      <b>Lista de Direcciones</b>
    </td>
    <td align="center">
      <img src="screenshots/Simulator Screenshot - iPhone 17 Pro Max - 2026-02-05 at 13.28.29.png" width="250" alt="Filtros Avanzados"/>
      <br/>
      <b>Filtros Avanzados</b>
    </td>
    <td align="center">
      <img src="screenshots/Simulator Screenshot - iPhone 17 Pro Max - 2026-02-05 at 13.16.18.png" width="250" alt="Buscador"/>
      <br/>
      <b>Buscador</b>
    </td>
  </tr>
</table>

</div>

## 🏗️ Arquitectura

Este proyecto implementa **Feature-First Clean Architecture** con separación en 3 capas:

```
lib/
├── core/                           # Código compartido
│   ├── error/                      # Manejo de errores
│   ├── router/                     # Navegación (Go Router)
│   ├── theme/                      # Sistema de diseño Material 3
│   ├── utils/                      # Utilidades y filtros
│   │   ├── validators.dart         # Validaciones de formularios
│   │   ├── formatters.dart         # Formateadores de datos
│   │   └── filters.dart            # Modelos de filtros
│   └── result.dart                 # Result Pattern
│
├── components/                     # Widgets reutilizables globales
│   └── widgets/
│       ├── confirmation_dialog.dart    # Dialog con glass effect
│       ├── shimmer_loading.dart        # 6 widgets shimmer
│       ├── glass_container.dart        # 5 widgets glass morphism
│       ├── animated_widgets.dart       # 7 widgets con animaciones
│       ├── filters_panel.dart          # Panel de filtros con glass
│       └── pagination_widgets.dart     # Sistema de paginación
│
└── features/                       # Features del negocio
    ├── users/
    │   ├── data/                   # Capa de datos
    │   │   ├── datasources/        # Fuentes de datos (Drift SQLite)
    │   │   ├── models/             # Modelos serializables
    │   │   └── repositories/       # Implementación de repositorios
    │   ├── domain/                 # Lógica de negocio
    │   │   ├── entities/           # Entidades de dominio
    │   │   ├── repositories/       # Contratos de repositorios
    │   │   └── usecases/           # Casos de uso
    │   └── presentation/           # UI
    │       ├── controllers/        # Estados y Notifiers
    │       ├── providers/          # Providers de Riverpod
    │       ├── screens/            # Pantallas
    │       └── widgets/            # Widgets específicos
    │
    └── addresses/                  # Estructura similar a users
```

## ✅ Funcionalidades Implementadas

### Core Layer

✅ Result Pattern para manejo funcional de errores  
✅ Hierarchy completa de Failures y Exceptions  
✅ Sistema de tema Material 3 con colores personalizados  
✅ Validadores para formularios (email, teléfono, edad, etc.)  
✅ Formateadores de datos (fechas, teléfonos, moneda)  
✅ Debouncer y Throttler para optimización

### Feature: Users

**Domain Layer:**

✅ Entidad UserEntity con propiedades calculadas  
✅ Repository interface (IUserRepository)  
✅ UseCases con lógica de negocio

**Data Layer:**

✅ Modelo serializable con json_serializable  
✅ DataSource Drift con operaciones CRUD completas y migraciones  
✅ Repository implementation con manejo de errores

**Presentation Layer:**

✅ Controllers con Freezed (UserListNotifier, UserFormNotifier)  
✅ Providers de Riverpod configurados  
✅ Screens: Lista, Detalle y Formulario  
✅ Widgets: UserCard, SearchBar, BirthDatePicker

### Feature: Addresses

**Domain Layer:**

✅ Entidad AddressEntity con enum para etiquetas  
✅ Repository interface (IAddressRepository)  
✅ UseCases con lógica de dirección principal

**Data Layer:**

✅ Modelo serializable con json_serializable  
✅ DataSource Drift con gestión de direcciones y relaciones  
✅ Repository implementation con manejo de errores

**Presentation Layer:**

✅ Controllers con Freezed (AddressFormNotifier)  
✅ Providers de Riverpod configurados  
✅ Screens: Lista de direcciones y Formulario  
✅ Integración con feature Users

### Navegación (Go Router)

✅ Rutas configuradas para todas las pantallas  
✅ Navegación con parámetros y estado (extra)  
✅ Deep linking preparado

### UI/UX Improvements

✅ **Shimmer Loading States** - 6 widgets profesionales
  - UserListShimmer, UserCardShimmer, UserDetailShimmer
  - AddressListShimmer, AddressCardShimmer
  - ShimmerLoading base configurable

✅ **Glass Morphism Effects** - 5 componentes modernos
  - GlassContainer, GlassCard, GlassDialog
  - GlassAppBar, GlassBottomSheet
  - Backdrop filter con gradientes adaptativos

✅ **Animaciones de Transición** - 7 widgets animados
  - FadeInWidget, SlideInWidget (con fade combinado)
  - ScaleInWidget, BounceWidget, AnimatedListView
  - CustomPageTransition para Go Router
  - Animaciones configurables y staggered delays

✅ **Sistema de Filtros Avanzados** - Filtrado inteligente
  - UserFiltersPanel con bottom sheet glass
  - Filtros por rango de edad (dual slider)
  - Ordenamiento por nombre, edad, email, fecha
  - ActiveFiltersBar con chips removibles
  - Contador de filtros activos con Badge

✅ Adaptación automática Dark/Light mode  
✅ Transiciones suaves entre estados  
✅ UsersListEnhancedScreen - Versión completa con todas las mejoras

## 🔧 Stack Tecnológico

```yaml
# State Management
flutter_riverpod: ^3.0.3

# Navigation
go_router: ^17.0.1

# Local Storage & Database
drift: ^2.31.0
sqlite3_flutter_libs: ^0.5.24
path_provider: ^2.1.5
path: ^1.9.1
sqlite3_web: ^0.1.1  # Web support
web: ^1.1.0  # Web support

# Code Generation
json_annotation: ^4.9.0
freezed_annotation: ^3.1.0
build_runner: ^2.10.4
json_serializable: ^6.11.2
freezed: ^3.2.3
drift_dev: ^2.31.0
build_web_compilers: ^4.0.11  # Web worker compilation

# Utils
intl: ^0.20.2
equatable: ^2.0.8

# UI
shimmer: ^3.0.0

# Testing
mocktail: ^1.0.4
```

## 🚀 Comandos Útiles

```bash
# Instalar dependencias
flutter pub get

# Generar código (models, freezed)
dart run build_runner build --delete-conflicting-outputs

# Watch mode para desarrollo
dart run build_runner watch

# Run app
flutter run

# Tests
flutter test

# Tests con cobertura
flutter test --coverage

# Análisis de código
flutter analyze
```

## 📝 Validaciones Implementadas

### Usuario
- **Nombre**: Requerido, mín. 2 caracteres
- **Apellido**: Requerido, mín. 2 caracteres
- **Fecha de nacimiento**: Edad entre 18-100 años
- **Email**: Formato válido, único
- **Teléfono**: Formato 10 dígitos

### Dirección
- **Calle**: Requerido
- **Colonia/Barrio**: Requerido
- **Ciudad**: Requerido
- **Estado**: Requerido
- **Código Postal**: 5 dígitos
- **Etiqueta**: Casa, Trabajo, Otro
- **Principal**: Solo una por usuario

## 🎯 Decisiones Arquitectónicas

**Feature-First**: Escalabilidad y modularidad  
**Riverpod sin codegen**: Simplicidad y type safety  
**Result Pattern**: Errores explícitos y funcionales  
**Drift (SQLite)**: Base de datos relacional con ORM type-safe, soporte multi-plataforma (mobile, desktop, web con WASM)
## 🌐 Soporte Web

Este proyecto incluye soporte completo para Flutter Web utilizando Drift con SQLite WASM:

✅ **WasmDatabase** - SQLite ejecutándose en el navegador con WebAssembly  
✅ **Web Worker** - Base de datos en background thread para mejor performance  
✅ **IndexedDB Storage** - Persistencia de datos en el navegador  
✅ **Mismo código** - Sin cambios en la lógica de negocio entre plataformas

### Ejecutar en Web

```bash
# Configurar assets web (primera vez)
.\setup_web.ps1  # Windows
# o
./setup_web.sh   # Linux/Mac

# Ejecutar en Chrome
flutter run -d chrome --web-port=8080

# Compilar para producción
flutter build web --release
```

Para más detalles sobre la configuración web, consulta [WEB_SUPPORT.md](WEB_SUPPORT.md).

## 🚀 Deployment

Este proyecto incluye configuración completa de CI/CD con **Fastlane** y **GitHub Actions** para despliegue automatizado a:

✅ **Google Play Store** (Internal, Beta, Production)  
✅ **Apple App Store** (TestFlight, App Store)  
✅ **Web Hosting** (GitHub Pages, Firebase, Vercel)

### Quick Start

```bash
# Android
cd android
bundle install
bundle exec fastlane internal  # Deploy to Internal Testing

# iOS (macOS only)
cd ios
bundle install  
bundle exec fastlane beta  # Deploy to TestFlight
```

### CI/CD Workflows

- **CI** - Tests, análisis y cobertura en cada push
- **Deploy Android** - Despliegue automático a Google Play
- **Deploy iOS** - Despliegue automático a App Store  
- **Deploy Web** - Despliegue automático a hosting web

Para configuración detallada, consulta [DEPLOYMENT.md](DEPLOYMENT.md).
