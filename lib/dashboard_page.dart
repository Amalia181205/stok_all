import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'login_page.dart';
import 'read_produk.dart';
import 'create_produk.dart';
import 'detail_produk.dart';
import 'edit_produk.dart';
import 'models/product.dart';
import 'platform_page.dart';
import 'history_page.dart';

import 'package:provider/provider.dart';
import 'providers/product_provider.dart';
import 'providers/auth_provider.dart';

import 'services/notification_service.dart';
import 'services/api_service.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  String name = "";
  int currentIndex = 0;

  List<Product> products = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    getData();
    getProducts();

    registerFcm();
  }

  Future<void> registerFcm() async {
    try {
      final token = await NotificationService.getToken();

      if (token != null) {
        await ApiService.registerToken(userId: 'user_001', fcmToken: token);

        debugPrint("FCM Registered: $token");
      }
    } catch (e) {
      debugPrint("FCM Error: $e");
    }
  }

  // =======================
  // GET USER
  // =======================
  Future<void> getData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      name = prefs.getString('name') ?? 'User';
    });
  }

  // =======================
  // READ PRODUCT 
  // =======================
  Future<void> getProducts() async {
    setState(() => isLoading = true);
     
    try {
      final response = await http.get(
        Uri.parse('http://192.168.0.107/api_stock/read.php'),
      );

      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);

        if (decoded is List) {
          final data = decoded
              .map<Product>((e) => Product.fromJson(e))
              .toList();

          products = data;

          context.read<ProductProvider>().setProducts(data);

        } else {
          products = [];
        }
      } else {
        products = [];
      }
    } catch (e) {
      print("ERROR GET: $e");
      products = [];
    }

    setState(() => isLoading = false);
  }

  // =======================
  // DELETE PRODUCT 
  // =======================
  
  Future<void> deleteProduct(String id) async {
    try {
      await http.post(
        Uri.parse('http://192.168.0.107/api_stock/delete.php'),
        body: {"id": id},
      );

      await getProducts(); // refresh langsung
    } catch (e) {
      print("ERROR DELETE: $e");
    }
  }

  // =======================
  // LOGOUT
  // =======================

  Future<void> logout() async {
    await context.read<AuthProvider>().logout();

    if (!mounted) return;

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const LoginPage()),
    );
  }

  Widget buildDashboard() {

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [
          /// HEADER
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,

            children: [
              const Row(
                children: [
                  Icon(Icons.inventory_2_outlined, color: Color(0xff5B2C1F)),

                  SizedBox(width: 8),

                  Text(
                    "StockAll",
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                ],
              ),

              IconButton(onPressed: logout, icon: const Icon(Icons.logout)),
            ],
          ),

          const SizedBox(height: 25),

          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: const Color(0xff4B2A21),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              children: [
                const CircleAvatar(
                  radius: 28,
                  backgroundColor: Colors.white,
                  child: Icon(Icons.person, color: Color(0xff4B2A21), size: 30),
                ),

                const SizedBox(width: 15),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Selamat Datang",
                        style: TextStyle(color: Colors.white70, fontSize: 14),
                      ),

                      Text(
                        name,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),

                // const Icon(Icons.verified, color: Colors.greenAccent),
              ],
            ),
          ),


          const SizedBox(height: 5),

          const Text(
            "Semua sistem sinkron, Stok Anda akan mulai aman hari ini.",
            style: TextStyle(color: Colors.grey),
          ),

          const SizedBox(height: 25),

          /// BUTTON TAMBAH
          SizedBox(
            width: double.infinity,
            height: 50,

            child: ElevatedButton.icon(
              onPressed: () async {
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const CreateProduk()),
                );

                if (result == true) {
                  getProducts();
                }
              },

              icon: const Icon(Icons.add),

              label: const Text("Tambah Stok"),

              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xff4B2A21),
                foregroundColor: Colors.white,

                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
            ),
          ),

          const SizedBox(height: 20),

          /// CARD TOTAL STOK
          Container(
            padding: const EdgeInsets.all(18),

            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: Colors.grey.shade200),
            ),

            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [
                const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,

                  children: [
                    Text(
                      "TOTAL STOK",
                      style: TextStyle(
                        color: Colors.grey,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    Icon(Icons.inventory),
                  ],
                ),

                const SizedBox(height: 20),

                Text(
                  "${context.watch<ProductProvider>().totalProduk}",
                  style: const TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const Text(
                  "Produk Tersedia",
                  style: TextStyle(color: Colors.grey),
                ),

                Text(
                  "Produk Menipis : ${context.watch<ProductProvider>().lowStockProducts.length}",
                  style: const TextStyle(
                    color: Colors.grey,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 20),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,

                  children: [
                    const Text("Kapasitas Gudang"),

                    Text(
                      "82%",
                      style: TextStyle(
                        color: Colors.orange.shade800,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 8),

                ClipRRect(
                  borderRadius: BorderRadius.circular(20),

                  child: LinearProgressIndicator(
                    value: 0.82,
                    minHeight: 8,
                    backgroundColor: Colors.grey.shade300,
                    color: const Color(0xff4B2A21),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),
    
          /// LIST PRODUK
          Container(
            padding: const EdgeInsets.all(18),

            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: Colors.grey.shade200),
            ),

            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [
                const Text(
                  "Daftar Produk",
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),

                const SizedBox(height: 20),

                isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : products.isEmpty
                    ? const Text("Belum ada produk")
                    : ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: products.length,

                        itemBuilder: (context, index) {
                          final product = products[index];

                          return Container(
                            margin: const EdgeInsets.only(bottom: 14),

                            decoration: BoxDecoration(
                              color: Colors.grey.shade100,
                              borderRadius: BorderRadius.circular(16),
                            ),

                            child: ListTile(
                              isThreeLine: true,
                              contentPadding: const EdgeInsets.all(14),

                              title: Text(
                                product.name,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),


                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      const Icon(
                                        Icons.inventory_2_outlined,
                                        size: 16,
                                        color: Colors.grey,
                                      ),
                                      const SizedBox(width: 5),
                                      Text("Stock : ${product.stock}"),
                                    ],
                                  ),

                                  const SizedBox(height: 4),

                                  Row(
                                    children: [
                                      const Icon(
                                        Icons.shopping_bag_outlined,
                                        size: 16,
                                        color: Colors.orange,
                                      ),
                                      const SizedBox(width: 5),
                                      Text("Shopee : ${product.shopeeStock}"),
                                    ],
                                  ),

                                  const SizedBox(height: 4),

                                  Row(
                                    children: [
                                      const Icon(
                                        Icons.store_outlined,
                                        size: 16,
                                        color: Colors.blue,
                                      ),
                                      const SizedBox(width: 5),
                                      Text(
                                        "Tokopedia : ${product.tokopediaStock}",
                                      ),
                                    ],
                                  ),

                                  Text(
                                     "Rp. ${product.price.toInt()}",
                                    style: const TextStyle(
                                      color: Colors.green,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),

                              // FIX: ada price + icon delete

                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    icon: const Icon(
                                      Icons.edit,
                                      color: Color(0xff4B2A21),
                                    ),
                                    onPressed: () async {
                                      final result = await Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (_) =>
                                              EditProduk(product: product),
                                        ),
                                      );

                                      if (result == true) {
                                        getProducts();
                                      }
                                    },
                                  ),

                                  IconButton(
                                    icon: const Icon(
                                      Icons.delete,
                                      color: Colors.red,
                                    ),
                                    onPressed: () {
                                      showDialog(
                                        context: context,
                                        builder: (context) {
                                          return AlertDialog(
                                            title: const Text("Hapus Produk?"),
                                            content: const Text(
                                              "Yakin ingin hapus data?",
                                            ),
                                            actions: [
                                              TextButton(
                                                onPressed: () =>
                                                    Navigator.pop(context),
                                                child: const Text("Batal"),
                                              ),
                                              ElevatedButton(
                                                style: ElevatedButton.styleFrom(
                                                  backgroundColor: Colors.red,
                                                ),
                                                onPressed: () async {
                                                  Navigator.pop(context);

                                                  await deleteProduct(
                                                    product.id,
                                                  );
                                                  await getProducts();
                                                },
                                                child: const Text("Hapus"),
                                              ),
                                            ],
                                          );
                                        },
                                      );
                                    },
                                  ),
                                ],
                              ),

                              onTap: () async {
                                final result = await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) =>
                                        DetailProduk(product: product),
                                  ),
                                );

                                if (result == true) {
                                  getProducts();
                                }
                              },

                              onLongPress: () {
                                showDialog(
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                      title: const Text("Hapus Produk?"),
                                      content: const Text(
                                        "Yakin ingin hapus data?",
                                      ),
                                      actions: [
                                        TextButton(
                                          onPressed: () =>
                                              Navigator.pop(context),
                                          child: const Text("Batal"),
                                        ),
                                        ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.red,
                                          ),
                                          onPressed: () async {
                                            Navigator.pop(context);

                                            await deleteProduct(product.id);
                                            await getProducts();
                                          },
                                          child: const Text("Hapus"),
                                        ),
                                      ],
                                    );
                                  },
                                );
                              },
                            ),
                          );
                        },
                      ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          /// PESANAN
          Container(
            padding: const EdgeInsets.all(18),

            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: Colors.grey.shade200),
            ),

            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [
                const Text(
                  "Pesanan Hari Ini",
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),

                const SizedBox(height: 20),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,

                  children: [
                    itemPesanan("154", "Total Order"),

                    itemPesanan("42", "Shopee"),
                  ],
                ),

                const SizedBox(height: 25),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,

                  children: [
                    itemPesanan("38", "Lazada"),

                    itemPesanan("74", "TikTok Shop"),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          /// KONEKSI PLATFORM
          Container(
            padding: const EdgeInsets.all(18),

            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: Colors.grey.shade200),
            ),

            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [
                const Text(
                  "Koneksi Platform",
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),

                const SizedBox(height: 20),

                platformItem(Icons.shopping_bag, "Shopee", Colors.orange),

                const SizedBox(height: 15),

                platformItem(Icons.store, "Lazada", Colors.blue),

                const SizedBox(height: 15),

                platformItem(Icons.music_note, "TikTok", Colors.black),
              ],
            ),
          ),

          const SizedBox(height: 20),

          /// AKTIVITAS
          Container(
            padding: const EdgeInsets.all(18),

            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: Colors.grey.shade200),
            ),

            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [
                const Text(
                  "Aktivitas Sinkronisasi",
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),

                const SizedBox(height: 20),

                aktivitasItem(
                  "Stok Terjual di Shopee",
                  "Kemeja Linen Pria (Navy) - 2 unit",
                  "Baru saja",
                ),

                aktivitasItem(
                  "Sinkronisasi TikTok Berhasil",
                  "Update massal 12 SKU",
                  "15 menit lalu",
                ),

                aktivitasItem(
                  "Pesanan Masuk Lazada",
                  "ID Order : LZ-9928172",
                  "1 jam lalu",
                ),

                aktivitasItem(
                  "Stok Menipis",
                  "Sepatu Canvas Putih (Sisa 3)",
                  "2 jam lalu",
                  isDanger: true,
                ),

                const SizedBox(height: 20),

                SizedBox(
                  width: double.infinity,

                  child: OutlinedButton(
                    onPressed: () {},

                    child: const Text("Lihat Semua Aktivitas"),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget itemPesanan(String angka, String title) {
    return Column(
      children: [
        Text(
          angka,

          style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
        ),

        Text(title, style: const TextStyle(color: Colors.grey)),
      ],
    );
  }

  Widget platformItem(IconData icon, String title, Color color) {
    return Container(
      padding: const EdgeInsets.all(15),

      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.grey.shade300),
      ),

      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: color.withValues(alpha: 0.05),

            child: Icon(icon, color: color),
          ),

          const SizedBox(width: 15),

          Expanded(
            child: Text(
              title,

              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),

          const Text(
            "TERHUBUNG",

            style: TextStyle(
              color: Colors.green,
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget aktivitasItem(
    String title,
    String subtitle,
    String time, {
    bool isDanger = false,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 18),

      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [
          Container(
            margin: const EdgeInsets.only(top: 7),

            width: 8,
            height: 8,

            decoration: BoxDecoration(
              color: isDanger ? Colors.red : const Color(0xff4B2A21),

              shape: BoxShape.circle,
            ),
          ),

          const SizedBox(width: 12),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [
                Text(
                  title,

                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: isDanger ? Colors.red : Colors.black,
                  ),
                ),

                const SizedBox(height: 3),

                Text(subtitle, style: const TextStyle(color: Colors.grey)),

                const SizedBox(height: 3),

                Text(
                  time,

                  style: const TextStyle(color: Colors.grey, fontSize: 12),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }


@override
Widget build(BuildContext context) {
  return Scaffold(
    backgroundColor: const Color(0xffF7F7F7),

    body: [
        buildDashboard(),
        const ReadProduk(),
        const PlatformPage(),
        const HistoryPage(),
      ][currentIndex],

    bottomNavigationBar: BottomNavigationBar(
      currentIndex: currentIndex,
      selectedItemColor: const Color(0xff4B2A21),
      unselectedItemColor: Colors.grey,
      type: BottomNavigationBarType.fixed,

      onTap: (index) {
        setState(() {
          currentIndex = index;
        });
      },

      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.dashboard),
          label: "Dashboard",
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.inventory_2),
          label: "Stock",
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.hub),
          label: "Platform",
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.history),
          label: "History",
        ),
      ],
    ),
  );
}
}
