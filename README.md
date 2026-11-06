# VetClay – Registro de pacientes veterinarios

App móvil hecha con **Flutter** y **Firebase (Cloud Firestore + Auth anónima)**, con estilo visual **claymorfismo**.
Proyecto del remedial del segundo parcial – Desarrollo móvil integral.

## Funciones
- Pantalla principal con contador de pacientes en tiempo real.
- Formulario de registro (mascota, especie, raza, edad, dueño, teléfono, motivo).
- Lista de pacientes en tiempo real y eliminación.
- Validaciones: campos obligatorios, sin registros vacíos, edad 0-40, teléfono de 10 dígitos.
- Seguridad: reglas de Firestore (`firestore.rules`) + credenciales fuera de Git.

## 1. Configuración del entorno
1. Instalar Flutter SDK (`flutter doctor` sin errores) y Android Studio.
2. En esta carpeta, generar las carpetas de plataforma:
   ```
   flutter create . --org com.tuusuario --project-name vet_pacientes
   flutter pub get
   ```
   (No sobrescribe `lib/` ni `pubspec.yaml`; si pregunta, conserva los tuyos.)

## 2. Configuración de Firebase
1. Consola Firebase → proyecto `remedial-a7ba1`.
2. **Firestore Database** → Crear base de datos (modo producción).
3. **Authentication** → Sign-in method → habilitar **Anónimo**.
4. **Firestore → Reglas**: pegar el contenido de `firestore.rules` y publicar.
5. Registrar la app **Android** (paquete = el de `android/app/build.gradle`, p. ej. `com.tuusuario.vet_pacientes`).
   Lo más fácil:
   ```
   dart pub global activate flutterfire_cli
   flutterfire configure --project=remedial-a7ba1
   ```
   Esto regenera `lib/firebase_options.dart` con los datos de Android.

## 3. Ejecutar
```
flutter run
```

## 4. Compilar el APK
```
flutter build apk --release
```
Resultado: `build/app/outputs/flutter-apk/app-release.apk`

## 5. Distribución (APK + URL)
- **APK**: copiar el archivo al celular e instalarlo (permitir orígenes desconocidos), o subirlo a GitHub Releases / Drive.
- **URL (web)**:
  ```
  flutter build web --release
  npm i -g firebase-tools
  firebase login
  firebase init hosting   # carpeta pública: build/web, SPA: sí
  firebase deploy --only hosting
  ```
  La URL queda como `https://remedial-a7ba1.web.app`.
  También hay que agregar el dominio en Authentication → Settings → Authorized domains (suele venir ya).

## 6. Control de versiones
```
git init
git add .
git commit -m "Proyecto inicial Flutter"
git branch -M main
git remote add origin https://github.com/GabrielFlar/remedial.git
git push -u origin main
```
Haz commits por etapa (diseño, conexión Firebase, validaciones, despliegue).
