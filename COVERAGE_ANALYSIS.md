# Análisis de Cobertura - Core

## 📊 Estado Actual: 82.92% ✅

**Última actualización**: 18 de febrero de 2026

### Cobertura General del Proyecto

```
Total:               79.26% ✅ (Supera el umbral del 60%)
├─ features/         93.34% ✅ Excelente
├─ core/             82.92% ✅ Muy bueno (+34.91% de mejora)
└─ components/       11.43% ❌ Crítico - Requiere atención urgente
```

### ✅ Archivos con Tests (7 archivos)
- `core/result.dart` ✓
- `core/error/failures.dart` ✓
- `core/error/exceptions.dart` ✓
- `core/utils/validators.dart` ✓
- `core/utils/formatters.dart` ✓
- `core/utils/debouncer.dart` ✓
- `core/utils/box_converter.dart` ✓

### ❌ Archivos SIN Tests (15 archivos)

#### Alta Prioridad
- `core/database/app_database.dart` - Base de datos principal
- `core/database/database_provider.dart` - Provider de BD
- `core/database/tables/users_table.dart` - Tabla usuarios
- `core/database/tables/addresses_table.dart` - Tabla direcciones
- `core/router/app_router.dart` - Rutas de la app
- `core/utils/input_formatters.dart` - Formatters de input

#### Media Prioridad
- `core/models/address_filters.dart` - Modelos de filtros
- `core/theme/app_theme.dart` - Tema de la app
- `core/theme/app_colors.dart` - Colores

#### Excluidos (No requieren tests)
- `core/database/app_database.g.dart` - ❌ Generado por drift (excluido de git)
- `core/database/connection/*` - Conexiones específicas de plataforma
- Otros archivos `*.g.dart` y `*.freezed.dart` - Código generado automáticamente

> **Nota**: Los archivos generados (`*.g.dart`, `*.freezed.dart`) ahora están excluidos de git y no requieren tests.

### 🎯 Plan de Acción

**Prioridad 1: Components/Widgets (CRÍTICO - 11.43%)**
- Crear tests para widgets reutilizables
- Testear componentes de UI (confirmación dialogs, shimmers, etc.)
- Meta: Alcanzar al menos 50%

**Prioridad 2: Mantener Core (82.92%)**
- Continuar mejorando tests existentes
- Agregar tests para casos edge
- Meta: Mantener o superar 80%

**Prioridad 3: Mantener Features (93.34%)**  
- Mantener la excelente cobertura actual
- Agregar tests para nuevas features

### 📈 Meta de Cobertura
- Actual: **79.26%** ✅
- Meta corto plazo: 80% (mejorar components)
- Meta largo plazo: 85%+

### 🎉 Logros Recientes
- ✅ Core mejoró de 48.01% a 82.92% (+34.91%)
- ✅ Total del proyecto supera el umbral del 60%
- ✅ Features mantiene cobertura excelente (>90%)
