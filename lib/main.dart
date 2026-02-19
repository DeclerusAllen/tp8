import 'package:flutter/material.dart';
import 'notification_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  final service = NotificationService();
  await service.initialize();
  await service.requestPermissions(); 

  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    theme: ThemeData(primarySwatch: Colors.blue, useMaterial3: true),
    home: HomePage(service: service),
  ));
}

class HomePage extends StatelessWidget {
  final NotificationService service;
  const HomePage({super.key, required this.service});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Aplikasyon Notifikasyon"),
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
        foregroundColor: Colors.white,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          // Bouton 1
          _btn(
            "Notifikasyon Rapid", 
            "L ap voye yon notifikasyon kounye a menm sou telefòn ou.",
            service.showNotification
          ),

          // Bouton 2
          _btn(
            "Pwogramasyon (5s)", 
            "Notifikasyon sa ap parèt apre 5 segond si w klike sou li.",
            service.scheduleNotification
          ),

          // Bouton 3
          _btn(
            "Repetisyon", 
            "Opsyon sa ap fè notifikasyon an parèt chak minit.",
            service.repeatNotification
          ),

          // Bouton 4
          _btn(
            "Gwo Foto", 
            "W ap resevwa yon notifikasyon ki gen yon bèl foto ladan l.",
            service.showBigImageNotification
          ),

          // Bouton 5
          _btn(
            "Opsyon Aksyon", 
            "Sa ap ba ou bouton pou w chwazi 'Aksepte' oswa 'Refize' nan notifikasyon an.",
            service.showNotificationWithActions
          ),
        ],
      ),
    );
  }

  // Widget bouton ak ti fraz kreyòl anba l
  Widget _btn(String tit, String deskripsyon, VoidCallback action) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ElevatedButton(
          onPressed: action,
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 12),
            elevation: 2,
          ),
          child: Text(tit, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 6, bottom: 20, left: 10, right: 10),
          child: Text(
            deskripsyon,
            style: TextStyle(
              fontSize: 14, 
              color: Colors.blueGrey[800], 
              fontStyle: FontStyle.italic
            ),
          ),
        ),
      ],
    );
  }
}