--[[- - - - - - - - - - - - - - - - - - - - - - - - - - 

    Ambiente: HIscada_Pro
     Projeto: Projeto_Colegio
     Empresa: HI Tecnologia
      Versão: 1.1.0.0
 Responsável: Daniel kantor
        Data: 18/10/2022 

 \b Descrição:  \brief
   ... função do script

- - - - - - - - - - - - - - - - - - - - - - - - - - - -]] 

local scr  = Sender.Screen

Sleep(100)

local tag_inicio = Tags.Get("Kernel.Tags.Local.TagLocalGroup_KN_relatorio.TagLocal_DataHoraInicioTaxas") 
local tag_final  = Tags.Get("Kernel.Tags.Local.TagLocalGroup_KN_relatorio.TagLocal_DataHoraFimTaxas")

tag_inicio.Value  = DateTime(DateTime():GetFormatString('dd/mm/yyyy 00:00:00'))
tag_final.Value   = DateTime(DateTime():GetFormatString('dd/mm/yyyy 23:59:59'))

tag_inicio:WriteValue()
tag_final:WriteValue()





