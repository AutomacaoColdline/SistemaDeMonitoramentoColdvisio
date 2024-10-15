------------------------------------------------------------------------------------------------------------------------------- 
--    Projeto: Demo HIscada Pro
--    Cliente: 
--       Data: 01/ago/2013  
--      Resp.: Eng. de Produto da HI Tecnologia
--   Ambiente: HIscada Pro, versão 1.3.03 ou superior
------------------------------------------------------------------------------------------------------------------------------- 




local Argumento = Sender.Argument

------------------------------------------------------------------------------------------------------------------------------- 
-- Obtém tela atual
------------------------------------------------------------------------------------------------------------------------------- 
scr = Sender.Screen



------------------------------------------------------------------------------------------------------------------------------- 
-- Pega os Tags para transformar
------------------------------------------------------------------------------------------------------------------------------- 
local tag_alarmes_bloco1 = Tags.Get('Kernel.Tags.Opc.TagOpcGroup_bloco_01_alarmes.TagOpc_aux_alarme_seguranca')
local tag_alarmes_bloco41 = Tags.Get('Kernel.Tags.Opc.TagOpcGroup_bloco_04_alarmes_clp_01.TagOpc_aux_alarme_seguranca')
local tag_alarmes_bloco42 = Tags.Get('Kernel.Tags.Opc.TagOpcGroup_bloco_04_alarmes_clp_02.TagOpc_aux_alarme_seguranca')
local tag_alarmes_bloco51 = Tags.Get('Kernel.Tags.Opc.TagOpcGroup_bloco_05_alarmes_clp_01.TagOpc_aux_alarme_seguranca')
local tag_alarmes_bloco52 = Tags.Get('Kernel.Tags.Opc.TagOpcGroup_bloco_05_alarmes_clp_02.TagOpc_aux_alarme_seguranca')

local tag_reseta_algum_bloco1 = Tags.Get('Kernel.Tags.Opc.TagOpcGroup_bloco_01_alarmes.TagOpc_algum_alarme_bloco1')
local tag_reseta_algum_bloco2 = Tags.Get('Kernel.Tags.Opc.TagOpcGroup_bloco_02_alarmes.TagOpc_algum_alarme_bloco2')
local tag_reseta_algum_bloco3 = Tags.Get('Kernel.Tags.Opc.TagOpcGroup_bloco_03_alarmes.TagOpc_algum_alarme_bloco3')
local tag_reseta_algum_bloco41 = Tags.Get('Kernel.Tags.Opc.TagOpcGroup_bloco_04_alarmes_clp_01.TagOpc_algum_alarme_bloco4')
local tag_reseta_algum_bloco42 = Tags.Get('Kernel.Tags.Opc.TagOpcGroup_bloco_04_alarmes_clp_02.TagOpc_algum_alarme_bloco4')
local tag_reseta_algum_bloco51 = Tags.Get('Kernel.Tags.Opc.TagOpcGroup_bloco_05_alarmes_clp_01.TagOpc_algum_alarme_bloco5')
local tag_reseta_algum_bloco52 = Tags.Get('Kernel.Tags.Opc.TagOpcGroup_bloco_05_alarmes_clp_02.TagOpc_algum_alarme_bloco5')



err1 = tag_alarmes_bloco1:ReadDevice()
err41 = tag_alarmes_bloco41:ReadDevice()
err42 = tag_alarmes_bloco42:ReadDevice()
err51 = tag_alarmes_bloco51:ReadDevice()
err52 = tag_alarmes_bloco52:ReadDevice()

local tag_pisca_bloco1 = Tags.Get('Viewers.Tags.Local.ViewerTagGroup_geral.ViewerTag_pisca_bloco_1')
local tag_pisca_bloco2 = Tags.Get('Viewers.Tags.Local.ViewerTagGroup_geral.ViewerTag_pisca_bloco_2')
local tag_pisca_bloco3 = Tags.Get('Viewers.Tags.Local.ViewerTagGroup_geral.ViewerTag_pisca_bloco_3')
local tag_pisca_bloco4 = Tags.Get('Viewers.Tags.Local.ViewerTagGroup_geral.ViewerTag_pisca_bloco_4')
local tag_pisca_bloco5 = Tags.Get('Viewers.Tags.Local.ViewerTagGroup_geral.ViewerTag_pisca_bloco_5')





------------------------------------------------------------------------------------------------------------------------------- 
-- Verifica qual o ação esta selecionada para o alarme
-------------------------------------------------------------------------------------------------------------------------------



if(Argumento == "Ack")then
  ret = scr.Alarms_grid_alarmes_base:Ack()        -- Reconhece o alarme selecionado

elseif(Argumento == "AckAll")then
  ret = scr.Alarms_grid_alarmes_base:AckAll()     -- Reconhece todos os alarmes

if err1 == 0 then
  for i = 1, #tag_alarmes_bloco1.Value do
     tag_alarmes_bloco1.Value[i] = -1
  end
  tag_alarmes_bloco1:WriteValue()
end

if err41 == 0 then
  for i = 1, #tag_alarmes_bloco41.Value do
     tag_alarmes_bloco41.Value[i] = -1
  end
  tag_alarmes_bloco41:WriteValue()
end

if err42 == 0 then
  for i = 1, #tag_alarmes_bloco42.Value do
     tag_alarmes_bloco42.Value[i] = -1
  end
  tag_alarmes_bloco42:WriteValue()
end

if err51 == 0 then
  for i = 1, #tag_alarmes_bloco51.Value do
     tag_alarmes_bloco51.Value[i] = -1
  end
  tag_alarmes_bloco51:WriteValue()
end

if err52 == 0 then
  for i = 1, #tag_alarmes_bloco52.Value do
     tag_alarmes_bloco52.Value[i] = -1
  end
  tag_alarmes_bloco52:WriteValue()
end

  tag_reseta_algum_bloco1.Value = 0
  tag_reseta_algum_bloco1:WriteValue()
  tag_pisca_bloco1.Value = 0
  tag_pisca_bloco1:WriteValue()

  tag_reseta_algum_bloco2.Value = 0
  tag_reseta_algum_bloco2:WriteValue()
  tag_pisca_bloco2.Value = 0
  tag_pisca_bloco2:WriteValue()

  tag_reseta_algum_bloco3.Value = 0
  tag_reseta_algum_bloco3:WriteValue()
  tag_pisca_bloco3.Value = 0
  tag_pisca_bloco3:WriteValue()

  tag_reseta_algum_bloco41.Value = 0
  tag_reseta_algum_bloco41:WriteValue()
  tag_reseta_algum_bloco42.Value = 0
  tag_reseta_algum_bloco42:WriteValue()
  tag_pisca_bloco4.Value = 0
  tag_pisca_bloco4:WriteValue()

  tag_reseta_algum_bloco51.Value = 0
  tag_reseta_algum_bloco51:WriteValue()
  tag_reseta_algum_bloco52.Value = 0
  tag_reseta_algum_bloco52:WriteValue()
  tag_pisca_bloco5.Value = 0
  tag_pisca_bloco5:WriteValue()

elseif(Argumento == "Silence")then
  ret = scr.Alarms_grid_alarmes_notificacao:Silence()    --Silencia o som do alarme selecionado

elseif(Argumento == "Reset")then
  ret = scr.Alarms_grid_alarmes_notificacao:Reset()     -- Reseta o alarme selecionado

elseif(Argumento == "Suppress")then
  ret = scr.Alarms_grid_alarmes_notificacao:Suppress()    --Suprime o alarme selecionado

elseif(Argumento == "UnSuppress")then
  ret = scr.Alarms_grid_alarmes_notificacao:UnSuppress()   --Remove a supressão de todos os alarmes

end

