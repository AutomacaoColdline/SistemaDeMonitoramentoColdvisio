------------------------------------------------------------------------------------------------------------------------------- 
--    Projeto: Demo HIscada Pro
--    Cliente: 
--       Data: 01/ago/2013  
--      Resp.: Eng. de Produto da HI Tecnologia
--   Ambiente: HIscada Pro, versão 1.3.03 ou superior
------------------------------------------------------------------------------------------------------------------------------- 




local Argumento = Sender.Argument

------------------------------------------------------------------------------------------------------------------------------- 
-- Obtém tela atual
------------------------------------------------------------------------------------------------------------------------------- 
scr = Sender.Screen


------------------------------------------------------------------------------------------------------------------------------- 
-- Verifica qual o ação esta selecionada para o alarme
-------------------------------------------------------------------------------------------------------------------------------
if(Argumento == "Ack")then
  ret = scr.Alarms_Geral:Ack()        -- Reconhece o alarme selecionado

elseif(Argumento == "AckAll")then
  ret = scr.Alarms_Geral:AckAll()     -- Reconhece todos os alarmes

elseif(Argumento == "Silence")then
  ret = scr.Alarms_Geral:Silence()    --Silencia o som do alarme selecionado

elseif(Argumento == "Reset")then
  ret = scr.Alarms_Geral:Reset()     -- Reseta o alarme selecionado

elseif(Argumento == "Suppress")then
  ret = scr.Alarms_Geral:Suppress()    --Suprime o alarme selecionado

elseif(Argumento == "UnSuppress")then
  ret = scr.Alarms_Geral:UnSuppress()   --Remove a supressão de todos os alarmes

end

