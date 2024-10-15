--[[- - - - - - - - - - - - - - - - - - - - - - - - - - 

    Ambiente: HIscada_Pro
     Projeto: Projeto_Colegio
     Empresa: HI Tecnologia
      Versão: 1.1.0.0
 Responsável: Daniel kantor
        Data: 28/09/2022 

 \b Descrição:  \brief
   ... função do script

- - - - - - - - - - - - - - - - - - - - - - - - - - - -]] 


--------------------------------------------------------------------------------------------------------
-- Verifica Comando para habilitar as instancias.
--------------------------------------------------------------------------------------------------------
local tag_local_hb   = Tags.Get("Kernel.Tags.Local.TagLocalGroup_KN_Geral.TagLocal_HAB_Conexoes")
local qtd_instancias = Tags.Get("Kernel.Tags.Local.TagLocalGroup_KN_Geral.Quantidade_Instancias")

if(tag_local_hb.Value == false)then
  return
end

local numero_controladores = qtd_instancias.Value

print("================== HABILITANDO  AS INSTANCIAS ================")


-- Escreve o nome das instancias habilitada.
for j = 1, numero_controladores do 

     caminho = 'Kernel.Tags.Local.TagLocalGroup_KN_Instancias.Controlador_' .. j 
     hab_controlado = Tags.Get(caminho)

    if(hab_controlado.Value == true)then

      -- pega caminho do tag.
      caminho_nome_tag_local = "Kernel.Tags.Local.TagLocalGroup_KN_Instancias.Nome_controlador_" .. j
      caminho_nome_tag_opc   = "Instances.InstanceGroup_Controladores.Controlador_" .. j .. ".Tags.Opc.Nome_Controlador.Nome_Controlador"
 
      nome_controlador_local = Tags.Get(caminho_nome_tag_local)
      nome_controlador_opc = Tags.Get(caminho_nome_tag_opc)

        nome_controlador_opc:ReadDevice()

      -- escreve no tag.
      nome_controlador_local.Value = nome_controlador_opc.Value
      nome_controlador_local:WriteValue()
   end

end


-- reseta comando
if(tag_local_hb.Value == true)then
  tag_local_hb.Value = false
  tag_local_hb:WriteValue()
end


Sleep(1000)
--Atualiza grid
local tag_local_atualizaGrid = Tags.Get("Kernel.Tags.Local.TagLocalGroup_KN_Geral.TagLocal_AtualizaGrid")

if(tag_local_atualizaGrid.Value == false)then
   tag_local_atualizaGrid.Value = true
   tag_local_atualizaGrid:WriteValue()
end

