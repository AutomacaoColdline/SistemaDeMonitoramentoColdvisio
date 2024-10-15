--[[- - - - - - - - - - - - - - - - - - - - - - - - - - 

    Ambiente: HIscada_Pro
     Projeto: Projeto Sup Controle Refrigeração
     Empresa: HI Tecnologia
      Versão: 1.0.00
 Responsável: HI Tecnologia
        Data: 08/11/2022 

 \b Descrição:  \brief
   ... função do script

- - - - - - - - - - - - - - - - - - - - - - - - - - - -]] 

local AddUsefulFunctions = require "UsefulFunctions"

-------------------------------------------------------------------------------------------------------------------------------
-- Obtém Tela
-------------------------------------------------------------------------------------------------------------------------------
local scr = Sender.Screen

local Argumento = Sender.Argument


-------------------------------------------------------------------------------------------------------------------------------
-- Obtém os tags
-------------------------------------------------------------------------------------------------------------------------------

local tag_tipo    = Tags.Get("Kernel.Tags.Local.TagLocalGroup_KN_relatorio.TagLocal_TipoGraficoTabular") 
local tag_tabular = Tags.Get("Kernel.Tags.Local.TagLocalGroup_KN_relatorio.TagLocal_Tabular") 
local tag_grafico = Tags.Get("Kernel.Tags.Local.TagLocalGroup_KN_relatorio.TagLocal_Grafico") 



if(Argumento == "tabular")then

   tag_tabular.Value = true
   tag_grafico.Value = false
   tag_tipo.Value = 0

   tag_tipo:WriteValue()
   tag_tabular:WriteValue()
  tag_grafico:WriteValue()

elseif(Argumento == "grafico")then

   tag_tabular.Value = false
   tag_grafico.Value = true
   tag_tipo.Value = 1

  tag_tipo:WriteValue()
  tag_tabular:WriteValue()
  tag_grafico:WriteValue()

end


