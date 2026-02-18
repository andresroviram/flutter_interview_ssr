# Despliegue con Fastlane y GitHub Actions

Esta guía explica cómo configurar y usar Fastlane con GitHub Actions para automatizar el despliegue de la aplicación Flutter Interview SSR a Google Play Store, Apple App Store y hosting web.

## 📋 Tabla de Contenidos

- [Requisitos Previos](#requisitos-previos)
- [Configuración de Android](#configuración-de-android)
- [Configuración de iOS](#configuración-de-ios)
- [Configuración de GitHub Actions](#configuración-de-github-actions)
- [Workflows Disponibles](#workflows-disponibles)
- [Comandos Locales](#comandos-locales)
- [Troubleshooting](#troubleshooting)

## 🔧 Requisitos Previos

### Software Necesario

- **Ruby** >= 3.2 (para Fastlane)
- **Bundler** (gestor de gems de Ruby)
- **Flutter** >= 3.27.2
- **Git** (para control de versiones)

### Instalación de Bundler

```bash
gem install bundler
```

### Instalación de Fastlane

#### Android
```bash
cd android
bundle install
```

#### iOS (solo en macOS)
```bash
cd ios
bundle install
```

## 🤖 Configuración de Android

### 1. Crear Keystore para Firma

Si no tienes un keystore, créalo:

```bash
keytool -genkey -v -keystore upload-keystore.jks -keyalg RSA -keysize 2048 -validity 10000 -alias upload
```

**⚠️ IMPORTANTE**: Guarda el archivo `.jks` y las contraseñas en un lugar seguro. Nunca los subas al repositorio.

### 2. Crear Cuenta de Servicio en Google Play Console

1. Ve a [Google Play Console](https://play.google.com/console)
2. Navega a **Setup** → **API access**
3. Crea una nueva cuenta de servicio o usa una existente
4. Descarga el archivo JSON de credenciales
5. Otorga permisos de **Admin** a la cuenta de servicio en **Users and permissions**

### 3. Configurar Variables de Entorno Locales

Crea el archivo `android/key.properties`:

```properties
storePassword=TU_STORE_PASSWORD
keyPassword=TU_KEY_PASSWORD
keyAlias=upload
storeFile=upload-keystore.jks
```

**⚠️ NUNCA** subas este archivo a Git (ya está en `.gitignore`)

### 4. Probar Fastlane Localmente

```bash
cd android
bundle exec fastlane build_aab
```

## 🍎 Configuración de iOS

### 1. Configurar Apple Developer Account

Necesitarás:
- Una cuenta de Apple Developer (de pago)
- Acceso a App Store Connect
- App ID registrado en el portal de desarrollador

### 2. Configurar Match (Gestión de Certificados)

Match es la herramienta de Fastlane para sincronizar certificados y perfiles de aprovisionamiento.

#### Crear Repositorio para Certificados

1. Crea un repositorio **privado** en GitHub (ej: `certificates`)
2. Este repositorio almacenará tus certificados encriptados

#### Inicializar Match

```bash
cd ios
bundle exec fastlane match init
```

Selecciona `git` como storage y proporciona la URL del repositorio de certificados.

#### Generar Certificados

```bash
# Para desarrollo
bundle exec fastlane match development

# Para App Store
bundle exec fastlane match appstore
```

Se te pedirá una contraseña para encriptar los certificados. **Guarda esta contraseña**.

### 3. Configurar Appfile

Edita `ios/fastlane/Appfile`:

```ruby
app_identifier("com.tuempresa.flutter_interview_ssr")
apple_id("tu-email@apple.com")
itc_team_id("TU_TEAM_ID") # Team ID de App Store Connect
team_id("TU_TEAM_ID") # Team ID del Developer Portal
```

### 4. Configurar Matchfile

Edita `ios/fastlane/Matchfile`:

```ruby
git_url("https://github.com/tu-usuario/certificates")
storage_mode("git")
type("appstore")
app_identifier(["com.tuempresa.flutter_interview_ssr"])
username("tu-email@apple.com")
```

### 5. Crear App en App Store Connect

1. Ve a [App Store Connect](https://appstoreconnect.apple.com)
2. Crea una nueva app
3. Completa la información básica (nombre, categoría, etc.)

### 6. Probar Fastlane Localmente

```bash
cd ios
bundle exec fastlane beta
```

## 🔐 Configuración de GitHub Actions

### Secrets de GitHub

Ve a tu repositorio → **Settings** → **Secrets and variables** → **Actions** y agrega:

#### Android Secrets

| Secret | Descripción | Cómo Obtenerlo |
|--------|-------------|----------------|
| `ANDROID_KEYSTORE_BASE64` | Keystore codificado en base64 | `base64 upload-keystore.jks \| tr -d '\n'` (Linux/Mac)<br>`[Convert]::ToBase64String([IO.File]::ReadAllBytes("upload-keystore.jks"))` (PowerShell) |
| `KEYSTORE_PASSWORD` | Contraseña del keystore | La que usaste al crear el keystore |
| `KEY_PASSWORD` | Contraseña de la key | La que usaste al crear el keystore |
| `KEY_ALIAS` | Alias de la key | Generalmente `upload` o `key` |
| `PLAY_STORE_CONFIG_JSON` | JSON de la cuenta de servicio | Contenido del archivo JSON descargado de Google Play Console |

#### iOS Secrets

| Secret | Descripción | Cómo Obtenerlo |
|--------|-------------|----------------|
| `MATCH_PASSWORD` | Contraseña para desencriptar certificados | La que usaste con `fastlane match init` |
| `MATCH_GIT_BASIC_AUTHORIZATION` | Token para acceder al repo de certificados | `echo -n "tu-usuario:tu-token" \| base64` |
| `FASTLANE_USER` | Email de Apple Developer | Tu email de Apple ID |
| `FASTLANE_PASSWORD` | Contraseña app-specific | Genera en https://appleid.apple.com |
| `FASTLANE_APPLE_APPLICATION_SPECIFIC_PASSWORD` | Password específico de app | Genera en Apple ID |
| `APP_STORE_CONNECT_API_KEY_ID` | ID de la API Key | App Store Connect → Users and Access → Keys |
| `APP_STORE_CONNECT_API_ISSUER_ID` | Issuer ID | App Store Connect → Users and Access → Keys |
| `APP_STORE_CONNECT_API_KEY` | Contenido de la API Key (.p8) | Descarga de App Store Connect |

#### Web Secrets (Opcional)

Para despliegues web, dependiendo de tu plataforma:

**Firebase Hosting:**
- `FIREBASE_SERVICE_ACCOUNT` - Cuenta de servicio de Firebase

**Vercel:**
- `VERCEL_TOKEN` - Token de Vercel
- `VERCEL_ORG_ID` - ID de organización
- `VERCEL_PROJECT_ID` - ID del proyecto

**GitHub Pages:**
- `GITHUB_TOKEN` - Generado automáticamente por GitHub

## 🚀 Workflows Disponibles

### 1. CI (Integración Continua)

**Trigger**: Todos los push y pull requests

**Acciones**:
- Verifica formato de código
- Ejecuta análisis estático
- Corre generación de código
- Ejecuta tests
- Genera reporte de cobertura

### 2. Deploy Android

**Triggers**:
- Push a `main` → Deploy a Internal Testing
- Push a `release/*` → Deploy a Beta
- Manual (workflow_dispatch) → Seleccionar track

**Tracks Disponibles**:
- `internal` - Testing interno
- `beta` - Testing beta (pre-producción)
- `production` - Producción (todos los usuarios)

### 3. Deploy iOS

**Triggers**:
- Push a `main` → Deploy a TestFlight
- Push a `release/*` → Deploy a App Store
- Manual (workflow_dispatch) → Seleccionar environment

**Environments**:
- `beta` - TestFlight
- `production` - App Store

### 4. Deploy Web

**Triggers**:
- Push a `main` → Deploy automático
- Push a `develop` → Preview deployment
- Pull requests → Artifact upload

**Plataformas** (configurables):
- GitHub Pages
- Firebase Hosting
- Vercel

## 💻 Comandos Locales

### Android

```bash
cd android

# Build APK
bundle exec fastlane build_apk

# Build AAB
bundle exec fastlane build_aab

# Deploy a Internal Testing
bundle exec fastlane internal

# Deploy a Beta
bundle exec fastlane beta

# Deploy a Production
bundle exec fastlane production
```

### iOS

```bash
cd ios

# Build IPA
bundle exec fastlane build_ipa

# Deploy a TestFlight
bundle exec fastlane beta

# Deploy a App Store
bundle exec fastlane production

# Ejecutar tests
bundle exec fastlane test
```

### Web

```bash
# Setup assets (primera vez)
./setup_web.sh  # o setup_web.ps1 en Windows

# Build
flutter build web --release

# Preview local
python -m http.server -d build/web 8000
```

## 🔄 Flujo de Trabajo Recomendado

### Feature Development

1. Crea branch desde `main`: `git checkout -b feature/nueva-funcionalidad`
2. Desarrolla y commitea cambios
3. Push y crea Pull Request
4. El workflow **CI** se ejecuta automáticamente
5. Revisa los resultados y haz merge a `main`

### Internal Testing (Android) / TestFlight (iOS)

1. Merge a `main`
2. Los workflows se ejecutan automáticamente
3. Los builds se publican en:
   - **Android**: Internal Testing en Google Play
   - **iOS**: TestFlight

### Beta Release

1. Crea branch `release/v1.0.0` desde `main`
2. Push el branch
3. Los workflows despliegan automáticamente a:
   - **Android**: Beta track en Google Play
   - **iOS**: TestFlight (o App Store según configuración)

### Production Release

1. Usa workflow manual (workflow_dispatch)
2. Selecciona `production` como target
3. Confirma la ejecución
4. El workflow despliega a producción

## 🐛 Troubleshooting

### Android

#### Error: "Build failed - signing config not found"

**Solución**: Verifica que `key.properties` existe y contiene los valores correctos.

```bash
cat android/key.properties
```

#### Error: "Service account not authorized"

**Solución**: Verifica que la cuenta de servicio tenga permisos de Admin en Google Play Console.

### iOS

#### Error: "No certificate found"

**Solución**: Ejecuta Match para regenerar certificados:

```bash
cd ios
bundle exec fastlane match appstore
```

#### Error: "Provisioning profile doesn't include signing certificate"

**Solución**: Los certificados y perfiles están desincronizados. Regenera con:

```bash
cd ios
bundle exec fastlane match appstore --force
```

#### Error: "Authentication failed"

**Solución**: Verifica que `FASTLANE_APPLE_APPLICATION_SPECIFIC_PASSWORD` esté configurado correctamente.

### GitHub Actions

#### Error: "Secret not found"

**Solución**: Verifica que todos los secrets estén configurados en GitHub:

```bash
Settings → Secrets and variables → Actions
```

#### Error: "Build number already exists"

**Solución**: Los build numbers en GitHub Actions usan `github.run_number`. Si necesitas sobrescribir:

1. Ve a Google Play Console / App Store Connect
2. Incrementa manualmente el build number
3. Actualiza la configuración de versión en `pubspec.yaml`

## 📚 Recursos Adicionales

- [Fastlane Documentation](https://docs.fastlane.tools/)
- [GitHub Actions Documentation](https://docs.github.com/actions)
- [Flutter Deployment Guide](https://flutter.dev/docs/deployment)
- [Google Play Console](https://play.google.com/console)
- [App Store Connect](https://appstoreconnect.apple.com)

## 🤝 Contribuciones

Para modificar los workflows:

1. Edita los archivos en `.github/workflows/`
2. Prueba localmente si es posible
3. Crea Pull Request
4. El workflow CI validará los cambios

## 📞 Soporte

Si encuentras problemas:

1. Revisa la sección [Troubleshooting](#troubleshooting)
2. Consulta los logs de GitHub Actions
3. Revisa la documentación de Fastlane
4. Crea un issue en el repositorio
