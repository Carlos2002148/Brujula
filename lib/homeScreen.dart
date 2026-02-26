import 'package:flutter/material.dart';
import 'package:brujula/app_color.dart';
import 'brujula.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Estilo para los nombres en color negro/gris oscuro
    const TextStyle nombreEstilo = TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w500,
      color: Color(0xFF2D2D2D), // Gris muy oscuro para suavizar el negro puro
    );

    return Scaffold(
      backgroundColor: Colors.white, // Fondo blanco solicitado
      body: Container(
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // --- LOGO UNISON ---
            Container(
              width: 170,
              height: 170,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
                image: const DecorationImage(
                  image: AssetImage('assets/logo_unison.png'),
                  fit: BoxFit.contain,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 20,
                    spreadRadius: 2,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 35),

            // TÍTULO EN NEGRO
            const Text(
              'BRÚJULA URBANA',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.w900,
                color: Color(0xFF1A1A1A), // Negro casi puro
                letterSpacing: 2,
              ),
            ),
            const Text(
              'PROYECTO UNISON',
              style: TextStyle(
                fontSize: 13,
                color: Color(0xFF00B0FF), // Mantenemos el azul neón para acentos
                fontWeight: FontWeight.bold,
                letterSpacing: 1.5,
              ),
            ),

            const SizedBox(height: 40),

            // NOMBRES DE LOS INTEGRANTES EN OSCURO
            const Text('Carlos Guadalupe Grijalva Castillo', style: nombreEstilo),
            const SizedBox(height: 10),
            const Text('Jorge Luis Ruiz Muños', style: nombreEstilo),
            const SizedBox(height: 10),
            const Text('Isaac Moreno Gonzalez', style: nombreEstilo),
            const SizedBox(height: 10),
            const Text('Carlos Rene Quijada Ruiz Lopez', style: nombreEstilo),

            const SizedBox(height: 60),

            // BOTÓN DE INICIO (Mantenemos el estilo que te gustó)
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const brujula_pantalla()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF00B0FF), // Azul Neón
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 55, vertical: 18),
                elevation: 5,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                shadowColor: const Color(0xFF00B0FF).withOpacity(0.4),
              ),
              child: const Text(
                'INICIAR NAVEGACIÓN',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                  letterSpacing: 1,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}