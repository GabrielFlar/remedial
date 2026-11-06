import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../services/auth_service.dart';
import '../theme/clay.dart';
import 'home_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  final _confirmPassCtrl = TextEditingController();
  final _authService = AuthService();

  bool _obscurePass = true;
  bool _obscureConfirm = true;
  bool _loadingEmail = false;

  @override
  void dispose() {
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _passCtrl.dispose();
    _confirmPassCtrl.dispose();
    super.dispose();
  }

  void _showError(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: ClayColors.danger,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
    );
  }

  Future<void> _registerEmail() async {
    if (!_formKey.currentState!.validate()) return;
    if (_passCtrl.text != _confirmPassCtrl.text) {
      _showError('Las contraseñas no coinciden.');
      return;
    }
    setState(() => _loadingEmail = true);
    try {
      await _authService.registerWithEmail(
        _emailCtrl.text,
        _passCtrl.text,
        _nameCtrl.text,
      );
      if (!mounted) return;
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const HomeScreen()),
        (route) => false,
      );
    } on FirebaseAuthException catch (e) {
      String msg = 'Error al registrar la cuenta.';
      if (e.code == 'weak-password') {
        msg = 'La contraseña debe tener al menos 6 caracteres.';
      } else if (e.code == 'email-already-in-use') {
        msg = 'Ya existe una cuenta con este correo.';
      } else if (e.code == 'invalid-email') {
        msg = 'El formato del correo no es válido.';
      } else if (e.message != null) {
        msg = e.message!;
      }
      _showError(msg);
    } catch (e) {
      _showError('Ocurrió un error inesperado: $e');
    } finally {
      if (mounted) setState(() => _loadingEmail = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEFF3FA),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              IconButton(
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                icon: const Icon(
                  Icons.arrow_back,
                  color: ClayColors.text,
                  size: 26,
                ),
                onPressed: () => Navigator.pop(context),
              ),
              const SizedBox(height: 18),
              const Text(
                'Crear cuenta',
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.w900,
                  color: ClayColors.text,
                ),
              ),
              const SizedBox(height: 6),
              const Text(
                'Empieza a registrar pacientes',
                style: TextStyle(
                  fontSize: 15,
                  color: ClayColors.textSoft,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 24),
              ClayContainer(
                color: Colors.white,
                radius: 30,
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      TextFormField(
                        controller: _nameCtrl,
                        validator: (val) {
                          if (val == null || val.trim().isEmpty) {
                            return 'Ingresa tu nombre';
                          }
                          return null;
                        },
                        style: const TextStyle(
                          color: ClayColors.text,
                          fontWeight: FontWeight.w600,
                        ),
                        decoration: InputDecoration(
                          hintText: 'Nombre completo',
                          hintStyle: const TextStyle(color: ClayColors.textSoft),
                          prefixIcon: const Icon(
                            Icons.person_outline_rounded,
                            color: ClayColors.textSoft,
                          ),
                          filled: true,
                          fillColor: const Color(0xFFF3F5FC),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 18,
                            vertical: 18,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(22),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _emailCtrl,
                        keyboardType: TextInputType.emailAddress,
                        validator: (val) {
                          if (val == null || val.trim().isEmpty) {
                            return 'Ingresa tu correo';
                          }
                          if (!val.contains('@')) {
                            return 'Correo inválido';
                          }
                          return null;
                        },
                        style: const TextStyle(
                          color: ClayColors.text,
                          fontWeight: FontWeight.w600,
                        ),
                        decoration: InputDecoration(
                          hintText: 'Correo electrónico',
                          hintStyle: const TextStyle(color: ClayColors.textSoft),
                          prefixIcon: const Icon(
                            Icons.mail_outline_rounded,
                            color: ClayColors.textSoft,
                          ),
                          filled: true,
                          fillColor: const Color(0xFFF3F5FC),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 18,
                            vertical: 18,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(22),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _passCtrl,
                        obscureText: _obscurePass,
                        validator: (val) {
                          if (val == null || val.isEmpty) {
                            return 'Ingresa tu contraseña';
                          }
                          if (val.length < 6) {
                            return 'Mínimo 6 caracteres';
                          }
                          return null;
                        },
                        style: const TextStyle(
                          color: ClayColors.text,
                          fontWeight: FontWeight.w600,
                        ),
                        decoration: InputDecoration(
                          hintText: 'Contraseña',
                          hintStyle: const TextStyle(color: ClayColors.textSoft),
                          prefixIcon: const Icon(
                            Icons.lock_outline_rounded,
                            color: ClayColors.textSoft,
                          ),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscurePass
                                  ? Icons.visibility_outlined
                                  : Icons.visibility_off_outlined,
                              color: ClayColors.textSoft,
                            ),
                            onPressed: () {
                              setState(() => _obscurePass = !_obscurePass);
                            },
                          ),
                          filled: true,
                          fillColor: const Color(0xFFF3F5FC),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 18,
                            vertical: 18,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(22),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _confirmPassCtrl,
                        obscureText: _obscureConfirm,
                        validator: (val) {
                          if (val == null || val.isEmpty) {
                            return 'Confirma tu contraseña';
                          }
                          if (val != _passCtrl.text) {
                            return 'Las contraseñas no coinciden';
                          }
                          return null;
                        },
                        style: const TextStyle(
                          color: ClayColors.text,
                          fontWeight: FontWeight.w600,
                        ),
                        decoration: InputDecoration(
                          hintText: 'Confirmar contraseña',
                          hintStyle: const TextStyle(color: ClayColors.textSoft),
                          prefixIcon: const Icon(
                            Icons.lock_outline_rounded,
                            color: ClayColors.textSoft,
                          ),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscureConfirm
                                  ? Icons.visibility_outlined
                                  : Icons.visibility_off_outlined,
                              color: ClayColors.textSoft,
                            ),
                            onPressed: () {
                              setState(() => _obscureConfirm = !_obscureConfirm);
                            },
                          ),
                          filled: true,
                          fillColor: const Color(0xFFF3F5FC),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 18,
                            vertical: 18,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(22),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      ClayButton(
                        label: 'Crear cuenta',
                        color: const Color(0xFFB8F0D8),
                        loading: _loadingEmail,
                        onPressed: _registerEmail,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 26),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    '¿Ya tienes cuenta? ',
                    style: TextStyle(
                      color: ClayColors.textSoft,
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: const Text(
                      'Inicia sesión',
                      style: TextStyle(
                        color: Color(0xFF6B5CD1),
                        fontWeight: FontWeight.w800,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
