# Directorio Dolorense — Flutter + API local + TDD

Proyecto basado en el manual proporcionado. Contiene una API REST en Node.js y una app Flutter organizada por dominio, datos y presentación.

## Requisitos
- Flutter instalado (`flutter doctor`)
- Dart incluido con Flutter
- Node.js 18 o superior

## 1. Abrir en Visual Studio Code
Abre en VS Code la carpeta `Directorio_Dolores_TDD` (Archivo > Abrir carpeta).

## 2. Iniciar la API
Abre una terminal en VS Code:

```powershell
cd api
node server.js
```

La API queda disponible en `http://localhost:3000/negocios`. Deja esta terminal abierta.

Prueba en el navegador:
- `http://localhost:3000/salud`
- `http://localhost:3000/negocios`

## 3. Preparar Flutter
Abre una segunda terminal:

```powershell
cd app
flutter pub get
flutter test
```

Este paquete incluye el código Dart, `pubspec.yaml` y pruebas. Para crear las carpetas nativas Android/iOS/web/Windows de acuerdo con las plataformas instaladas en tu computadora, ejecuta una sola vez desde `app`:

```powershell
flutter create .
```

Después puedes ejecutar:

```powershell
flutter run
```

## 4. Dirección de la API
- Emulador Android: `http://10.0.2.2:3000` (configurado automáticamente).
- Windows/escritorio: `http://localhost:3000`.
- Celular físico: usa la IP local de tu PC, por ejemplo:

```powershell
flutter run --dart-define=API_URL=http://192.168.1.50:3000
```

Sustituye la IP de ejemplo por la IPv4 de tu PC (`ipconfig`). El celular y la PC deben estar en la misma Wi-Fi y el firewall debe permitir el puerto 3000.

En Android, para desarrollo local HTTP, revisa `app/android/app/src/main/AndroidManifest.xml` después de generar Android con `flutter create .` y agrega `android:usesCleartextTraffic="true"` dentro de `<application>`. Esto es únicamente para desarrollo; en producción se debe usar HTTPS.

## Funciones incluidas
- Consultar y buscar negocios.
- Agregar negocios.
- Marcar/quitar favoritos.
- Eliminar deslizando un elemento.
- Estados inicial, cargando, listo, vacío y error.
- Pruebas unitarias con `MockClient`, sin depender de la red.

Los negocios de la API se guardan en memoria; al reiniciar Node.js, la lista vuelve a los cinco registros iniciales.
