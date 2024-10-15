--[[- - - - - - - - - - - - - - - - - - - - - - - - - - 

    Ambiente: HIscada_Pro
     Projeto: Projeto_Colegio
     Empresa: HI Tecnologia
      Versão: 1.1.0.0
 Responsável: Daniel kantor
        Data: 30/09/2022 

 \b Descrição:  \brief
   ... função do script

- - - - - - - - - - - - - - - - - - - - - - - - - - - -]] 
--Verifica total de instrancias 
local qtd_instancias = Tags.Get("Kernel.Tags.Local.TagLocalGroup_KN_Geral.Quantidade_Instancias")

-----------------------------------------------------------------------------------------------------------------------------
-- Atualiza o nome do controlador  
-----------------------------------------------------------------------------------------------------------------------------
for j = 1, qtd_instancias.Value do 

       caminho_habilita_controlador = "Kernel.Tags.Local.TagLocalGroup_KN_Instancias.Controlador_" .. j
       controlador_local = Tags.Get(caminho_habilita_controlador)

  if(controlador_local.Value == true)then 

     -- escreve o nome da Instancia na tela de habilta instancia
     caminho_nome_tag_local = "Kernel.Tags.Local.TagLocalGroup_KN_Instancias.Nome_controlador_" .. j
     caminho_nome_tag_opc   = "Instances.InstanceGroup_Controladores.Controlador_" .. j .. ".Tags.Opc.Nome_Controlador.Nome_Controlador" 

      nome_controlador_local = Tags.Get(caminho_nome_tag_local)
      nome_controlador_opc = Tags.Get(caminho_nome_tag_opc)
     
     nome_controlador_local.Value =  nome_controlador_opc.Value
     nome_controlador_local:WriteValue()

 end 
  
end







