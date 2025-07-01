// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'artwork.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Artwork {

 String get id;@JsonKey(name: 'prdct_cl_nm', fromJson: _nullToEmptyString) String get className;@JsonKey(name: 'manage_no_year', fromJson: _nullToEmptyString) String get manageYear;@JsonKey(name: 'prdct_nm_korean', fromJson: _nullToEmptyString) String get nameKr;@JsonKey(name: 'prdct_nm_eng', fromJson: _nullToEmptyString) String get nameEn;@JsonKey(name: 'prdct_stndrd', fromJson: _nullToEmptyString) String get standard;@JsonKey(name: 'mnfct_year', fromJson: _nullToEmptyString) String get manufactureYear;@JsonKey(name: 'matrl_technic', fromJson: _nullToEmptyString) String get material;@JsonKey(name: 'writr_nm', fromJson: _nullToEmptyString) String get writer;@JsonKey(name: 'main_image', fromJson: _nullToEmptyString) String get mainImage;@JsonKey(name: 'thumb_image', fromJson: _nullToEmptyString) String get thumbImage; int get price;
/// Create a copy of Artwork
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ArtworkCopyWith<Artwork> get copyWith => _$ArtworkCopyWithImpl<Artwork>(this as Artwork, _$identity);

  /// Serializes this Artwork to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Artwork&&(identical(other.id, id) || other.id == id)&&(identical(other.className, className) || other.className == className)&&(identical(other.manageYear, manageYear) || other.manageYear == manageYear)&&(identical(other.nameKr, nameKr) || other.nameKr == nameKr)&&(identical(other.nameEn, nameEn) || other.nameEn == nameEn)&&(identical(other.standard, standard) || other.standard == standard)&&(identical(other.manufactureYear, manufactureYear) || other.manufactureYear == manufactureYear)&&(identical(other.material, material) || other.material == material)&&(identical(other.writer, writer) || other.writer == writer)&&(identical(other.mainImage, mainImage) || other.mainImage == mainImage)&&(identical(other.thumbImage, thumbImage) || other.thumbImage == thumbImage)&&(identical(other.price, price) || other.price == price));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,className,manageYear,nameKr,nameEn,standard,manufactureYear,material,writer,mainImage,thumbImage,price);

@override
String toString() {
  return 'Artwork(id: $id, className: $className, manageYear: $manageYear, nameKr: $nameKr, nameEn: $nameEn, standard: $standard, manufactureYear: $manufactureYear, material: $material, writer: $writer, mainImage: $mainImage, thumbImage: $thumbImage, price: $price)';
}


}

/// @nodoc
abstract mixin class $ArtworkCopyWith<$Res>  {
  factory $ArtworkCopyWith(Artwork value, $Res Function(Artwork) _then) = _$ArtworkCopyWithImpl;
@useResult
$Res call({
 String id,@JsonKey(name: 'prdct_cl_nm', fromJson: _nullToEmptyString) String className,@JsonKey(name: 'manage_no_year', fromJson: _nullToEmptyString) String manageYear,@JsonKey(name: 'prdct_nm_korean', fromJson: _nullToEmptyString) String nameKr,@JsonKey(name: 'prdct_nm_eng', fromJson: _nullToEmptyString) String nameEn,@JsonKey(name: 'prdct_stndrd', fromJson: _nullToEmptyString) String standard,@JsonKey(name: 'mnfct_year', fromJson: _nullToEmptyString) String manufactureYear,@JsonKey(name: 'matrl_technic', fromJson: _nullToEmptyString) String material,@JsonKey(name: 'writr_nm', fromJson: _nullToEmptyString) String writer,@JsonKey(name: 'main_image', fromJson: _nullToEmptyString) String mainImage,@JsonKey(name: 'thumb_image', fromJson: _nullToEmptyString) String thumbImage, int price
});




}
/// @nodoc
class _$ArtworkCopyWithImpl<$Res>
    implements $ArtworkCopyWith<$Res> {
  _$ArtworkCopyWithImpl(this._self, this._then);

  final Artwork _self;
  final $Res Function(Artwork) _then;

/// Create a copy of Artwork
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? className = null,Object? manageYear = null,Object? nameKr = null,Object? nameEn = null,Object? standard = null,Object? manufactureYear = null,Object? material = null,Object? writer = null,Object? mainImage = null,Object? thumbImage = null,Object? price = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,className: null == className ? _self.className : className // ignore: cast_nullable_to_non_nullable
as String,manageYear: null == manageYear ? _self.manageYear : manageYear // ignore: cast_nullable_to_non_nullable
as String,nameKr: null == nameKr ? _self.nameKr : nameKr // ignore: cast_nullable_to_non_nullable
as String,nameEn: null == nameEn ? _self.nameEn : nameEn // ignore: cast_nullable_to_non_nullable
as String,standard: null == standard ? _self.standard : standard // ignore: cast_nullable_to_non_nullable
as String,manufactureYear: null == manufactureYear ? _self.manufactureYear : manufactureYear // ignore: cast_nullable_to_non_nullable
as String,material: null == material ? _self.material : material // ignore: cast_nullable_to_non_nullable
as String,writer: null == writer ? _self.writer : writer // ignore: cast_nullable_to_non_nullable
as String,mainImage: null == mainImage ? _self.mainImage : mainImage // ignore: cast_nullable_to_non_nullable
as String,thumbImage: null == thumbImage ? _self.thumbImage : thumbImage // ignore: cast_nullable_to_non_nullable
as String,price: null == price ? _self.price : price // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// @nodoc
@JsonSerializable()

class _Artwork implements Artwork {
  const _Artwork({required this.id, @JsonKey(name: 'prdct_cl_nm', fromJson: _nullToEmptyString) required this.className, @JsonKey(name: 'manage_no_year', fromJson: _nullToEmptyString) required this.manageYear, @JsonKey(name: 'prdct_nm_korean', fromJson: _nullToEmptyString) required this.nameKr, @JsonKey(name: 'prdct_nm_eng', fromJson: _nullToEmptyString) required this.nameEn, @JsonKey(name: 'prdct_stndrd', fromJson: _nullToEmptyString) required this.standard, @JsonKey(name: 'mnfct_year', fromJson: _nullToEmptyString) required this.manufactureYear, @JsonKey(name: 'matrl_technic', fromJson: _nullToEmptyString) required this.material, @JsonKey(name: 'writr_nm', fromJson: _nullToEmptyString) required this.writer, @JsonKey(name: 'main_image', fromJson: _nullToEmptyString) required this.mainImage, @JsonKey(name: 'thumb_image', fromJson: _nullToEmptyString) required this.thumbImage, required this.price});
  factory _Artwork.fromJson(Map<String, dynamic> json) => _$ArtworkFromJson(json);

@override final  String id;
@override@JsonKey(name: 'prdct_cl_nm', fromJson: _nullToEmptyString) final  String className;
@override@JsonKey(name: 'manage_no_year', fromJson: _nullToEmptyString) final  String manageYear;
@override@JsonKey(name: 'prdct_nm_korean', fromJson: _nullToEmptyString) final  String nameKr;
@override@JsonKey(name: 'prdct_nm_eng', fromJson: _nullToEmptyString) final  String nameEn;
@override@JsonKey(name: 'prdct_stndrd', fromJson: _nullToEmptyString) final  String standard;
@override@JsonKey(name: 'mnfct_year', fromJson: _nullToEmptyString) final  String manufactureYear;
@override@JsonKey(name: 'matrl_technic', fromJson: _nullToEmptyString) final  String material;
@override@JsonKey(name: 'writr_nm', fromJson: _nullToEmptyString) final  String writer;
@override@JsonKey(name: 'main_image', fromJson: _nullToEmptyString) final  String mainImage;
@override@JsonKey(name: 'thumb_image', fromJson: _nullToEmptyString) final  String thumbImage;
@override final  int price;

/// Create a copy of Artwork
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ArtworkCopyWith<_Artwork> get copyWith => __$ArtworkCopyWithImpl<_Artwork>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ArtworkToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Artwork&&(identical(other.id, id) || other.id == id)&&(identical(other.className, className) || other.className == className)&&(identical(other.manageYear, manageYear) || other.manageYear == manageYear)&&(identical(other.nameKr, nameKr) || other.nameKr == nameKr)&&(identical(other.nameEn, nameEn) || other.nameEn == nameEn)&&(identical(other.standard, standard) || other.standard == standard)&&(identical(other.manufactureYear, manufactureYear) || other.manufactureYear == manufactureYear)&&(identical(other.material, material) || other.material == material)&&(identical(other.writer, writer) || other.writer == writer)&&(identical(other.mainImage, mainImage) || other.mainImage == mainImage)&&(identical(other.thumbImage, thumbImage) || other.thumbImage == thumbImage)&&(identical(other.price, price) || other.price == price));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,className,manageYear,nameKr,nameEn,standard,manufactureYear,material,writer,mainImage,thumbImage,price);

@override
String toString() {
  return 'Artwork(id: $id, className: $className, manageYear: $manageYear, nameKr: $nameKr, nameEn: $nameEn, standard: $standard, manufactureYear: $manufactureYear, material: $material, writer: $writer, mainImage: $mainImage, thumbImage: $thumbImage, price: $price)';
}


}

/// @nodoc
abstract mixin class _$ArtworkCopyWith<$Res> implements $ArtworkCopyWith<$Res> {
  factory _$ArtworkCopyWith(_Artwork value, $Res Function(_Artwork) _then) = __$ArtworkCopyWithImpl;
@override @useResult
$Res call({
 String id,@JsonKey(name: 'prdct_cl_nm', fromJson: _nullToEmptyString) String className,@JsonKey(name: 'manage_no_year', fromJson: _nullToEmptyString) String manageYear,@JsonKey(name: 'prdct_nm_korean', fromJson: _nullToEmptyString) String nameKr,@JsonKey(name: 'prdct_nm_eng', fromJson: _nullToEmptyString) String nameEn,@JsonKey(name: 'prdct_stndrd', fromJson: _nullToEmptyString) String standard,@JsonKey(name: 'mnfct_year', fromJson: _nullToEmptyString) String manufactureYear,@JsonKey(name: 'matrl_technic', fromJson: _nullToEmptyString) String material,@JsonKey(name: 'writr_nm', fromJson: _nullToEmptyString) String writer,@JsonKey(name: 'main_image', fromJson: _nullToEmptyString) String mainImage,@JsonKey(name: 'thumb_image', fromJson: _nullToEmptyString) String thumbImage, int price
});




}
/// @nodoc
class __$ArtworkCopyWithImpl<$Res>
    implements _$ArtworkCopyWith<$Res> {
  __$ArtworkCopyWithImpl(this._self, this._then);

  final _Artwork _self;
  final $Res Function(_Artwork) _then;

/// Create a copy of Artwork
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? className = null,Object? manageYear = null,Object? nameKr = null,Object? nameEn = null,Object? standard = null,Object? manufactureYear = null,Object? material = null,Object? writer = null,Object? mainImage = null,Object? thumbImage = null,Object? price = null,}) {
  return _then(_Artwork(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,className: null == className ? _self.className : className // ignore: cast_nullable_to_non_nullable
as String,manageYear: null == manageYear ? _self.manageYear : manageYear // ignore: cast_nullable_to_non_nullable
as String,nameKr: null == nameKr ? _self.nameKr : nameKr // ignore: cast_nullable_to_non_nullable
as String,nameEn: null == nameEn ? _self.nameEn : nameEn // ignore: cast_nullable_to_non_nullable
as String,standard: null == standard ? _self.standard : standard // ignore: cast_nullable_to_non_nullable
as String,manufactureYear: null == manufactureYear ? _self.manufactureYear : manufactureYear // ignore: cast_nullable_to_non_nullable
as String,material: null == material ? _self.material : material // ignore: cast_nullable_to_non_nullable
as String,writer: null == writer ? _self.writer : writer // ignore: cast_nullable_to_non_nullable
as String,mainImage: null == mainImage ? _self.mainImage : mainImage // ignore: cast_nullable_to_non_nullable
as String,thumbImage: null == thumbImage ? _self.thumbImage : thumbImage // ignore: cast_nullable_to_non_nullable
as String,price: null == price ? _self.price : price // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
