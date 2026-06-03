import 'package:flutter/material.dart';
import '../models/product.dart';

class DetailProduk extends StatelessWidget {
  final Product product;

  const DetailProduk({super.key, required this.product});

@override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF7F7F7),

      appBar: AppBar(
        backgroundColor: const Color(0xffF7F7F7),
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "Detail Produk",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        iconTheme: const IconThemeData(color: Colors.black),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),

        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(25),

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
                children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundColor: const Color(
                      0xff4B2A21,
                    ).withValues(alpha: 0.1),

                    child: const Icon(
                      Icons.inventory_2,
                      size: 40,
                      color: Color(0xff4B2A21),
                    ),
                  ),

                  const SizedBox(height: 20),

                  Text(
                    product.name,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 25),

                  const Divider(),

                  const SizedBox(height: 15),

                  detailItem(
                    Icons.inventory,
                    "Stok Produk",
                    "${product.stock}",
                  ),

                  const SizedBox(height: 15),

                  detailItem(
                    Icons.payments,
                    "Harga Produk",
                    "Rp ${product.price.toInt()}"
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget detailItem(IconData icon, String title, String value) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(10),

          decoration: BoxDecoration(
            color: const Color(0xff4B2A21).withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
          ),

          child: Icon(icon, color: const Color(0xff4B2A21)),
        ),

        const SizedBox(width: 15),

        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,

            children: [
              Text(
                title,
                style: const TextStyle(color: Colors.grey, fontSize: 13),
              ),

              const SizedBox(height: 3),

              Text(
                value,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
