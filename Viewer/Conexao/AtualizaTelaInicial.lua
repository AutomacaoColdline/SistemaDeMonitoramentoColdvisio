--[[- - - - - - - - - - - - - - - - - - - - - - - - - - 

    Ambiente: HIscada_Pro
     Projeto: Projeto Sup Controle Refrigeração
     Empresa: HI Tecnologia
      Versão: 1.0.00
 Responsável: HI Tecnologia
        Data: 11/11/2022 

 \b Descrição:  \brief
   ... função do script

- - - - - - - - - - - - - - - - - - - - - - - - - - - -]] 

local tag_local_atualizaGrid = Tags.Get("Kernel.Tags.Local.TagLocalGroup_KN_Geral.TagLocal_AtualizaGrid")

if(tag_local_atualizaGrid.Value == true)then
 tag_local_atualizaGrid.Value = false
 tag_local_atualizaGrid:WriteValue()
end


local ret = Screens.Close("Screen_Inicial")

Sleep(3000)

local ret = Screens.Open("Screen_Inicial","Viewers.Screens.ScreenGroup_Inicial.Screen_Inicial")

Sleep(1000)
local ret = Screens.Close("Screen_AGUARDE")

Sleep(300)
result, err = Scripts.Run('Viewers.Scripts.ScriptGroup_Geral.Script_Visibilidade_Grid')
