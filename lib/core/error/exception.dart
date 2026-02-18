class ServerException implements Exception {
  final String message;
  const ServerException(this.message);
}

class NoInternetException implements Exception {
  final String message = "No Internet Connection";
}