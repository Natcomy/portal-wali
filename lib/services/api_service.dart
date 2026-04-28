import 'dart:convert';
import 'package:http/http.dart' as http;
import 'api_config.dart';

class WaliApiService {
  static String? authToken; 

  // 1. LOGIN WALI MURID
  static Future<Map<String, dynamic>> login(String username, String password) async {
    final url = Uri.parse('${ApiConfig.baseUrl}/login');
    final response = await http.post(
      url,
      headers: ApiConfig.getHeaders(),
      body: jsonEncode({'username': username, 'password': password}),
    );
    
    final data = jsonDecode(response.body);
    if (response.statusCode == 200 && data['success']) {
      if (data['data']['user']['role'] != 'wali') {
        throw Exception('Akun ini bukan akun Wali Murid.');
      }
      
      authToken = data['data']['access_token']; 
      
      // Langsung tarik data dashboard anak setelah token didapat
      return await getDashboardData();
    } else {
      throw Exception(data['message'] ?? 'Login gagal. Periksa Username dan Password.');
    }
  }

  // 2. MENGAMBIL DATA DASHBOARD ANAK
  static Future<Map<String, dynamic>> getDashboardData() async {
    final url = Uri.parse('${ApiConfig.baseUrl}/parent/dashboard');
    final response = await http.get(url, headers: ApiConfig.getHeaders(authToken));
    final data = jsonDecode(response.body);
    
    if (response.statusCode == 200 && data['success']) {
      return data['data']; 
    } else {
      throw Exception(data['message'] ?? 'Gagal memuat data anak.');
    }
  }

  // 3. MENGIRIM KOMPLAIN / LAPORAN
  static Future<void> submitComplaint(Map<String, dynamic> payload) async {
    if (authToken == null) throw Exception('Sesi tidak valid.');
    
    final url = Uri.parse('${ApiConfig.baseUrl}/parent/complaints');
    final response = await http.post(
      url,
      headers: ApiConfig.getHeaders(authToken),
      body: jsonEncode(payload),
    );
    
    final resData = jsonDecode(response.body);
    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception(resData['message'] ?? 'Gagal mengirim laporan.');
    }
  }
}