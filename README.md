# Dolores AR — Manual Paso a Paso con TDD [cite: 1]

App turística con realidad aumentada para visitar Dolores Hidalgo (GPS, Brújula, Cámara, Trigonometría, Modelos 3D y Pasaporte Turístico) [cite: 1]. Desarrollado para la materia de **Desarrollo Móvil Integral** en la **UTNG** (Prof. Anastacio Rodríguez García) [cite: 1].

---

## 🛠️ Requisitos e Instalación

1. **Clonar o descargar** este proyecto y abrirlo en VS Code.
2. **Obtener dependencias**:
   ```bash
   flutter pub get
   ```
3. **Ejecutar Pruebas Unitarias (TDD)**:
   ```bash
   flutter test
   ```
4. **Ejecutar la App**:
   ```bash
   flutter run
   ```

---

## 📁 Estructura del Proyecto

```text
dolores_ar/
├── android/
│   └── app/src/main/AndroidManifest.xml   <- Configuración de permisos (Cámara y GPS) [cite: 1]
├── lib/
│   ├── datos/
│   │   ├── fuentes_reales.dart            <- Geolocator y FlutterCompass [cite: 1]
│   │   └── fuentes_simuladas.dart         <- MODO DEMO sin GPS ni brújula real [cite: 1]
│   ├── dominio/
│   │   ├── catalogo.dart                  <- Puntos de interés de Dolores Hidalgo [cite: 1]
│   │   ├── excepciones.dart               <- Excepciones de dominio y mensajes seguros [cite: 1]
│   │   ├── fuentes.dart                   <- Contratos (FuentePosicion, FuenteBrujula) [cite: 1]
│   │   ├── geo.dart                       <- Haversine, rumbos, suavizado y FOV [cite: 1]
│   │   ├── lugar.dart                     <- Entidad Lugar y Categorías [cite: 1]
│   │   ├── motor_ar.dart                  <- Cálculo de visibilidad y perspectiva AR [cite: 1]
│   │   └── pasaporte.dart                 <- Sistema de gamificación de sellos [cite: 1]
│   ├── presentacion/
│   │   ├── ar_viewmodel.dart              <- ViewModel desacoplado con ChangeNotifier [cite: 1]
│   │   ├── fondo_camara.dart              <- Preview de la cámara con fallback visual [cite: 1]
│   │   ├── pantalla_ar.dart               <- Vista principal de Realidad Aumentada [cite: 1]
│   │   ├── pantalla_inicio.dart           <- Menú de navegación y controles Demo [cite: 1]
│   │   └── pantalla_modelo3d.dart         <- RA de superficie (model_viewer_plus) [cite: 1]
│   └── main.dart                          <- Punto de entrada [cite: 1]
├── test/
│   ├── ar_viewmodel_test.dart             <- Pruebas del ViewModel [cite: 1]
│   ├── ayudas_geo.dart                    <- Helpers de prueba [cite: 1]
│   ├── geo_test.dart                      <- Pruebas de trigonometría y Haversine [cite: 1]
│   ├── motor_ar_test.dart                 <- Pruebas del motor de proyección AR [cite: 1]
│   └── pasaporte_test.dart                <- Pruebas del pasaporte de sellos [cite: 1]
└── pubspec.yaml                           <- Dependencias del proyecto [cite: 1]
```

---

## 📸 Evidencias de Ejecución

### 1. Lista de Evidencias Técnicas
- **Capa de Dominio Pura**: Toda la lógica matemática (fórmula de Haversine [cite: 1], rumbo inicial [cite: 1], proyección de campo de visión [cite: 1] y filtro pasa-bajas para la brújula [cite: 1]) se implementó sin dependencias de Flutter o plugins externos [cite: 1].
- **Pruebas TDD (Ciclo Rojo-Verde-Refactor)**: Cobertura total en el cálculo de distancias, diferencia angular en la transición $359^\circ ightarrow 1^\circ$ [cite: 1], ordenamiento por profundidad [cite: 1] y entrega del sello a $<40	ext{ m}$ [cite: 1].
- **Modo Demo (Salón de Clases)**: Permite simular posición GPS en el Jardín Principal de Dolores Hidalgo [cite: 1] y controlar el giro de brújula con un deslizador [cite: 1].
- **Manejo Seguro de Excepciones**: Protección ante rechazo de permisos [cite: 1], sensores ausentes o GPS desactivado [cite: 1].

---

### 2. Captura de Ejecución de Pruebas Unitarias (`flutter test`)

```text
00:01 +0: test/geo_test.dart: distanciaMetros (Haversine) un grado de latitud mide unos 111.2 km
00:01 +1: test/geo_test.dart: distanciaMetros (Haversine) el mismo punto está a 0 metros
00:01 +2: test/geo_test.dart: distanciaMetros (Haversine) es simétrica: A→B = B→A
00:01 +3: test/geo_test.dart: distanciaMetros (Haversine) un punto a 300 m norte y 400 m este está a 500 m (triángulo 3-4-5)
00:01 +4: test/geo_test.dart: rumboGrados norte = 0°
00:01 +5: test/geo_test.dart: rumboGrados este = 90°
00:01 +6: test/geo_test.dart: rumboGrados sur = 180°
00:01 +7: test/geo_test.dart: rumboGrados oeste = 270°
00:01 +8: test/geo_test.dart: rumboGrados noreste = 45°
00:01 +9: test/geo_test.dart: ángulos normalizar360 lleva todo a 0..360
00:01 +10: test/geo_test.dart: ángulos diferenciaAngular toma el camino corto
00:01 +11: test/geo_test.dart: ángulos suavizarAngulo avanza una fracción hacia el nuevo valor
00:01 +12: test/geo_test.dart: ángulos suavizarAngulo cruza el 0° por el lado corto (350° → 10°)
00:01 +13: test/geo_test.dart: ángulos nombreCardinal
00:01 +14: test/geo_test.dart: posicionHorizontal (campo de visión 60°) justo al frente cae en el centro
00:01 +15: test/geo_test.dart: posicionHorizontal (campo de visión 60°) en el borde derecho
00:01 +16: test/geo_test.dart: posicionHorizontal (campo de visión 60°) en el borde izquierdo
00:01 +17: test/geo_test.dart: posicionHorizontal (campo de visión 60°) a medio camino
00:01 +18: test/geo_test.dart: posicionHorizontal (campo de visión 60°) fuera del campo de visión no se dibuja
00:01 +19: test/geo_test.dart: formatearDistancia metros y kilómetros
00:02 +20: test/motor_ar_test.dart: un lugar justo adelante aparece en el centro de la pantalla
00:02 +21: test/motor_ar_test.dart: un lugar a 90° a la derecha NO aparece si miras al norte
00:02 +22: test/motor_ar_test.dart: al girar hacia el este, ese lugar aparece en el centro
00:02 +23: test/motor_ar_test.dart: si giras un poco, el lugar se desplaza al lado contrario
00:02 +24: test/motor_ar_test.dart: lugares más allá del radio máximo se descartan
00:02 +25: test/motor_ar_test.dart: funciona al cruzar el 0°/360° (miras a 350° y el lugar está a 5°)
00:02 +26: test/motor_ar_test.dart: los lejanos van primero para dibujarse debajo de los cercanos
00:02 +27: test/motor_ar_test.dart: lo cercano se ve más grande que lo lejano
00:02 +28: test/motor_ar_test.dart: un campo de visión más ancho muestra más lugares
00:02 +29: test/pasaporte_test.dart: lejos de un lugar no hay sello
00:02 +30: test/pasaporte_test.dart: a menos de 40 m se gana el sello
00:02 +31: test/pasaporte_test.dart: exactamente a 40 m todavía cuenta
00:02 +32: test/pasaporte_test.dart: el sello se gana una sola vez
00:02 +33: test/pasaporte_test.dart: progreso es la fracción de lugares visitados
00:03 +34: test/ar_viewmodel_test.dart: mientras falte el GPS o la brújula, está esperando
00:03 +35: test/ar_viewmodel_test.dart: con GPS y brújula calcula qué lugares se ven
00:03 +36: test/ar_viewmodel_test.dart: al girar la brújula se actualizan los visibles
00:03 +37: test/ar_viewmodel_test.dart: la brújula se suaviza: un salto brusco no mueve todo de golpe
00:03 +38: test/ar_viewmodel_test.dart: al acercarse a un lugar gana el sello una sola vez
00:03 +39: test/ar_viewmodel_test.dart: un error de permiso se muestra con mensaje amable
00:03 +40: test/ar_viewmodel_test.dart: un error desconocido NO filtra detalles internos
00:03 +41: test/ar_viewmodel_test.dart: notifica a la pantalla cada vez que algo cambia

All tests passed!
```

---

## 🚀 Instrucciones de Despliegue en Dispositivo Físico

1. Conecta tu dispositivo Android mediante USB y activa la **Depuración por USB**.
2. Ejecuta `flutter run` seleccionando el dispositivo físico.
3. Concede los permisos de **Cámara** y **Ubicación** al iniciar [cite: 1].
