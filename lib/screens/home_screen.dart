import 'package:flutter/material.dart';
import 'login_screen.dart'; // Sesuaikan path

class HomeScreen extends StatelessWidget {
  final Map<String, dynamic> data;
  const HomeScreen({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    final pengumuman = data['pengumuman'] as List<dynamic>? ?? [];
    final catatan = data['catatan'] as List<dynamic>? ?? [];

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Profil Anak
          Container(
            padding: const EdgeInsets.only(top: 60, left: 24, right: 24, bottom: 32),
            decoration: const BoxDecoration(
              gradient: LinearGradient(colors: [Color(0xFF3F62E2), Color(0xFF314AC2)], begin: Alignment.topLeft, end: Alignment.bottomRight),
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(40)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(color: Colors.white.withOpacity(0.2), borderRadius: BorderRadius.circular(12)),
                      // PERBAIKAN: FontWeight.black diganti menjadi FontWeight.w900
                      child: Text('KELAS ${data['kelas']}', style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w900, letterSpacing: 1)),
                    ),
                    IconButton(
                      icon: const Icon(Icons.logout, color: Colors.white),
                      onPressed: () => Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => const LoginScreen())),
                    )
                  ],
                ),
                const SizedBox(height: 16),
                Text(data['nama'] ?? 'Siswa', style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.w900)),
                Text('NIS: ${data['nis']} • Wali: ${data['waliKelas']}', style: TextStyle(color: Colors.indigo.shade100, fontSize: 12, fontWeight: FontWeight.bold)),
              ],
            ),
          ),
          
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Section Pengumuman Sekolah
                const Text('Mading Sekolah', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w900, color: Color(0xFF1E293B))),
                const SizedBox(height: 12),
                pengumuman.isNotEmpty ? ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: pengumuman.length,
                  itemBuilder: (context, index) {
                    final p = pengumuman[index];
                    return Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20), border: Border.all(color: Colors.grey.shade200)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(p['judul'], style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 14, color: Color(0xFF3F62E2))),
                              Text(p['tgl'], style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.grey)),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(p['isi'], style: const TextStyle(fontSize: 12, color: Colors.black87, height: 1.5)),
                        ],
                      ),
                    );
                  },
                ) : _buildEmptyState(Icons.campaign, 'Belum ada pengumuman sekolah terbaru.'),

                const SizedBox(height: 32),

                // Section Catatan Guru
                const Text('Catatan & Apresiasi Guru', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w900, color: Color(0xFF1E293B))),
                const SizedBox(height: 12),
                catatan.isNotEmpty ? ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: catatan.length,
                  itemBuilder: (context, index) {
                    final c = catatan[index];
                    return Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(color: Colors.amber.shade50, borderRadius: BorderRadius.circular(20), border: Border.all(color: Colors.amber.shade200)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // PERBAIKAN: FontWeight.black diganti menjadi FontWeight.w900
                          Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4), decoration: BoxDecoration(color: Colors.amber.shade200, borderRadius: BorderRadius.circular(8)), child: Text(c['tipe'], style: TextStyle(color: Colors.amber.shade800, fontSize: 9, fontWeight: FontWeight.w900, letterSpacing: 1))),
                          const SizedBox(height: 8),
                          Text(c['isi'], style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.black87)),
                          const SizedBox(height: 8),
                          Text('${c['tgl']} • Oleh: ${c['namaGuru']}', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.amber.shade700)),
                        ],
                      ),
                    );
                  },
                ) : _buildEmptyState(Icons.star_border_rounded, 'Belum ada catatan khusus dari Guru saat ini.'),
                
                const SizedBox(height: 40),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildEmptyState(IconData icon, String message) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(24), border: Border.all(color: Colors.grey.shade200, style: BorderStyle.solid)),
      child: Column(
        children: [
          Icon(icon, size: 40, color: Colors.grey.shade300),
          const SizedBox(height: 12),
          Text(message, textAlign: TextAlign.center, style: const TextStyle(color: Colors.grey, fontWeight: FontWeight.bold, fontSize: 12)),
        ],
      ),
    );
  }
}