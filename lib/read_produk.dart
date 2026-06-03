import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'models/product.dart';

class ReadProduk extends StatefulWidget {
  const ReadProduk({super.key});

  @override
  State<ReadProduk> createState() => _ReadProdukState();
}

class _ReadProdukState extends State<ReadProduk> {
  List<Product> products = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    getProducts();
  }

  Future<void> getProducts() async {
    try {
      final response = await http.get(
        Uri.parse('http://192.168.0.107/api_stock/read.php'),
      );

      print(response.body);

      if (response.statusCode == 200) {
        final List data = jsonDecode(response.body);

        setState(() {
          products = data.map((e) => Product.fromJson(e)).toList();
          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      print("ERROR: $e");

      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> refreshData() async {
    setState(() {
      isLoading = true;
    });

    await getProducts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Data Produk"),
        actions: [
          IconButton(icon: const Icon(Icons.refresh), onPressed: refreshData),
        ],
      ),

      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : products.isEmpty
          ? const Center(child: Text("Belum ada data"))
          : RefreshIndicator(
              onRefresh: refreshData,
              child: ListView.builder(
                itemCount: products.length,
                itemBuilder: (context, index) {
                  final p = products[index];

                  return Card(
                    margin: const EdgeInsets.all(10),
                    child: ListTile(
                      title: Text(p.name),
                      subtitle: Text("Stok: ${p.stock}"),
                      trailing: Text("Rp ${p.price.toInt()}"),
                    //  Text("Rp ${p.price}"),
                    ),
                  );
                },
              ),
            ),
    );
  }
}
