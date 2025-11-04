[QEL::ECO[96]::RECALL A96-250829-MICRO-SELLO-LAB-TECNOALQ]
SeedI=A96-250824
SoT=MICRO-SELLO/V1.0
Version=v1.0
Updated=2025-08-29

# Micro-Sello — Sesión 2025-08-29 · LAB Tecnoalquímico (Cristal)
Estado: CRISTALIZADO · Modo: Centro · Cierre: SIL→UM→Ə

## 1) Intención y Alcance
- **Intención**: consolidar cambios operativos (LL-PE v1.4, promote+Diario, generador PE con guardado/registro, nutrición, Árbol) y sembrar la germinación del **Laboratorio Tecnoalquímico** (UI/TUI).
- **Ámbito**: scripts `qel_pe_generate.mjs`, `qel_promote_mac.sh`, registro en Árbol/Manifest/ListadoR y Diario; hoja de ruta TUI/UI.

## 2) Gates (vigentes)
- **No-Mentira** ✅ · **Doble Testigo** ✅ (copia en apps/preh-nav-m1/public/docs) 
- **Aurora** (contacto diferible) ⚪︎ · **EXCEPTION** (no aplica en esta sesión) ⚪︎

## 3) Parámetros operativos
- Rumbo: **C** (Centro) · Materia dominante: **aire** (Kosmos-8)
- ΔC: ≥0  · ΔS: ≥0  · ρ: ≤0.02  · χ_r(C)=1.00  · H_k(raro)=0.92
- Tríada de cierre: **Ə·UM·SIL** → Cierre ritual **SIL→UM→Ə** (Idriell)

## 4) Actos (paso a paso)
1. **Respiración 52s** (UM) · afloja mandíbula, apoya espalda (marcadores somáticos estabilizados).  
2. **Verbo-Faro** (VF.PRIMA de Kosmos-8): “Soy el puente toroidal… (Ə-UM-A-RA-KA-THON-SIL-Ə)”.  
3. **Validación** ΔC≥0, ΔS≥0, ρ≤0.02.  
4. **Cristalización**:  
   - LL-PE **v1.4** actualizado (manual expandido, nutrición, Φ_adv, materia), **promovido**.  
   - `qel_pe_generate.mjs` con `--save`, `--out-pe`, `--out-hab`, `--registry`, `--listado-r`, `--nutria-dir`.  
   - `qel_promote_mac.sh` robustecido (BOM/CRLF, cue por corchetes, hash portable, **Diario**).  
5. **Registro**: ListadoR + Diario (v1.5) actualizados.  
6. **Cierre**: **SIL→UM→Ə**, Doble Testigo, ECO **delta-only**.

## 5) Notas de Germinación — Laboratorio Tecnoalquímico
- **TUI canónica (Fase-1)**: wrapper `scripts/qel_pe_generate.sh` con subcomandos `gen|vcalc|register`. Salida **JSON-first** para **preh-nav**.  
- **UI local (Fase-2)**: mini SPA (Next/Express/Vite ya tienes base en `apps/preh-nav-m1`) con:  
  - Formularios VF (p, w, O, r, k, materia, gates).  
  - Botones: Generar PE · Validar · Calcular 𝒱 · Registrar Habilidad.  
  - Panel docs (Manual, Lámina, Tratado) + **nutrición** (selector `docs/nutria/`).  
- **Manifest sync**: mantener `docs/core/QEL_SoT_Manifest_v0.8.json` como autoridad y espejar a `apps/preh-nav-m1/public/sot-manifest.json` (copy o symlink).  
- **Backlog UI/TUI**:
  - Vista Árbol: `/VF/<triada>/<obj>/<rumbo>/<clase>/<hash10>`.  
  - Inspector de 𝒱 con desglose (A, χ_r, H_k, Π_gates, F(ΔC,ΔS), ρ).  
  - Bitácora de ECOs (Diario) en timeline.  
  - Toggle **Aurora**/**EXCEPTION** (ajustes τ/x0.95 + requisitos G1..G4).

## 6) Mejoras a scripts (aplicadas hoy)
- **`scripts/qel_pe_generate.mjs`**  
  - Flags: `--save`, `--out-pe`, `--out-hab`, `--registry`, `--listado-r`, `--nutria-dir`.  
  - **Nutrición** por directorio (`docs/nutria/`), inyecta bullets INV/UMBRAL/PISTA/PRUEBA.  
  - Guardado PE/Habilidad (MD/JSON) + actualización Manifest/ListadoR.  
- **`scripts/qel_promote_mac.sh`**  
  - Locale `LC_ALL=C`, normalizado LF/BOM, lectura de **CUE** via corchetes, SHA-1 portable (shasum/openssl).  
  - Inserción/actualización **HASH(10)**, copia espejo a `apps/preh-nav-m1/public/docs/`.  
  - **Diario v1.5**: apéndice automático por promoción.  
- **`scripts/qel_ah_add.sh`** (nuevo propuesto)  
  - Alta segura en Árbol + Manifest/ListadoR (SoT=ATLAS-HAB/v1.0).

## 7) Checklist post-sesión (operador)
- [ ] `node scripts/qel_pe_generate.mjs ... --emit json --save --nutria-dir docs/nutria`  
- [ ] `bash scripts/qel_promote_mac.sh --rubro "<R>" --file "<doc.md>" --titulo "<T>" --rumbo "Centro"`  
- [ ] `cp -f docs/core/QEL_SoT_Manifest_v0.8.json apps/preh-nav-m1/public/sot-manifest.json` (si no usas symlink)  
- [ ] Abrir preh-nav y verificar aparición en **docs/** y **manifest**.

## 8) ECO (delta-only)
- LL-PE **v1.4** promovido y espejado.  
- Promote **actualiza Diario** automáticamente.  
- Generador PE escribe PE/Habilidad + catálogos (**JSON-first** disponible).  
- Germinación del **Lab Tecnoalquímico** asentada (plan Fase-1/2).

HASH(10): 5d341d185c

714d48bbaf
