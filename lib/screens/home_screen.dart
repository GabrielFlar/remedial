import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../services/auth_service.dart';
import '../theme/clay.dart';
import 'lista_screen.dart';
import 'login_screen.dart';
import 'registro_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    final name = (user?.displayName != null && user!.displayName!.isNotEmpty)
        ? user.displayName!
        : (user?.email != null ? user!.email!.split('@').first : 'Doctor(a)');

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Hola, $name 👋',
                          style: const TextStyle(
                              fontSize: 18,
                              color: ClayColors.textSoft,
                              fontWeight: FontWeight.w600)),
                      const Text('Clínica Veterinaria',
                          style: TextStyle(
                              fontSize: 28,
                              color: ClayColors.text,
                              fontWeight: FontWeight.w900)),
                    ],
                  ),
                  IconButton(
                    icon: const Icon(Icons.logout_rounded,
                        color: ClayColors.danger, size: 26),
                    tooltip: 'Cerrar sesión',
                    onPressed: () async {
                      await AuthService().signOut();
                      if (!context.mounted) return;
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (_) => const LoginScreen()),
                        (route) => false,
                      );
                    },
                  ),
                ],
              ),
              const SizedBox(height: 28),
              ClayContainer(
                color: ClayColors.sky,
                padding: const EdgeInsets.all(24),
                child: Row(
                  children: [
                    const Text('🐶', style: TextStyle(fontSize: 54)),
                    const SizedBox(width: 18),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Pacientes registrados',
                              style: TextStyle(
                                  color: ClayColors.text,
                                  fontWeight: FontWeight.w700)),
                          StreamBuilder<QuerySnapshot>(
                            stream: FirebaseFirestore.instance
                                .collection('pacientes')
                                .snapshots(),
                            builder: (context, snap) {
                              final n = snap.hasData ? snap.data!.size : 0;
                              return Text('$n',
                                  style: const TextStyle(
                                      fontSize: 42,
                                      color: ClayColors.text,
                                      fontWeight: FontWeight.w900));
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 28),
              _MenuCard(
                emoji: '📝',
                titulo: 'Registrar paciente',
                subtitulo: 'Agrega una nueva mascota',
                color: ClayColors.mint,
                onTap: () => Navigator.push(context,
                    MaterialPageRoute(builder: (_) => const RegistroScreen())),
              ),
              const SizedBox(height: 20),
              _MenuCard(
                emoji: '📋',
                titulo: 'Ver pacientes',
                subtitulo: 'Consulta los registros',
                color: ClayColors.peach,
                onTap: () => Navigator.push(context,
                    MaterialPageRoute(builder: (_) => const ListaScreen())),
              ),
              const Spacer(),
              const Center(
                child: Text('Desarrollo móvil integral · Flutter + Firebase',
                    style: TextStyle(color: ClayColors.textSoft, fontSize: 12)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MenuCard extends StatelessWidget {
  final String emoji, titulo, subtitulo;
  final Color color;
  final VoidCallback onTap;

  const _MenuCard({
    required this.emoji,
    required this.titulo,
    required this.subtitulo,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: ClayContainer(
        color: color,
        padding: const EdgeInsets.all(22),
        child: Row(
          children: [
            Text(emoji, style: const TextStyle(fontSize: 40)),
            const SizedBox(width: 18),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(titulo,
                      style: const TextStyle(
                          fontSize: 19,
                          fontWeight: FontWeight.w800,
                          color: ClayColors.text)),
                  Text(subtitulo,
                      style: const TextStyle(color: ClayColors.textSoft)),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios_rounded,
                color: ClayColors.text, size: 18),
          ],
        ),
      ),
    );
  }
}
