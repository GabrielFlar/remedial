import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/paciente.dart';
import '../services/paciente_service.dart';
import '../theme/clay.dart';

class ListaScreen extends StatelessWidget {
  const ListaScreen({super.key});

  static const _emojis = {
    'Perro': '🐶',
    'Gato': '🐱',
    'Ave': '🐦',
    'Conejo': '🐰',
    'Reptil': '🦎',
  };

  @override
  Widget build(BuildContext context) {
    final service = PacienteService();
    final colores = [
      ClayColors.mint,
      ClayColors.peach,
      ClayColors.sky,
      ClayColors.lavender,
    ];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: ClayColors.text),
        title: const Text('Pacientes',
            style: TextStyle(
                color: ClayColors.text, fontWeight: FontWeight.w900)),
      ),
      body: StreamBuilder<List<Paciente>>(
        stream: service.streamPacientes(),
        builder: (context, snap) {
          if (snap.hasError) {
            return Center(
                child: Padding(
              padding: const EdgeInsets.all(24),
              child: Text('Error al cargar: ${snap.error}',
                  textAlign: TextAlign.center),
            ));
          }
          if (!snap.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final lista = snap.data!;
          if (lista.isEmpty) {
            return const Center(
              child: Text('Aún no hay pacientes 🐾',
                  style: TextStyle(
                      color: ClayColors.textSoft,
                      fontSize: 18,
                      fontWeight: FontWeight.w700)),
            );
          }
          return ListView.separated(
            padding: const EdgeInsets.all(20),
            itemCount: lista.length,
            separatorBuilder: (_, __) => const SizedBox(height: 18),
            itemBuilder: (context, i) {
              final p = lista[i];
              return ClayContainer(
                color: colores[i % colores.length],
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(_emojis[p.especie] ?? '🐾',
                        style: const TextStyle(fontSize: 38)),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(p.nombreMascota,
                              style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w900,
                                  color: ClayColors.text)),
                          Text('${p.especie} · ${p.raza} · ${p.edad} años',
                              style:
                                  const TextStyle(color: ClayColors.textSoft)),
                          const SizedBox(height: 8),
                          Text('Dueño: ${p.nombreDueno}',
                              style: const TextStyle(
                                  color: ClayColors.text,
                                  fontWeight: FontWeight.w600)),
                          Text('Tel: ${p.telefono}',
                              style: const TextStyle(color: ClayColors.text)),
                          const SizedBox(height: 6),
                          Text('Motivo: ${p.motivo}',
                              style: const TextStyle(color: ClayColors.text)),
                          if (p.fecha != null)
                            Padding(
                              padding: const EdgeInsets.only(top: 6),
                              child: Text(
                                  DateFormat('dd/MM/yyyy HH:mm')
                                      .format(p.fecha!),
                                  style: const TextStyle(
                                      color: ClayColors.textSoft,
                                      fontSize: 12)),
                            ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete_rounded,
                          color: ClayColors.text),
                      onPressed: () async {
                        final ok = await showDialog<bool>(
                          context: context,
                          builder: (_) => AlertDialog(
                            title: const Text('Eliminar paciente'),
                            content: Text('¿Eliminar a ${p.nombreMascota}?'),
                            actions: [
                              TextButton(
                                  onPressed: () => Navigator.pop(context, false),
                                  child: const Text('Cancelar')),
                              TextButton(
                                  onPressed: () => Navigator.pop(context, true),
                                  child: const Text('Eliminar')),
                            ],
                          ),
                        );
                        if (ok == true && p.id != null) {
                          await service.eliminar(p.id!);
                        }
                      },
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
