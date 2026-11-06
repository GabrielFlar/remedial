import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../services/auth_service.dart';
import '../theme/clay.dart';
import 'home_screen.dart';
import 'register_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  final _authService = AuthService();

  bool _obscurePass = true;
  bool _loadingEmail = false;

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passCtrl.dispose();
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

  void _showSuccess(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: const Color(0xFF67B99A),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
    );
  }

  Future<void> _loginEmail() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _loadingEmail = true);
    try {
      await _authService.signInWithEmail(_emailCtrl.text, _passCtrl.text);
      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const HomeScreen()),
      );
    } on FirebaseAuthException catch (e) {
      String msg = 'Error al iniciar sesión.';
      if (e.code == 'user-not-found' || e.code == 'invalid-credential') {
        msg = 'Correo o contraseña incorrectos.';
      } else if (e.code == 'wrong-password') {
        msg = 'Contraseña incorrecta.';
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

  void _forgotPassword() {
    final email = _emailCtrl.text.trim();
    if (email.isEmpty) {
      _showError('Ingresa tu correo para restablecer la contraseña.');
      return;
    }
    _authService.sendPasswordReset(email).then((_) {
      _showSuccess('Enlace enviado a $email.');
    }).catchError((e) {
      _showError('No se pudo enviar el correo de recuperación.');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEFF3FA),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 82,
                  height: 82,
                  decoration: BoxDecoration(
                    color: const Color(0xFFDDD5FF),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.white.withOpacity(0.9),
                        offset: const Offset(-4, -4),
                        blurRadius: 10,
                      ),
                      BoxShadow(
                        color: const Color(0xFF9F92D0).withOpacity(0.35),
                        offset: const Offset(4, 5),
                        blurRadius: 12,
                      ),
                    ],
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.pets_rounded,
                      size: 40,
                      color: Color(0xFF382A64),
                    ),
                  ),
                ),
                const SizedBox(height: 18),
                const Text(
                  'Bienvenido',
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.w900,
                    color: ClayColors.text,
                  ),
                ),
                const SizedBox(height: 6),
                const Text(
                  'Inicia sesión para continuar',
                  style: TextStyle(
                    fontSize: 15,
                    color: ClayColors.textSoft,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 26),
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
                        const SizedBox(height: 8),
                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                            onPressed: _forgotPassword,
                            child: const Text(
                              '¿Olvidaste tu contraseña?',
                              style: TextStyle(
                                color: Color(0xFF6B5CD1),
                                fontWeight: FontWeight.w600,
                                fontSize: 13,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        ClayButton(
                          label: 'Iniciar sesión',
                          color: const Color(0xFFC7B8FF),
                          loading: _loadingEmail,
                          onPressed: _loginEmail,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 28),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      '¿No tienes cuenta? ',
                      style: TextStyle(
                        color: ClayColors.textSoft,
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const RegisterScreen(),
                          ),
                        );
                      },
                      child: const Text(
                        'Regístrate',
                        style: TextStyle(
                          color: Color(0xFF6B5CD1),
                          fontWeight: FontWeight.w800,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
