// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'artwork.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Artwork _$ArtworkFromJson(Map<String, dynamic> json) => _Artwork(
  id: json['id'] as String,
  className: _nullToEmptyString(json['prdct_cl_nm']),
  manageYear: _nullToEmptyString(json['manage_no_year']),
  nameKr: _nullToEmptyString(json['prdct_nm_korean']),
  nameEn: _nullToEmptyString(json['prdct_nm_eng']),
  standard: _nullToEmptyString(json['prdct_stndrd']),
  manufactureYear: _nullToEmptyString(json['mnfct_year']),
  material: _nullToEmptyString(json['matrl_technic']),
  writer: _nullToEmptyString(json['writr_nm']),
  mainImage: _nullToEmptyString(json['main_image']),
  thumbImage: _nullToEmptyString(json['thumb_image']),
  price: (json['price'] as num).toInt(),
);

Map<String, dynamic> _$ArtworkToJson(_Artwork instance) => <String, dynamic>{
  'id': instance.id,
  'prdct_cl_nm': instance.className,
  'manage_no_year': instance.manageYear,
  'prdct_nm_korean': instance.nameKr,
  'prdct_nm_eng': instance.nameEn,
  'prdct_stndrd': instance.standard,
  'mnfct_year': instance.manufactureYear,
  'matrl_technic': instance.material,
  'writr_nm': instance.writer,
  'main_image': instance.mainImage,
  'thumb_image': instance.thumbImage,
  'price': instance.price,
};
