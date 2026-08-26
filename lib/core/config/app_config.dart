class AppConfig {
  const AppConfig._();

  static const String baseUrl = String.fromEnvironment('API_BASE_URL');
  static const int paginationLimit = int.fromEnvironment('PAGINATION_LIMIT', defaultValue: 10);
  static const int searchDebounceMs = int.fromEnvironment('SEARCH_DEBOUNCE_MS', defaultValue: 300);
}
