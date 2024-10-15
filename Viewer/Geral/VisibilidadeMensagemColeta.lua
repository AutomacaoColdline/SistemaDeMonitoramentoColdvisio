--[[- - - - - - - - - - - - - - - - - - - - - - - - - - 

    Ambiente: HIscada_Pro
     Projeto: Projeto Sup Controle Refrigeração
     Empresa: HI Tecnologia
      Versão: 1.0.00
 Responsável: HI Tecnologia
        Data: 09/02/2024 

 \b Descrição:  \brief
   ... função do script

- - - - - - - - - - - - - - - - - - - - - - - - - - - -]] 

-------------------------------------------------------------------------------------------------------------------------------
-- Obtém Tela
-------------------------------------------------------------------------------------------------------------------------------
local scr = Sender.Screen

-------------------------------------------------------------------------------------------------------------------------------
-- Obtém o tag de flag coletando dados
-------------------------------------------------------------------------------------------------------------------------------
local tag_local_coletando_dados = Tags.Get("Kernel.Tags.Local.TagLocalGroup_Dados.TagLocal_FlagColetando")

-------------------------------------------------------------------------------------------------------------------------------
-- Verifica se o flga de coletando dados esta com o valor true 
-- TRUE: Aparece a mensagem de coletando dados
-- FLASE: Retira a mensagem de coletando dados 
-------------------------------------------------------------------------------------------------------------------------------
if(tag_local_coletando_dados.Value == true)then 

 scr.TextList_ColetandoDados.Visible = true

else
 
 scr.TextList_ColetandoDados.Visible = false

end 


