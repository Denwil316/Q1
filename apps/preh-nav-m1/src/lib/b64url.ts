// [QEL::ECO[96]::RECALL A96-250817-PREH-NAV-REHIDRATA]
export function enc(input:string){return btoa(input).replace(/\+/g,'-').replace(/\//g,'_').replace(/=+$/g,'')}
export function dec(input:string){input=input.replace(/-/g,'+').replace(/_/g,'/');while(input.length%4) input+='=';return atob(input)}
