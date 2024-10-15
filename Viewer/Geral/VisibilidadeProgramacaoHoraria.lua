--[[- - - - - - - - - - - - - - - - - - - - - - - - - - 

    Ambiente: HIscada_Pro
     Projeto: Projeto_Colegio
     Empresa: HI Tecnologia
      Versão: 1.1.0.0
 Responsável: Daniel kantor
        Data: 06/10/2022 

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
local tag_dia_semana = ConsisteTagOpc(prefix .. ".Tags.Opc.TagOpcGroup_HabilitaDesabilitaHorarios.HabilitaDesabilitaHorarios")


tag_dia_semana:ReadDevice()
-------------------------------------------------------------------------------------------------------------------------------
-- DOMINGO - 0 desabilitado/ 1 - Habilitado
-------------------------------------------------------------------------------------------------------------------------------
--Liga
if(tag_dia_semana.Value[1] == false)then 

   scr.ComboBox_001.Visible   = false
   scr.ComboBox_003.Visible   = false
   scr.ComboBox_036.Visible   = true
   scr.ComboBox_037.Visible   = true
   scr.ComboBox_036.Enabled   = false
   scr.ComboBox_037.Enabled   = false

elseif(tag_dia_semana.Value[1] == true )then 

   scr.ComboBox_001.Visible   = true
   scr.ComboBox_003.Visible   = true
   scr.ComboBox_036.Visible   = false
   scr.ComboBox_037.Visible   = false

end

--Desliga
if(tag_dia_semana.Value[2] == false)then 

   scr.ComboBox_004.Visible   = false
   scr.ComboBox_005.Visible   = false
   scr.ComboBox_038.Visible   = true
   scr.ComboBox_039.Visible   = true
   scr.ComboBox_038.Enabled    = false
   scr.ComboBox_039.Enabled    = false

elseif(tag_dia_semana.Value[2] == true)then 

   scr.ComboBox_004.Visible   = true
   scr.ComboBox_005.Visible   = true
   scr.ComboBox_038.Visible   = false
   scr.ComboBox_039.Visible   = false

end
-------------------------------------------------------------------------------------------------------------------------------
-- SEGUNDA -  0 desabilitado/ 1 - Habilitado
-------------------------------------------------------------------------------------------------------------------------------
--Liga
if(tag_dia_semana.Value[3] == false)then 

   scr.ComboBox_007.Visible   = false
   scr.ComboBox_018.Visible   = false
   scr.ComboBox_002.Visible   = true
   scr.ComboBox_006.Visible   = true
   scr.ComboBox_002.Enabled    = false
   scr.ComboBox_006.Enabled    = false

elseif(tag_dia_semana.Value[3] == true)then 

   scr.ComboBox_007.Visible   = true
   scr.ComboBox_018.Visible   = true
   scr.ComboBox_002.Visible   = false
   scr.ComboBox_006.Visible   = false

end

--Desliga
if(tag_dia_semana.Value[4] == false)then 

   scr.ComboBox_009.Visible   = false
   scr.ComboBox_010.Visible   = false
   scr.ComboBox_011.Visible   = true
   scr.ComboBox_012.Visible   = true
   scr.ComboBox_011.Enabled    = false
   scr.ComboBox_012.Enabled    = false

elseif(tag_dia_semana.Value[4] == true)then 

   scr.ComboBox_009.Visible   = true
   scr.ComboBox_010.Visible   = true
   scr.ComboBox_011.Visible   = false
   scr.ComboBox_012.Visible   = false

end

-------------------------------------------------------------------------------------------------------------------------------
-- TERÇA -  0 desabilitado/ 1 - Habilitado
-------------------------------------------------------------------------------------------------------------------------------

--Liga
if(tag_dia_semana.Value[5] == false)then 

   scr.ComboBox_013.Visible   = false
   scr.ComboBox_014.Visible   = false
   scr.ComboBox_021.Visible   = true
   scr.ComboBox_022.Visible   = true
   scr.ComboBox_021.Enabled    = false
   scr.ComboBox_022.Enabled    = false

elseif(tag_dia_semana.Value[5] == true)then 

   scr.ComboBox_013.Visible   = true
   scr.ComboBox_014.Visible   = true
   scr.ComboBox_021.Visible   = false
   scr.ComboBox_022.Visible   = false

end

--Desliga
if(tag_dia_semana.Value[6] == false)then 

   scr.ComboBox_015.Visible   = false
   scr.ComboBox_016.Visible   = false
   scr.ComboBox_023.Visible   = true
   scr.ComboBox_040.Visible   = true
   scr.ComboBox_023.Enabled    = false
   scr.ComboBox_040.Enabled    = false

elseif(tag_dia_semana.Value[6] == true)then 

   scr.ComboBox_015.Visible   = true
   scr.ComboBox_016.Visible   = true
   scr.ComboBox_023.Visible   = false
   scr.ComboBox_040.Visible   = false

end



-------------------------------------------------------------------------------------------------------------------------------
-- QUARTA - 0 desabilitado/ 1 - Habilitado
-------------------------------------------------------------------------------------------------------------------------------
--Liga
if(tag_dia_semana.Value[7] == false)then 

   scr.ComboBox_017.Visible   = false
   scr.ComboBox_008.Visible   = false
   scr.ComboBox_041.Visible   = true
   scr.ComboBox_042.Visible   = true
   scr.ComboBox_041.Enabled    = false
   scr.ComboBox_042.Enabled    = false

elseif(tag_dia_semana.Value[7] == true)then 

   scr.ComboBox_017.Visible   = true
   scr.ComboBox_008.Visible   = true
   scr.ComboBox_041.Visible   = false
   scr.ComboBox_042.Visible   = false

end

--Desliga
if(tag_dia_semana.Value[8] == false)then 

   scr.ComboBox_019.Visible   = false
   scr.ComboBox_020.Visible   = false
   scr.ComboBox_043.Visible   = true
   scr.ComboBox_044.Visible   = true
   scr.ComboBox_043.Enabled    = false
   scr.ComboBox_044.Enabled    = false

elseif(tag_dia_semana.Value[8] == true)then 

   scr.ComboBox_019.Visible   = true
   scr.ComboBox_020.Visible   = true
   scr.ComboBox_043.Visible   = false
   scr.ComboBox_044.Visible   = false

end

-------------------------------------------------------------------------------------------------------------------------------
-- QUINTA -  0 desabilitado/ 1 - Habilitado
-------------------------------------------------------------------------------------------------------------------------------
--Liga
if(tag_dia_semana.Value[9] == false)then 

   scr.ComboBox_026.Visible   = false
   scr.ComboBox_027.Visible   = false
   scr.ComboBox_045.Visible   = true
   scr.ComboBox_046.Visible   = true
   scr.ComboBox_045.Enabled    = false
   scr.ComboBox_046.Enabled    = false

elseif(tag_dia_semana.Value[9] == true)then 

   scr.ComboBox_026.Visible   = true
   scr.ComboBox_027.Visible   = true
   scr.ComboBox_045.Visible   = false
   scr.ComboBox_046.Visible   = false

end

--Desliga
if(tag_dia_semana.Value[10] == false)then 

   scr.ComboBox_032.Visible   = false
   scr.ComboBox_033.Visible   = false
   scr.ComboBox_047.Visible   = true
   scr.ComboBox_048.Visible   = true
   scr.ComboBox_047.Enabled    = false
   scr.ComboBox_048.Enabled    = false

elseif(tag_dia_semana.Value[10] == true)then 

   scr.ComboBox_032.Visible   = true
   scr.ComboBox_033.Visible   = true
   scr.ComboBox_047.Visible   = false
   scr.ComboBox_048.Visible   = false

end


-------------------------------------------------------------------------------------------------------------------------------
-- SEXTA - 0 desabilitado/ 1 - Habilitado
-------------------------------------------------------------------------------------------------------------------------------
--Liga
if(tag_dia_semana.Value[11] == false)then 

   scr.ComboBox_025.Visible   = false
   scr.ComboBox_029.Visible   = false
   scr.ComboBox_049.Visible   = true
   scr.ComboBox_050.Visible   = true
   scr.ComboBox_049.Enabled    = false
   scr.ComboBox_050.Enabled    = false

elseif(tag_dia_semana.Value[11] == true)then 

   scr.ComboBox_025.Visible   = true
   scr.ComboBox_029.Visible   = true
   scr.ComboBox_049.Visible   = false
   scr.ComboBox_050.Visible   = false

end

--Desliga
if(tag_dia_semana.Value[12] == false)then 

   scr.ComboBox_031.Visible   = false
   scr.ComboBox_034.Visible   = false
   scr.ComboBox_051.Visible   = true
   scr.ComboBox_052.Visible   = true
   scr.ComboBox_051.Enabled    = false
   scr.ComboBox_052.Enabled    = false

elseif(tag_dia_semana.Value[12] == true)then 

   scr.ComboBox_031.Visible   = true
   scr.ComboBox_034.Visible   = true
   scr.ComboBox_051.Visible   = false
   scr.ComboBox_052.Visible   = false

end



-------------------------------------------------------------------------------------------------------------------------------
-- SABADO - 0 desabilitado/ 1 - liga / 2 - desliga / 3- liga e desliga
-------------------------------------------------------------------------------------------------------------------------------
--Liga
if(tag_dia_semana.Value[13] == false)then 

   scr.ComboBox_024.Visible   = false
   scr.ComboBox_028.Visible   = false
   scr.ComboBox_053.Visible   = true
   scr.ComboBox_054.Visible   = true
   scr.ComboBox_053.Enabled    = false
   scr.ComboBox_054.Enabled    = false

elseif(tag_dia_semana.Value[13] == true)then 

   scr.ComboBox_024.Visible   = true
   scr.ComboBox_028.Visible   = true
   scr.ComboBox_053.Visible   = false
   scr.ComboBox_054.Visible   = false

end

--Desliga
if(tag_dia_semana.Value[14] == false)then 

   scr.ComboBox_030.Visible   = false
   scr.ComboBox_035.Visible   = false
   scr.ComboBox_055.Visible   = true
   scr.ComboBox_056.Visible   = true
   scr.ComboBox_055.Enabled    = false
   scr.ComboBox_056.Enabled    = false

elseif(tag_dia_semana.Value[14] == true)then 

   scr.ComboBox_030.Visible   = true
   scr.ComboBox_035.Visible   = true
   scr.ComboBox_055.Visible   = false
   scr.ComboBox_056.Visible   = false

end


