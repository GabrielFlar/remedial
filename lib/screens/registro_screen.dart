import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../models/paciente.dart';
import '../services/paciente_service.dart';
import '../theme/clay.dart';

class RegistroScreen extends StatefulWidget {
  const RegistroScreen({super.key});

  @override
  State<RegistroScreen> createState() => _RegistroScreenState();
}

class _RegistroScreenState extends State<RegistroScreen> {
  final _formKey = GlobalKey<FormState>();
  final _service = PacienteService();

  final _mascota = TextEditingController();
  final _raza = TextEditingController();
  final _edad = TextEditingController();
  final _dueno = TextEditingController();
  final _telefono = TextEditingController();
  final _motivo = TextEditingController();

  static const _especies = ['Perro', 'Gato', 'Ave', 'Conejo', 'Reptil', 'Otro'];
  String _especie = 'Perro';
  bool _guardando = false;

  @override
  void dispose() {
    for (final c in [_mascota, _raza, _edad, _dueno, _telefono, _motivo]) {
      c.dispose();
    }
    super.dispose();
  }

  String? _requerido(String? v, [String campo = 'Este campo']) {
    if (v == null || v.trim().isEmpty) return '$campo es obligatorio';
    return null;
  }

  Future<void> _guardar() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _guardando = true);
    try {
      await _service.agregar(Paciente(
        nombreMascota: _mascota.text.trim(),
        especie: _especie,
        raza: _raza.text.trim(),
        edad: int.parse(_edad.text.trim()),
        nombreDueno: _dueno.text.trim(),
        telefono: _telefono.text.trim(),
        motivo: _motivo.text.trim(),
      ));
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Paciente registrado ✅')),
      );
      Navigator.pop(context);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al guardar: $e')),
      );
    } finally {
      if (mounted) setState(() => _guardando = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: ClayColors.text),
        title: const Text('Registrar paciente',
            style: TextStyle(
                color: ClayColors.text, fontWeight: FontWeight.w900)),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: ClayContainer(
            padding: const EdgeInsets.all(22),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClayField(
                    controller: _mascota,
                    label: 'Nombre de la mascota',
                    icon: Icons.pets_rounded,
                    maxLength: 40,
                    validator: (v) => _requerido(v, 'El nombre'),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(left: 6, bottom: 8),
                    child: Text('Especie',
                        style: TextStyle(
                            color: ClayColors.textSoft,
                            fontWeight: FontWeight.w700)),
                  ),
                  Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: _especies.map((e) {
                      final sel = e == _especie;
                      return GestureDetector(
                        onTap: () => setState(() => _especie = e),
                        child: ClayContainer(
                          radius: 18,
                          pressed: sel,
                          color: sel ? ClayColors.mint : Colors.white,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 10),
                          child: Text(e,
                              style: const TextStyle(
                                  color: ClayColors.text,
                                  fontWeight: FontWeight.w700)),
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 20),
                  ClayField(
                    controller: _raza,
                    label: 'Raza',
                    icon: Icons.category_rounded,
                    maxLength: 40,
                    validator: (v) => _requerido(v, 'La raza'),
                  ),
                  ClayField(
                    controller: _edad,
                    label: 'Edad (años)',
                    icon: Icons.cake_rounded,
                    keyboardType: TextInputType.number,
                    maxLength: 2,
                    validator: (v) {
                      final r = _requerido(v, 'La edad');
                      if (r != null) return r;
                      final n = int.tryParse(v!.trim());
                      if (n == null || n < 0 || n > 40) {
                        return 'Ingresa una edad válida (0-40)';
                      }
                      return null;
                    },
                  ),
                  ClayField(
                    controller: _dueno,
                    label: 'Nombre del dueño',
                    icon: Icons.person_rounded,
                    maxLength: 60,
                    validator: (v) => _requerido(v, 'El nombre del dueño'),
                  ),
                  ClayField(
                    controller: _telefono,
                    label: 'Teléfono (10 dígitos)',
                    icon: Icons.phone_rounded,
                    keyboardType: TextInputType.phone,
                    maxLength: 10,
                    validator: (v) {
                      final r = _requerido(v, 'El teléfono');
                      if (r != null) return r;
                      if (!RegExp(r'^\d{10}$').hasMatch(v!.trim())) {
                        return 'Debe tener 10 dígitos';
                      }
                      return null;
                    },
                  ),
                  ClayField(
                    controller: _motivo,
                    label: 'Motivo de la consulta',
                    icon: Icons.medical_services_rounded,
                    maxLines: 3,
                    maxLength: 200,
                    validator: (v) => _requerido(v, 'El motivo'),
                  ),
                  const SizedBox(height: 4),
                  ClayButton(
                    label: 'Guardar paciente',
                    icon: Icons.save_rounded,
                    color: ClayColors.lavender,
                    loading: _guardando,
                    onPressed: _guardar,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
