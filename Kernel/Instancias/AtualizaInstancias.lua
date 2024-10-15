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

Sleep(1000)
--------------------------------------------------------------------------------------------------------
-- verifica Comando para atualizar as instancias.
--------------------------------------------------------------------------------------------------------
local tag_local_atualiza = Tags.Get("Kernel.Tags.Local.TagLocalGroup_KN_Geral.TagLocal_AtualizaInstancias")
local qtd_instancias     = Tags.Get("Kernel.Tags.Local.TagLocalGroup_KN_Geral.Quantidade_Instancias")


if(tag_local_atualiza.Value == false)then
  return
end


local numero_controladores = qtd_instancias.Value

print("================== ATUALIZANDO AS INSTANCIAS ================")


-- ATUALIZA AS INSTANCIAS HABILITADAS 
for i = 1, numero_controladores do 
    Sleep(500)

   -- caminho das instancias
   caminho_tag_local = 'Kernel.Tags.Local.TagLocalGroup_KN_Instancias.Controlador_' .. i 
   caminho_tag_opc   = "Kernel.Tags.Opc.TagOpcGroup_Habilita_Controladores.Controlador_" .. i
 
   hab_controlador_local = Tags.Get(caminho_tag_local)
   hab_controlador_opc   = Tags.Get(caminho_tag_opc)



   -- atauliza o tag.
   hab_controlador_opc:ReadDevice()

   if(hab_controlador_opc.Value == 1)then
      
      tag_local_valor = true 
      hab_controlador_local.Value = tag_local_valor
      hab_controlador_local:WriteValue()

      hab_controlador_opc:ReadDevice()
   end

end


Sleep(2000)

-- Reinicia a flga de atualizacao de instancias
if(tag_local_atualiza.Value == true)then
  tag_local_atualiza.Value = false
  tag_local_atualiza:WriteValue()
end



--------------------------------------------------------------------------------------------------------
-- Envia Comando para habilitar as instancias.
--------------------------------------------------------------------------------------------------------
local tag_local_hb = Tags.Get("Kernel.Tags.Local.TagLocalGroup_KN_Geral.TagLocal_HAB_Conexoes")

if(tag_local_hb.Value == false)then
  tag_local_hb.Value = true
  tag_local_hb:WriteValue()
end
