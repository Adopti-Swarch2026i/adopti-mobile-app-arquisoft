import '../../domain/entities/pet.dart';
import '../../domain/repositories/pet_repository.dart';
import 'report_response_model.dart';

class PaginatedReportsModel {
  final int total;
  final int page;
  final int pageSize;
  final List<ReportResponseModel> results;

  const PaginatedReportsModel({
    required this.total,
    required this.page,
    required this.pageSize,
    required this.results,
  });

  factory PaginatedReportsModel.fromJson(Map<String, dynamic> json) {
    return PaginatedReportsModel(
      total: json['total'] as int,
      page: json['page'] as int,
      pageSize: json['page_size'] as int,
      results: (json['results'] as List<dynamic>)
          .map((e) => ReportResponseModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  PaginatedPets toEntity() => PaginatedPets(
        total: total,
        page: page,
        pageSize: pageSize,
        results: results.map((r) => r.toEntity()).toList(),
      );
}
