import 'package:cloud_firestore/cloud_firestore.dart';

class Paciente {
  final String? id;
  final String nombreMascota;
  final String especie;
  final String raza;
  final int edad;
  final String nombreDueno;
  final String telefono;
  final String motivo;
  final DateTime? fecha;

  Paciente({
    this.id,
    required this.nombreMascota,
    required this.especie,
    required this.raza,
    required this.edad,
    required this.nombreDueno,
    required this.telefono,
    required this.motivo,
    this.fecha,
  });

  Map<String, dynamic> toMap() => {
        'nombreMascota': nombreMascota,
        'especie': especie,
        'raza': raza,
        'edad': edad,
        'nombreDueno': nombreDueno,
        'telefono': telefono,
        'motivo': motivo,
        'fecha': FieldValue.serverTimestamp(),
      };

  factory Paciente.fromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
    final d = doc.data() ?? {};
    return Paciente(
      id: doc.id,
      nombreMascota: d['nombreMascota'] ?? '',
      especie: d['especie'] ?? '',
      raza: d['raza'] ?? '',
      edad: (d['edad'] ?? 0) as int,
      nombreDueno: d['nombreDueno'] ?? '',
      telefono: d['telefono'] ?? '',
      motivo: d['motivo'] ?? '',
      fecha: (d['fecha'] as Timestamp?)?.toDate(),
    );
  }
}
