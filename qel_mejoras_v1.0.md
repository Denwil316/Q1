# QEL Mejoras v1.0 - CodeX

> Fecha: 2026-04-13
> SeedI: IMPROVE-V1-260413

---

## 1. Frontend (PreH-NAV React)

### 1.1 Alta Prioridad

| # | Problema | Archivo | Sugerencia |
|---|----------|---------|------------|
| 1 | **XSS en DocViewer** - `rehypeRaw` permite HTML arbitrario | `DocViewer.tsx:69` | Sanitizar HTML con `rehype-sanitize` o validar origen |
| 2 | **Sin loading states** - UI freeze en operaciones largas | `RitualStudio.tsx` | Agregar spinner/skeleton durante fetch |
| 3 | **Sin manejo de errores** - Errores no se muestran al usuario | `api.ts:4-8` | Mostrar errores en UI, no solo throw |
| 4 | **Memory leak en SSE** - No cleanup en componente unmount | `RitualStudio.tsx:67-80` | Usar `useEffect` cleanup para `es.close()` |

### 1.2 Media Prioridad

| # | Problema | Archivo | Sugerencia |
|---|----------|---------|------------|
| 5 | **Hardcoded paths** - rutas en componente | `RitualStudio.tsx:51` | Mover a config/manifest |
| 6 | **Duplicación de tipos** - FS definido en client y server | `RitualStudio.tsx:8-19` vs `server.mjs` | Crear `/src/types/` compartido |
| 7 | **Sin TypeScript strict** - `any` en api.ts | `api.ts:11,14,41,46` | Tipar respuestas correctamente |
| 8 | **Styles inline** - mix de CSS y estilos en componente | `App.tsx:37-40,58-63` | Extraer a `styles.css` o modules |

### 1.3 Baja Prioridad

| # | Problema | Archivo | Sugerencia |
|---|----------|---------|------------|
| 9 | **Magic numbers** - timeouts, limits hardcoded | `server.mjs:460` | Mover a constantes config |
| 10 | **Sin tests** - 0 tests en frontend | `apps/preh-nav-m1/` | Agregar Vitest + React Testing Library |
| 11 | **Sin lazy loading** - Todo el bundle en inicial | `App.tsx` | Code-split rutas con `React.lazy()` |

---

## 2. Backend (server.mjs)

### 2.1 Alta Prioridad

| # | Problema | Línea | Sugerencia |
|---|----------|-------|------------|
| 1 | **Endpoint `/api/v1/llpe` no implementado** | - | Agregar handler o remover de api.ts |
| 2 | **Endpoint `/api/v1/fs/hash` no implementado** | - | Agregar handler o remover de api.ts |
| 3 | **Sin validación de schemas** - payloads sin validación | `req.body` | Usar `zod` o `joi` para validar |
| 4 | **Jobs SSE nunca se limpian** - memory leak en Map | `jobs` Map (línea ~479) | TTL o cleanup periódico |

### 2.2 Media Prioridad

| # | Problema | Línea | Sugerencia |
|---|----------|-------|------------|
| 5 | **try-catch vacío** - silenciar errores | `server.mjs:789-743` | Loggear o retornar error útil |
| 6 | **fetch a localhost sin manejo de errors** | `line ~729-742` | Agregar timeout y retry logic |
| 7 | **Sin health check endpoint** | - | Agregar `GET /api/v1/health` |
| 8 | **Path traversal parcial** - solo verifica ROOT | `resolveSafe()` | Validar extensión también |

---

## 3. Scripts

### 3.1 Scripts con errores

| Script | Error | Sugerencia |
|--------|-------|------------|
| `qel_session_new.sh` | Syntax error línea 241: `;);` | Cambiar a `);` |

### 3.2 Sugerencias

| # | Mejora | Script |
|---|--------|--------|
| 1 | Estandarizar ayuda (`--help` o `-h`) | Todos |
| 2 | Agregar `set -euo pipefail` | Los que no lo tienen |
| 3 | Usar `#!/usr/bin/env` consistente | Algunosmix |

---

## 4. Infraestructura

### 4.1 Alta Prioridad

| # | Problema | Sugerencia |
|---|----------|------------|
| 1 | **Sin .gitignore para node_modules en root** - 121 carpetas | Excluir `node_modules/` del repo |
| 2 | **Archivos orphan** - `.{DS_Store, --emit, --materia, --preset, --ruido, --vf}` | Limpiar o documentar |
| 3 | **package.json duplicado** - root y apps/preh-nav-m1 | Unificar o clear scope |

### 4.2 Media Prioridad

| # | Problema | Sugerencia |
|---|----------|------------|
| 4 | **Sin CI/CD** - 0 pipelines | Agregar GitHub Actions |
| 5 | **Sin linting** - No ESLint/Prettier | Configurar y agregar pre-commit |
| 6 | **Makefile desactualizado** | Revisar targets |

---

## 5.得分 (Score)

| Área | Score | Notas |
|------|-------|-------|
| Frontend Security | 6/10 | XSS mitigate, pero sin tests |
| Backend Security | 7/10 | Sanitización OK, falta validación |
| Code Quality | 5/10 | Muchos `any`, sin types compartidos |
| Scripts | 8/10 | 28/29 OK, 1 syntax error |
| DevOps | 3/10 | Sin CI, node_modules en git |

---

## 6. Próximos Pasos Recomendados

1. **Inmediato**: Fix `qel_session_new.sh` syntax error
2. **Esta semana**: Sanitizar DocViewer, agregar error handling
3. **Este mes**: Agregar tipos compartidos, validar schemas con zod
4. **Próx. sprint**: Tests, CI/CD, limpiar node_modules del repo