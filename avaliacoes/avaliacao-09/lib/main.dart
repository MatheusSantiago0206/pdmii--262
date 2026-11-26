import 'package:flutter/material.dart';
import 'screens/catalogo_guitarras_screen.dart';

void main() {
  runApp(const CatalogoGuitarrasApp());
}

class CatalogoGuitarrasApp extends StatelessWidget {
  const CatalogoGuitarrasApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Guitar Store API',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepOrange.shade800,
        ),
        useMaterial3: true,
      ),
      home: const CatalogoGuitarrasScreen(),
    );
  }
}