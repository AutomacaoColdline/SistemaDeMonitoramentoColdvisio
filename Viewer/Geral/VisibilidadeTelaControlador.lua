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

local instance  = Sender.Screen:GetInstance('RefModel_Controlador')
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


-------------------------------------------------------------------------------------------------------------------------------
-- Nenhum 
-------------------------------------------------------------------------------------------------------------------------------
if(tag_modelo.Value == 0)then 

  scr.StaticText_MSG.Visible   = true

  scr.Image_017.Visible             = false
  scr.Image_042.Visible             = false
  scr.Image_041.Visible             = false
  scr.Image_015.Visible             = false  

  -- Temp Ambiente
  scr.Image_002.Visible             = false 
  scr.Image_010.Visible             = false 
  scr.Image_001.Visible             = false 
  scr.StaticText_001.Visible        = false 
  scr.Display_TempAmbiente.Visible  = false 
 
  -- Temp Max Diaria 
  scr.Image_003.Visible             = false 
  scr.Image_011.Visible             = false 
  scr.Image_004.Visible             = false 
  scr.StaticText_002.Visible        = false 
  scr.Display_TempMaxDiaria.Visible = false    

  -- Temp Min Diaria 
  scr.Image_006.Visible             = false 
  scr.Image_012.Visible             = false 
  scr.Image_007.Visible             = false 
  scr.StaticText_004.Visible        = false   
  scr.Display_TempMinDiaria.Visible = false 

  -- Umidade
  scr.Image_008.Visible             = false 
  scr.Image_013.Visible             = false 
  scr.Image_009.Visible             = false 
  scr.StaticText_005.Visible        = false   
  scr.Display_Umidade.Visible       = false  

 -- Temp Evaporador
  scr.Image_016.Visible             = false 
  scr.StaticText_006.Visible        = false   
  scr.Display_TempEvap.Visible      = false    

  -- Status Controlador
  scr.Image_019.Visible             = false 
  scr.Image_028.Visible             = false 
  scr.Image_018.Visible             = false 
  scr.StaticText_007.Visible        = false   
  scr.ImageList_001.Visible         = false    
  
  -- Status  Desumificacao
  scr.Image_020.Visible             = false 
  scr.Image_029.Visible             = false 
  scr.Image_021.Visible             = false 
  scr.StaticText_008.Visible        = false   
  scr.ImageList_003.Visible         = false   

  -- Status PHP
  scr.Image_038.Visible             = false 
  scr.Image_039.Visible             = false 
  scr.Image_040.Visible             = false 
  scr.StaticText_014.Visible        = false   
  scr.ImageList_008.Visible         = false 
	
  -- Status Degelo
  scr.Image_023.Visible             = false 
  scr.Image_030.Visible             = false 
  scr.Image_024.Visible             = false 
  scr.StaticText_009.Visible        = false   
  scr.ImageList_004.Visible         = false
  
  -- Status  Refrigeração
  scr.Image_031.Visible             = false 
  scr.Image_022.Visible             = false 
  scr.Image_025.Visible             = false 
  scr.StaticText_010.Visible        = false   
  scr.ImageList_005.Visible         = false  
  
  -- Status Ventilação
  scr.Image_026.Visible             = false 
  scr.Image_032.Visible             = false 
  scr.Image_027.Visible             = false 
  scr.StaticText_011.Visible        = false   
  scr.ImageList_006.Visible         = false  
  
  -- Comando Liga Desliga
  scr.Image_034.Visible             = false 
  scr.StaticText_012.Visible        = false   
  scr.ImageList_002.Visible         = false   
  
  -- Comando Degelo
  scr.Image_035.Visible             = false 
  scr.StaticText_013.Visible        = false   
  scr.ImageList_007.Visible         = false   
    
 scr.Image_AbreTelaconfig.Visible   = false  

-------------------------------------------------------------------------------------------------------------------------------
-- Modelo Dixell XH260
-------------------------------------------------------------------------------------------------------------------------------
elseif(tag_modelo.Value == 1)then 

  scr.StaticText_MSG.Visible   = false

  scr.Image_017.Visible             = true
  scr.Image_042.Visible             = true
  scr.Image_041.Visible             = false
  scr.Image_015.Visible             = false 
  
    -- Temp Ambiente
  scr.Image_002.Visible             = true 
  scr.Image_010.Visible             = true 
  scr.Image_001.Visible             = true 
  scr.StaticText_001.Visible        = true 
  scr.Display_TempAmbiente.Visible  = true 
 
  -- Temp Max Diaria 
  scr.Image_003.Visible             = true 
  scr.Image_011.Visible             = true 
  scr.Image_004.Visible             = true 
  scr.StaticText_002.Visible        = true 
  scr.Display_TempMaxDiaria.Visible = true    

  -- Temp Min Diaria 
  scr.Image_006.Visible             = true 
  scr.Image_012.Visible             = true 
  scr.Image_007.Visible             = true 
  scr.StaticText_004.Visible        = true   
  scr.Display_TempMinDiaria.Visible = true 

  -- Umidade
  scr.Image_008.Visible             = true 
  scr.Image_013.Visible             = true 
  scr.Image_009.Visible             = true 
  scr.StaticText_005.Visible        = true   
  scr.Display_Umidade.Visible       = true  

 -- Temp Evaporador
  scr.Image_016.Visible             = false 
  scr.StaticText_006.Visible        = false   
  scr.Display_TempEvap.Visible      = false    

  -- Status Controlador
  scr.Image_019.Visible             = true 
  scr.Image_028.Visible             = true 
  scr.Image_018.Visible             = true 
  scr.StaticText_007.Visible        = true   
  scr.ImageList_001.Visible         = true    
  
  -- Status  Desumificacao
  scr.Image_020.Visible             = true 
  scr.Image_029.Visible             = true 
  scr.Image_021.Visible             = true 
  scr.StaticText_008.Visible        = true   
  scr.ImageList_003.Visible         = true

  -- Status PHP
  scr.Image_038.Visible             = true 
  scr.Image_039.Visible             = true 
  scr.Image_040.Visible             = true 
  scr.StaticText_014.Visible        = true   
  scr.ImageList_008.Visible         = true    

  -- Status Degelo
  scr.Image_023.Visible             = true 
  scr.Image_030.Visible             = true 
  scr.Image_024.Visible             = true 
  scr.StaticText_009.Visible        = true   
  scr.ImageList_004.Visible         = true
  
  -- Status  Refrigeração
  scr.Image_031.Visible             = true 
  scr.Image_022.Visible             = true 
  scr.Image_025.Visible             = true 
  scr.StaticText_010.Visible        = true   
  scr.ImageList_005.Visible         = true  
  
  -- Status Ventilação
  scr.Image_026.Visible             = true 
  scr.Image_032.Visible             = true 
  scr.Image_027.Visible             = true 
  scr.StaticText_011.Visible        = true   
  scr.ImageList_006.Visible         = true  
  
  -- Comando Liga Desliga
  scr.Image_034.Visible             = true 
  scr.StaticText_012.Visible        = true   
  scr.ImageList_002.Visible         = true   
  
  -- Comando Degelo
  scr.Image_035.Visible             = true 
  scr.StaticText_013.Visible        = true   
  scr.ImageList_007.Visible         = true   
    
  
-------------------------------------------------------------------------------------------------------------------------------
-- Full Gauge TC 900e Log
-------------------------------------------------------------------------------------------------------------------------------
elseif(tag_modelo.Value == 2)then 

  scr.StaticText_MSG.Visible   = false

  scr.Image_017.Visible             = false
  scr.Image_042.Visible             = false
  scr.Image_041.Visible             = true
  scr.Image_015.Visible             = true

  -- Temp Ambiente
  scr.Image_002.Visible             = true 
  scr.Image_010.Visible             = true 
  scr.Image_001.Visible             = true 
  scr.StaticText_001.Visible        = true 
  scr.Display_TempAmbiente.Visible  = true 
 
  -- Temp Max Diaria 
  scr.Image_003.Visible             = true 
  scr.Image_011.Visible             = true 
  scr.Image_004.Visible             = true 
  scr.StaticText_002.Visible        = true 
  scr.Display_TempMaxDiaria.Visible = true    

  -- Temp Min Diaria 
  scr.Image_006.Visible             = true 
  scr.Image_012.Visible             = true 
  scr.Image_007.Visible             = true 
  scr.StaticText_004.Visible        = true   
  scr.Display_TempMinDiaria.Visible = true 

  -- Umidade
  scr.Image_013.Visible             = false 
  scr.StaticText_005.Visible        = false   
  scr.Display_Umidade.Visible       = false  

 -- Temp Evaporador
  scr.Image_008.Visible             = true 
  scr.Image_009.Visible             = true 
  scr.Image_016.Visible             = true 
  scr.StaticText_006.Visible        = true   
  scr.Display_TempEvap.Visible      = true    

  -- Status Controlador
  scr.Image_019.Visible             = true 
  scr.Image_028.Visible             = true 
  scr.Image_018.Visible             = true 
  scr.StaticText_007.Visible        = true   
  scr.ImageList_001.Visible         = true    
  
  -- Status  Desumificacao
  scr.Image_020.Visible             = false 
  scr.Image_029.Visible             = false 
  scr.Image_021.Visible             = false 
  scr.StaticText_008.Visible        = false   
  scr.ImageList_003.Visible         = false

  -- Status PHP
  scr.Image_038.Visible             = false 
  scr.Image_039.Visible             = false 
  scr.Image_040.Visible             = false 
  scr.StaticText_014.Visible        = false   
  scr.ImageList_008.Visible         = false    

  -- Status Degelo
  scr.Image_023.Visible             = true 
  scr.Image_030.Visible             = true 
  scr.Image_024.Visible             = true 
  scr.StaticText_009.Visible        = true   
  scr.ImageList_004.Visible         = true
  
  -- Status  Refrigeração
  scr.Image_031.Visible             = true 
  scr.Image_022.Visible             = true 
  scr.Image_025.Visible             = true 
  scr.StaticText_010.Visible        = true   
  scr.ImageList_005.Visible         = true  
  
  -- Status Ventilação
  scr.Image_026.Visible             = true 
  scr.Image_032.Visible             = true 
  scr.Image_027.Visible             = true 
  scr.StaticText_011.Visible        = true   
  scr.ImageList_006.Visible         = true  
  
  -- Comando Liga Desliga
  scr.Image_034.Visible             = true 
  scr.StaticText_012.Visible        = true   
  scr.ImageList_002.Visible         = true   
  
  -- Comando Degelo
  scr.Image_035.Visible             = true 
  scr.StaticText_013.Visible        = true   
  scr.ImageList_007.Visible         = true   
    
 scr.Image_AbreTelaconfig.Visible   = true  


end
