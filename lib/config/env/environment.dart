enum Environment { development, production }

class EnvironmentConfig {
  static const Environment currentEnvironment = Environment.production;

  static String get baseUrl {
    switch (currentEnvironment) {
      case Environment.development:
        return 'https://api.axeninfotech.com/api/v1/';
      case Environment.production:
        return 'https://api.axeninfotech.com/api/v1/';
    }
  }

  static bool get isDevelopment =>
      currentEnvironment == Environment.development;
  static bool get isProduction => currentEnvironment == Environment.production;

  // Environment name for debugging
  static String get environmentName {
    switch (currentEnvironment) {
      case Environment.development:
        return 'Development';
      case Environment.production:
        return 'Production';
    }
  }
}
