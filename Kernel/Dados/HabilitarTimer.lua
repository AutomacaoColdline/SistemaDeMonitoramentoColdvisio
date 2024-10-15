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

--Obtem o Tag
local tag_local_erro = Tags.Get("Kernel.Tags.Local.TagLocalGroup_Dados.TagLocal_Erro_Script_Coleta")

-- Verifica se o tag esta desligado para sair do script
if(tag_local_erro.Value ==  false)then 
  return 
end 


--Obtem o timer 
local timer = Timers.Get("Kernel.Timers.Timer_InsertBanco")
-- Habilita timer
ret = timer:Enable(2000)


-- Desliga flag de erro do script de coleta 
tag_local_erro.Value = false 
tag_local_erro:WriteValue()
