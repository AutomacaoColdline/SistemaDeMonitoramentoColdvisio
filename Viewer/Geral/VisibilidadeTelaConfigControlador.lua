--[[- - - - - - - - - - - - - - - - - - - - - - - - - - 

    Ambiente: HIscada_Pro
     Projeto: Projeto_Colegio
     Empresa: HI Tecnologia
      Versão: 1.1.0.0
 Responsável: Daniel kantor
        Data: 03/10/2022 

 \b Descrição:  \brief
   ... função do script

- - - - - - - - - - - - - - - - - - - - - - - - - - - -]] 

local AddUsefulFunctions = require "UsefulFunctions"

local instance  = Sender.Screen:GetInstance('RefModel_Controlador_cfg')
local prefix = 'Instances.' .. instance.Group .. '.' .. instance.Name

--print(prefix)

-------------------------------------------------------------------------------------------------------------------------------
-- Obtém Tela
-------------------------------------------------------------------------------------------------------------------------------
local scr = Sender.Screen

-------------------------------------------------------------------------------------------------------------------------------
-- Obtém Tag
-------------------------------------------------------------------------------------------------------------------------------
local tag_modelo = ConsisteTagOpc(prefix .. ".Tags.Opc.Modelo_Controlador.Modelo")

tag_modelo:ReadDevice()
-------------------------------------------------------------------------------------------------------------------------------
-- Nenhum 
-------------------------------------------------------------------------------------------------------------------------------
if(tag_modelo.Value == 0)then 

  scr.Image_007.Visible                      = false
  scr.Image_017.Visible                      = false
  scr.Image_003.Visible                      = false
  scr.StaticText_SP_TempAmb.Visible          = false
  scr.Edit_SetPoint_Temp_Ambiente.Visible    = false
  scr.Button_SetPoint_Temp_Ambiente.Visible  = false

  scr.Image_009.Visible               = false
  scr.Image_019.Visible               = false
  scr.Image_005.Visible               = false
  scr.StaticText_SP_Umidade.Visible   = false
  scr.Edit_SetPointUmidade.Visible    = false
  scr.Button_SetPointUmidade.Visible  = false

  scr.Image_001.Visible               = false
  scr.Image_020.Visible               = false
  scr.Image_002.Visible               = false
  scr.StaticText_SP_TempEvap.Visible  = false
  scr.Edit_SP_TempEvap.Visible        = false
  scr.Button_SP_TempEvap.Visible      = false

  scr.Image_018.Visible                   = false
  scr.StaticText_IntervaloDegelo.Visible  = false
  scr.Edit_IntervaloDegelo.Visible        = false
  scr.Button_IntervaloDegelo.Visible      = false


-------------------------------------------------------------------------------------------------------------------------------
-- Modelo Dixell XH260
-------------------------------------------------------------------------------------------------------------------------------
elseif(tag_modelo.Value == 1)then 

  scr.Image_007.Visible                      = true
  scr.Image_017.Visible                      = true
  scr.Image_003.Visible                      = true
  scr.StaticText_SP_TempAmb.Visible          = true
  scr.Edit_SetPoint_Temp_Ambiente.Visible    = true
  scr.Button_SetPoint_Temp_Ambiente.Visible  = true

  scr.Image_009.Visible               = true
  scr.Image_019.Visible               = true
  scr.Image_005.Visible               = true
  scr.StaticText_SP_Umidade.Visible   = true
  scr.Edit_SetPointUmidade.Visible    = true
  scr.Button_SetPointUmidade.Visible  = true

  scr.Image_001.Visible               = false
  scr.Image_020.Visible               = false
  scr.Image_002.Visible               = false
  scr.StaticText_SP_TempEvap.Visible  = false
  scr.Edit_SP_TempEvap.Visible        = false
  scr.Button_SP_TempEvap.Visible      = false

  scr.Image_018.Visible                   = false
  scr.StaticText_IntervaloDegelo.Visible  = false
  scr.Edit_IntervaloDegelo.Visible        = false
  scr.Button_IntervaloDegelo.Visible      = false
  

-------------------------------------------------------------------------------------------------------------------------------
-- Full Gauge TC 900e Log
-------------------------------------------------------------------------------------------------------------------------------
elseif(tag_modelo.Value == 2)then 

  scr.Image_007.Visible                      = true
  scr.Image_017.Visible                      = true
  scr.Image_003.Visible                      = true
  scr.StaticText_SP_TempAmb.Visible          = true
  scr.Edit_SetPoint_Temp_Ambiente.Visible    = true
  scr.Button_SetPoint_Temp_Ambiente.Visible  = true

  scr.Image_019.Visible               = false

  scr.StaticText_SP_Umidade.Visible   = false
  scr.Edit_SetPointUmidade.Visible    = false
  scr.Button_SetPointUmidade.Visible  = false

  scr.Image_001.Visible               = true
  scr.Image_020.Visible               = true
  scr.Image_002.Visible               = true
  scr.StaticText_SP_TempEvap.Visible  = true
  scr.Edit_SP_TempEvap.Visible        = true
  scr.Button_SP_TempEvap.Visible      = true

  scr.Image_005.Visible                   = true
  scr.Image_009.Visible                   = true
  scr.Image_018.Visible                   = true
  scr.StaticText_IntervaloDegelo.Visible  = true
  scr.Edit_IntervaloDegelo.Visible        = true
  scr.Button_IntervaloDegelo.Visible      = true
  
end
