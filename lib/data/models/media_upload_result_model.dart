import '../../domain/repositories/media_repository.dart';

class MediaUploadResultModel {
  final String url;
  final String thumbnailUrl;
  final String hash;

  const MediaUploadResultModel({
    required this.url,
    required this.thumbnailUrl,
    required this.hash,
  });

  factory MediaUploadResultModel.fromJson(Map<String, dynamic> json) {
    return MediaUploadResultModel(
      url: json['url'] as String,
      thumbnailUrl: json['thumbnailUrl'] as String,
      hash: json['hash'] as String,
    );
  }

  MediaUploadResult toEntity() => MediaUploadResult(
        url: url,
        thumbnailUrl: thumbnailUrl,
        hash: hash,
      );
}
