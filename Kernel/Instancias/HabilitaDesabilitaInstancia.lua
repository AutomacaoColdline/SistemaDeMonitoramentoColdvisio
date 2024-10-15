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

-- Monta path da instancia
local PathInst = "InstanceGroup_Controladores." .. Tag.Name

-- Obtém a instancia 
local Inst = Instances.Get(PathInst)

NomeInst = Inst.Name
--print(Inst.Name)


local tipo, modo = string.match(Tag.Name,'(.*)_(.*)')
--print(modo)


local caminho_nome_tag_local = "Kernel.Tags.Local.TagLocalGroup_KN_Instancias.Nome_controlador_" .. modo
local nome_controlador = Tags.Get(caminho_nome_tag_local) 


--habilita instancia.
if (Tag.Value == true)then
  ret = Inst:Enable()

elseif(Tag.Value == false)then
   nome_controlador.Value = "Controlador Desabilitado"
   nome_controlador:WriteValue()
  ret = Inst:Disable()
end

--print(ret)







