import 'package:flutter/material.dart';

class TugasScreen extends StatelessWidget {
  final List<dynamic> tugasList;
  final List<dynamic> tahfidzList;
  
  const TugasScreen({super.key, required this.tugasList, required this.tahfidzList});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.only(top: 24, left: 24, right: 24, bottom: 12),
              child: Text('Akademik Siswa', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w900, color: Color(0xFF1E293B))),
            ),
            const TabBar(
              indicatorColor: Color(0xFF3F62E2),
              labelColor: Color(0xFF3F62E2),
              unselectedLabelColor: Colors.grey,
              labelStyle: TextStyle(fontWeight: FontWeight.w900),
              tabs: [Tab(text: 'Tugas & PR'), Tab(text: 'Jurnal Tahfidz')],
            ),
            Expanded(
              child: TabBarView(
                children: [
                  // Tab 1: Daftar Tugas
                  tugasList.isNotEmpty 
                    ? ListView.builder(
                        padding: const EdgeInsets.all(24),
                        itemCount: tugasList.length,
                        itemBuilder: (context, index) {
                          final t = tugasList[index];
                          return Container(
                            margin: const EdgeInsets.only(bottom: 16),
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(24), border: Border.all(color: Colors.blue.shade100), boxShadow: [BoxShadow(color: Colors.blue.shade100.withOpacity(0.5), blurRadius: 10, offset: const Offset(0, 4))]),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    // PERBAIKAN: FontWeight.black -> FontWeight.w900
                                    Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4), decoration: BoxDecoration(color: Colors.blue.shade50, borderRadius: BorderRadius.circular(8)), child: Text(t['mapel'], style: TextStyle(color: Colors.blue.shade700, fontSize: 10, fontWeight: FontWeight.w900))),
                                    Text('Deadline: ${t['deadline']}', style: const TextStyle(color: Colors.red, fontSize: 10, fontWeight: FontWeight.bold)),
                                  ],
                                ),
                                const SizedBox(height: 12),
                                Text(t['judul'], style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w900, color: Color(0xFF1E293B))),
                                const SizedBox(height: 8),
                                Text(t['deskripsi'], style: const TextStyle(fontSize: 12, color: Colors.grey)),
                                const SizedBox(height: 12),
                                Text('Oleh: ${t['guru']}', style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.grey)),
                              ],
                            ),
                          );
                        },
                      )
                    : _buildEmpty(Icons.check_circle_outline, 'Alhamdulillah, belum ada PR baru untuk Ananda saat ini.'),

                  // Tab 2: Tahfidz
                  tahfidzList.isNotEmpty 
                    ? ListView.builder(
                        padding: const EdgeInsets.all(24),
                        itemCount: tahfidzList.length,
                        itemBuilder: (context, index) {
                          final t = tahfidzList[index];
                          return Container(
                            margin: const EdgeInsets.only(bottom: 12),
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20), border: Border.all(color: Colors.grey.shade200)),
                            child: Row(
                              children: [
                                // PERBAIKAN: Colors.emerald diganti menjadi Colors.green, FontWeight.black menjadi FontWeight.w900
                                Container(
                                  width: 50, height: 50,
                                  decoration: BoxDecoration(color: Colors.green.shade50, borderRadius: BorderRadius.circular(16)),
                                  child: Center(child: Text(t['predikat'].toString().split(' ')[0], style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: Colors.green.shade600))),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text('${t['surah']} (Ayat ${t['ayat']})', style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 14)),
                                      Text('${t['tgl']} • Penguji: ${t['namaGuru']}', style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.grey)),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          );
                        },
                      )
                    : _buildEmpty(Icons.mic_none_rounded, 'Belum ada rekaman setoran hafalan baru.'),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildEmpty(IconData icon, String message) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 64, color: Colors.grey.shade300),
            const SizedBox(height: 16),
            Text(message, textAlign: TextAlign.center, style: const TextStyle(color: Colors.grey, fontWeight: FontWeight.bold, fontSize: 14)),
          ],
        ),
      ),
    );
  }
}