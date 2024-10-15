--[[- - - - - - - - - - - - - - - - - - - - - - - - - - 

    Ambiente: HIscada_Pro
     Projeto: Projeto Sup Controle Refrigeração
     Empresa: HI Tecnologia
      Versão: 1.0.00
 Responsável: HI Tecnologia
        Data: 10/11/2022 

 \b Descrição:  \brief
   ... função do script

- - - - - - - - - - - - - - - - - - - - - - - - - - - -]] 

print("================== INICIANDO A NOVA CONEXAO ================")

-----------------------------------------------------------------------------------------------------------
-- Verifica a versão do programa clp
-----------------------------------------------------------------------------------------------------------
local result,err = Scripts.Run('Viewers.Scripts.ScriptGroup_Notificacoes.Script_VersaoIncompativel')

if(result == false)then 
 return
end 


--Obtem a tela
local scr  = Sender.Screen

-----------------------------------------------------------------------------------------
-- Obtem Tags
-----------------------------------------------------------------------------------------
local id_clp_conectado   = Tags.Get("Kernel.Tags.Local.TagLocalGroup_KN_Conexao.TagLocal_Id_Ultima_conexao")
local id_controlador      = Tags.Get("Kernel.Tags.Local.TagLocalGroup_CadastroControladores.ComboBox")

local tag_local = Tags.Get("Kernel.Tags.Local.TagLocalGroup_KN_Geral.TagLocal_DesabilitaInstancia")

local nome_controlador = Tags.Get("Kernel.Tags.Local.TagLocalGroup_KN_Geral.TagLocal_NOME_CONTROLADOR")


-----------------------------------------------------------------------------------------
-- Verifica se o clp ja esta conectado
-----------------------------------------------------------------------------------------
if(id_controlador.Value == 0)then 
   MessageBox("SELECIONE UM CLP!")
  -- Atualiza o Estado da máquina
    return
end

nome_controlador.Value = scr.ComboBox_CLPs.Text
nome_controlador:WriteValue()

Sleep(200)
-----------------------------------------------------------------------------------------
-- Verifica se o clp ja esta conectado
-----------------------------------------------------------------------------------------
if(id_controlador.Value == id_clp_conectado.Value)then 
  local ret = Screens.Open("Screen_Popup","Viewers.Screens.ScreenGroup_Inicial.Screen_Popup")
  --MessageBox("CLP NEON já Cadastrado")
  -- Atualiza o Estado da máquina
    return
end

-- Abre tela aguarde
local ret = Screens.Open("Screen_AGUARDE","Viewers.Screens.ScreenGroup_Inicial.Screen_AGUARDE")


Sleep(1000)
-----------------------------------------------------------------------------------------
-- Envia comando para desabilitar as instancias
-----------------------------------------------------------------------------------------
tag_local.Value = true
tag_local:WriteValue()

