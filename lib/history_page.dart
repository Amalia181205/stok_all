import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  List history = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    getHistory();
  }

  Future<void> getHistory() async {
    try {
      final res = await http.get(
        Uri.parse("http://192.168.0.107/api_stock/history_read.php"),
      );

      final data = jsonDecode(res.body);

      setState(() {
        history = data;
        isLoading = false;
      });
    } catch (e) {
      setState(() => isLoading = false);
      print("ERROR HISTORY: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF7F7F7),

      appBar: AppBar(
        backgroundColor: const Color(0xffF7F7F7),
        elevation: 0,
        title: const Text(
          "History Aktivitas",
          style: TextStyle(color: Color(0xff4B2A21)),
        ),
      ),

      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : history.isEmpty
          ? const Center(child: Text("Belum ada history"))
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: history.length,
              itemBuilder: (context, i) {
                final h = history[i];

                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                  ),

                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        h['action'],
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: h['action'] == 'Hapus Produk'
                              ? Colors.red
                              : const Color(0xff4B2A21),
                        ),
                      ),

                      const SizedBox(height: 6),

                      Text(
                        h['product_name'] ?? '',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 6),

                      Text(
                        h['description'] ?? '',
                        style: const TextStyle(color: Colors.grey),
                      ),

                      const SizedBox(height: 6),

                      Text(
                        h['created_at'] ?? '',
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }
}
