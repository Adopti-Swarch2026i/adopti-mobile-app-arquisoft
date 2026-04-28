class AppConstants {
  static const String appName = 'Adopti';
  static const String appVersion = '1.0.0';

  // Pet filters
  static const List<String> petStatuses = ['lost', 'found', 'reunited'];
  static const List<String> petSpecies = ['dog', 'cat', 'bird', 'other'];

  // Pagination
  static const int defaultPageSize = 20;
  static const int maxImageSizeBytes = 5 * 1024 * 1024; // 5MB

  // Allowed image formats
  static const List<String> allowedImageExtensions = ['jpg', 'jpeg', 'png', 'webp'];
}
