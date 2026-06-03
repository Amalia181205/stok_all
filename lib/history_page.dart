// history_page.dart

import 'package:flutter/material.dart';

class HistoryPage extends StatelessWidget {
  const HistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF7F7F7),

      body: SafeArea(
        child: Column(
          children: [
            // HEADER
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),

              child: Row(
                children: [
                  const Icon(
                    Icons.shopping_bag_outlined,
                    color: Color(0xff4B2A21),
                  ),

                  const SizedBox(width: 8),

                  const Text(
                    "stockAll",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Color(0xff4B2A21),
                    ),
                  ),

                  const Spacer(),

                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),

                    decoration: BoxDecoration(
                      color: const Color(0xffE8DAD5),
                      borderRadius: BorderRadius.circular(30),
                    ),

                    child: const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Status",
                          style: TextStyle(
                            fontSize: 10,
                            color: Color(0xff7A5A50),
                          ),
                        ),

                        Text(
                          "Sinkronisasi\nAktif",
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: Color(0xff4B2A21),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(width: 12),

                  const Icon(
                    Icons.notifications_none,
                    color: Color(0xff4B2A21),
                  ),
                ],
              ),
            ),

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 16),

                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,

                  children: [
                    // TAB
                    Container(
                      padding: const EdgeInsets.all(8),

                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                      ),

                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,

                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 18,
                              vertical: 8,
                            ),

                            decoration: BoxDecoration(
                              color: const Color(0xff4B2A21),
                              borderRadius: BorderRadius.circular(20),
                            ),

                            child: const Text(
                              "Semua",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                              ),
                            ),
                          ),

                          const Text(
                            "Shopee",
                            style: TextStyle(color: Colors.grey, fontSize: 12),
                          ),

                          const Text(
                            "Tokopedia",
                            style: TextStyle(color: Colors.grey, fontSize: 12),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 14),

                    // SEARCH
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12),

                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                      ),

                      child: const TextField(
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          icon: Icon(Icons.search, color: Colors.grey),
                          hintText: "Cari invoice atau produk",
                          hintStyle: TextStyle(fontSize: 12),
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    const Text(
                      "Hari Ini, 24 Okt 2023",
                      style: TextStyle(fontSize: 12, color: Color(0xff7A5A50)),
                    ),

                    const SizedBox(height: 14),

                    // CARD 1
                    buildHistoryCard(
                      icon: Icons.shopping_bag_outlined,
                      title: "3x Wireless Mouse",
                      invoice: "INV/20231024/001",
                      marketplace: "SHOPEE",
                      time: "14:20",
                      status: "Tersinkron",
                      marketplaceColor: Colors.orange,
                    ),

                    const SizedBox(height: 14),

                    // CARD 2
                    buildHistoryCard(
                      icon: Icons.desktop_windows_outlined,
                      title: "1x Monitor Stand Pro",
                      invoice: "INV/20231024/002",
                      marketplace: "TOKOPEDIA",
                      time: "12:15",
                      status: "Tersinkron",
                      marketplaceColor: Colors.green,
                    ),

                    const SizedBox(height: 14),

                    // CARD 3
                    buildHistoryCard(
                      icon: Icons.keyboard_alt_outlined,
                      title: "5x Mechanical Switches",
                      invoice: "INV/20231024/003",
                      marketplace: "SHOPEE",
                      time: "11:58",
                      status: "Memproses...",
                      marketplaceColor: Colors.orange,
                    ),

                    const SizedBox(height: 30),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildHistoryCard({
    required IconData icon,
    required String title,
    required String invoice,
    required String marketplace,
    required String time,
    required String status,
    required Color marketplaceColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),

      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
      ),

      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [
          Container(
            padding: const EdgeInsets.all(10),

            decoration: BoxDecoration(
              color: const Color(0xffF5F1EE),
              borderRadius: BorderRadius.circular(10),
            ),

            child: Icon(icon, size: 20, color: const Color(0xff4B2A21)),
          ),

          const SizedBox(width: 12),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [
                Text(
                  invoice,
                  style: const TextStyle(fontSize: 10, color: Colors.grey),
                ),

                const SizedBox(height: 4),

                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    color: Color(0xff4B2A21),
                  ),
                ),

                const SizedBox(height: 8),

                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 2,
                      ),

                      decoration: BoxDecoration(
                        color: marketplaceColor.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(20),
                      ),

                      child: Text(
                        marketplace,
                        style: TextStyle(
                          fontSize: 9,
                          fontWeight: FontWeight.bold,
                          color: marketplaceColor,
                        ),
                      ),
                    ),

                    const SizedBox(width: 8),

                    Text(
                      time,
                      style: const TextStyle(fontSize: 11, color: Colors.grey),
                    ),
                  ],
                ),

                const SizedBox(height: 8),

                Row(
                  children: [
                    const Icon(Icons.sync, size: 14, color: Colors.grey),

                    const SizedBox(width: 4),

                    Text(
                      status,
                      style: const TextStyle(fontSize: 11, color: Colors.grey),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const Icon(Icons.more_vert, size: 18, color: Colors.grey),
        ],
      ),
    );
  }
}
