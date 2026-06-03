import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthProvider with ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  final GoogleSignIn _googleSignIn = GoogleSignIn(scopes: ['email']);

  User? user;

  final String baseUrl = "http://192.168.0.107";

  AuthProvider() {
    _auth.authStateChanges().listen((u) {
      user = u;
      notifyListeners();
    });
  }

  // ================= REGISTER (PHP) =================
  Future<bool> register({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      final res = await http.post(
        Uri.parse("$baseUrl/api_stock/register.php"),
        body: {"name": name, "email": email, "password": password},
      );

      final data = jsonDecode(res.body);
      return data["success"] == true;
    } catch (e) {
      debugPrint("Register error: $e");
      return false;
    }
  }

  // ================= LOGIN MANUAL (PHP + MySQL) =================
  Future<bool> loginManual(String email, String password) async {
    try {
      final res = await http.post(
        Uri.parse("$baseUrl/api_stock/login.php"),
        body: {"email": email, "password": password},
      );

      final data = jsonDecode(res.body);

      if (data["success"] == true) {
        final prefs = await SharedPreferences.getInstance();

        await prefs.setBool("isLogin", true);
        await prefs.setString("name", data["name"]);
        await prefs.setString("email", data["email"]);
        await prefs.setString("provider", "manual");

        return true;
      }

      return false;
    } catch (e) {
      debugPrint("Login manual error: $e");
      return false;
    }
  }

  // ================= LOGIN GOOGLE (FIREBASE ONLY) =================
  Future<bool> signInWithGoogle() async {
    try {
      await _googleSignIn.signOut();

      final googleUser = await _googleSignIn.signIn();
      if (googleUser == null) return false;

      final googleAuth = await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final result = await _auth.signInWithCredential(credential);

      final prefs = await SharedPreferences.getInstance();

      await prefs.setBool("isLogin", true);
      await prefs.setString("name", result.user?.displayName ?? "User");
      await prefs.setString("email", result.user?.email ?? "");
      await prefs.setString("provider", "google");

      return true;
    } catch (e) {
      debugPrint("Google login error: $e");
      return false;
    }
  }

  // ================= LOGOUT =================
  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.clear();
    await _googleSignIn.signOut();
    await _auth.signOut();
  }
}
