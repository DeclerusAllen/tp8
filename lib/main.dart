import 'package:flutter/material.dart';
import 'notification_service.dart'; // Assurez-vous que le nom du fichier est correct

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  final service = NotificationService();
  await service.initialize();
  await service.requestPermissions(); // Demande la permission au démarrage

  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: HomePage(service: service),
  ));
}

class HomePage extends StatelessWidget {
  final NotificationService service;
  const HomePage({super.key, required this.service});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Flutter Notifications")),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          _btn("Notification Immédiate", service.showNotification),
          _btn("Programmer (5s)", service.scheduleNotification),
          _btn("Répéter chaque minute", service.repeatNotification),
          _btn("Grande Image", service.showBigImageNotification),
          _btn("Avec Boutons d'Action", service.showNotificationWithActions),
          const Divider(),
          ElevatedButton(
            onPressed: service.cancelAll,
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text("Tout annuler", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  Widget _btn(String text, VoidCallback action) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: ElevatedButton(onPressed: action, child: Text(text)),
    );
  }
}