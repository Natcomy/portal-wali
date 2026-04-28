class ApiConfig {
  static const String baseUrl = 'http://127.0.0.1:8000/api'; 
  
  static Map<String, String> getHeaders([String? token]) {
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };
    
    // Jika ada token yang dikirim, tambahkan ke dalam header
    if (token != null && token.isNotEmpty) {
      headers['Authorization'] = 'Bearer $token';
    }
    
    return headers;
  }
}