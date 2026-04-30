class ApiConfig {
  static const String baseUrl = 'https://overcerebral-unsteadily-charmaine.ngrok-free.dev/api'; 
  
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