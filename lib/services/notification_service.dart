import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter/foundation.dart';

class NotificationService {
  static final FlutterLocalNotificationsPlugin _localNotifications =
      FlutterLocalNotificationsPlugin();

  static final FirebaseMessaging _messaging = FirebaseMessaging.instance;

  // ── Inisialisasi semua layanan notifikasi ──────────────────────────
  static Future<void> initialize() async {
    // 1. Minta izin notifikasi dari pengguna
    await _requestPermission();

    // 2. Siapkan channel notifikasi Android
    await _setupAndroidChannel();

    // 3. Inisialisasi flutter_local_notifications
    await _initLocalNotifications();

    // 4. Dengarkan notifikasi FCM saat app di foreground
    _listenForeground();
  }

  // ── Meminta izin notifikasi ────────────────────────────────────────
  static Future<void> _requestPermission() async {
    NotificationSettings settings = await _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    debugPrint('Status izin: ${settings.authorizationStatus}');
  }

  // ── Membuat Android Notification Channel ──────────────────────────
  static Future<void> _setupAndroidChannel() async {
    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      'high_importance_channel',
      'Notifikasi Penting',
      description: 'Channel untuk notifikasi pesanan realtime',
      importance: Importance.max,
    );

    await _localNotifications
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.createNotificationChannel(channel);
  }

  // ── Inisialisasi plugin lokal ──────────────────────────────────────
  static Future<void> _initLocalNotifications() async {
    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const InitializationSettings initSettings = InitializationSettings(
      android: androidSettings,
    );

    await _localNotifications.initialize(initSettings);
  }

  // ── Dengarkan notifikasi FCM di foreground ─────────────────────────
  static void _listenForeground() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      debugPrint('FCM Foreground: ${message.notification?.title}');

      if (message.notification != null) {
        showLocalNotification(
          title: message.notification!.title ?? "Notifikasi",
          body: message.notification!.body ?? "",
        );
      }
    });
  }

  // ── Tampilkan notifikasi lokal ─────────────────────────────────────
  static Future<void> showLocalNotification({
    required String title,
    required String body,
    int id = 0,
  }) async {
    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
          'high_importance_channel',
          'Notifikasi Penting',
          importance: Importance.max,
          priority: Priority.high,
          showWhen: true,
        );

    await _localNotifications.show(
      id,
      title,
      body,
      const NotificationDetails(android: androidDetails),
    );
  }

  // ── Ambil FCM Token perangkat ini ──────────────────────────────────
  static Future<String?> getToken() async {
    final token = await _messaging.getToken();
    debugPrint('FCM Token: $token');
    return token;
  }

  // ── Daftarkan background handler ───────────────────────────────────
  static void registerBackgroundHandler(
    Future<void> Function(RemoteMessage) handler,
  ) {
    FirebaseMessaging.onBackgroundMessage(handler);
  }
}
