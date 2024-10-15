--[[- - - - - - - - - - - - - - - - - - - - - - - - - - -

    Ambiente: HIscada_Pro
     Projeto: SistemaSupervisaoCombateIncedio
     Empresa: 
      Versão: 
 Responsável: 
        Data: 26/06/2018 

 \b Descrição:  \brief
   ... função do script

Indice dos Vetores

1 - Segundos
2 - Minutos
3 - Horas
4 - Dia
5 - Mês
6 - Ano
7 - Dia da semana ( 0 = Domingo / 1 = Segunda-Feira / 2 = Terça-Feira / 3 = Quarta-Feira / 4 = Quinta-Feira / 5 = Sexta-Feira / 6 = Sábado )
- - - - - - - - - - - - - - - - - - - - - - - - - - - -]]

-------------------------------------------------------------------------------------------------------------------------------
-- Função para verificar o status de comunicação com o CLP antes de continuar o script
-------------------------------------------------------------------------------------------------------------------------------
local function ConsisteComunicaoCLP(CaminhoTagOpc)
  
  -- Obtém o Tag no caminho recebido como parâmetro
  local TagOpc = Tags.Get(CaminhoTagOpc)
  
  -- Verifica se houve alguma falha na obtenção do objeto Tag
  if(TagOpc == nil)then
    return false
  end
  
  -- Verifica a Qualidade do Tag
  if(TagOpc.Quality ~= 192)then
    return false
  end
  
  -- Verifica se o valor do Tag é Nulo
  if(TagOpc.Value == nil)then
    return false
  end
  

  -- Verifica se a conexão com o Device é diferente de Connection Active(3)
  if(TagOpc.Value ~=3)then
    return false
  end
  
  -- Caso o Tag tenha passo por todos os testes, retorna true
  return true
  
end

-------------------------------------------------------------------------------------------------------------------------------
-- Função para consistir um Tag OPC 
-------------------------------------------------------------------------------------------------------------------------------
local function ConsisteTagOpc(CaminhoTagOpc)

  -- Obtém o Tag no caminho recebido como parâmetro
  local TagOpc = Tags.Get(CaminhoTagOpc)
  
  -- Verifica se houve alguma falha na obtenção do objeto Tag
  if(TagOpc == nil)then
    print("Falha ao obter o Tag OPC: " .. CaminhoTagOpc)
    return false
  end

  -- local ret = ConsisteComunicaoCLP("Kernel.Tags.Opc.TagOpcGroup_KN_Comunicacao.TagOpc_StatusDevice")
  -- if ret == false then
  --   print("Falha na Conexão com o Controlador" .. CaminhoTagOpc) 
   --  return false
   --end

  -- Força a leitura do Tag no Device
  local retRD = TagOpc:ReadDevice()
  if(retRD ~= 0)then
    print("Falha na leitura do Tag OPC: " .. CaminhoTagOpc)
    return false
  end

  -- Verifica a Qualidade do Tag
  if(TagOpc.Quality ~= 192)then
    print("Qualidade do Tag OPC não é GOOD: " .. CaminhoTagOpc)
    return false
  end

  -- Verifica se o valor do Tag é Nulo
  if(TagOpc.Value == nil)then
    print("Valor do Tag OPC é nulo: " .. CaminhoTagOpc)
    return false
  end
  
  -- Caso o Tag tenha passo por todos os testes, retorna o objeto Tag
  return TagOpc
  
end 

-- Fim de Tartamento de Tags.
-------------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------

------------------------------------------------------------------------------------------
--Verifica a consistência dos Tags OPC.
--Se caso uma das consistências retornar FALSE, encerra a execução do script.
------------------------------------------------------------------------------------------
local RTC_controlador = ConsisteTagOpc("Kernel.Tags.Opc.TagOpcGroup_InfosControlador.TagOpc_DataHoraClp")
local ProgramaRTC     = ConsisteTagOpc("Kernel.Tags.Opc.TagOpcGroup_InfosControlador.TagOpc_ProgramaRTC")

if (RTC_controlado == false or 
    ProgramaRTC    == false) then

   print("Falha na consistência dos Tags!")
   return

end

------------------------------------------------------------------------------------------
--Realiza Leitura dos Tags e da Data/Hora atual do Computador.
------------------------------------------------------------------------------------------
RTC_controlador:ReadDevice()
ProgramaRTC:ReadDevice()

local datahora = DateTime()

------------------------------------------------------------------------------------------
--Realiza a separação dos valores, e faz comparações entre eles
------------------------------------------------------------------------------------------
dia_pc     = tonumber(datahora:GetFormatString('dd'))
mes_pc     = tonumber(datahora:GetFormatString('mm'))
ano_pc     = tonumber(datahora:GetFormatString('yyyy'))
hora_pc    = tonumber(datahora:GetFormatString('hh'))
minuto_pc  = tonumber(datahora:GetFormatString('nn'))
segundo_pc = tonumber(datahora:GetFormatString('ss'))

dia_clp     = RTC_controlador.Value[4]
mes_clp     = RTC_controlador.Value[5]
ano_clp     = RTC_controlador.Value[6]
hora_clp    = RTC_controlador.Value[3]
minuto_clp  = RTC_controlador.Value[2]
segundo_clp = RTC_controlador.Value[1]


local CLP = false


------------------------------------------------------------------------------------------
--Verifica se a dataha hora do controlado é igual a data hora Atual.
------------------------------------------------------------------------------------------


local minuto_comp

if minuto_pc < minuto_clp then
       minuto_comp = minuto_clp - minuto_pc  
else
       minuto_comp = minuto_pc - minuto_clp  
end

if (dia_pc == dia_clp and mes_pc == mes_clp and ano_pc == ano_clp and hora_pc == hora_clp and minuto_comp <= 5) then

   CLP = true

end


------------------------------------------------------------------------------------------
--Caso os valores das datas e horas sejam iguais, interrompe execução do script
------------------------------------------------------------------------------------------
if (CLP == true) then

  --print("Data e Hora dos Equipamentos ok!")
   return

end

-----------------------------------------------------------------------------------------------------------
--Caso os valores de Data e Hora do controlador 1 estejam diferentes, atualiza Data/Hora do clp 1
-----------------------------------------------------------------------------------------------------------
if (CLP == false) then

  RTC_controlador.Value[4] = dia_pc
  RTC_controlador.Value[5] = mes_pc 
  RTC_controlador.Value[6] = ano_pc
  RTC_controlador.Value[3] = hora_pc 
  RTC_controlador.Value[2] = minuto_pc
  RTC_controlador.Value[1] = segundo_pc

  ProgramaRTC.Value = 12345

  local retWR  = RTC_controlador:WriteValue()
  local retWRp = ProgramaRTC:WriteValue()
 
   if (retWR ~= 0 or retWRp ~= 0) then

      --print("Falha na atualização da Data/Hora do controlador!")

   end

   --print("Atualização da Data/Hora controlador  realizada com sucesso!")

end
