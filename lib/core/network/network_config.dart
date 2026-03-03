class ClientConfig {
  static const BASE_URL = "https://dundiary.codecraftcloud.co.th/api/";
  static const TIMEOUT = Duration(seconds: 10);
  static const DEFAULT_HEADER = {
    "Content-Type": "application/json",
    "Accept": "application/json",
    // "Authorization": "Bearer $token",
  };
}
