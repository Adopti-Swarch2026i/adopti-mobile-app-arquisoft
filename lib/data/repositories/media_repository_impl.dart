import '../../core/errors/exceptions.dart';
import '../../core/errors/failures.dart';
import '../../domain/repositories/media_repository.dart';
import '../datasources/remote/media_api_datasource.dart';

class MediaRepositoryImpl implements MediaRepository {
  final MediaApiDataSource _dataSource;

  MediaRepositoryImpl(this._dataSource);

  @override
  Future<MediaUploadResult> uploadImage(dynamic imageFile, {int? petId}) async {
    try {
      final result = await _dataSource.uploadImage(imageFile, petId: petId);
      return result.toEntity();
    } on ServerException catch (e) {
      throw ServerFailure(e.message);
    }
  }

  @override
  Future<MediaUploadResult> getCachedImage(String hash) async {
    try {
      final result = await _dataSource.getCachedImage(hash);
      return result.toEntity();
    } on ServerException catch (e) {
      throw ServerFailure(e.message);
    }
  }
}
