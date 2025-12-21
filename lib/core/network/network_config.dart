class ClientConfig{
  static const BASE_URL = "https://jsonplaceholder.typicode.com";
  static const TIMEOUT = Duration(seconds: 10);
  static const DEFAULT_HEADER = {
      "Content-Type": "application/json",
      "Accept": "application/json",
      // "Authorization": "Bearer $token",
    };
}