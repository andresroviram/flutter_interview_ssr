// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'address_form_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$AddressFormState {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AddressFormState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'AddressFormState()';
}


}

/// @nodoc
class $AddressFormStateCopyWith<$Res>  {
$AddressFormStateCopyWith(AddressFormState _, $Res Function(AddressFormState) __);
}


/// Adds pattern-matching-related methods to [AddressFormState].
extension AddressFormStatePatterns on AddressFormState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( AddressFormInitial value)?  initial,TResult Function( AddressFormSaving value)?  saving,TResult Function( AddressFormSuccess value)?  success,TResult Function( AddressFormError value)?  error,required TResult orElse(),}){
final _that = this;
switch (_that) {
case AddressFormInitial() when initial != null:
return initial(_that);case AddressFormSaving() when saving != null:
return saving(_that);case AddressFormSuccess() when success != null:
return success(_that);case AddressFormError() when error != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( AddressFormInitial value)  initial,required TResult Function( AddressFormSaving value)  saving,required TResult Function( AddressFormSuccess value)  success,required TResult Function( AddressFormError value)  error,}){
final _that = this;
switch (_that) {
case AddressFormInitial():
return initial(_that);case AddressFormSaving():
return saving(_that);case AddressFormSuccess():
return success(_that);case AddressFormError():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( AddressFormInitial value)?  initial,TResult? Function( AddressFormSaving value)?  saving,TResult? Function( AddressFormSuccess value)?  success,TResult? Function( AddressFormError value)?  error,}){
final _that = this;
switch (_that) {
case AddressFormInitial() when initial != null:
return initial(_that);case AddressFormSaving() when saving != null:
return saving(_that);case AddressFormSuccess() when success != null:
return success(_that);case AddressFormError() when error != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  initial,TResult Function()?  saving,TResult Function( AddressEntity? address)?  success,TResult Function( String message)?  error,required TResult orElse(),}) {final _that = this;
switch (_that) {
case AddressFormInitial() when initial != null:
return initial();case AddressFormSaving() when saving != null:
return saving();case AddressFormSuccess() when success != null:
return success(_that.address);case AddressFormError() when error != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  initial,required TResult Function()  saving,required TResult Function( AddressEntity? address)  success,required TResult Function( String message)  error,}) {final _that = this;
switch (_that) {
case AddressFormInitial():
return initial();case AddressFormSaving():
return saving();case AddressFormSuccess():
return success(_that.address);case AddressFormError():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  initial,TResult? Function()?  saving,TResult? Function( AddressEntity? address)?  success,TResult? Function( String message)?  error,}) {final _that = this;
switch (_that) {
case AddressFormInitial() when initial != null:
return initial();case AddressFormSaving() when saving != null:
return saving();case AddressFormSuccess() when success != null:
return success(_that.address);case AddressFormError() when error != null:
return error(_that.message);case _:
  return null;

}
}

}

/// @nodoc


class AddressFormInitial implements AddressFormState {
  const AddressFormInitial();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AddressFormInitial);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'AddressFormState.initial()';
}


}




/// @nodoc


class AddressFormSaving implements AddressFormState {
  const AddressFormSaving();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AddressFormSaving);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'AddressFormState.saving()';
}


}




/// @nodoc


class AddressFormSuccess implements AddressFormState {
  const AddressFormSuccess([this.address]);
  

 final  AddressEntity? address;

/// Create a copy of AddressFormState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AddressFormSuccessCopyWith<AddressFormSuccess> get copyWith => _$AddressFormSuccessCopyWithImpl<AddressFormSuccess>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AddressFormSuccess&&(identical(other.address, address) || other.address == address));
}


@override
int get hashCode => Object.hash(runtimeType,address);

@override
String toString() {
  return 'AddressFormState.success(address: $address)';
}


}

/// @nodoc
abstract mixin class $AddressFormSuccessCopyWith<$Res> implements $AddressFormStateCopyWith<$Res> {
  factory $AddressFormSuccessCopyWith(AddressFormSuccess value, $Res Function(AddressFormSuccess) _then) = _$AddressFormSuccessCopyWithImpl;
@useResult
$Res call({
 AddressEntity? address
});




}
/// @nodoc
class _$AddressFormSuccessCopyWithImpl<$Res>
    implements $AddressFormSuccessCopyWith<$Res> {
  _$AddressFormSuccessCopyWithImpl(this._self, this._then);

  final AddressFormSuccess _self;
  final $Res Function(AddressFormSuccess) _then;

/// Create a copy of AddressFormState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? address = freezed,}) {
  return _then(AddressFormSuccess(
freezed == address ? _self.address : address // ignore: cast_nullable_to_non_nullable
as AddressEntity?,
  ));
}


}

/// @nodoc


class AddressFormError implements AddressFormState {
  const AddressFormError(this.message);
  

 final  String message;

/// Create a copy of AddressFormState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AddressFormErrorCopyWith<AddressFormError> get copyWith => _$AddressFormErrorCopyWithImpl<AddressFormError>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AddressFormError&&(identical(other.message, message) || other.message == message));
}


@override
int get hashCode => Object.hash(runtimeType,message);

@override
String toString() {
  return 'AddressFormState.error(message: $message)';
}


}

/// @nodoc
abstract mixin class $AddressFormErrorCopyWith<$Res> implements $AddressFormStateCopyWith<$Res> {
  factory $AddressFormErrorCopyWith(AddressFormError value, $Res Function(AddressFormError) _then) = _$AddressFormErrorCopyWithImpl;
@useResult
$Res call({
 String message
});




}
/// @nodoc
class _$AddressFormErrorCopyWithImpl<$Res>
    implements $AddressFormErrorCopyWith<$Res> {
  _$AddressFormErrorCopyWithImpl(this._self, this._then);

  final AddressFormError _self;
  final $Res Function(AddressFormError) _then;

/// Create a copy of AddressFormState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? message = null,}) {
  return _then(AddressFormError(
null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
