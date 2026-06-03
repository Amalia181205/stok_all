import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dashboard_page.dart';
import 'register_page.dart';
import 'providers/auth_provider.dart';

const primaryColor = Color.fromARGB(255, 165, 130, 122);

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final email = TextEditingController();
  final password = TextEditingController();

  bool rememberMe = false;
  bool loading = false;

  Future<void> login() async {
    setState(() => loading = true);

    final auth = context.read<AuthProvider>();

    final success = await auth.loginManual(
      email.text.trim(),
      password.text.trim(),
    );

    setState(() => loading = false);

    if (!mounted) return;

    if (success) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const DashboardPage()),
      );
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Login gagal")));
    }
  }

  Future<void> loginGoogle() async {
    setState(() => loading = true);

    final auth = context.read<AuthProvider>();
    final success = await auth.signInWithGoogle();

    setState(() => loading = false);

    if (!mounted) return;

    if (success) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const DashboardPage()),
      );
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Google login gagal")));
    }
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
                  "Selamat Datang Kembali",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),

                const SizedBox(height: 5),

                const Text(
                  "Silakan masuk untuk melanjutkan operasional Anda.",
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),

                const SizedBox(height: 20),

                inputField(
                  controller: email,
                  hint: "Email atau Username",
                  icon: Icons.email,
                ),

                inputField(
                  controller: password,
                  hint: "Password",
                  icon: Icons.lock,
                  obscure: true,
                ),

                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {},
                    child: const Text(
                      "Lupa Password?",
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                ),

                const SizedBox(height: 10),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: loading ? null : login,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor,
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Text(
                      loading ? "Loading..." : "MASUK SEKARANG",
                      style: const TextStyle(color: Colors.black),
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                const Row(
                  children: [
                    Expanded(child: Divider()),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      child: Text("Atau masuk dengan"),
                    ),
                    Expanded(child: Divider()),
                  ],
                ),

                const SizedBox(height: 10),

                OutlinedButton.icon(
                  onPressed: loading ? null : loginGoogle,
                  icon: const Icon(
                    Icons.g_mobiledata,
                    size: 30,
                    color: Colors.red,
                  ),
                  label: const Text(
                    "Masuk dengan Google",
                    style: TextStyle(color: Colors.black),
                  ),
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 50),
                  ),
                ),

                const SizedBox(height: 20),

                Center(
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const RegisterPage()),
                      );
                    },
                    child: const Text.rich(
                      TextSpan(
                        text: "Belum punya akun? ",
                        children: [
                          TextSpan(
                            text: "Daftar",
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