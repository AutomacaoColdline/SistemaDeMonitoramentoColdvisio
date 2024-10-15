(*==============================================================================

DESCRIÇÃO: Power-up do sistema. Ciclo unico de execução.
           Detalhes e historico de liberações consulte a aba "Documentação"

================================================================================*)

(* - - - - - - - - - - Início da sessão de inicialização - - - - - - - - - - - -*)

(*==============================================================================
   INICIALIZAÇÕES ESPECÍFICAS DA APLICAÇÃO
 *==============================================================================*)

// Atualiza o valor da versão da aplicação
PUB_WAPP.APP_VERSION := INT_TO_UINT(HILS.GET_SYSVAR(ADDR := 14));

// Atualiza o valor da versão do firmware
PUB_WAPP.FWR_VERSION := INT_TO_UINT(HILS.GET_SYSVAR(ADDR := 11));


(* =============================================================================
   Cria no banco de dados em flash um registro para salvar todos
   os parametros e bases de dados de configuração da aplicação
   =============================================================================*)

// Aloca bases de banco em flash para as seguintes informações:
//    .. 1 - base de configuração em BITS e WORDS da aplicação + CRC
//    .. 2 - reserva
//    .. 3 - reserva
//    .. 4 - reserva
//    .. 5 - reserva
//
// A quantidade de bases de dados alocadas na flash rom possui um
// Limite inicial no firmware G5 de 5 bases em flash rom

PRI_CFG.FDB_ID := HILS.FDB_INIT(MAX_RECS := 1, DATA := PRI_CFG.FDB);

ERR := HILS.SUCCESS;    // por default, assume sem erro no acesso a base de configuraçao na flash

(*==============================================================================
 Leitura da base de configuração em BITS e WORDS + CRC da aplicação em flash rom
 *==============================================================================*)

//__ testa se alocou as bases de dados em flash rom mapeada em BITS e WORDS
IF (ERR = HILS.SUCCESS) THEN
  IF (PRI_CFG.FDB_ID <> -1) THEN

    // Le no banco em flash a base de configuraçao salva
    // Aloca base no banco em flash para as seguintes informações:
    //    .. CRC das Bases BITS e WORDS
    //    .. Bases de dados em BITS e WORDS
    //
    ERR := HILS.FDB_RD(PRI_CFG.FDB_ID, 0, PRI_CFG.FDB);
    IF (ERR = HILS.SUCCESS) THEN
      // calcula o checksum da base de configuração lida da flash rom
      // CRC := HILS.DATA_CRC16(PRI_CFG.FDB.DAT.X) + HILS.DATA_CRC16(PRI_CFG.FDB.DAT.W);
      CRC_X := HILS.DATA_CRC16(PRI_CFG.FDB.DAT.X);
      CRC_W := HILS.DATA_CRC16(PRI_CFG.FDB.DAT.W);
      // verifica se CRC da base lida da flash confere
      IF (CRC_X <> PRI_CFG.FDB.CRC_X) OR (CRC_W <> PRI_CFG.FDB.CRC_W) THEN
        ERR := AEC_INV_CFG_BASE;  // base de configuraçao lida com checksum invalido
      END_IF;
    END_IF;
  ELSE
    // Erro no acesso ao banco de dados em flash rom
    ERR := AEC_INV_CFG_BASE;
  END_IF;
END_IF;

(*==============================================================================
   Valida base PRIVADA de configuração lida da flash rom
 *==============================================================================*)

//__ testa se erro no acesso a configuração na flash ou checksum da base invalida
IF (ERR <> HILS.SUCCESS) THEN
  // inicializa a base de configuração privada com valores de fabrica
  MD_CFG_DEFAULT(PRI_CFG.FDB.DAT.X, PRI_CFG.FDB.DAT.W); // Inicializa base com valores default
  // seta codigo de erro indicando base de configuração default
  PUB_WAPP.CFG_FAIL_CODE := INT_TO_UINT(AEC_CFG_BASE_DEFAULT);
END_IF;

// Neste ponto temos a base de configuração PRIVADA:
//   . ou com os valores lidos da flash rom, se leitura e checksum são validos
//   . ou inicializada com valores default, se erro na leitura e/ou checksum invalidos

(*==============================================================================
   Consiste a base PRIVADA lida da flash rom, e caso algum parametro esteja
   invalido, considera o valor DEFAULT definido na base de configuração
 *==============================================================================*)

// inicializa a base de configuração PUBLICA com valores de fabrica
// para que os valores invalidos desta base PRIVADA, sejam restaurados
// com valor DEFAULT desta base de configuração
MD_CFG_DEFAULT(PUB_XCFG, PUB_WCFG); // Inicializa base com valores default

// Consiste a base PRIVADA lida da flash, onde utilizamos uma base de
// configuração PUBLICA com valores DEFAULT para restaurar
// todos os valores invalidos desta base PRIVADA
ERR := MD_CFG_CONSIST(PRI_CFG.FDB.DAT.X, PRI_CFG.FDB.DAT.W, PUB_XCFG, PUB_WCFG, IDX_ERR_CFG, CNT_ERR_CFG);

// copia a base PRIVADA consistida acimaa para base PUBLICA, equalizando as bases
PUB_XCFG := PRI_CFG.FDB.DAT.X; // inicializa base BITS publica
PUB_WCFG := PRI_CFG.FDB.DAT.W; // inicializa base WORDS publica

// Se nro de parametros inconsistente é muito grande força incializar
// base de parametros de configuração com valores default
if (CNT_ERR_CFG > 10) then
  // inicializa a base de configuração PUBLICA com valores de fabrica
  MD_CFG_DEFAULT(PUB_XCFG, PUB_WCFG); // Inicializa base com valores default
  // seta codigo de erro indicando base de configuração default
  PUB_WAPP.CFG_FAIL_CODE := INT_TO_UINT(AEC_CFG_BASE_DEFAULT);
end_if;

// se já não está com a configuração default
IF (PUB_WAPP.CFG_FAIL_CODE <> AEC_CFG_BASE_DEFAULT) THEN
  // seta codigo de retorno associado a consistencia da base de configuração
  PUB_WAPP.CFG_FAIL_CODE := INT_TO_UINT(ERR);
END_IF;

// Neste ponto temos a base de configuração PUBLICA:
//   . ou com os valores lidos da flash rom, se base privada lida da falhas é valida
//   . ou inicializada com valores default, se base privada inválido

(*==============================================================================
   Equaliza bases PUBLICA e PRIVADA de configuração da aplicação
 *==============================================================================*)

// Transfere a base de configuração PUBLICA para a base de configuração PRIVADA,
// pois a base PUBLICA pode ter sido alterada em função da consistencia realizada
// acima. Assim equaliza ambas as bases PUBLICA e PRIVADA
//
PRI_CFG.FDB.DAT.X := PUB_XCFG; // atribui base PUBLICA em BITS  para base PRIVADA
PRI_CFG.FDB.DAT.W := PUB_WCFG; // atribui base PUBLICA em WORDS para base PRIVADA

// reatualiza o CRC da base de configuração após a consistencia dos parâmetros
// CRC := HILS.DATA_CRC16(PRI_CFG.FDB.DAT.X) + HILS.DATA_CRC16(PRI_CFG.FDB.DAT.W);
CRC_X := HILS.DATA_CRC16(PRI_CFG.FDB.DAT.X);
CRC_W := HILS.DATA_CRC16(PRI_CFG.FDB.DAT.W);

// reatuliza CRC da base privada após atualização da mesma
PRI_CFG.FDB.CRC_X := CRC_X;
PRI_CFG.FDB.CRC_W := CRC_W;

(*==============================================================================
   INICIALIZAÇÕES ESPECÍFICAS DA APLICAÇÃO
 *==============================================================================*)

// INICIALIZA DIA DA SEMANA
LOC_WAPP.RTC_WEEK     := HILS.GET_SYSVAR(56);
LOC_WAPP.OLD_CUR_WEEK := LOC_WAPP.RTC_WEEK;


(* - - - - - - - - - - Fim da sessão de inicialização - - - - - - - - - - - - - *)

