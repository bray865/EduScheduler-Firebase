# EduScheduler-Firebase

<div align="center">
  <img src="assets/logo.jpg" alt="EduScheduler logo" width="180" />
</div>

<p align="center">
  <a href="https://flutter.dev/">
    <img alt="Flutter" src="https://img.shields.io/badge/Flutter-3.7.2-02569B?style=for-the-badge&logo=flutter" />
  </a>
  <a href="https://dart.dev/">
    <img alt="Dart" src="https://img.shields.io/badge/Dart-3.7.2-0175C2?style=for-the-badge&logo=dart" />
  </a>
  <a href="https://firebase.google.com/">
    <img alt="Firebase" src="https://img.shields.io/badge/Firebase-Auth%20%2F%20Firestore-FFCA28?style=for-the-badge&logo=firebase" />
  </a>
  <a href="https://github.com/bray865/EduScheduler-Firebase">
    <img alt="GitHub Repo" src="https://img.shields.io/badge/GitHub-EduScheduler%20Firebase-181717?style=for-the-badge&logo=github" />
  </a>
</p>

<p align="center">
  <strong>Aplicación Flutter para gestión académica y operativa con Firebase.</strong>
</p>

Una solución desarrollada con Flutter y Firebase para gestionar proyectos, tareas, calendario de eventos y carga de documentos relacionados con actividades académicas o administrativas. El repositorio evidencia un flujo de trabajo centrado en autenticación de usuarios, visualizar información desde Firestore y organizar procesos mediante una interfaz administrativa.

## Tabla de contenido

- [Descripción general](#descripción-general)
- [Vista previa](#vista-previa)
- [Características verificadas](#características-verificadas)
- [Tecnologías utilizadas](#tecnologías-utilizadas)
- [Arquitectura del proyecto](#arquitectura-del-proyecto)
- [Requisitos previos](#requisitos-previos)
- [Instalación](#instalación)
- [Configuración de Firebase](#configuración-de-firebase)
- [Variables y archivos de configuración](#variables-y-archivos-de-configuración)
- [Ejecución](#ejecución)
- [Plataformas compatibles](#plataformas-compatibles)
- [Solución de problemas frecuentes](#solución-de-problemas-frecuentes)
- [Seguridad](#seguridad)
- [Mejoras futuras](#mejoras-futuras)
- [Contribuciones](#contribuciones)
- [Licencia](#licencia)
- [Autor](#autor)
- [Contacto y enlaces](#contacto-y-enlaces)

## Descripción general

EduScheduler-Firebase es un proyecto de tipo dashboard/gestor académico desarrollado en Flutter. El código muestra que la aplicación está enfocada en:

- autenticación de usuarios con Firebase Auth;
- registro e inicio de sesión con correo y contraseña;
- gestión de proyectos y tareas;
- calendario con eventos y filtros por tipo;
- carga de archivos Excel para procesamiento o gestión documental;
- almacenamiento centralizado de datos en Cloud Firestore.

Aunque el repositorio no define un nombre de producto más formal que el del proyecto mismo, la estructura del código y los archivos confirmados indican claramente que se trata de una app de gestión con enfoque académico o administrativo.

## Vista previa

No se encontraron capturas reales dentro del repositorio. El proyecto incluye activos gráficos como `assets/logo.png` y `assets/Icon.png`, pero no hay una carpeta `screenshots/` ni imágenes de interfaz disponibles para exhibir una vista previa visual real.

Puedes agregar una sección de vista previa más adelante con algo como esto:

```md
![Pantalla principal](assets/screenshots/home.png)
![Calendario](assets/screenshots/calendar.png)
![Gestión de tareas](assets/screenshots/tasks.png)
```

> La documentación del repositorio actual no incluye imágenes de pantalla verificadas, por lo que se recomienda añadirlas manualmente cuando existan.

## Características verificadas

Las funcionalidades que se pueden comprobar en el código son las siguientes:

### 1) Autenticación

- registro de usuarios con `createUserWithEmailAndPassword`;
- inicio de sesión con `signInWithEmailAndPassword`;
- cierre de sesión con Firebase Auth;
- flujo de login/registro con pantallas dedicadas.

### 2) Gestión de proyectos

- creación de proyectos desde una pantalla de formulario;
- campos como nombre, descripción, fecha de inicio, fecha fin, responsable, estado y tipo;
- listado de proyectos desde Firestore;
- visualización de detalles por proyecto.

### 3) Gestión de tareas

- creación de tareas relacionadas a un proyecto;
- estado, prioridad, categoría, responsable, comentarios y fecha de vencimiento;
- lista de tareas con indicadores visuales por estado;
- detalle de cada tarea.

### 4) Calendario y eventos

- carga de eventos desde la colección `eventos` en Firestore;
- renderizado tabular de eventos;
- filtros por tipo;
- formulario para añadir nuevos eventos manualmente.

### 5) Carga de archivos Excel

- selección de archivos `.xlsx` y `.xls` usando `file_picker`;
- validación del tipo de archivo;
- flujo de carga orientado a archivos Excel.

### 6) Persistencia con Firebase

- uso de `cloud_firestore` para almacenar y consultar datos;
- configuración de Firebase con `firebase_core`;
- archivos de configuración generados por FlutterFire.

## Tecnologías utilizadas

Las tecnologías confirmadas en el repositorio son:

- Flutter
- Dart
- Firebase Core
- Firebase Auth
- Cloud Firestore
- Firebase Storage
- Firebase Data Connect
- Google Sign-In
- Provider
- Flutter Hooks
- Table Calendar
- File Picker
- Excel
- Path Provider
- PDF
- Logger
- Flutter Toast
- Font Awesome Flutter
- SidebarX

## Arquitectura del proyecto

La estructura del repositorio es coherente con una aplicación Flutter con separación básica entre vistas, controladores y servicios.

```text
EduScheduler-Firebase/
├── .firebase/
├── .firebaserc
├── .gitignore
├── .metadata
├── analysis_options.yaml
├── firebase.json
├── pubspec.yaml
├── pubspec.lock
├── README.md
├── android/
├── ios/
├── linux/
├── macos/
├── windows/
├── web/
├── assets/
│   ├── Icon.png
│   └── logo.png
├── dataconnect/
│   ├── connector/
│   ├── schema/
│   └── dataconnect.yaml
├── dataconnect-generated/
├── lib/
│   ├── components/
│   │   └── menu.dart
│   ├── controller/
│   │   └── auth_controller.dart
│   ├── service/
│   │   └── auth_service.dart
│   ├── view/
│   │   ├── add_task_screen.dart
│   │   ├── all_project_screen.dart
│   │   ├── all_tasks_screen.dart
│   │   ├── calendar.dart
│   │   ├── create_project.dart
│   │   ├── home_page.dart
│   │   ├── login_page.dart
│   │   ├── project_detail_screen.dart
│   │   ├── register_page.dart
│   │   ├── task_details.dart
│   │   └── upload_files.dart
│   ├── firebase_options.dart
│   └── main.dart
├── test/
└── ...
```

### Organización funcional

- `lib/view`: pantallas y UI principal.
- `lib/controller`: lógica del flujo de autenticación.
- `lib/service`: integración con Firebase Auth y servicios del backend.
- `lib/components`: widgets reutilizables, incluido el menú lateral.
- `lib/firebase_options.dart`: configuración generada por FlutterFire.
- `dataconnect/`: configuración de Firebase Data Connect.

## Requisitos previos

Antes de ejecutar este proyecto, asegúrate de contar con:

- Flutter SDK 3.7.2 o compatible
- Dart SDK
- Android Studio o VS Code
- Android SDK configurado
- Xcode para iOS/macOS cuando aplique
- Firebase CLI (recomendado para reconfigurar los servicios)
- Git

## Instalación

Clona el repositorio:

```bash
git clone https://github.com/bray865/EduScheduler-Firebase.git
cd EduScheduler-Firebase
```

Instala las dependencias de Flutter:

```bash
flutter pub get
```

Si se presentan errores de caché o dependencias, puedes limpiar y reinstalar:

```bash
flutter clean
flutter pub cache repair
flutter pub get
```

## Configuración de Firebase

El repositorio ya incluye archivos de configuración para Firebase:

- `firebase.json`
- `.firebaserc`
- `lib/firebase_options.dart`

Esto confirma que el proyecto está preparado para usar Firebase con Flutter.

### Procedimiento recomendado

1. Crea o selecciona un proyecto en Firebase Console.
2. Registra la aplicación para Android y Web si lo necesitas.
3. Ejecuta el siguiente comando para regenerar la configuración si fuera necesario:

```bash
flutterfire configure
```

4. Verifica que se generen archivos como:
   - `android/app/google-services.json`
   - `lib/firebase_options.dart`

> No se incluyen credenciales reales ni archivos sensibles en el repositorio. La configuración de Firebase debe realizarse con la CLI, la consola de Firebase o tus propios secretos del entorno.

## Variables y archivos de configuración

Los archivos más importantes son:

- `pubspec.yaml`: dependencias y metadatos del proyecto Flutter.
- `firebase.json`: configuración de Firebase y Firebase Data Connect.
- `.firebaserc`: proyecto Firebase por defecto.
- `lib/firebase_options.dart`: configuración por plataforma.
- `android/app/google-services.json`: archivo generado para Android.

### Buenas prácticas

- no publiques claves ni archivos sensibles;
- revisa las reglas de Firestore/Storage antes del despliegue;
- no almacenes secretos en el repositorio;
- usa distintos entornos para desarrollo y producción.

## Ejecución

Desde la raíz del proyecto:

```bash
flutter pub get
flutter run
```

Para ejecutar la app en navegador:

```bash
flutter run -d chrome
```

Para Android:

```bash
flutter run -d android
```

Si Firebase no se inicializa correctamente o la configuración quedó desactualizada:

```bash
flutterfire configure
```

## Plataformas compatibles

La base del proyecto está diseñada para Flutter y el repositorio incluye soporte estructural para varias plataformas:

- Android
- Web
- Windows

También hay estructura base para:

- iOS
- macOS
- Linux

Sin embargo, la configuración verificable en `lib/firebase_options.dart` muestra soporte concreto para:

- Android
- Web
- Windows

No se ha verificado una configuración completa y validada para iOS o Linux en este repositorio.

## Solución de problemas frecuentes

### 1) Error al ejecutar `flutter pub get`

Revisa que tengas la versión correcta del SDK:

```bash
flutter --version
dart --version
```

### 2) Firebase no se inicializa

Asegúrate de haber instalado las dependencias y de haber configurado la app:

```bash
flutter pub get
flutterfire configure
```

### 3) No aparece el dispositivo de destino

Consulta los dispositivos disponibles:

```bash
flutter devices
```

### 4) Error al subir archivos Excel

El proyecto valida extensiones `.xlsx` y `.xls`. Asegúrate de que el archivo tenga una extensión válida y no esté corrupto.

### 5) `lib/firebase_options.dart` no coincide con la configuración

Si un proyecto no está correctamente conectado, vuelve a ejecutar:

```bash
flutterfire configure
```

### 6) Data Connect no está funcionando

El repositorio incluye `dataconnect/` pero no se observan queries ni mutations concretas consumidas por la app. Si deseas usarlo, deberá integrarse y configurarse específicamente.

## Seguridad

Este proyecto usa Firebase, por lo que es importante tener precaución:

- no publiques claves de API o secretos;
- no compartas archivos de configuración en repositorios públicos sin revisar el alcance;
- revisa las reglas de Firebase antes de desplegar;
- no subas certificados, archivos de entorno o credenciales de producción;
- usa variables y entornos separados para desarrollo y producción.

## Mejoras futuras

Las siguientes mejoras no están confirmadas como implementadas en el código actual, pero son propuestas razonables para evolucionar el proyecto:

- separar mejor la lógica de negocio de la UI;
- crear modelos de dominio para proyectos, tareas y eventos;
- mejorar filtros de búsqueda y ordenamiento;
- centralizar acceso a Firestore en repositorios o servicios especializados;
- añadir pruebas unitarias y de widgets;
- incluir notificaciones push;
- ampliar la integración con más plataformas y servicios de Firebase;
- mejorar la experiencia de autenticación con Google Sign-In o autenticación por terceros;
- definir flujos reales de subida de archivos a Firebase Storage.

## Contribuciones

Las contribuciones son bienvenidas. Si encuentras un problema o deseas proponer una mejora:

1. revisa si ya existe un issue relacionado;
2. abre un issue describiendo el problema o la mejora;
3. incluye pasos de reproducción, errores observados y contexto técnico;
4. usa una rama separada para tus cambios;
5. describe el objetivo del pull request de manera clara.

## Licencia

No se encontró un archivo `LICENSE` ni una licencia declarada en el repositorio. Por lo tanto, la licencia no está definida todavía y debe establecerse antes de distribuir el proyecto públicamente.

## Autor

Desarrollado por:

- Bray Hernández
- GitHub: https://github.com/bray865

## Contacto y enlaces

- Repositorio del proyecto: https://github.com/bray865/EduScheduler-Firebase
- Perfil de GitHub del autor: https://github.com/bray865
- Flutter: https://flutter.dev/
- Firebase: https://firebase.google.com/
- Documentation FlutterFire: https://firebase.flutter.dev/

---

Este README refleja únicamente las funcionalidades y tecnologías que pueden verificarse en el repositorio actual. Los elementos no confirmados, como capturas reales o una licencia definida, son señalados explícitamente para evitar documentación inexacta.

