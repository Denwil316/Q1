// [QEL::ECO[96]::RECALL A96-250817-PREH-NAV-REHIDRATA]
import React,{createContext,useContext,useEffect,useState} from 'react'
type FileItem={name:string;role:string;path:string}
type Manifest={consolidated_package?:string;files:FileItem[];recommended_core?:string[];optional?:string[]}
type Ctx={manifest:Manifest|null,loading:boolean,error:string|null}
const Ctx=createContext<Ctx>({manifest:null,loading:true,error:null})
export default function ManifestProvider({children}:{children:React.ReactNode}){
  const [state,set]=useState<Ctx>({manifest:null,loading:true,error:null})
  useEffect(()=>{fetch('/sot-manifest.json').then(r=>r.json()).then((m:Manifest)=>set({manifest:m,loading:false,error:null})).catch(e=>set({manifest:null,loading:false,error:String(e)}))},[])
  return <Ctx.Provider value={{manifest:state.manifest,loading:state.loading,error:state.error}}>{children}</Ctx.Provider>
}
export function useManifest(){ return useContext(Ctx) }
