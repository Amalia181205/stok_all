import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/auth_provider.dart';

const primaryColor = Color.fromARGB(255, 165, 130, 122);

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final name = TextEditingController();
  final email = TextEditingController();
  final phone = TextEditingController();
  final password = TextEditingController();

  bool agree = false;
  bool loading = false;

  Future<void> register() async {
    if (!agree) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Harus setuju dulu ya")));
      return;
    }

    setState(() => loading = true);

    final auth = context.read<AuthProvider>();

    final success = await auth.register(
      name: name.text.trim(),
      email: email.text.trim(),
      password: password.text.trim(),
    );

    setState(() => loading = false);

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(success ? "Registrasi berhasil" : "Registrasi gagal"),
      ),
    );

    if (success) Navigator.pop(context);
  }

  Widget inputField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    bool obscure = false,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      decoration: BoxDecoration(
        color: const Color(0xFFF6F6F6),
        borderRadius: BorderRadius.circular(10),
      ),
      child: TextField(
        controller: controller,
        obscureText: obscure,
        decoration: InputDecoration(
          hintText: hint,
          prefixIcon: Icon(icon, color: Colors.grey),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 15),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F3F3),
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            width: 360,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(18),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 12,
                  offset: Offset(0, 5),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Center(
                  child: Icon(Icons.inventory_2, size: 40, color: primaryColor),
                ),
                const SizedBox(height: 10),
                const Center(
                  child: Text(
                    "StockAll",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: primaryColor,
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                const Text(
                  "Buat Akun Baru",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 5),
                const Text(
                  "Mulai kelola penjualan di berbagai platform Anda dengan mudah.",
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),

                const SizedBox(height: 20),

                inputField(
                  controller: name,
                  hint: "Nama Lengkap",
                  icon: Icons.person,
                ),
                inputField(controller: email, hint: "Email", icon: Icons.email),
                inputField(
                  controller: phone,
                  hint: "Nomor Telepon",
                  icon: Icons.phone,
                ),
                inputField(
                  controller: password,
                  hint: "Kata Sandi",
                  icon: Icons.lock,
                  obscure: true,
                ),

                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Checkbox(
                      value: agree,
                      onChanged: (val) => setState(() => agree = val ?? false),
                    ),
                    const Expanded(
                      child: Text(
                        "Saya menyetujui Syarat & Ketentuan serta Kebijakan Privasi yang berlaku.",
                        style: TextStyle(fontSize: 12),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 10),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: loading ? null : register,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor,
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Text(
                      loading ? "Loading..." : "Daftar Sekarang",
                      style: const TextStyle(color: Colors.black),
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                Center(
                  child: GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: const Text.rich(
                      TextSpan(
                        text: "Sudah memiliki akun? ",
                        children: [
                          TextSpan(
                            text: "Masuk",
                            style: TextStyle(
                              color: primaryColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}