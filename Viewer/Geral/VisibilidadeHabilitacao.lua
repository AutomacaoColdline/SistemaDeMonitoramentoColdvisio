--[[- - - - - - - - - - - - - - - - - - - - - - - - - - 

    Ambiente: HIscada_Pro
     Projeto: Projeto_Colegio
     Empresa: HI Tecnologia
      Versão: 1.1.0.0
 Responsável: Daniel kantor
        Data: 19/10/2022 

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
-- Obtém Tag local
-------------------------------------------------------------------------------------------------------------------------------
local qtd_instancias = Tags.Get("Kernel.Tags.Local.TagLocalGroup_KN_Geral.Quantidade_Instancias")

local numero_controladores = qtd_instancias.Value

-------------------------------------------------------------------------------------------------------------------------------
-- Obtém Tag opc
-------------------------------------------------------------------------------------------------------------------------------
local tag_opc_qtd_contoladores = ConsisteTagOpc("Kernel.Tags.Opc.TagOpcGroup_Habilita_Controladores.NumeroControladores")



if(tag_opc_qtd_contoladores == false)then

    for i = 1 , numero_controladores do 
  
    image             = "Image_Controlador_".. i   
    image_list        = "ImageList_Controlador_".. i
    display           = "Display_Nome_Controlador_"..i
    image_fundo_texto = "Image_fundo_texto_"..i
    img_config        = "Image_config_"..i
	
    scr[image].Visible              = false
    scr[image_list].Visible         = false
    scr[display].Visible            = false 
    scr[image_fundo_texto].Visible  = false 
    scr[img_config].Visible         = false 
	
  end

  return
end



local qts_local = tag_opc_qtd_contoladores.Value

if( tag_opc_qtd_contoladores.Value > 0)then 

  -- habilita instancia de acordo com o numero selecionado.
  for i = 1 , qts_local do 
  
    image      = "Image_Controlador_".. i   
    image_list = "ImageList_Controlador_".. i
    display    = "Display_Nome_Controlador_"..i
    image_fundo_texto = "Image_fundo_texto_"..i
    img_config        = "Image_config_"..i
	
    scr[image].Visible              = true
    scr[image_list].Visible         = true
    scr[display].Visible            = true 
    scr[image_fundo_texto].Visible  = true 
    scr[img_config].Visible         = true 
	
  end

  -- retira instancias que não vão usar.
  for j = qts_local + 1 , numero_controladores do 

     caminho_desabilita = "Kernel.Tags.Local.TagLocalGroup_KN_Instancias.Controlador_" .. j
     desabilita =  Tags.Get(caminho_desabilita)

      desabilita.Value = false
      desabilita:WriteValue()

    image      = "Image_Controlador_".. j   
    image_list = "ImageList_Controlador_".. j
    display    = "Display_Nome_Controlador_"..j
    image_fundo_texto = "Image_fundo_texto_"..j
    img_config        = "Image_config_"..j
	
    scr[image].Visible              = false
    scr[image_list].Visible         = false
    scr[display].Visible            = false 
    scr[image_fundo_texto].Visible  = false
    scr[img_config].Visible         = false

  end

else

  for i = 1 ,numero_controladores do 
 
    image             = "Image_Controlador_".. i   
    image_list        = "ImageList_Controlador_".. i
    display           = "Display_Nome_Controlador_"..i
    image_fundo_texto = "Image_fundo_texto_"..i
    img_config        = "Image_config_"..i

    scr[image].Visible              = false
    scr[image_list].Visible         = false
    scr[display].Visible            = false  
    scr[image_fundo_texto].Visible  = false 
    scr[img_config].Visible         = false 

  end


end




  
  
  
