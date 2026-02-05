// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user_list_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$UserListState {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UserListState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'UserListState()';
}


}

/// @nodoc
class $UserListStateCopyWith<$Res>  {
$UserListStateCopyWith(UserListState _, $Res Function(UserListState) __);
}


/// Adds pattern-matching-related methods to [UserListState].
extension UserListStatePatterns on UserListState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( UserListInitial value)?  initial,TResult Function( UserListLoading value)?  loading,TResult Function( UserListSuccess value)?  success,TResult Function( UserListError value)?  error,required TResult orElse(),}){
final _that = this;
switch (_that) {
case UserListInitial() when initial != null:
return initial(_that);case UserListLoading() when loading != null:
return loading(_that);case UserListSuccess() when success != null:
return success(_that);case UserListError() when error != null:
return error(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( UserListInitial value)  initial,required TResult Function( UserListLoading value)  loading,required TResult Function( UserListSuccess value)  success,required TResult Function( UserListError value)  error,}){
final _that = this;
switch (_that) {
case UserListInitial():
return initial(_that);case UserListLoading():
return loading(_that);case UserListSuccess():
return success(_that);case UserListError():
return error(_that);case _:
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( UserListInitial value)?  initial,TResult? Function( UserListLoading value)?  loading,TResult? Function( UserListSuccess value)?  success,TResult? Function( UserListError value)?  error,}){
final _that = this;
switch (_that) {
case UserListInitial() when initial != null:
return initial(_that);case UserListLoading() when loading != null:
return loading(_that);case UserListSuccess() when success != null:
return success(_that);case UserListError() when error != null:
return error(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  initial,TResult Function()?  loading,TResult Function()?  success,TResult Function( String message)?  error,required TResult orElse(),}) {final _that = this;
switch (_that) {
case UserListInitial() when initial != null:
return initial();case UserListLoading() when loading != null:
return loading();case UserListSuccess() when success != null:
return success();case UserListError() when error != null:
return error(_that.message);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  initial,required TResult Function()  loading,required TResult Function()  success,required TResult Function( String message)  error,}) {final _that = this;
switch (_that) {
case UserListInitial():
return initial();case UserListLoading():
return loading();case UserListSuccess():
return success();case UserListError():
return error(_that.message);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  initial,TResult? Function()?  loading,TResult? Function()?  success,TResult? Function( String message)?  error,}) {final _that = this;
switch (_that) {
case UserListInitial() when initial != null:
return initial();case UserListLoading() when loading != null:
return loading();case UserListSuccess() when success != null:
return success();case UserListError() when error != null:
return error(_that.message);case _:
  return null;

}
}

}

/// @nodoc


class UserListInitial implements UserListState {
  const UserListInitial();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UserListInitial);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'UserListState.initial()';
}


}




/// @nodoc


class UserListLoading implements UserListState {
  const UserListLoading();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UserListLoading);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'UserListState.loading()';
}


}




/// @nodoc


class UserListSuccess implements UserListState {
  const UserListSuccess();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UserListSuccess);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'UserListState.success()';
}


}




/// @nodoc


class UserListError implements UserListState {
  const UserListError(this.message);
  

 final  String message;

/// Create a copy of UserListState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UserListErrorCopyWith<UserListError> get copyWith => _$UserListErrorCopyWithImpl<UserListError>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UserListError&&(identical(other.message, message) || other.message == message));
}


@override
int get hashCode => Object.hash(runtimeType,message);

@override
String toString() {
  return 'UserListState.error(message: $message)';
}


}

/// @nodoc
abstract mixin class $UserListErrorCopyWith<$Res> implements $UserListStateCopyWith<$Res> {
  factory $UserListErrorCopyWith(UserListError value, $Res Function(UserListError) _then) = _$UserListErrorCopyWithImpl;
@useResult
$Res call({
 String message
});




}
/// @nodoc
class _$UserListErrorCopyWithImpl<$Res>
    implements $UserListErrorCopyWith<$Res> {
  _$UserListErrorCopyWithImpl(this._self, this._then);

  final UserListError _self;
  final $Res Function(UserListError) _then;

/// Create a copy of UserListState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? message = null,}) {
  return _then(UserListError(
null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
