import 'package:dio/dio.dart';

import '../../../core/errors/exceptions.dart';
import '../../models/paginated_reports_model.dart';

class MatchingApiDataSource {
  final Dio _dio;

  MatchingApiDataSource(this._dio);

  Future<PaginatedReportsModel> searchPets({
    String? query,
    String? breed,
    String? city,
    String? type,
    String? status,
    int page = 1,
    int pageSize = 20,
  }) async {
    try {
      final response = await _dio.get<Map<String, dynamic>>(
        '/search',
        queryParameters: {
          if (query != null) 'q': query,
          if (breed != null) 'breed': breed,
          if (city != null) 'city': city,
          if (type != null) 'type': type,
          if (status != null) 'status': status,
          'page': page,
          'page_size': pageSize,
        },
      );
      return PaginatedReportsModel.fromJson(response.data!);
    } on DioException catch (e) {
      throw ServerException(e.message ?? 'Failed to search pets');
    }
  }
}
