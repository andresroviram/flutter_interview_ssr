# Setup Inicial

## Después de clonar el repositorio

Este proyecto utiliza generación de código con `build_runner`. Los archivos generados (`*.g.dart`, `*.freezed.dart`) **NO** están en el repositorio.

### Pasos obligatorios:

1. **Instalar dependencias**
   ```bash
   flutter pub get
   ```

2. **Generar código**
   ```bash
   dart run build_runner build --delete-conflicting-outputs
   ```

3. **Ejecutar la aplicación**
   ```bash
   flutter run
   ```

### Durante el desarrollo

Para regenerar automáticamente el código cuando haces cambios:

```bash
dart run build_runner watch
```

Esto observará los cambios y regenerará los archivos necesarios automáticamente.

## Archivos generados

Los siguientes archivos se generan automáticamente y están excluidos de git:

- `*.g.dart` - Serializadores JSON, tablas Drift
- `*.freezed.dart` - Clases inmutables y unions
- `*.gr.dart` - Rutas (si se usa auto_route)
- `*.config.dart` - Configuraciones

**No edites estos archivos manualmente**, tus cambios se perderán.

## Problemas comunes

### Error: "The getter 'xyz' isn't defined"

**Causa**: Archivos generados faltantes

**Solución**:
```bash
dart run build_runner build --delete-conflicting-outputs
```

### Error: "Conflicting outputs"

**Solución**:
```bash
dart run build_runner build --delete-conflicting-outputs
```

### Los cambios en modelos no se reflejan

**Causa**: build_runner no se ha ejecutado

**Solución**: Ejecuta `build_runner` o usa el modo watch durante desarrollo
