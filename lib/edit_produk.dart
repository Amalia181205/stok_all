import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../models/product.dart';

class EditProduk extends StatefulWidget {
  final Product product;

  const EditProduk({super.key, required this.product});

  @override
  State<EditProduk> createState() => _EditProdukState();
}

class _EditProdukState extends State<EditProduk> {
  late TextEditingController name;
  late TextEditingController stock;
  late TextEditingController price;
  late TextEditingController shopee;
  late TextEditingController tokopedia;
  
  @override
  void initState() {
    super.initState();
    name = TextEditingController(text: widget.product.name);
    stock = TextEditingController(text: widget.product.stock.toString());
    price = TextEditingController(text: widget.product.price.toStringAsFixed(0),);

    shopee = TextEditingController(text: widget.product.shopeeStock.toString(),);

    tokopedia = TextEditingController(text: widget.product.tokopediaStock.toString(),);
  }

  Future<void> update() async {
    print("ID UPDATE = ${widget.product.id}");

    final res = await http.post(
      Uri.parse("http://192.168.0.107/api_stock/edit.php"),
      body: {
        "id": widget.product.id,
        "nama_produk": name.text,
        "stok": stock.text,
        "harga": price.text,
        "shopee_stock": shopee.text,
        "tokopedia_stock": tokopedia.text,
      },
    );

    print(res.body);

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
        "Edit Produk",
        style: TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.bold,
        ),
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
            const Text(
              "Informasi Produk",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 25),

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
                labelText: "Stok",
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
                labelText: "Harga",
                prefixIcon: const Icon(Icons.payments_outlined),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
            ),

            const SizedBox(height: 18),

            TextField(
                controller: shopee,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: "Stok Shopee",
                  prefixIcon: const Icon(Icons.shopping_bag),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
              ),

              const SizedBox(height: 18),

              TextField(
                controller: tokopedia,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: "Stok Tokopedia",
                  prefixIcon: const Icon(Icons.store),
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
                onPressed: update,

                icon: const Icon(Icons.save),

                label: const Text(
                  "Update Produk",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
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