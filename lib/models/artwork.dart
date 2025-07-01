import 'package:freezed_annotation/freezed_annotation.dart';

part 'artwork.freezed.dart';
part 'artwork.g.dart';

@freezed
abstract class Artwork with _$Artwork {
  const factory Artwork({
    required String id,
    @JsonKey(name: 'prdct_cl_nm', fromJson: _nullToEmptyString)
    required String className,
    @JsonKey(name: 'manage_no_year', fromJson: _nullToEmptyString)
    required String manageYear,
    @JsonKey(name: 'prdct_nm_korean', fromJson: _nullToEmptyString)
    required String nameKr,
    @JsonKey(name: 'prdct_nm_eng', fromJson: _nullToEmptyString)
    required String nameEn,
    @JsonKey(name: 'prdct_stndrd', fromJson: _nullToEmptyString)
    required String standard,
    @JsonKey(name: 'mnfct_year', fromJson: _nullToEmptyString)
    required String manufactureYear,
    @JsonKey(name: 'matrl_technic', fromJson: _nullToEmptyString)
    required String material,
    @JsonKey(name: 'writr_nm', fromJson: _nullToEmptyString)
    required String writer,
    @JsonKey(name: 'main_image', fromJson: _nullToEmptyString)
    required String mainImage,
    @JsonKey(name: 'thumb_image', fromJson: _nullToEmptyString)
    required String thumbImage,
    required int price,
  }) = _Artwork;

  factory Artwork.fromJson(Map<String, dynamic> json) => _$ArtworkFromJson(json);
}

String _nullToEmptyString(dynamic value) {
  return value?.toString() ?? '';
}