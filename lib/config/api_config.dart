class ApiConfig {
  // Google Gemini API Configuration
  static const String geminiApiKey = 'AIzaSyDUmxOhRkjal-y5jP-4o3wCZ41r323VKMo';
  static const String geminiBaseUrl = 'https://generativelanguage.googleapis.com/v1/models/gemini-1.0-pro:generateContent';
  
  // API Endpoints
  static const String geminiGenerateContent = '$geminiBaseUrl?key=$geminiApiKey';
  
  // Request Configuration
  static const Map<String, dynamic> geminiConfig = {
    'temperature': 0.7,
    'topK': 40,
    'topP': 0.95,
    'maxOutputTokens': 1024,
  };
  
  // Error Messages
  static const Map<String, String> errorMessages = {
    'network_error': 'Network connection error. Please check your internet connection.',
    'api_error': 'AI service temporarily unavailable. Please try again later.',
    'timeout_error': 'Request timed out. Please try again.',
    'unknown_error': 'An unexpected error occurred. Please try again.',
  };
} 