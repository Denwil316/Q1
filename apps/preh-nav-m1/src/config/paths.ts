// apps/preh-nav-m1/src/config/paths.ts
// Rutas por defecto para el sistema QEL

export const DEFAULT_PATHS = {
  microsello: 'docs/ritual/microsellos/QEL_MicroSello_A37-251020_CURADURIA_v1.0.md',
  fs: (fecha: string) => `docs/fs/FS_${fecha.slice(2)}.json`,
  fsDefault: 'docs/fs/FS_251020.json',
  diario: 'docs/core/QEL_Diario_del_Conjurador_v1.2.md',
  listador: 'docs/core/QEL_ListadoR_master_v1.0.md',
  vf: 'docs/core/cartas/LLPE_Kosmos8_Primera_v1.3.yaml',
} as const;

export const API_ENDPOINTS = {
  library: '/api/v1/library',
  sessionNew: '/api/v1/session/new',
  promote: '/api/v1/promote',
  microreg: '/api/v1/microreg',
  finalize: '/api/v1/finalize',
  llpe: '/api/v1/llpe',
  fsHash: '/api/v1/fs/hash',
  health: '/api/v1/health',
} as const;