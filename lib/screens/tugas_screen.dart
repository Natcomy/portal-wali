import 'package:flutter/material.dart';
import '../services/api_service.dart';

class TugasScreen extends StatefulWidget {
  final List<dynamic> tugasList;
  final List<dynamic> tahfidzList;
  
  const TugasScreen({super.key, required this.tugasList, required this.tahfidzList});

  @override
  State<TugasScreen> createState() => _TugasScreenState();
}

class _TugasScreenState extends State<TugasScreen> {
  late List<dynamic> _tugasList;
  late List<dynamic> _tahfidzList;

  @override
  void initState() {
    super.initState();
    // Inisialisasi data awal dari parameter MainLayout
    _tugasList = widget.tugasList;
    _tahfidzList = widget.tahfidzList;
  }

  // FUNGSI PULL-TO-REFRESH
  Future<void> _refreshData() async {
    try {
      final data = await WaliApiService.getDashboardData();
      if (mounted) {
        setState(() {
          _tugasList = data['tugas'] ?? [];
          _tahfidzList = data['tahfidz'] ?? [];
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Gagal memperbarui: ${e.toString().replaceAll('Exception: ', '')}'),
            backgroundColor: Colors.red,
          )
        );
      }
    }
  }

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
                  // TAB 1: DAFTAR TUGAS (Dengan Pull-to-Refresh & Tampilan Ringkasan)
                  RefreshIndicator(
                    onRefresh: _refreshData,
                    color: const Color(0xFF3F62E2),
                    child: _tugasList.isNotEmpty 
                      ? ListView.builder(
                          padding: const EdgeInsets.all(24),
                          physics: const AlwaysScrollableScrollPhysics(), // Memastikan bisa di-drag meski item sedikit
                          itemCount: _tugasList.length,
                          itemBuilder: (context, index) {
                            final t = _tugasList[index];
                            return Container(
                              margin: const EdgeInsets.only(bottom: 12),
                              decoration: BoxDecoration(
                                color: Colors.white, 
                                borderRadius: BorderRadius.circular(20), 
                                border: Border.all(color: Colors.grey.shade200),
                                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10, offset: const Offset(0, 4))]
                              ),
                              child: Material(
                                color: Colors.transparent,
                                child: InkWell(
                                  borderRadius: BorderRadius.circular(20),
                                  onTap: () {
                                    // Navigasi ke Halaman Detail Tugas
                                    Navigator.push(context, MaterialPageRoute(builder: (_) => DetailTugasScreen(tugas: t)));
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.all(16),
                                    child: Row(
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.all(12),
                                          decoration: BoxDecoration(color: Colors.blue.shade50, borderRadius: BorderRadius.circular(16)),
                                          child: const Icon(Icons.menu_book_rounded, color: Color(0xFF3F62E2)),
                                        ),
                                        const SizedBox(width: 16),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(t['judul'], style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w900, color: Color(0xFF1E293B)), maxLines: 1, overflow: TextOverflow.ellipsis),
                                              const SizedBox(height: 4),
                                              Row(
                                                children: [
                                                  Text(t['mapel'], style: TextStyle(color: Colors.blue.shade700, fontSize: 10, fontWeight: FontWeight.w900)),
                                                  const Text(' • ', style: TextStyle(color: Colors.grey, fontSize: 10)),
                                                  Text('Tenggat: ${t['deadline']}', style: const TextStyle(color: Colors.red, fontSize: 10, fontWeight: FontWeight.bold)),
                                                ],
                                              )
                                            ],
                                          ),
                                        ),
                                        const Icon(Icons.chevron_right_rounded, color: Colors.grey)
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        )
                      : ListView(
                          physics: const AlwaysScrollableScrollPhysics(),
                          children: [
                            SizedBox(height: MediaQuery.of(context).size.height * 0.2),
                            _buildEmpty(Icons.check_circle_outline, 'Alhamdulillah, belum ada PR baru untuk Ananda saat ini.\n(Tarik ke bawah untuk memuat ulang)'),
                          ],
                        ),
                  ),

                  // TAB 2: TAHFIDZ (Dengan Pull-to-Refresh)
                  RefreshIndicator(
                    onRefresh: _refreshData,
                    color: const Color(0xFF3F62E2),
                    child: _tahfidzList.isNotEmpty 
                      ? ListView.builder(
                          padding: const EdgeInsets.all(24),
                          physics: const AlwaysScrollableScrollPhysics(),
                          itemCount: _tahfidzList.length,
                          itemBuilder: (context, index) {
                            final t = _tahfidzList[index];
                            return Container(
                              margin: const EdgeInsets.only(bottom: 12),
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20), border: Border.all(color: Colors.grey.shade200)),
                              child: Row(
                                children: [
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
                      : ListView(
                          physics: const AlwaysScrollableScrollPhysics(),
                          children: [
                            SizedBox(height: MediaQuery.of(context).size.height * 0.2),
                            _buildEmpty(Icons.mic_none_rounded, 'Belum ada rekaman setoran hafalan baru.\n(Tarik ke bawah untuk memuat ulang)'),
                          ],
                        ),
                  ),
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

// =========================================================================
// SCREEN BARU: HALAMAN DETAIL TUGAS
// =========================================================================
class DetailTugasScreen extends StatelessWidget {
  final dynamic tugas;
  const DetailTugasScreen({super.key, required this.tugas});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: const Text('Detail Tugas', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 18)),
        backgroundColor: Colors.white,
        foregroundColor: const Color(0xFF1E293B),
        elevation: 0,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white, 
            borderRadius: BorderRadius.circular(32), 
            border: Border.all(color: Colors.grey.shade200),
            boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 15, offset: const Offset(0, 8))]
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6), 
                    decoration: BoxDecoration(color: Colors.blue.shade50, borderRadius: BorderRadius.circular(8)), 
                    child: Text(tugas['mapel'], style: TextStyle(color: Colors.blue.shade700, fontSize: 10, fontWeight: FontWeight.w900))
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6), 
                    decoration: BoxDecoration(color: Colors.red.shade50, borderRadius: BorderRadius.circular(8)), 
                    child: Text('Tenggat: ${tugas['deadline']}', style: const TextStyle(color: Colors.red, fontSize: 10, fontWeight: FontWeight.bold))
                  ),
                ],
              ),
              const SizedBox(height: 20),
              
              Text(tugas['judul'], style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: Color(0xFF1E293B))),
              const SizedBox(height: 16),
              
              const Text('INSTRUKSI PENGERJAAN', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w900, color: Colors.grey, letterSpacing: 1)),
              const SizedBox(height: 8),
              Text(tugas['deskripsi'], style: const TextStyle(fontSize: 14, color: Colors.black87, height: 1.6)),
              
              // FOTO LAMPIRAN JIKA ADA
              if (tugas['attachment_url'] != null) ...[
                const SizedBox(height: 24),
                const Text('LAMPIRAN DARI GURU', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w900, color: Colors.grey, letterSpacing: 1)),
                const SizedBox(height: 12),
                ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Image.network(
                    tugas['attachment_url'],
                    width: double.infinity,
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) => Container(
                      padding: const EdgeInsets.all(16),
                      width: double.infinity,
                      decoration: BoxDecoration(color: Colors.grey.shade50, border: Border.all(color: Colors.grey.shade200), borderRadius: BorderRadius.circular(16)),
                      child: const Column(
                        children: [
                          Icon(Icons.broken_image, color: Colors.grey, size: 32),
                          SizedBox(height: 8),
                          Text('Gagal memuat gambar lampiran', style: TextStyle(fontSize: 12, color: Colors.grey, fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ),
                  ),
                )
              ],

              const SizedBox(height: 24),
              const Divider(color: Color(0xFFEFF6FF), thickness: 2),
              const SizedBox(height: 16),
              
              Row(
                children: [
                  CircleAvatar(
                    backgroundColor: Colors.blue.shade100,
                    child: const Icon(Icons.person, color: Colors.blue),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Diberikan oleh', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.grey)),
                      Text(tugas['guru'], style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w900, color: Color(0xFF1E293B))),
                      Text('Tanggal Posting: ${tugas['tgl']}', style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.grey)),
                    ],
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}