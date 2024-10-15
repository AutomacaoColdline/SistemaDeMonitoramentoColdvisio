--[[- - - - - - - - - - - - - - - - - - - - - - - - - - 

    Ambiente: HIscada_Pro
     Projeto: Projeto Sup Controle Refrigeração
     Empresa: HI Tecnologia
      Versão: 1.0.00
 Responsável: HI Tecnologia
        Data: 10/11/2022 

 \b Descrição:  \brief
   ... função do script

- - - - - - - - - - - - - - - - - - - - - - - - - - - -]] 

local tag_local = Tags.Get("Kernel.Tags.Local.TagLocalGroup_KN_Conexao.TagLocal_ComandoConectar")


if(tag_local.Value ~=0)then

  return
end


local ret = Screens.Open("Screen_Inicial","Viewers.Screens.ScreenGroup_Inicial.Screen_Inicial")

local ret = Screens.Clese("Screen_Popup")


