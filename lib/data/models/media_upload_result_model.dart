import '../../domain/repositories/media_repository.dart';

class MediaUploadResultModel {
  final String url;
  final String thumbnailUrl;
  final String hash;
  final bool cached;

  const MediaUploadResultModel({
    required this.url,
    required this.thumbnailUrl,
    required this.hash,
    this.cached = false,
  });

  factory MediaUploadResultModel.fromJson(Map<String, dynamic> json) {
    return MediaUploadResultModel(
      url: json['url'] as String,
      thumbnailUrl: json['thumbnailUrl'] as String,
      hash: json['hash'] as String,
      cached: json['cached'] as bool? ?? false,
    );
  }

  MediaUploadResult toEntity() => MediaUploadResult(
        url: url,
        thumbnailUrl: thumbnailUrl,
        hash: hash,
        cached: cached,
      );
}
