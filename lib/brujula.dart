import 'dart:math';
import 'package:brujula/app_color.dart';
import 'package:brujula/brujula_pintar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_compass/flutter_compass.dart';
import 'package:geolocator/geolocator.dart';

class brujula_pantalla extends StatefulWidget {
  const brujula_pantalla({super.key});

  @override
  State<brujula_pantalla> createState() => _EstadoBrujula();
}

class _EstadoBrujula extends State<brujula_pantalla> {
  double? direction;
  Position? _currentPosition;

  @override
  void initState() {
    super.initState();
    _determinePosition();
  }

  void _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) return;

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) return;
    }

    Geolocator.getPositionStream(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 2,
      ),
    ).listen((Position position) {
      if (mounted) {
        setState(() {
          _currentPosition = position;
        });
      }
    });
  }

  double headingToDegree(double heading) {
    return heading < 0 ? 360 - heading.abs() : heading;
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: AppColor.primaryColor, // Color de fondo oscuro (Gris/Negro)
      body: StreamBuilder<CompassEvent>(
        stream: FlutterCompass.events,
        builder: (context, snapshot) {
          if (snapshot.hasError) return const Center(child: Text("Error"));
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator(color: AppColor.greenColor));
          }

          direction = snapshot.data!.heading;
          if (direction == null) return const Center(child: Text("Sin sensores"));

          return Stack(
            children: [
              // Texto decorativo superior (Título Urbano)
              Positioned(
                top: 80,
                left: 40,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("URBANO",
                        style: TextStyle(color: AppColor.white, fontSize: 32, fontWeight: FontWeight.w900, letterSpacing: 2)),
                    Text("Sistema de orientación",
                        style: TextStyle(color: AppColor.greenColor, fontSize: 12, fontWeight: FontWeight.bold, letterSpacing: 1.5)),
                  ],
                ),
              ),

              // --- POSICIONAMIENTO MEDIA BAJA ---
              Align(
                alignment: const Alignment(0, 0.6), // Ubica la brújula abajo
                child: Stack(
                  alignment: Alignment.center,
                  children: [

                    // --- 1. SOMBRA NEGRA MUY DIFUMINADA (EXTERNA) ---
                    Container(
                      width: size.width * 0.85,
                      height: size.width * 0.85,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.8), // Negro profundo
                            blurRadius: 80,    // Difuminado máximo para suavidad
                            spreadRadius: 15,  // Extensión larga hacia afuera
                            offset: const Offset(0, 20),
                          ),
                        ],
                      ),
                    ),

                    // --- 2. MARCO EXTERIOR (CARCASA NEGRA METALIZADA) ---
                    Container(
                      width: size.width * 0.94,
                      height: size.width * 0.94,
                      decoration: BoxDecoration(
                        color: AppColor.PrimaryDarkColor, // Negro carbón
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.grey.shade800, // Brillo metálico sutil
                          width: 4,
                        ),
                      ),
                    ),

                    // --- 3. DISCO DE LA BRÚJULA (ESTILO LIMPIO SIN BLANCO) ---
                    Container(
                      width: size.width * 0.82,
                      height: size.width * 0.82,
                      decoration: const BoxDecoration(
                        color: Color(0xFFF5F5F5), // Blanco mate / gris muy claro
                        shape: BoxShape.circle,
                      ),
                      padding: const EdgeInsets.all(10),
                      child: Transform.rotate(
                        angle: (direction! * (pi / 180) * -1),
                        child: CustomPaint(
                          size: size,
                          painter: BrujulaPintar(color: Colors.black54),
                        ),
                      ),
                    ),

                    // --- 4. WIDGET CENTRAL (ACENTO AZUL NEÓN) ---
                    CenterDisplayMeter(
                      direction: headingToDegree(direction!),
                      lat: _currentPosition?.latitude,
                      lon: _currentPosition?.longitude,
                      alt: _currentPosition?.altitude,
                    ),

                    // --- 5. AGUJA INDICADORA (NORTE INDUSTRIAL) ---
                    Transform.translate(
                      offset: Offset(0, -size.width * 0.36),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 12,
                            height: 12,
                            decoration: const BoxDecoration(
                              color: AppColor.red,
                              shape: BoxShape.circle,
                            ),
                          ),
                          Container(
                            width: 3,
                            height: size.width * 0.16,
                            decoration: const BoxDecoration(
                              color: AppColor.red,
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class CenterDisplayMeter extends StatelessWidget {
  const CenterDisplayMeter({
    super.key,
    required this.direction,
    this.lat,
    this.alt,
    this.lon,
  });

  final double direction;
  final double? lat;
  final double? alt;
  final double? lon;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Container(
      width: size.width * 0.44, // Círculo central más grande para datos
      height: size.width * 0.44,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: AppColor.greenColor.withOpacity(0.4), // Resplandor azul neón
            blurRadius: 15,
            spreadRadius: 2,
          ),
        ],
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColor.greenDarkColor, // Azul oscuro
            AppColor.greenColor,     // Azul neón
          ],
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "${direction.toInt()}°",
            style: TextStyle(
              color: Colors.white,
              fontSize: size.width * 0.08,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            getDirection(direction),
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
          const Divider(color: Colors.white24, height: 12, indent: 35, endIndent: 35),
          _infoText("Lat", lat, size),
          _infoText("Lon", lon, size),
          _infoText("Alt", alt, size, isAlt: true),
        ],
      ),
    );
  }

  Widget _infoText(String label, double? val, Size size, {bool isAlt = false}) {
    return Text(
      val != null ? "$label: ${isAlt ? val.toInt() : val.toStringAsFixed(4)}${isAlt ? 'm' : ''}" : "$label: --",
      style: TextStyle(
        color: Colors.white.withOpacity(0.9),
        fontSize: size.width * 0.026,
      ),
    );
  }

  String getDirection(double direction) {
    if (direction >= 337.6 || direction < 22.5) return "NORTE";
    if (direction >= 22.5 && direction < 67.5) return "NORESTE";
    if (direction >= 67.5 && direction < 112.5) return "ESTE";
    if (direction >= 112.5 && direction < 157.5) return "SURESTE";
    if (direction >= 157.5 && direction < 202.5) return "SUR";
    if (direction >= 202.5 && direction < 247.5) return "SUROESTE";
    if (direction >= 247.5 && direction < 292.5) return "OESTE";
    return "NOROESTE";
  }
}