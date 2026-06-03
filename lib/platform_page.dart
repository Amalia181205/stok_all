// platform_page.dart

import 'package:flutter/material.dart';

class PlatformPage extends StatelessWidget {
  const PlatformPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF7F3F0),

      appBar: AppBar(
        backgroundColor: const Color(0xffF7F3F0),
        elevation: 0,
        title: const Text(
          "stockAll",
          style: TextStyle(color: Colors.brown, fontWeight: FontWeight.bold),
        ),
      ),

      body: Padding(
        padding: const EdgeInsets.all(16),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
            const Text(
              "Integrasi Platform",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 8),

            const Text(
              "Sambungkan toko Anda dari berbagai marketplace",
              style: TextStyle(color: Colors.grey),
            ),

            const SizedBox(height: 20),

            SizedBox(
              width: double.infinity,

              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.brown,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),

                onPressed: () {},

                child: const Text(
                  "Tambah Toko Baru",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),

            const SizedBox(height: 20),

            _platformCard(
              icon: Icons.shopping_bag,
              title: "Shopee",
              products: "1.240 Produk",
            ),

            const SizedBox(height: 16),

            _platformCard(
              icon: Icons.store,
              title: "Tokopedia",
              products: "980 Produk",
            ),
            
          ],
        ),
      ),
    );
  }

  Widget _platformCard({
    required IconData icon,
    required String title,
    required String products,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),

      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,

            children: [
              Icon(icon, color: Colors.orange),

              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),

                decoration: BoxDecoration(
                  color: Colors.green.shade100,
                  borderRadius: BorderRadius.circular(20),
                ),

                child: const Text(
                  "TERHUBUNG",
                  style: TextStyle(
                    fontSize: 10,
                    color: Colors.green,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          Text(
            title,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 8),

          Text(products, style: const TextStyle(color: Colors.grey)),
        ],
      ),
    );
  }
}
