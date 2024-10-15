--[[- - - - - - - - - - - - - - - - - - - - - - - - - - 

    Ambiente: HIscada_Pro
     Projeto: Projeto_Colegio
     Empresa: HI Tecnologia
      Versão: 1.1.0.0
 Responsável: Daniel kantor
        Data: 30/09/2022 

 \b Descrição:  \brief
   ... função do script

- - - - - - - - - - - - - - - - - - - - - - - - - - - -]] 

-------------------------------------------------------------------------------------------------------------------------------
-- Obtém Tela
-------------------------------------------------------------------------------------------------------------------------------
local scr = Sender.Screen

local AddUsefulFunctions = require "UsefulFunctions"

-------------------------------------------------------------------------------------------------------------------------------
-- Obtém instancia
-------------------------------------------------------------------------------------------------------------------------------

local ret = Screens.Open("Screen_Habilita_Instancias","Viewers.Screens.ScreenGroup_Configuracao.Screen_Habilita_Instancias")

if Screens.Exist("Screen_Configuracao_Controlador") then
  --print("Tela Existe")
  Screens.Close("Screen_Configuracao_Controlador")
end
