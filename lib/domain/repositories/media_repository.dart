class MediaUploadResult {
  final String url;
  final String thumbnailUrl;
  final String hash;
  final bool cached;

  const MediaUploadResult({
    required this.url,
    required this.thumbnailUrl,
    required this.hash,
    this.cached = false,
  });
}

abstract class MediaRepository {
  Future<MediaUploadResult> uploadImage(dynamic imageFile, {int? petId});
  Future<MediaUploadResult> getCachedImage(String hash);
}
