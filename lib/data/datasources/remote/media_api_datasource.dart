import 'package:dio/dio.dart';

import '../../../core/errors/exceptions.dart';
import '../../models/media_upload_result_model.dart';

class MediaApiDataSource {
  final Dio _dio;

  MediaApiDataSource(this._dio);

  Future<MediaUploadResultModel> uploadImage(dynamic imageFile) async {
    try {
      final formData = FormData.fromMap({
        'file': imageFile,
      });
      final response = await _dio.post<Map<String, dynamic>>(
        '/media/upload',
        data: formData,
      );
      return MediaUploadResultModel.fromJson(response.data!);
    } on DioException catch (e) {
      throw ServerException(e.message ?? 'Failed to upload image');
    }
  }
}
