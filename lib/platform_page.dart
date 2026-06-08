import 'package:flutter/material.dart';
import 'services/api_service.dart';

import 'package:url_launcher/url_launcher.dart';

class PlatformPage extends StatefulWidget {
  const PlatformPage({super.key});

  @override
  State<PlatformPage> createState() => _PlatformPageState();
}

class _PlatformPageState extends State<PlatformPage> {
  bool shopeeConnected = true; // nanti dari API
  bool loading = false;

  List shopeeProducts = [];

  bool tokopediaConnected = false;
  List tokopediaProducts = [];

  final token = "ISI_TOKEN_SHOPEE"; // tidak bisa karena harus daftra dan perusahaan resmi ntuk mendapai API platform resmi

  Future<void> fetchShopee() async {
    setState(() => loading = true);

    final res = await ApiService.getShopeeProducts(token: token);

    if (res['success'] == true) {
      shopeeProducts = res['data']['response']['item'] ?? [];
    }

    setState(() => loading = false);
  }

 Future<void> openShopeeSeller() async {
    final url = Uri.parse("https://shopee.co.id/shop/123456789");

    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      throw "Tidak bisa membuka Shopee";
    }
  } 

  Future<void> openTokopediaSeller() async {
    final url = Uri.parse("https://seller.tokopedia.com/home");
    await launchUrl(url, mode: LaunchMode.externalApplication);
  }

  @override
  void initState() {
    super.initState();
    fetchShopee();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF7F3F0),

      appBar: AppBar(
        backgroundColor: const Color(0xffF7F3F0),
        elevation: 0,
        title: const Text(
          "StockAll",
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

            ///  SHOPEE CARD REAL

            _platformCard(
              icon: Icons.shopping_bag,
              title: "Shopee",
              products: "${shopeeProducts.length} Produk",
              connected: shopeeConnected,
              onTap: () {
                fetchShopee();
                openShopeeSeller();
              },
            ),

            const SizedBox(height: 16),

            // TOKOPEDIA 
            _platformCard(
              icon: Icons.store,
              title: "Tokopedia",
              products: "${tokopediaProducts.length} Produk",
              connected: tokopediaConnected,
              onTap: () {
                openTokopediaSeller();
              },
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
    required bool connected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
       onTap: onTap,

      child: Container(
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
                    color: connected
                        ? Colors.green.shade100
                        : Colors.red.shade100,
                    borderRadius: BorderRadius.circular(20),
                  ),

                  child: Text(
                    connected ? "TERHUBUNG" : "BELUM",
                    style: TextStyle(
                      fontSize: 10,
                      color: connected ? Colors.green : Colors.red,
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

            const SizedBox(height: 10),

            const Text(
              "Tap untuk masuk ke platform",
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}
