SoT=CORE/MANUAL
cue: "[QEL::ECO[96]::RECALL A96-251008-MANUAL-CUEMACHINE]"
SeedI: "A96-250824"
SoT: "MANUAL/CUEMACHINE/v1.0"
Version: "v1.0"
Updated: "2025-10-08"

# Manual Operativo — CueMachine (QEL)

> **Propósito**: Documentar el uso humano‑ritual del *CueMachine* y sus scripts asociados (`qel_cuemachine_add.sh`, `qel_cuemachine_check.sh`, `qel_secret_init.sh`) con foco en **registro manual**, **custodia criptográfica** (Doble Testigo) y **seguridad operativa** en macOS/Bash 3.2.

---

## 1) Contexto y alcance
- **CueMachine** es el *ledger* (pergamino) de CUEs del proyecto QEL.
- Se preserva la **agencia humana**: el registro es manual y deliberado (*evoca, no representa*).
- La máquina **testimonia y custodia**: cadena de hashes (append‑only lógico) y sello HMAC opcional.
- Este manual cubre:
  - Registro de entradas (add).
  - Encadenamiento, verificación y firma con HMAC (check).
  - Forja del secreto híbrido nutria+verso (secret_init).
  - Estructura de sidecars en `docs/ritual/cuemachine/`.

**No** cubre promoción ni ListadoR (se dejan plantillas fuera del manual).

---

## 2) Requisitos y entorno
- **SO**: macOS (Bash 3.2) / POSIX.
- **Herramientas**: `openssl`, `shasum`, `security` (Keychain macOS), `chflags`.
- **Rutas** por defecto:
  - Ledger: `docs/ritual/QEL_CueMachineA96_v1.0.txt` (editable/bloqueable).
  - Sidecars (auto): `docs/ritual/cuemachine/` → `.chain`, `.sig`, `.sig.meta`, `.state`.
  - Alternativa: pasar `--sidecar-dir` en `qel_cuemachine_check.sh`.

---

## 3) Instalación / Setup
1. Guarda los scripts en `scripts/` y dales permisos:
   ```bash
   chmod +x scripts/qel_cuemachine_add.sh scripts/qel_cuemachine_check.sh scripts/qel_secret_init.sh
   ```
2. Crea el árbol de ritual:
   ```bash
   mkdir -p docs/ritual/cuemachine
   ```
3. (Opcional) Inicializa tu **secreto híbrido**:
   ```bash
   scripts/qel_secret_init.sh --nutria-dir "docs/nutria" --verso "bajo el lago yo vibro"
   ```

---

## 4) Flags y parámetros

### 4.1 `qel_cuemachine_add.sh` (registro manual)
| Flag | Tipo | Requerido | Ejemplo | Descripción |
|---|---|---|---|---|
| `--cm-file` | path | ✓ | `docs/ritual/QEL_CueMachineA96_v1.0.txt` | Ledger (TXT). Crea cabecera si no existe. |
| `--cue` | str | ✓ | `[QEL::ECO[96]::RECALL A96-251006-ATLAS-MADRE-V2-4]` | CUE canónica con `A96-YYMMDD`. |
| `--seed` | str | ✓ | `A96-250824` | SeedI del proyecto. |
| `--sot` | str | ✓ | `ATLAS-TARJETAS/v2.4 — Rol Árbitra (...)` | SoT libre (texto). |
| `--version` | str | ✓ | `v2.4-final` | Versión de la entrada/documento. |
| `--updated` | date | ✓ | `2025-10-06` | Fecha de actualización (ISO). |
| `--target` | str | - | `atlas|tarjetas|unificado` | Etiquetas o foco. |
| `--allow-duplicate` | flag | - |  | Permite re‑registrar la misma CUE. |
| `--verbose` | flag | - |  | Log adicional. |

**Salida**: añade línea al ledger y muestra `hash10(linea)=<10hex>`.

### 4.2 `qel_cuemachine_check.sh` (chain/verify/sign/lock)
| Flag | Tipo | Requerido | Ejemplo | Descripción |
|---|---|---|---|---|
| `--cm-file` | path | ✓ | `docs/ritual/QEL_CueMachineA96_v1.0.txt` | Ledger base. |
| `--sidecar-dir` | path | - | `docs/ritual/cuemachine` | Carpeta para sidecars. Si existe `cuemachine` junto al ledger, se usa automáticamente. |
| `--update-chain` | flag | - |  | Construye/actualiza `.chain` (append‑only lógico). |
| `--verify` | flag | - |  | Verifica integridad de `.chain`. |
| `--sign` | flag | - |  | Firma HMAC → `.sig` (usa secreto de Keychain o env). |
| `--verify-sign` | flag | - |  | Verifica la firma HMAC. |
| `--witness` | str | - | `"Sello Árbitra 251006"` | Nota pública asociada a la firma. |
| `--lock` / `--unlock` | flag | - |  | Bloquea/desbloquea el ledger con `chflags`. |
| `--verbose` | flag | - |  | Log adicional. |

**Salida**: reporta `state_hash10` (de `.chain`) y `sig_hash10` (de `.sig`).

### 4.3 `qel_secret_init.sh` (forja del secreto híbrido)
| Flag | Tipo | Requerido | Ejemplo | Descripción |
|---|---|---|---|---|
| `--nutria-dir` | path | ✓ | `docs/nutria` | Carpeta nutria (materia viva). |
| `--verso` | str | ✓ | `bajo el lago yo vibro` | Verso inicial (se completará en prompt oculto). |
| `--service` | str | - | `QEL_CueMachine_HMAC` | Nombre del secreto en Keychain. |
| `--preview` | flag | - |  | Muestra `SAL_A` (no revela el secreto). |

**Salida**: guarda secreto en Keychain y muestra `secret_hash10` (marca de cuaderno).

---

## 5) Flujos de uso (paso a paso)

### 5.1 Registro humano + custodia criptográfica
1. **Añadir entrada** (acto humano):
   ```bash
   scripts/qel_cuemachine_add.sh \
     --cm-file "docs/ritual/QEL_CueMachineA96_v1.0.txt" \
     --cue "[QEL::ECO[96]::RECALL A96-251006-ATLAS-MADRE-V2-4]" \
     --seed "A96-250824" \
     --sot  "ATLAS-TARJETAS/v2.4 — Rol Árbitra (UNIFICADO con Códice Madre v0.1)" \
     --version "v2.4-final" \
     --updated "2025-10-06" \
     --target "atlas|tarjetas|unificado"
   ```
2. **Encadenar + firmar + bloquear** (custodia):
   ```bash
   scripts/qel_cuemachine_check.sh \
     --cm-file "docs/ritual/QEL_CueMachineA96_v1.0.txt" \
     --update-chain --sign --witness "Sello Árbitra 251006" --lock
   ```
3. **Verificar cuando gustes**:
   ```bash
   scripts/qel_cuemachine_check.sh \
     --cm-file "docs/ritual/QEL_CueMachineA96_v1.0.txt" \
     --verify --verify-sign --witness "Sello Árbitra 251006"
   ```

### 5.2 Rotación del secreto (ritual)
```bash
scripts/qel_secret_init.sh --nutria-dir "docs/nutria" --verso "bajo el lago yo vibro"
# Luego re‑firmar el estado actual con el nuevo anillo
scripts/qel_cuemachine_check.sh --cm-file "docs/ritual/QEL_CueMachineA96_v1.0.txt" --update-chain --sign --witness "Sello Árbitra ROT-YYYYMM" --lock
```

---

## 6) Ejemplos completos

### 6.1 Sidecars en subdirectorio `cuemachine/` (autosense)
```bash
mkdir -p docs/ritual/cuemachine
scripts/qel_cuemachine_check.sh \
  --cm-file "docs/ritual/QEL_CueMachineA96_v1.0.txt" \
  --update-chain --sign --witness "Sello Árbitra 251006" --lock
# Genera: docs/ritual/cuemachine/QEL_CueMachineA96_v1.0.txt.{chain,sig,sig.meta,state}
```

### 6.2 Uso explícito de `--sidecar-dir`
```bash
scripts/qel_cuemachine_check.sh \
  --cm-file "docs/ritual/QEL_CueMachineA96_v1.0.txt" \
  --sidecar-dir "docs/ritual/cuemachine" \
  --update-chain --sign --witness "Sello Árbitra 251006" --lock
```

---

## 7) Integración con otras herramientas (sin automatizar de más)
- **ListadoR / Manifest**: CueMachine no sincroniza automáticamente. Puedes anotar `state_hash10` en tu Diario/ListadoR para Doble Testigo.
- **Promoción**: En iteración posterior, se puede condicionar la promoción a `--verify` y `--verify-sign` exitosos.
- **PE Generate / Atlas**: El ledger puede referenciarse como fuente ritual para componer *witness* o glosas (sin lectura automática).

---

## 8) Buenas prácticas
- **Evita duplicados** de CUE; usa `--allow-duplicate` sólo si necesitas re‑asentar.
- **Usa `--witness`** para firmar con una glosa pública.
- **Bloquea** el ledger después de firmar (`--lock`).
- **Guarda fuera de banda** el último `state_hash10` (cuaderno/QR).
- **Rota** el secreto cuando cambie la materia de nutria o por calendario ritual.

---

## 9) Solución de problemas (FAQ)
- **"no existe chain (ejecuta --update-chain primero)"** → corre `--update-chain` o usa `--sign` (auto‑construye).
- **`tmp: unbound variable`** → versión previa; usa `qel_cuemachine_check.sh >= v1.3`.
- **`hash10` vacío** → `openssl` sin `-r`; actualiza a versiones con `-r` ya en scripts.
- **`no hay secreto HMAC`** → corre `qel_secret_init.sh` o exporta `QEL_CUEMACH_HMAC`.
- **`no pude bloquear (chflags)`** → permisos insuficientes; ejecuta en el repo local con tu usuario.

---

## 10) Anexos

### 10.1 Plantilla de **llenado manual** del CueMachine (ledger)
> Usa esta plantilla cuando quieras escribir a mano el archivo `QEL_CueMachineA96_v1.0.txt` evitando errores.

```text
# ——— Cabecera ritual (una sola vez al inicio del archivo) ———
cue: "[QEL::ECO[96]::RECALL A96-YYYYMMDD-CUEMACHINE-A96]"
SeedI: "A96-250824"
SoT: "CUEMACHINE/A96/v1.0"
Version: "v1.0"
Updated: "YYYY-MM-DD"

# ——— Entradas (una por línea; no uses # aquí) ———
[QEL::ECO[96]::RECALL A96-YYMMDD-NOMBRE-DE-LA-ENTRADA] SOT=SECCION-O-DOC/Vx.y TARGET=etiqueta1|etiqueta2|etiqueta3
[QEL::ECO[96]::RECALL A96-YYMMDD-OTRA-ENTRADA] SOT=OTRO-DOC/Vx.y TARGET=...
```
**Reglas**:
- Mantén el patrón `A96-YYMMDD-...` dentro de la CUE.
- No uses `#` en las líneas de entrada (se ignoran).
- `TARGET` es opcional.
- Tras editar, **encadena y firma** con `qel_cuemachine_check.sh`.

### 10.2 Smoke test (rápido)
```bash
mkdir -p tmp/ritual/cuemachine
cp docs/ritual/QEL_CueMachineA96_v1.0.txt tmp/ritual/

scripts/qel_cuemachine_add.sh \
  --cm-file "tmp/ritual/QEL_CueMachineA96_v1.0.txt" \
  --cue "[QEL::ECO[96]::RECALL A96-251008-SMOKE]" \
  --seed "A96-250824" \
  --sot "PRUEBA/SMOKE/v1.0" \
  --version "v1.0" \
  --updated "2025-10-08"

scripts/qel_cuemachine_check.sh \
  --cm-file "tmp/ritual/QEL_CueMachineA96_v1.0.txt" \
  --sidecar-dir "tmp/ritual/cuemachine" \
  --update-chain --sign --witness "Sello Smoke" --verify --verify-sign
```

---

### 10.3 Notas de ética Idriell
- **Evoca, no representa**: el ledger es memoria evocada, no reemplazo del acto.
- **Doble Testigo**: (1) registro humano; (2) testimonio criptográfico.
- **No‑Mentira**: si la verificación falla, se documenta la ruptura y se atiende antes de continuar.

SeedI=A37-251015

Version=v1.0
Updated=2025-11-04

a7c70fd5ab
