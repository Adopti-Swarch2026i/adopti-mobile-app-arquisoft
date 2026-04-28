import 'dart:io';

import 'package:dio/dio.dart';

import '../../../core/errors/exceptions.dart';
import '../../models/media_upload_result_model.dart';

class MediaApiDataSource {
  final Dio _dio;

  MediaApiDataSource(this._dio);

  Future<MediaUploadResultModel> uploadImage(dynamic imageFile) async {
    try {
      final file = imageFile as File;
      final formData = FormData.fromMap({
        'file': await MultipartFile.fromFile(
          file.path,
          filename: file.path.split('/').last,
        ),
      });
      final response = await _dio.post<Map<String, dynamic>>(
        '/upload',
        data: formData,
      );
      return MediaUploadResultModel.fromJson(response.data!);
    } on DioException catch (e) {
      throw ServerException(e.message ?? 'Failed to upload image');
    }
  }

  Future<MediaUploadResultModel> getCachedImage(String hash) async {
    try {
      // Verify the cached image exists via HEAD request
      await _dio.head<Map<String, dynamic>>('/$hash');
      return MediaUploadResultModel(
        url: '${_dio.options.baseUrl}/$hash',
        thumbnailUrl: '${_dio.options.baseUrl}/$hash/thumbnail',
        hash: hash,
      );
    } on DioException catch (e) {
      throw ServerException(e.message ?? 'Failed to verify cached image');
    }
  }
}
