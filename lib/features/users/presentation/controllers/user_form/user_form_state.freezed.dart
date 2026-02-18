// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user_form_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$UserFormState {
  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is UserFormState);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() {
    return 'UserFormState()';
  }
}

/// @nodoc
class $UserFormStateCopyWith<$Res> {
  $UserFormStateCopyWith(UserFormState _, $Res Function(UserFormState) __);
}

/// Adds pattern-matching-related methods to [UserFormState].
extension UserFormStatePatterns on UserFormState {
  /// A variant of `map` that fallback to returning `orElse`.
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case final Subclass value:
  ///     return ...;
  ///   case _:
  ///     return orElse();
  /// }
  /// ```

  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(UserFormInitial value)? initial,
    TResult Function(UserFormSaving value)? saving,
    TResult Function(UserFormSuccess value)? success,
    TResult Function(UserFormError value)? error,
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case UserFormInitial() when initial != null:
        return initial(_that);
      case UserFormSaving() when saving != null:
        return saving(_that);
      case UserFormSuccess() when success != null:
        return success(_that);
      case UserFormError() when error != null:
        return error(_that);
      case _:
        return orElse();
    }
  }

  /// A `switch`-like method, using callbacks.
  ///
  /// Callbacks receives the raw object, upcasted.
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case final Subclass value:
  ///     return ...;
  ///   case final Subclass2 value:
  ///     return ...;
  /// }
  /// ```

  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(UserFormInitial value) initial,
    required TResult Function(UserFormSaving value) saving,
    required TResult Function(UserFormSuccess value) success,
    required TResult Function(UserFormError value) error,
  }) {
    final _that = this;
    switch (_that) {
      case UserFormInitial():
        return initial(_that);
      case UserFormSaving():
        return saving(_that);
      case UserFormSuccess():
        return success(_that);
      case UserFormError():
        return error(_that);
      case _:
        throw StateError('Unexpected subclass');
    }
  }

  /// A variant of `map` that fallback to returning `null`.
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case final Subclass value:
  ///     return ...;
  ///   case _:
  ///     return null;
  /// }
  /// ```

  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(UserFormInitial value)? initial,
    TResult? Function(UserFormSaving value)? saving,
    TResult? Function(UserFormSuccess value)? success,
    TResult? Function(UserFormError value)? error,
  }) {
    final _that = this;
    switch (_that) {
      case UserFormInitial() when initial != null:
        return initial(_that);
      case UserFormSaving() when saving != null:
        return saving(_that);
      case UserFormSuccess() when success != null:
        return success(_that);
      case UserFormError() when error != null:
        return error(_that);
      case _:
        return null;
    }
  }

  /// A variant of `when` that fallback to an `orElse` callback.
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case Subclass(:final field):
  ///     return ...;
  ///   case _:
  ///     return orElse();
  /// }
  /// ```

  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? saving,
    TResult Function(UserEntity? user)? success,
    TResult Function(String message)? error,
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case UserFormInitial() when initial != null:
        return initial();
      case UserFormSaving() when saving != null:
        return saving();
      case UserFormSuccess() when success != null:
        return success(_that.user);
      case UserFormError() when error != null:
        return error(_that.message);
      case _:
        return orElse();
    }
  }

  /// A `switch`-like method, using callbacks.
  ///
  /// As opposed to `map`, this offers destructuring.
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case Subclass(:final field):
  ///     return ...;
  ///   case Subclass2(:final field2):
  ///     return ...;
  /// }
  /// ```

  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() saving,
    required TResult Function(UserEntity? user) success,
    required TResult Function(String message) error,
  }) {
    final _that = this;
    switch (_that) {
      case UserFormInitial():
        return initial();
      case UserFormSaving():
        return saving();
      case UserFormSuccess():
        return success(_that.user);
      case UserFormError():
        return error(_that.message);
      case _:
        throw StateError('Unexpected subclass');
    }
  }

  /// A variant of `when` that fallback to returning `null`
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case Subclass(:final field):
  ///     return ...;
  ///   case _:
  ///     return null;
  /// }
  /// ```

  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? saving,
    TResult? Function(UserEntity? user)? success,
    TResult? Function(String message)? error,
  }) {
    final _that = this;
    switch (_that) {
      case UserFormInitial() when initial != null:
        return initial();
      case UserFormSaving() when saving != null:
        return saving();
      case UserFormSuccess() when success != null:
        return success(_that.user);
      case UserFormError() when error != null:
        return error(_that.message);
      case _:
        return null;
    }
  }
}

/// @nodoc

class UserFormInitial implements UserFormState {
  const UserFormInitial();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is UserFormInitial);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() {
    return 'UserFormState.initial()';
  }
}

/// @nodoc

class UserFormSaving implements UserFormState {
  const UserFormSaving();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is UserFormSaving);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() {
    return 'UserFormState.saving()';
  }
}

/// @nodoc

class UserFormSuccess implements UserFormState {
  const UserFormSuccess([this.user]);

  final UserEntity? user;

  /// Create a copy of UserFormState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $UserFormSuccessCopyWith<UserFormSuccess> get copyWith =>
      _$UserFormSuccessCopyWithImpl<UserFormSuccess>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is UserFormSuccess &&
            (identical(other.user, user) || other.user == user));
  }

  @override
  int get hashCode => Object.hash(runtimeType, user);

  @override
  String toString() {
    return 'UserFormState.success(user: $user)';
  }
}

/// @nodoc
abstract mixin class $UserFormSuccessCopyWith<$Res>
    implements $UserFormStateCopyWith<$Res> {
  factory $UserFormSuccessCopyWith(
          UserFormSuccess value, $Res Function(UserFormSuccess) _then) =
      _$UserFormSuccessCopyWithImpl;
  @useResult
  $Res call({UserEntity? user});
}

/// @nodoc
class _$UserFormSuccessCopyWithImpl<$Res>
    implements $UserFormSuccessCopyWith<$Res> {
  _$UserFormSuccessCopyWithImpl(this._self, this._then);

  final UserFormSuccess _self;
  final $Res Function(UserFormSuccess) _then;

  /// Create a copy of UserFormState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  $Res call({
    Object? user = freezed,
  }) {
    return _then(UserFormSuccess(
      freezed == user
          ? _self.user
          : user // ignore: cast_nullable_to_non_nullable
              as UserEntity?,
    ));
  }
}

/// @nodoc

class UserFormError implements UserFormState {
  const UserFormError(this.message);

  final String message;

  /// Create a copy of UserFormState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $UserFormErrorCopyWith<UserFormError> get copyWith =>
      _$UserFormErrorCopyWithImpl<UserFormError>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is UserFormError &&
            (identical(other.message, message) || other.message == message));
  }

  @override
  int get hashCode => Object.hash(runtimeType, message);

  @override
  String toString() {
    return 'UserFormState.error(message: $message)';
  }
}

/// @nodoc
abstract mixin class $UserFormErrorCopyWith<$Res>
    implements $UserFormStateCopyWith<$Res> {
  factory $UserFormErrorCopyWith(
          UserFormError value, $Res Function(UserFormError) _then) =
      _$UserFormErrorCopyWithImpl;
  @useResult
  $Res call({String message});
}

/// @nodoc
class _$UserFormErrorCopyWithImpl<$Res>
    implements $UserFormErrorCopyWith<$Res> {
  _$UserFormErrorCopyWithImpl(this._self, this._then);

  final UserFormError _self;
  final $Res Function(UserFormError) _then;

  /// Create a copy of UserFormState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  $Res call({
    Object? message = null,
  }) {
    return _then(UserFormError(
      null == message
          ? _self.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

// dart format on
