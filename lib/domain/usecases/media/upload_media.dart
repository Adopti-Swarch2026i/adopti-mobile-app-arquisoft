import '../../repositories/media_repository.dart';

class UploadMedia {
  final MediaRepository _repository;

  const UploadMedia(this._repository);

  Future<MediaUploadResult> call(dynamic imageFile) =>
      _repository.uploadImage(imageFile);
}
