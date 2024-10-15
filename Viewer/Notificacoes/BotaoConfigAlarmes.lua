------------------------------------------------------------------------------------------------------------------------------- 
--    Projeto: Demo HIscada Pro
--    Cliente: 
--       Data: 01/ago/2013  
--      Resp.: Eng. de Produto da HI Tecnologia
--   Ambiente: HIscada Pro, versão 1.3.03 ou superior
------------------------------------------------------------------------------------------------------------------------------- 

local function escreveTagOpc(TagOpc)

  local retWR = 0

  if(TagOpc ~= false and TagOpc ~= nil)then
    retWR = TagOpc:WriteValue()
  
    if(retWR == 0)then
      return true
    end
  end

  return false

end

-- Função para consistir
local AddUsefulFunctions = require "UsefulFunctions"


local Argumento = Sender.Argument

------------------------------------------------------------------------------------------------------------------------------- 
-- Obtém tela atual
------------------------------------------------------------------------------------------------------------------------------- 
scr = Sender.Screen


local flag_falha_execucao_comando = false
------------------------------------------------------------------------------------------------------------------------------- 
-- Pega os Tags para transformar
------------------------------------------------------------------------------------------------------------------------------- 
local tag_alarmes_bloco1   = ConsisteTagOpc('Kernel.Tags.Opc.TagOpcGroup_bloco_01_alarmes.TagOpc_aux_alarme_seguranca')
local tag_alarmes_bloco2   = ConsisteTagOpc('Kernel.Tags.Opc.TagOpcGroup_bloco_02_alarmes.TagOpc_aux_alarme_seguranca')
local tag_alarmes_bloco3   = ConsisteTagOpc('Kernel.Tags.Opc.TagOpcGroup_bloco_03_alarmes.TagOpc_aux_alarme_seguranca')
local tag_alarmes_bloco4_1 = ConsisteTagOpc('Kernel.Tags.Opc.TagOpcGroup_bloco_04_alarmes_clp_01.TagOpc_aux_alarme_seguranca')
local tag_alarmes_bloco4_2 = ConsisteTagOpc('Kernel.Tags.Opc.TagOpcGroup_bloco_04_alarmes_clp_02.TagOpc_aux_alarme_seguranca')
local tag_alarmes_bloco5_1 = ConsisteTagOpc('Kernel.Tags.Opc.TagOpcGroup_bloco_05_alarmes_clp_01.TagOpc_aux_alarme_seguranca')
local tag_alarmes_bloco5_2 = ConsisteTagOpc('Kernel.Tags.Opc.TagOpcGroup_bloco_05_alarmes_clp_02.TagOpc_aux_alarme_seguranca')

if(tag_alarmes_bloco1   == false or
   tag_alarmes_bloco2   == false or
   tag_alarmes_bloco3   == false or
   tag_alarmes_bloco4_1 == false or
   tag_alarmes_bloco4_2 == false or
   tag_alarmes_bloco5_1 == false or
   tag_alarmes_bloco5_2 == false)then
  flag_falha_execucao_comando = true
end

local tag_reseta_algum_bloco1  = ConsisteTagOpc('Kernel.Tags.Opc.TagOpcGroup_bloco_01_alarmes.TagOpc_algum_alarme_bloco1')
local tag_reseta_algum_bloco2  = ConsisteTagOpc('Kernel.Tags.Opc.TagOpcGroup_bloco_02_alarmes.TagOpc_algum_alarme_bloco2')
local tag_reseta_algum_bloco3  = ConsisteTagOpc('Kernel.Tags.Opc.TagOpcGroup_bloco_03_alarmes.TagOpc_algum_alarme_bloco3')
local tag_reseta_algum_bloco41 = ConsisteTagOpc('Kernel.Tags.Opc.TagOpcGroup_bloco_04_alarmes_clp_01.TagOpc_algum_alarme_bloco4')
local tag_reseta_algum_bloco42 = ConsisteTagOpc('Kernel.Tags.Opc.TagOpcGroup_bloco_04_alarmes_clp_02.TagOpc_algum_alarme_bloco4')
local tag_reseta_algum_bloco51 = ConsisteTagOpc('Kernel.Tags.Opc.TagOpcGroup_bloco_05_alarmes_clp_01.TagOpc_algum_alarme_bloco5')
local tag_reseta_algum_bloco52 = ConsisteTagOpc('Kernel.Tags.Opc.TagOpcGroup_bloco_05_alarmes_clp_02.TagOpc_algum_alarme_bloco5')

if(tag_reseta_algum_bloco1   == false or
   tag_reseta_algum_bloco2   == false or
   tag_reseta_algum_bloco3   == false or
   tag_reseta_algum_bloco4_1 == false or
   tag_reseta_algum_bloco4_2 == false or
   tag_reseta_algum_bloco5_1 == false or
   tag_reseta_algum_bloco5_2 == false)then
  flag_falha_execucao_comando = true
end

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

  local retWR = 0

  if(tag_alarmes_bloco1 ~= false)then
    for i = 1, #tag_alarmes_bloco1.Value do
      tag_alarmes_bloco1.Value[i] = -1
    end
    if(escreveTagOpc(tag_alarmes_bloco1) == false)then
      flag_falha_execucao_comando = true
    end
  end

  if(tag_alarmes_bloco2 ~= false)then
    for i = 1, #tag_alarmes_bloco2.Value do
      tag_alarmes_bloco2.Value[i] = -1
    end
    if(escreveTagOpc(tag_alarmes_bloco2) == false)then
      flag_falha_execucao_comando = true
    end
  end

  if(tag_alarmes_bloco3 ~= false)then
    for i = 1, #tag_alarmes_bloco3.Value do
      tag_alarmes_bloco3.Value[i] = -1
    end
    if(escreveTagOpc(tag_alarmes_bloco3) == false)then
      flag_falha_execucao_comando = true
    end
  end

  if(tag_alarmes_bloco4_1 ~= false)then
    for i = 1, #tag_alarmes_bloco4_1.Value do
      tag_alarmes_bloco4_1.Value[i] = -1
    end
    if(escreveTagOpc(tag_alarmes_bloco4_1) == false)then
      flag_falha_execucao_comando = true
    end
  end

  if(tag_alarmes_bloco4_2 ~= false)then
    for i = 1, #tag_alarmes_bloco4_2.Value do
      tag_alarmes_bloco4_2.Value[i] = -1
    end
    if(escreveTagOpc(tag_alarmes_bloco4_2) == false)then
      flag_falha_execucao_comando = true
    end
  end

  if(tag_alarmes_bloco5_1 ~= false)then
    for i = 1, #tag_alarmes_bloco5_1.Value do
      tag_alarmes_bloco5_1.Value[i] = -1
    end
    if(escreveTagOpc(tag_alarmes_bloco5_1) == false)then
      flag_falha_execucao_comando = true
    end
  end

  if(tag_alarmes_bloco5_2 ~= false)then
    for i = 1, #tag_alarmes_bloco5_2.Value do
      tag_alarmes_bloco5_2.Value[i] = -1
    end
    if(escreveTagOpc(tag_alarmes_bloco5_2) == false)then
      flag_falha_execucao_comando = true
    end
  end

  if(tag_reseta_algum_bloco1 ~= false)then
    tag_reseta_algum_bloco1.Value = 0
    if(escreveTagOpc(tag_reseta_algum_bloco1) == false)then
      flag_falha_execucao_comando = true
    end
  end
  tag_pisca_bloco1.Value = 0
  tag_pisca_bloco1:WriteValue()

  if(tag_reseta_algum_bloco2 ~= false)then
    tag_reseta_algum_bloco2.Value = 0
    if(escreveTagOpc(tag_reseta_algum_bloco2) == false)then
      flag_falha_execucao_comando = true
    end
  end
  tag_pisca_bloco2.Value = 0
  tag_pisca_bloco2:WriteValue()

  if(tag_reseta_algum_bloco3 ~= false)then
    tag_reseta_algum_bloco3.Value = 0
    if(escreveTagOpc(tag_reseta_algum_bloco3) == false)then
      flag_falha_execucao_comando = true
    end
  end
  tag_pisca_bloco3.Value = 0
  tag_pisca_bloco3:WriteValue()

  if(tag_reseta_algum_bloco41 ~= false)then
    tag_reseta_algum_bloco41.Value = 0
    if(escreveTagOpc(tag_reseta_algum_bloco41) == false)then
      flag_falha_execucao_comando = true
    end
  end
  if(tag_reseta_algum_bloco42 ~= false)then
    tag_reseta_algum_bloco42.Value = 0
    if(escreveTagOpc(tag_reseta_algum_bloco42) == false)then
      flag_falha_execucao_comando = true
    end
  end
  tag_pisca_bloco4.Value = 0
  tag_pisca_bloco4:WriteValue()

  if(tag_reseta_algum_bloco51 ~= false)then
    tag_reseta_algum_bloco51.Value = 0
    if(escreveTagOpc(tag_reseta_algum_bloco51) == false)then
      flag_falha_execucao_comando = true
    end
  end
  if(tag_reseta_algum_bloco52 ~= false)then
    tag_reseta_algum_bloco52.Value = 0
    if(escreveTagOpc(tag_reseta_algum_bloco52) == false)then
      flag_falha_execucao_comando = true
    end
  end
  tag_pisca_bloco5.Value = 0
  tag_pisca_bloco5:WriteValue()

  if(flag_falha_execucao_comando == true)then
    MessageBox('ERW: Falha ao executar comando')
  end

elseif(Argumento == "Silence")then
  ret = scr.Alarms_grid_alarmes_notificacao:Silence()    --Silencia o som do alarme selecionado

elseif(Argumento == "Reset")then
  ret = scr.Alarms_grid_alarmes_notificacao:Reset()     -- Reseta o alarme selecionado

elseif(Argumento == "Suppress")then
  ret = scr.Alarms_grid_alarmes_notificacao:Suppress()    --Suprime o alarme selecionado

elseif(Argumento == "UnSuppress")then
  ret = scr.Alarms_grid_alarmes_notificacao:UnSuppress()   --Remove a supressão de todos os alarmes

end





