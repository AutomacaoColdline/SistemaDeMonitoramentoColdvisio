--[[- - - - - - - - - - - - - - - - - - - - - - - - - - 

    Ambiente: HIscada_Pro
     Projeto: Projeto Sup Controle Refrigeração
     Empresa: HI Tecnologia
      Versão: 1.0.00
 Responsável: HI Tecnologia
        Data: 11/11/2022 

 \b Descrição:  \brief
   ... função do script

- - - - - - - - - - - - - - - - - - - - - - - - - - - -]] 

--Obtem a tela
local scr  = Sender.Screen

--------------------------------------------------------------------------------------------------------
-- Verifica Comando para habilitar as instancias.
--------------------------------------------------------------------------------------------------------
local tag_local_atualizaGrid = Tags.Get("Kernel.Tags.Local.TagLocalGroup_KN_Geral.TagLocal_AtualizaGrid")

if(tag_local_atualizaGrid.Value == false)then
    return
end

print("================== ATUALIZNDO O GRID ================")



local tg_clp_count = Tags.Get('Kernel.Tags.Local.TagLocalGroup_KN_Conexao.TagLocal_DevicesDetectados')

tg_clp_count.Value = 0 
tg_clp_count:WriteValue()



Sleep(500)

local ret, error = Scripts.Run("Viewers.Scripts.ScriptGroup_CONEXAO.Script_AtualizaTelaInicial")

