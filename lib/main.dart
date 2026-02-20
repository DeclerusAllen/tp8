import 'package:flutter/material.dart';
import 'notification_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final service = NotificationService();
  await service.initialize();
  await service.requestPermissions();
  runApp(MyApp(service: service));
}

class MyApp extends StatelessWidget {
  final NotificationService service;
  const MyApp({super.key, required this.service});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: const Text("Aplikasyon Notifikasyon"),
          backgroundColor: Colors.blue,
          foregroundColor: Colors.white,
        ),
        body: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            ElevatedButton(
              onPressed: () => service.showNotification(),
              child: const Text("Voye Notifikasyon Rapid"),
            ),
            const Text("L ap voye yon notifikasyon kounye a menm sou telefòn ou."),
            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: () => service.scheduleNotification(),
              child: const Text("Pwogramasyon (5 segonn)"),
            ),
            const Text("Notifikasyon sa ap parèt apre 5 segond si w klike sou li."),
            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: () => service.repeatNotification(),
              child: const Text("Repetisyon Chak Minit"),
            ),
            const Text("Opsyon sa ap fè notifikasyon an parèt chak minit."),
            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: () => service.showBigImageNotification(),
              child: const Text("Notifikasyon ak Gwo Foto"),
            ),
            const Text("W ap resevwa yon notifikasyon ki gen yon bèl foto ladan l."),
            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: () => service.showNotificationWithActions(),
              child: const Text("Notifikasyon ak Opsyon Aksyon"),
            ),
            const Text("Sa ap ba ou bouton pou w chwazi 'Aksepte' oswa 'Refize'."),
          ],
        ),
      ),
    );
  }
}