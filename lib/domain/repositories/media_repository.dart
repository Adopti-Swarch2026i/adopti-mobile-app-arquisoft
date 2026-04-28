class MediaUploadResult {
  final String url;
  final String thumbnailUrl;
  final String hash;

  const MediaUploadResult({
    required this.url,
    required this.thumbnailUrl,
    required this.hash,
  });
}

abstract class MediaRepository {
  Future<MediaUploadResult> uploadImage(dynamic imageFile);
  Future<MediaUploadResult> getCachedImage(String hash);
}
