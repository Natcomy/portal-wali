import 'package:flutter/material.dart';
import '../services/api_service.dart';

class LaporScreen extends StatefulWidget {
  // 1. Menerima parameter daftar siswa dari Main Layout
  final List<dynamic> studentsList; 
  
  const LaporScreen({super.key, required this.studentsList});

  @override
  State<LaporScreen> createState() => _LaporScreenState();
}

class _LaporScreenState extends State<LaporScreen> {
  final TextEditingController _keluhanController = TextEditingController();
  String tingkat = 'Ringan';
  String? selectedStudent; // State untuk menyimpan anak yang dipilih
  bool isSubmitting = false;

  @override
  void initState() {
    super.initState();
    // Otomatis memilih anak pertama sebagai default jika daftarnya tidak kosong
    if (widget.studentsList.isNotEmpty) {
      selectedStudent = widget.studentsList[0]['id'].toString();
    }
  }

  void handleSubmit() async {
    if (_keluhanController.text.isEmpty) return;

    if (selectedStudent == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Harap pilih nama anak terlebih dahulu!'), backgroundColor: Colors.red));
      return;
    }

    setState(() => isSubmitting = true);
    
    try {
      // 2. Menembak payload langsung ke API Laravel
      final payload = {
        'student_id': selectedStudent,
        'urgency_level': tingkat,
        'description': _keluhanController.text,
      };
      
      await WaliApiService.submitComplaint(payload);
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Laporan berhasil dikirim ke Kepala Sekolah.'), backgroundColor: Colors.blue));
        setState(() { _keluhanController.clear(); });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString().replaceAll('Exception: ', '')), backgroundColor: Colors.red));
      }
    } finally {
      if (mounted) setState(() => isSubmitting = false);
    }
  }

  @override
  void dispose() {
    _keluhanController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          const Text('Pusat Bantuan', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w900, color: Color(0xFF1E293B))),
          const Text('Kirimkan saran, masukan, atau laporan kendala langsung ke Kepala Sekolah.', style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold)),
          const SizedBox(height: 24),

          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(32), border: Border.all(color: Colors.grey.shade200)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // DROPDOWN PILIH ANAK
                const Text('Terkait Anak', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.grey, letterSpacing: 1)),
                const SizedBox(height: 8),
                DropdownButtonFormField<String>(
                  value: selectedStudent,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)), filled: true, fillColor: Colors.white,
                  ),
                  items: widget.studentsList.map((s) => DropdownMenuItem(
                    value: s['id'].toString(), 
                    child: Text(s['nama'].toString(), style: const TextStyle(fontWeight: FontWeight.bold))
                  )).toList(),
                  onChanged: (val) => setState(() => selectedStudent = val),
                ),
                const SizedBox(height: 20),

                // DROPDOWN TINGKAT URGENSI
                const Text('Tingkat Urgensi', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.grey, letterSpacing: 1)),
                const SizedBox(height: 8),
                DropdownButtonFormField<String>(
                  value: tingkat,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)), filled: true, fillColor: Colors.white,
                  ),
                  items: ['Ringan', 'Sedang', 'Berat'].map((c) => DropdownMenuItem(value: c, child: Text(c, style: const TextStyle(fontWeight: FontWeight.bold)))).toList(),
                  onChanged: (val) => setState(() => tingkat = val!),
                ),
                const SizedBox(height: 20),
                
                // INPUT KELUHAN
                const Text('Pesan / Laporan', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.grey, letterSpacing: 1)),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _keluhanController, 
                  onChanged: (val) => setState(() {}), 
                  maxLines: 5,
                  decoration: InputDecoration(
                    hintText: 'Tuliskan detail laporan Anda di sini...',
                    hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 14),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
                    filled: true, fillColor: Colors.white,
                  ),
                ),
                const SizedBox(height: 24),
                
                // TOMBOL KIRIM API
                SizedBox(
                  width: double.infinity, height: 56,
                  child: ElevatedButton.icon(
                    onPressed: isSubmitting || _keluhanController.text.isEmpty ? null : handleSubmit,
                    icon: const Icon(Icons.send), 
                    label: isSubmitting ? const CircularProgressIndicator(color: Colors.white) : const Text('KIRIM LAPORAN', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 16)),
                    style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF3F62E2), foregroundColor: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16))),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}