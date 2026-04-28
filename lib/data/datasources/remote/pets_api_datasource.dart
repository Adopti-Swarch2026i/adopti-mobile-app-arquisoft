import 'package:dio/dio.dart';

import '../../../core/errors/exceptions.dart';
import '../../models/paginated_reports_model.dart';
import '../../models/report_response_model.dart';

class PetsApiDataSource {
  final Dio _dio;

  PetsApiDataSource(this._dio);

  Future<Map<String, int>> getStats() async {
    try {
      final response = await _dio.get<Map<String, dynamic>>('/stats');
      final data = response.data!;
      return {
        'lost': (data['lost'] as num).toInt(),
        'found': (data['found'] as num).toInt(),
        'reunited': (data['reunited'] as num).toInt(),
      };
    } on DioException catch (e) {
      throw ServerException(e.message ?? 'Failed to fetch stats');
    }
  }

  Future<PaginatedReportsModel> listPets({
    String? status,
    String? type,
    String? city,
    String? search,
    int page = 1,
    int pageSize = 20,
  }) async {
    try {
      final response = await _dio.get<Map<String, dynamic>>('', queryParameters: {
        if (status != null) 'status': status,
        if (type != null) 'type': type,
        if (city != null) 'city': city,
        if (search != null) 'search': search,
        'page': page,
        'page_size': pageSize,
      });
      return PaginatedReportsModel.fromJson(response.data!);
    } on DioException catch (e) {
      throw ServerException(e.message ?? 'Failed to list pets');
    }
  }

  Future<ReportResponseModel> getPetDetail(int id) async {
    try {
      final response = await _dio.get<Map<String, dynamic>>('/$id');
      return ReportResponseModel.fromJson(response.data!);
    } on DioException catch (e) {
      throw ServerException(e.message ?? 'Failed to get pet detail');
    }
  }

  Future<ReportResponseModel> createReport(Map<String, dynamic> data) async {
    try {
      final response = await _dio.post<Map<String, dynamic>>('', data: data);
      return ReportResponseModel.fromJson(response.data!);
    } on DioException catch (e) {
      throw ServerException(e.message ?? 'Failed to create report');
    }
  }

  Future<ReportResponseModel> updateReport(int id, Map<String, dynamic> data) async {
    try {
      final response = await _dio.put<Map<String, dynamic>>('/$id', data: data);
      return ReportResponseModel.fromJson(response.data!);
    } on DioException catch (e) {
      throw ServerException(e.message ?? 'Failed to update report');
    }
  }

  Future<void> deleteReport(int id) async {
    try {
      await _dio.delete('/$id');
    } on DioException catch (e) {
      throw ServerException(e.message ?? 'Failed to delete report');
    }
  }
}
