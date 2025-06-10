import 'package:freezed_annotation/freezed_annotation.dart';

part 'upload_item.freezed.dart';
part 'upload_item.g.dart';

@freezed
abstract class UploadItem with _$UploadItem {
  const factory UploadItem({
    required String name,
    required String url,
    required String type, // 'file', 'image', 'text'
  }) = _UploadItem;

  factory UploadItem.fromJson(Map<String, dynamic> json) =>
      _$UploadItemFromJson(json);
}