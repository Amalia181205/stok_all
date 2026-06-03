import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class CreateProduk extends StatefulWidget {
  const CreateProduk({super.key});

  @override
  State<CreateProduk> createState() => _CreateProdukState();
}

class _CreateProdukState extends State<CreateProduk> {
  TextEditingController name = TextEditingController();
  TextEditingController stock = TextEditingController();
  TextEditingController price = TextEditingController();
  
  Future<void> simpan() async {
    if (name.text.isEmpty || stock.text.isEmpty || price.text.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Semua data harus diisi")));
      return;
    }

    final res = await http.post(
      Uri.parse("http://192.168.0.107/api_stock/create.php"),
      body: {"nama_produk": name.text, "stok": stock.text, "harga": price.text,
      },
    );

    final data = jsonDecode(res.body);

    if (data['success'] == true) {
      Navigator.pop(context, true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF7F7F7),

      appBar: AppBar(
        backgroundColor: const Color(0xffF7F7F7),
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "Tambah Produk",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        iconTheme: const IconThemeData(color: Colors.black),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),

        child: Container(
          padding: const EdgeInsets.all(20),

          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,

            children: [
              const Center(
                child: CircleAvatar(
                  radius: 40,
                  backgroundColor: Color(0x1A4B2A21),
                  child: Icon(
                    Icons.add_box_outlined,
                    size: 40,
                    color: Color(0xff4B2A21),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              const Center(
                child: Text(
                  "Tambah Produk Baru",
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
              ),

              const SizedBox(height: 30),

              TextField(
                controller: name,
                decoration: InputDecoration(
                  labelText: "Nama Produk",
                  prefixIcon: const Icon(Icons.inventory_2_outlined),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
              ),

              const SizedBox(height: 18),

              TextField(
                controller: stock,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: "Jumlah Stok",
                  prefixIcon: const Icon(Icons.storage),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
              ),

              const SizedBox(height: 18),

              TextField(
                controller: price,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: "Harga Produk",
                  prefixIcon: const Icon(Icons.payments_outlined),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
              ),

              const SizedBox(height: 30),

              SizedBox(
                width: double.infinity,
                height: 55,

                child: ElevatedButton.icon(
                  onPressed: simpan,

                  icon: const Icon(Icons.save),

                  label: const Text(
                    "Simpan Produk",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),

                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xff4B2A21),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
