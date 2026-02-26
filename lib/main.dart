import 'package:brujula/app_color.dart';
import 'package:brujula/homeScreen.dart'; // Asegúrate de importar tu nueva pantalla de inicio
import 'package:flutter/material.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Brujula Urbana', // Actualizamos el título del sistema
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        // Aplicamos el tema oscuro global basado en tu paleta urbana
        brightness: Brightness.dark,
        primaryColor: AppColor.PrimaryDarkColor,
        scaffoldBackgroundColor: AppColor.primaryColor,
      ),
      // Cambiamos brujula_pantalla() por HomeScreen() para que sea lo primero en verse
      home: const HomeScreen(),
    );
  }
}