import 'package:flutter/material.dart';

class LaporScreen extends StatefulWidget {
  const LaporScreen({super.key});

  @override
  State<LaporScreen> createState() => _LaporScreenState();
}

class _LaporScreenState extends State<LaporScreen> {
  // PERBAIKAN: Menggunakan TextEditingController untuk input text alih-alih property 'value' langsung
  final TextEditingController _keluhanController = TextEditingController();
  String tingkat = 'Ringan';
  bool isSubmitting = false;

  void handleSubmit() async {
    if (_keluhanController.text.isEmpty) return;
    setState(() => isSubmitting = true);
    await Future.delayed(const Duration(seconds: 1)); // Simulasi API
    setState(() { isSubmitting = false; _keluhanController.clear(); });
    
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Laporan berhasil dikirim ke pihak sekolah.'), backgroundColor: Colors.blue));
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
                
                const Text('Pesan / Laporan', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.grey, letterSpacing: 1)),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _keluhanController, // Menggunakan controller dengan benar
                  onChanged: (val) => setState(() {}), // Memaksa re-build untuk update state tombol submit
                  maxLines: 5,
                  decoration: InputDecoration(
                    hintText: 'Tuliskan detail laporan Anda di sini...',
                    hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 14),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
                    filled: true, fillColor: Colors.white,
                  ),
                ),
                const SizedBox(height: 24),
                
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