--[[- - - - - - - - - - - - - - - - - - - - - - - - - - 

    Ambiente: HIscada_Pro
     Projeto: Projeto Sup Controle Refrigeração
     Empresa: HI Tecnologia
      Versão: 1.0.00
 Responsável: HI Tecnologia
        Data: 13/12/2022 

 \b Descrição:  \brief
   ... função do script

- - - - - - - - - - - - - - - - - - - - - - - - - - - -]] 


local Versao = Tags.Get("Kernel.Tags.Local.TagLocalGroup_APP.Versao")

local ret_MessageBox = MessageBox("YN2:Deseja realmente Sair do Sistema")

if (ret_MessageBox == 0) then
   ApplicationClose()

   --[[----------------------------------------------
   Sleep(3000)
   local VR = string.sub(Versao.Value, 1, -4)
   local CMD = "Kernel " .. VR .. " Coldvisio"
   os.execute('NET STOP "' .. CMD .. '"')
   Sleep(200)
   os.execute("start /min TASKKILL /F /IM MOS.EXE")
   Sleep(100)
   os.execute("start /min TASKKILL /F /IM MCS.EXE")
   Sleep(1000)
   --]]-----------------------------------------------


end 


