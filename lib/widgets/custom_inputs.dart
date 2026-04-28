import 'package:flutter/material.dart';

// Helper fungsi untuk dekorasi input form (Perbaikan error placeholder)
InputDecoration inputDecor(String label, {String? hint}) {
  return InputDecoration(
    labelText: label,
    hintText: hint, // Di Flutter, placeholder menggunakan hintText
    labelStyle: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.grey),
    hintStyle: TextStyle(fontSize: 14, color: Colors.grey.shade400),
    border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide(color: Colors.grey.shade300)),
    enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide(color: Colors.grey.shade300)),
    filled: true,
    fillColor: Colors.white,
    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
  );
}