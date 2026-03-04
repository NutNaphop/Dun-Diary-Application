class ClientConfig {
  static const BASE_URL = String.fromEnvironment(
    "BASE_URL",
    defaultValue: "http://10.0.2.2:3000/api/",
  );
  static const TIMEOUT = Duration(seconds: 10);
  static const DEFAULT_HEADER = {
    "Content-Type": "application/json",
    "Accept": "application/json",
  };
}
