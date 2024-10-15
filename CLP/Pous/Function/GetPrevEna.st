(* ============================================================================
 *                          FUNÇÃO GET_PREV_ENA
 *
 *      FUNÇÃO: GET_PREV_ENA
 *     REVISÃO: 1.0.00
 *        DATA: 30/07/2024
 * RESPONSAVEL: Eng. de Aplicação da HI TECNOLOGIA
 *
 *   DESCRIÇÃO: Esta função verifica a partir do ID do controlador de temperatura atual
 *   Qual controlador de temperatura anterior que está habilitado.
 * ============================================================================*)
// Consiste o valor dentro dos IDs possíveis de 0 a 19
ID := IDX_ATUAL;
if (ID <0) or (ID>(MAX_EQP-1)) then
    ID := 0;
end_if;
// Reseta a flag que indica que encontrou ID Habilitado e com modelo configurado
ACHOU := false;
// Se o Id do controlador for maior que zero inicia a verificação DECRESCENTE
// para verificar qual é o controlador de temperatura anterior que está habilitado
// e com modelo, partindo do valor anterior até 0.
IF (ID > 0) THEN
for I := (ID - 1) to 0 by -1 do
      if (PRI_CFG.FDB.DAT.W.CONF_CTRL[I].HAB_CTRL = 1) AND
         (PRI_CFG.FDB.DAT.W.CONF_CTRL[I].MODELO <> 0)  THEN
          ACHOU := true;
          exit;
      end_if;
end_for;
END_IF;
// Caso não encontre nenhum controlador de temperatura habilitado e com modelo anterior ao
// ID do controlador atual, procura agora do último 19 até o ID atual
if ACHOU = false then
   for I := (MAX_EQP-1) to ID by -1  do
      if (PRI_CFG.FDB.DAT.W.CONF_CTRL[I].HAB_CTRL = 1) AND
         (PRI_CFG.FDB.DAT.W.CONF_CTRL[I].MODELO <> 0)  THEN
          ACHOU := true;
          exit;
      end_if;
   end_for;
end_if;
// Se após a varredura completa não encontrar nenhum controlador de temperatura
// habilitado envia valor 255 para ID do controlador de temperatura
if ACHOU = false then
      I := 255;
end_if;
// Atribui o valor do ID como retorno da função.
GET_PREV_ENA := I;