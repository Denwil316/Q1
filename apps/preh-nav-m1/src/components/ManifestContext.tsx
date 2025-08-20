// [QEL::ECO[96]::RECALL A96-250817-PREH-NAV-REHIDRATA]
// [QEL::ECO[96]::RECALL A96-250819-MANIFEST-CONTEXT]
/* SeedI=PREH-NAV::M1
   SOT=PREH-NAV/v0.3 TARGET=context|refresh
   VERSION=v0.3 UPDATED=2025-08-19 */

import React,{createContext,useContext,useEffect,useState,useCallback} from 'react'

type FileItem = { name:string; role:string; path:string }
type Manifest = { files:FileItem[]; recommended_core?:string[]; optional?:string[] }
export type Ctx = { manifest:Manifest|null; loading:boolean; error:string|null; reload:()=>void }

const Ctx = createContext<Ctx>({
  manifest:null,
  loading:true,
  error:null,
  reload: () => {}
})

export default function ManifestProvider({children}:{children:React.ReactNode}){
  const [manifest,setManifest] = useState<Manifest|null>(null)
  const [loading,setLoading] = useState(true)
  const [error,setError] = useState<string|null>(null)

  const loadManifest = useCallback(() => {
    setLoading(true); setError(null)
    const url = '/sot-manifest.json?cb=' + Date.now() // cache-bust
    fetch(url)
      .then(r => r.json())
      .then(m => { setManifest(m); setLoading(false) })
      .catch(e => { setError(String(e)); setLoading(false) })
  }, [])

  useEffect(() => { loadManifest() }, [loadManifest])

  return <Ctx.Provider value={{manifest,loading,error,reload:loadManifest}}>
    {children}
  </Ctx.Provider>
}

export function useManifest(){ return useContext(Ctx) }