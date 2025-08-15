import React, { useMemo, useState } from "react";
import { Search, Download, ExternalLink, Folder, FileText, Package, ChevronRight, Check, Copy, AlertCircle } from "lucide-react";
import { Card, CardContent } from "@/components/ui/card";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import { Badge } from "@/components/ui/badge";

// ----------------------------------------------------------------------------
// NOTA DE DEPURACIÓN (v0.2)
// - Se removieron ANOTACIONES TYPESCRIPT para compatibilidad con JS/JSX puro.
// - Se mantuvieron caracteres Unicode (títulos con acentos, símbolos) en strings
//   válidos de JS.
// - Se añadieron PRUEBAS RÁPIDAS renderizadas para validar el dataset.
// ----------------------------------------------------------------------------

// --- Data model -------------------------------------------------------------
// Tip: All links are local sandbox paths produced en esta sesión
const DATA = {
  zip: {
    title: "QEL_Sistema_Completo_v0.4_Consolidado.zip",
    href: "sandbox:/mnt/data/QEL_Sistema_Completo_v0.4_Consolidado.zip",
    note: "Paquete con TODO (core + opcionales + confirmaciones + sello)",
  },
  sections: [
    {
      name: "Core",
      icon: "folder",
      items: [
        { t: "README v0.4", p: "sandbox:/mnt/data/QEL_Sistema_Completo_v0.4_Consolidado/README_Consolidado_v0.4.md" },
        { t: "Manifest v0.7", p: "sandbox:/mnt/data/QEL_Sistema_Completo_v0.4_Consolidado/manifest/QEL_SoT_Manifest_v0.7.json" },
        { t: "Lámina 𝒱 v1.0", p: "sandbox:/mnt/data/QEL_Lamina_V_Detallada_v1.0.md" },
        { t: "MFH v1.2", p: "sandbox:/mnt/data/QEL_Matriz_Fonemica_Habilidades_v1.2.md" },
        { t: "Glosario v1.2", p: "sandbox:/mnt/data/QEL_Glosario_v1.2.md" },
        { t: "Diario v1.2", p: "sandbox:/mnt/data/QEL_Diario_del_Conjurador_v1.2.md" },
        { t: "Tratado v1.1 (Seguridad Sombras)", p: "sandbox:/mnt/data/QEL_Tratado_Metahumano_Protocolo_Seguridad_Sombras_v1.1.md" },
        { t: "Manual Sombras v1.1 (humano)", p: "sandbox:/mnt/data/QEL_Manual_Interpretacion_Sombras_v1.1.md" },
        { t: "Formato VF/Árbol v1.0", p: "sandbox:/mnt/data/QEL_Formato_VF_Arbol_Habilidades_v1.0.md" },
        { t: "Esculpido v0.3 (completo)", p: "sandbox:/mnt/data/Esculpido_en_Qel_Guia_de_Trabajo_v0.3_completo.md" },
        { t: "Listado R v1.3", p: "sandbox:/mnt/data/QEL_ListadoR_A96_v1.3.md" },
        { t: "Tarjetas Atlas v2.2", p: "sandbox:/mnt/data/Tarjetas_Atlas_QEL_v2.2.md" },
      ],
    },
    {
      name: "Poesía / Operadores",
      icon: "folder",
      items: [
        { t: "Poema‑Enigma v1.0", p: "sandbox:/mnt/data/QEL_Poema_Enigma_VF_v1.0.md" },
        { t: "Meditación Lun‑Nai v1.1", p: "sandbox:/mnt/data/QEL_Meditacion_Reiteracion_Lun-Nai_v1.1.md" },
        { t: "Meditaciones Primordiales v1.0", p: "sandbox:/mnt/data/QEL_Meditaciones_Primordiales_v1.0.md" },
        { t: "Sello (Oriente) v1.0", p: "sandbox:/mnt/data/QEL_Sello_A96-250814_Oriente_RA-VOH-EIA__Silencio-UM-A_v1.0.md" },
      ],
    },
    {
      name: "Herramientas / Especial",
      icon: "folder",
      items: [
        { t: "CUE‑EXCEPTION v1.0", p: "sandbox:/mnt/data/QEL_CUE_Exception_v1.0.md" },
        { t: "AURORA Spec v1.0", p: "sandbox:/mnt/data/QEL_Aurora_Spec_v1.0.md" },
        { t: "CueMachine v1.0 (texto)", p: "sandbox:/mnt/data/QEL_CueMachineA96_v1.0.txt" },
        { t: "MFH v1.0 (histórico)", p: "sandbox:/mnt/data/QEL_Matriz_Fonemica_Habilidades_v1.0.md" },
        { t: "Matemáticas Resonantes (DS)", p: "sandbox:/mnt/data/Matematicas Resonantes (DS).md" },
      ],
    },
    {
      name: "Confirmaciones / Registro",
      icon: "folder",
      items: [
        { t: "CONF · Sistema v0.2", p: "sandbox:/mnt/data/QEL_Sistema_Consolidado_v0.2_Confirmacion_v0.1.md" },
        { t: "CONF · Listado R v1.2", p: "sandbox:/mnt/data/QEL_ListadoR_A96_v1.2_Confirmacion_v0.1.md" },
        { t: "CONF · Diario v1.2", p: "sandbox:/mnt/data/QEL_Diario_del_Conjurador_v1.2_Confirmacion_v0.1.md" },
        { t: "CONF · Tratado v1.0", p: "sandbox:/mnt/data/QEL_Tratado_Metahumano_RECALL_A96-250812_v1.0_Confirmacion_v0.1.md" },
      ],
    },
  ],
};

// --- Helpers ---------------------------------------------------------------
const Icon = ({ name, className }) => {
  if (name === "folder") return <Folder className={className || "w-4 h-4"} />;
  return <Folder className={className || "w-4 h-4"} />;
};

function Row(props){
  const { label, href } = props;
  const [copied, setCopied] = useState(false);
  const onCopy = async () => {
    try {
      await navigator.clipboard.writeText(href);
      setCopied(true);
      setTimeout(()=>setCopied(false), 1200);
    } catch (e) {
      console.error("Clipboard error", e);
    }
  };
  return (
    <div className="flex items-center justify-between rounded-xl border p-3 hover:bg-muted/40 transition">
      <div className="flex items-center gap-2 min-w-0">
        <FileText className="w-4 h-4 shrink-0"/>
        <a className="truncate font-medium hover:underline" href={href}>{label}</a>
      </div>
      <div className="flex items-center gap-2">
        <Button variant="outline" size="icon" onClick={onCopy} title="Copiar enlace">
          {copied ? <Check className="w-4 h-4"/> : <Copy className="w-4 h-4"/>}
        </Button>
        <Button asChild size="icon" title="Abrir">
          <a href={href}><ExternalLink className="w-4 h-4"/></a>
        </Button>
      </div>
    </div>
  );
}

// --- Quick tests (rendered) ------------------------------------------------
function runSelfTests(){
  const errors = [];
  try {
    if (!DATA.zip || typeof DATA.zip.href !== "string" || !DATA.zip.href.startsWith("sandbox:")) {
      errors.push("ZIP href inválido o ausente");
    }
    DATA.sections.forEach((s, si) => {
      if (!Array.isArray(s.items)) errors.push(`Sección ${si} sin items`);
      s.items.forEach((it, ji) => {
        if (typeof it.t !== "string" || typeof it.p !== "string") {
          errors.push(`Item inválido en sección ${s.name} índice ${ji}`);
        }
        if (!it.p.startsWith("sandbox:")) {
          errors.push(`Href no sandbox en ${s.name} » ${it.t}`);
        }
      });
    });
  } catch (e) {
    errors.push("Excepción durante pruebas: " + (e && e.message));
  }
  return { pass: errors.length === 0, errors };
}

function TestPanel(){
  const result = useMemo(runSelfTests, []);
  return (
    <Card className="shadow-sm">
      <CardContent className="p-4 text-sm">
        <div className="flex items-center gap-2 mb-2">
          {result.pass ? <Check className="w-4 h-4"/> : <AlertCircle className="w-4 h-4"/>}
          <span className="font-semibold">Autotests</span>
          <Badge variant={result.pass ? "default" : "destructive"} className="ml-2">
            {result.pass ? "OK" : "Revisar"}
          </Badge>
        </div>
        {result.pass ? (
          <div className="text-muted-foreground">Todos los enlaces y títulos lucen válidos.</div>
        ) : (
          <ul className="list-disc ml-5 space-y-1">
            {result.errors.map((e, i) => (<li key={i}>{e}</li>))}
          </ul>
        )}
      </CardContent>
    </Card>
  );
}

export default function QELNavegador(){
  const [q, setQ] = useState("");
  const filtered = useMemo(() => {
    if(!q) return DATA.sections;
    const k = q.toLowerCase();
    return DATA.sections.map(s=>({
      ...s,
      items: s.items.filter(i => `${i.t}`.toLowerCase().includes(k))
    })).filter(s => s.items.length>0);
  }, [q]);

  return (
    <div className="min-h-screen bg-gradient-to-b from-zinc-50 to-white text-zinc-900">
      <header className="sticky top-0 z-20 backdrop-blur border-b bg-white/70">
        <div className="max-w-6xl mx-auto px-4 py-3 flex items-center gap-3">
          <Package className="w-5 h-5"/>
          <h1 className="text-lg font-semibold tracking-tight">QEL · Navegador de Sistema (v0.2)</h1>
          <Badge className="ml-auto">UPDATED 2025-08-14</Badge>
        </div>
      </header>

      <main className="max-w-6xl mx-auto px-4 py-6 grid md:grid-cols-3 gap-6">
        <div className="md:col-span-2 flex flex-col gap-6">
          <Card className="shadow-sm">
            <CardContent className="p-4 flex items-center gap-2">
              <Search className="w-4 h-4"/>
              <Input value={q} onChange={(e)=>setQ(e.target.value)} placeholder={"Buscar (p. ej., \"Lámina\", \"Sombras\", \"Atlas\")"}/>
            </CardContent>
          </Card>

          {filtered.map((section, idx) => (
            <Card key={`${idx}-${section.name}`} className="shadow-sm">
              <CardContent className="p-4 space-y-3">
                <div className="flex items-center gap-2">
                  <Icon name={section.icon} />
                  <h2 className="font-semibold">{section.name}</h2>
                </div>
                <div className="space-y-2">
                  {section.items.map((it, j)=> (
                    <Row key={`${idx}-${j}-${it.t}`} label={it.t} href={it.p}/>
                  ))}
                </div>
              </CardContent>
            </Card>
          ))}

          <TestPanel/>
        </div>

        <aside className="md:col-span-1 space-y-4">
          <Card className="shadow-sm">
            <CardContent className="p-4 space-y-3">
              <div className="flex items-center gap-2">
                <Download className="w-4 h-4"/>
                <h3 className="font-semibold">Descargar Paquete</h3>
              </div>
              <a href={DATA.zip.href} className="group flex items-center justify-between rounded-xl border p-3 hover:bg-muted/40 transition">
                <div className="min-w-0">
                  <div className="truncate font-medium group-hover:underline">{DATA.zip.title}</div>
                  <div className="text-xs text-muted-foreground">{DATA.zip.note}</div>
                </div>
                <ChevronRight className="w-4 h-4"/>
              </a>
            </CardContent>
          </Card>

          <Card className="shadow-sm">
            <CardContent className="p-4 text-sm leading-relaxed space-y-2">
              <div className="font-semibold">Flujo rápido (15–30′)</div>
              <ol className="list-decimal list-inside space-y-1">
                <li>FS en Diario v1.2</li>
                <li>Lámina 𝒱 + Glosario</li>
                <li>Proyección → Vibración → Eco</li>
                <li>Cierre SIL→UM→Ə</li>
                <li>Si Cristaliza → Árbol/VF + LR</li>
              </ol>
            </CardContent>
          </Card>
        </aside>
      </main>

      <footer className="px-4 py-6 border-t">
        <div className="max-w-6xl mx-auto text-xs text-muted-foreground">
          [QEL::ECO[96]::RECALL A96-250814-UI-NAVEGADOR] · SOT=INTERFAZ-HTML/v0.2 · VERSION=v0.2 · UPDATED=2025-08-14
        </div>
      </footer>
    </div>
  );
}
