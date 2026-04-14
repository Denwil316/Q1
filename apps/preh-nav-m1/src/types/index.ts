// apps/preh-nav-m1/src/types/index.ts
// Tipos compartidos entre client y server

export type Modo = 'M0'|'M1'|'M2'|'M3';
export type Delta = 'up'|'flat'|'down';
export type Rumbo = 'N'|'S'|'E'|'W'|'O'|'C'|'Centro'|'Norte'|'Sur'|'Este'|'Oeste';

export interface FS {
  fecha: string;          // YYMMDD
  tema: string;
  intencion: string;
  modo: Modo;
  rumbo: string;
  tiempo: number;
  referencias?: string[];
  salidas_esperadas?: string[];
  resultados?: {
    artefactos?: string[];
    micro_sellos?: string[];
  };
  meta?: Record<string, unknown>;
}

export interface Job {
  ok: boolean;
  jobId: string;
}

export interface JobResult {
  ok: boolean;
  code?: number;
  err?: string;
  out?: string;
}

export interface LibraryItem {
  name: string;
  rel: string;
  abs: string;
  type: 'file'|'dir';
  bucket?: string;
  category?: string;
}

export interface LibraryResponse {
  core: LibraryItem[];
  ritual: LibraryItem[];
  atlas: LibraryItem[];
  memory: LibraryItem[];
  published?: {
    all: LibraryItem[];
    core: LibraryItem[];
    ritual: LibraryItem[];
    atlas: LibraryItem[];
    memory: LibraryItem[];
  };
}

export interface ApiError {
  error: string;
  detail?: string;
}

export interface HealthResponse {
  ok: boolean;
  timestamp: string;
  uptime: number;
  jobs: number;
  memory: {
    rss: number;
    heapTotal: number;
    heapUsed: number;
    external: number;
  };
}