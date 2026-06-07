import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';

class ApiService {
  // Ganti dengan IP komputer Anda jika pakai perangkat fisik
  // Contoh: 'http://192.168.1.5/notifikasi-server'
  static const String _baseUrl = 'http://192.168.0.107/api_stock';

  // ── Kirim FCM token ke server PHP ─────────────────────────────────
  static Future<bool> registerToken({
    required String userId,
    required String fcmToken,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/register_token.php'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'user_id': userId, 'fcm_token': fcmToken}),
      );

      final data = jsonDecode(response.body);
      return data['success'] == true;
    } catch (e) {
      debugPrint('Error registerToken: $e');
      return false;
    }
  }

  // ── Update status pesanan (memicu notifikasi) ──────────────────────
  static Future<Map<String, dynamic>> updateOrder({
    required int orderId,
    required String status,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/update_order.php'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'order_id': orderId, 'status': status}),
      );

      return jsonDecode(response.body) as Map<String, dynamic>;
    } catch (e) {
      return {'error': e.toString()};
    }
  }
}
