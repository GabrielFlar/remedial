import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/paciente.dart';

class PacienteService {
  final _col = FirebaseFirestore.instance.collection('pacientes');

  Future<void> agregar(Paciente p) async {
    await _col.add(p.toMap());
  }

  Stream<List<Paciente>> streamPacientes() {
    return _col
        .orderBy('fecha', descending: true)
        .snapshots()
        .map((s) => s.docs.map(Paciente.fromDoc).toList());
  }

  Future<void> eliminar(String id) => _col.doc(id).delete();
}
