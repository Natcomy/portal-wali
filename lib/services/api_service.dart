import 'dart:convert';
import 'package:http/http.dart' as http;
import 'api_config.dart';

class WaliApiService {
  static String? authToken; // Token Sanctum milik Wali Murid

  // 1. LOGIN (DIUBAH KARENA SEKARANG PAKAI AUTH SAMA SEPERTI GURU)
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
      
      // Setelah login sukses, langsung tarik data dashboard wali
      return await getDashboardData();
    } else {
      throw Exception(data['message'] ?? 'Login gagal. Periksa Username dan Password.');
    }
  }

  // 2. MENGAMBIL DATA DASHBOARD ANAK (Dari endpoint getDashboardData)
  static Future<Map<String, dynamic>> getDashboardData() async {
    final url = Uri.parse('${ApiConfig.baseUrl}/parent/dashboard');
    final response = await http.get(url, headers: ApiConfig.getHeaders(authToken));
    final data = jsonDecode(response.body);
    
    if (response.statusCode == 200 && data['success']) {
      return data['data']; // Mengembalikan { students, pengumuman, tugas, tahfidz, catatan }
    } else {
      throw Exception(data['message'] ?? 'Gagal memuat data anak.');
    }
  }

  // 2. KIRIM KOMPLAIN / BANTUAN
  static Future<bool> sendComplaint(String studentId, String tingkat, String keluhan) async {
    final url = Uri.parse('${ApiConfig.baseUrl}/parent/complaints');
    final response = await http.post(
      url,
      headers: ApiConfig.getHeaders(authToken),
      body: jsonEncode({
        'student_id': studentId,
        'tingkat': tingkat,
        'keluhan': keluhan,
      }),
    );
    
    if (response.statusCode != 200) {
      throw Exception('Gagal mengirim laporan. Coba lagi.');
    }
    return true;
  }
}