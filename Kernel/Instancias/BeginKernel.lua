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

Sleep(3000)

--Obtem o timer 
local timer = Timers.Get("Kernel.Timers.Timer_InsertBanco")
-- Habilita timer
ret = timer:Enable(2000)
print("INICIALIZOU O TIMER DE COLETA DE DADOS")


--Obtem quantidade de instancia.
local qtd_instancias = Tags.Get("Kernel.Tags.Local.TagLocalGroup_KN_Geral.Quantidade_Instancias")

--Habilita as instancias.
for i = 1, qtd_instancias.Value do 
  caminho = 'Kernel.Tags.Local.TagLocalGroup_KN_Instancias.Controlador_' .. i 
  hab_controlado = Tags.Get(caminho)

   -- Monta path da instancia
    local PathInst = "InstanceGroup_Controladores.Controlador_" .. i
    -- Obtém a instancia 
    local Inst = Instances.Get(PathInst)

  if(hab_controlado.Value == true)then
     ret = Inst:Enable()
  else
     ret = Inst:Disable()
  end

end

Sleep(300)

-- Escreve o nome das instancias habilitada.
for j = 1, qtd_instancias.Value do 

     local caminho = 'Kernel.Tags.Local.TagLocalGroup_KN_Instancias.Controlador_' .. j 
     local hab_controlado_ok = Tags.Get(caminho)
 

    if(hab_controlado_ok.Value == true)then 

      
        print(j)

       -- pega caminho do tag.
       local caminho_nome_tag_local = "Kernel.Tags.Local.TagLocalGroup_KN_Instancias.Nome_controlador_" .. j
       local caminho_nome_tag_opc   = "Instances.InstanceGroup_Controladores.Controlador_" .. j .. ".Tags.Opc.Nome_Controlador.Nome_Controlador"
 
 
       local nome_controlador_local = Tags.Get(caminho_nome_tag_local)
       local nome_controlador_opc = Tags.Get(caminho_nome_tag_opc)

        -- escreve no tag.
        nome_controlador_local.Value = nome_controlador_opc.Value
        nome_controlador_local:WriteValue()

   end 

end



local tag_opc_comunicacao = Tags.Get("Kernel.Tags.Opc.TagOpcGroup_Geral.Status_Supervisorio")

tag_opc_comunicacao.Value = true
tag_opc_comunicacao:WriteValue()


