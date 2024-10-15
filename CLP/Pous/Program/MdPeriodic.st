(*==============================================================================

DESCRIÇÃO: Programa para realizar monitoração PERIODICA da aplicação.
           Detalhes e historico de liberações consulte a aba "Documentação"

================================================================================*)

(* - - - - -  - - Código executado em intervalos cíclicos - - - - - - *)

(*==============================================================================
           MONITORA ALTERAÇÃO na BASE de CONFIGURAÇÃO PUBLICA
================================================================================
  Monitora alteração de algum parametro de configuração na base PUBLICA
  que poe ter sido realizado via comunicação. Se existe parametro alterado:
   > Atualiza estes parâmetros de configuração na base PRIVADA do sistema
   > Salvar os parametros de configuração na flash rom
================================================================================*)

// Verifica se alterou o CRC da base de configuração PUBLICA visando
// verificar se houve alguma alteração de algum parâmetro de configuração
// via comunicação

// calcula o checksum da base de configuração publica
//
//  CRC := HILS.DATA_CRC16(PUB_XCFG) + HILS.DATA_CRC16(PUB_WCFG);
//

CRC_X := HILS.DATA_CRC16(PUB_XCFG);
CRC_W := HILS.DATA_CRC16(PUB_WCFG);

// verifica se CRC da base publica confere com o da lida da flash
IF (CRC_X <> PRI_CFG.FDB.CRC_X) OR (CRC_W <> PRI_CFG.FDB.CRC_W) THEN
// tags setadas para indicar alteração na base de configuração para esperar finalização
// de mudança de parâmetros para gravá-los na flash (Verificar Lógica abaixo)
  FLAG_ALT := true;
  RST_CONT := true;
  // Valida os novos parametros de configuração da base PUBLICA, que
  // eventualmente foram alterados pelo usuario via comunicação
  PUB_WAPP.CFG_FAIL_CODE := INT_TO_UINT(MD_CFG_CONSIST(PUB_XCFG, PUB_WCFG, PRI_CFG.FDB.DAT.X, PRI_CFG.FDB.DAT.W, IDX_ERR_CFG, CNT_ERR_CFG));

  // Transfere a base de configuração publica validada para a base privada
  PRI_CFG.FDB.DAT.X := PUB_XCFG;
  PRI_CFG.FDB.DAT.W := PUB_WCFG;

  CRC_X := HILS.DATA_CRC16(PRI_CFG.FDB.DAT.X);
  IF (CRC_X <> PRI_CFG.FDB.CRC_X)  THEN
//******************************************************************************
//           ATRIBUIÇÃO DE LIGAR E DESLIGAR NA BASE DE CONFIGURAÇÃO
//------------------------------------------------------------------------------
        FOR A := 0 TO (MAX_EQP-1) DO
            FOR B := 0 TO 6 DO
                 PROG := 0;
                 IF PRI_CFG.FDB.DAT.X.HAB_ONOFF[A].SEMANA[B].LIGA THEN
                      PROG := PROG + 1;
                 END_IF;
                 IF PRI_CFG.FDB.DAT.X.HAB_ONOFF[A].SEMANA[B].DESLIGA THEN
                      PROG := PROG + 2;
                 END_IF;
                 PUB_WCFG.CONF_CTRL[A].SEMANA[B] := PROG;
            END_FOR;
        END_FOR;
 //------------------------------------------------------------------------------
 //       FIM ATRIBUIÇÃO DE LIGAR E DESLIGAR NA BASE DE CONFIGURAÇÃO
 //*****************************************
  END_IF;

  // Escreve os novos parametros de configuração em BITS no banco em flash
  //
  //  CRC := HILS.DATA_CRC16(PRI_CFG.FDB.DAT.X) + HILS.DATA_CRC16(PRI_CFG.FDB.DAT.W);
  //

  CRC_X := HILS.DATA_CRC16(PRI_CFG.FDB.DAT.X);
  CRC_W := HILS.DATA_CRC16(PRI_CFG.FDB.DAT.W);



  IF (CRC_X <> PRI_CFG.FDB.CRC_X) or ((CRC_W <> PRI_CFG.FDB.CRC_W)) THEN
    // reatualiza CRC da base publica após atualização da mesma
    PRI_CFG.FDB.CRC_X := CRC_X;
    PRI_CFG.FDB.CRC_W := CRC_W;

   END_IF;

END_IF;
// Verifica se há tag indicando alteração na base de configuração
if FLAG_ALT then
// Inicializa Timeout para esperar 10s Sem alterações na base de configuração antes
// de salvar configuraçãoes na Flash.
         TIMEOUT_ALT(  // TON
          IN := not RST_CONT,  // [BOOL] Entrada de habilitação da temporização
          PT := T#10s   // [TIME] Tempo de atraso para ligar
          );
// Reseta flag de contagem para sinalizar que não houve mais alterações
          RST_CONT := false;
          if (not RST_CONT) then
             COUNT_GV := COUNT_GV + 1;
          else
             COUNT_GV := 0;
          end_if;


end_if;
// Caso estoure o tempo de aguardo sem alterações
//if TIMEOUT_ALT.Q then
if (COUNT_GV >= 10) then
     // salva base de configuração no banco de dados em flash rom
     ERR := HILS.FDB_WR(PRI_CFG.FDB_ID, 0, PRI_CFG.FDB);
     IF (ERR = HILS.SUCCESS) THEN
       // incrementa contador de alterações detectadas na base de configuração em BITS e WORDS
       PRI_CFG.CNT_ALTER := PRI_CFG.CNT_ALTER + 1;
     END_IF;
// Reseta flag indicando que houve alteração.
     FLAG_ALT := false;
     TIMEOUT_ALT(  // TON
      IN := false);  // [BOOL] Entrada de habilitação da temporização
      COUNT_GV := 0;
end_if;




(*==============================================================================
              Tratador da COMANDOS Individuais da Aplicação
================================================================================
  Trata solicitações de comandos individuais sem parametros no sistema.
================================================================================*)

// Teste se existe comando setado na base de comando
IF PUB_WCMD.CMD_LOCAL <> 0 THEN

  // Tratador de comandos
  CASE PUB_WCMD.CMD_LOCAL OF

  (*-----------------------------------------------------------------------------=
  | CMD: Habilita modo de teste
  *-------------------------------------------------------------------------------*)
  10:
    // Ativa modo de teste
    //PUB_XAPP.TEST_MODE := TRUE;
    // Finaliza tratamento do comando
    PUB_WCMD.CMD_LOCAL := 0; // reseta solicitação de comando

  (*-----------------------------------------------------------------------------=
  | CMD: Desabilita modo de teste
  *-------------------------------------------------------------------------------*)
  11:
    // Desativa modo de teste
    //PUB_XAPP.TEST_MODE := FALSE;
    // Finaliza tratamento do comando
    PUB_WCMD.CMD_LOCAL := 0; // reseta solicitação de comando

  (*-----------------------------------------------------------------------------=
  | CMD: Habilita modo de Simulação de valores de processo para debug
  *-------------------------------------------------------------------------------*)
  100:
    // Ativa modo de simulação
    SIMULA_MODE := TRUE;
    // Finaliza tratamento do comando
    PUB_WCMD.CMD_LOCAL := 0; // reseta solicitação de comando

  (*-----------------------------------------------------------------------------=
  | CMD: Desabilita modo de Simulação de valores de processo para debug
  *-------------------------------------------------------------------------------*)
  101:
    // Desativa modo de simulação
    SIMULA_MODE := FALSE;
    // Finaliza tratamento do comando
    PUB_WCMD.CMD_LOCAL := 0; // reseta solicitação de comando

  (*-----------------------------------------------------------------------------=
  |  CMD: INVALIDO. Código de comando não reconhecido pelo sistema.
  *-------------------------------------------------------------------------------*)
  ELSE
    // codigo de comando não reconhecido, retorna codigo de erro
    PUB_WCMD.CMD_LOCAL := 0; // reseta solicitação de comando
  END_CASE;
END_IF;


(*==============================================================================
               Tratador da Base de COMANDOS da Aplicação
================================================================================
  Trata solicitações de comandos na base de comandos da aplicação.
  Esta base de comando suporta diversos códigos de comaandos, entre comandos
  especificos de cada aplicação e comandos padrões do template de aplicação.
================================================================================
   Trata os comandos externos da BASE DE COMANDOS, por exemplo, setados
   via comunicação.

  . Faixa de comandos 1..10000 são reservados para comandos especificos de
    cada aplicação:

    1 - Comando ...
    2 - Comando ...

    ...


  . Faixa de comandos a partir de 30000 são reservados para comandos PADROES
    do sistema:

   30000 : Seleciona parametros de configuração DEFAULT da aplicação
   30001 : Le o RTC do controlador
   30002 : Programa o RTC do controlador
   30003 : Reconhecimento global de alarmes

  GL_ALM_ACK := FALSE;

================================================================================*)


// Teste se existe comando setado na base de comando
IF PUB_WCMD.CMD_GEN_CODE <> 0 THEN

  // Tratador de comandos
  CASE PUB_WCMD.CMD_GEN_CODE OF

  (*-----------------------------------------------------------------------------=
  | CMD: Inicializa base PRIVADA e PUBLICA de configuração da aplicação com
  |      valores DEFAULT.
  |
  | Parametros Entrada: Nenhum
  | Parametros Saida  : Nenhum
  |
  *-------------------------------------------------------------------------------*)
  30000:
    // inicializa a base de configuração PUBLICA com valores de fabrica
    MD_CFG_DEFAULT(PUB_XCFG, PUB_WCFG); // Inicializa base com valores default

    // Prepara parametros de retorno do comando
    PUB_WCMD.CMD_GEN_CODE := 0;  // reseta solicitação de comando
    PUB_WCMD.CMD_GEN_RET  := HILS.SUCCESS;  // retorna codigo de SUCESSO na execução do comando

    // Fim do tratamento do comando

  (*-----------------------------------------------------------------------------=
  | CMD: Le o RTC do controlador
  |
  | Parametros Entrada: Nenhum
  |
  | Parametros Saida  :
  |    CMD_GEN_PAR[0] = Dia
  |    CMD_GEN_PAR[1] = Mes
  |    CMD_GEN_PAR[2] = Ano
  |    CMD_GEN_PAR[3] = Hora
  |    CMD_GEN_PAR[4] = Minutos
  |    CMD_GEN_PAR[5] = Segundos
  |
  *-------------------------------------------------------------------------------*)
  30001:
    // Le o RTC do controlador
    HILS.READ_RTC(PUB_WCMD.CMD_GEN_PAR[5],
                  PUB_WCMD.CMD_GEN_PAR[4],
                  PUB_WCMD.CMD_GEN_PAR[3],
                  PUB_WCMD.CMD_GEN_PAR[0],
                  PUB_WCMD.CMD_GEN_PAR[1],
                  PUB_WCMD.CMD_GEN_PAR[2]);

    // Prepara parametros de retorno do comando
    PUB_WCMD.CMD_GEN_CODE := 0;  // reseta solicitação de comando
    PUB_WCMD.CMD_GEN_RET  := HILS.SUCCESS;  // retorna codigo de SUCESSO na execução do comando

    // Fim do tratamento do comando

  (*-----------------------------------------------------------------------------=
  | CMD: Escreve o RTC do controlador
  |
  | Parametros Entrada:
  |    CMD_GEN_PAR[0] = Dia
  |    CMD_GEN_PAR[1] = Mes
  |    CMD_GEN_PAR[2] = Ano
  |    CMD_GEN_PAR[3] = Hora
  |    CMD_GEN_PAR[4] = Minutos
  |    CMD_GEN_PAR[5] = Segundos
  |
  | Parametros Saida  : Nenhum
  |
  *-------------------------------------------------------------------------------*)
  30002:
    // F50 = Segundo corrente do equipamento (0..59)
    HILS.SET_SYSVAR(50, PUB_WCMD.CMD_GEN_PAR[5]);
    // F51 = Minuto corrente do equipamento (0..59)
    HILS.SET_SYSVAR(51, PUB_WCMD.CMD_GEN_PAR[4]);
    // F52 = Hora corrente do equipamento (0..23)
    HILS.SET_SYSVAR(52, PUB_WCMD.CMD_GEN_PAR[3]);
    // F53 = Dia corrente do equipamento (1..31)
    HILS.SET_SYSVAR(53, PUB_WCMD.CMD_GEN_PAR[0]);
    // F54 = Mês corrente do equipamento (1..12)
    HILS.SET_SYSVAR(54, PUB_WCMD.CMD_GEN_PAR[1]);
    // F55 = Ano corrente do equipamento (ex:2015)
    HILS.SET_SYSVAR(55, PUB_WCMD.CMD_GEN_PAR[2]);
    // F57 = Programa o relógio com os valores previamente escritos nas variaveis F50..F55.
    //       O valor a ser escrito nesta memória deve ser 12345. Qualquer valor diferente
    //       deste é ignorado e a escrita não é realizada.
    HILS.SET_SYSVAR(57, 12345);

    // Prepara parametros de retorno do comando
    PUB_WCMD.CMD_GEN_CODE := 0;         // reseta solicitação de comando
    PUB_WCMD.CMD_GEN_RET  := HILS.SUCCESS;   // retorna codigo de SUCESSO na execução do comando

    // Fim do tratamento do comando

  (*-----------------------------------------------------------------------------=
  | CMD: Reconhecimento global de alarmes
  |
  | Parametros Entrada: Nenhum
  | Parametros Saida  : Nenhum
  |
  *-------------------------------------------------------------------------------*)
  30003:

    // seta flag de reconhecimento global de alarmes
    GL_ALM_ACK := TRUE;

    // Prepara parametros de retorno do comando
    PUB_WCMD.CMD_GEN_CODE := 0;        // reseta solicitação de comando
    PUB_WCMD.CMD_GEN_RET  := HILS.SUCCESS;  // retorna codigo de SUCESSO na execução do comando

    // Fim do tratamento do comando

  (*-----------------------------------------------------------------------------=
  | CMD: Envia Setpoint de Temperatua Ambiente para o controlador
  |
  | Parametros Entrada: 0 - Index do Controlador de 1 a 20
  |                     1 - Valor do SP
  | Parametros Saida  : Nenhum
  | Obs.: Comando executado na PUO MDB_CTRL
  *-------------------------------------------------------------------------------*)
  31000:

    IDX_COM := PUB_WCMD.CMD_GEN_PAR[0] - 1;
    APP_COMANDO[0] := TRUE;

    // Prepara parametros de retorno do comando
    PUB_WCMD.CMD_GEN_CODE := 0;        // reseta solicitação de comando
    PUB_WCMD.CMD_GEN_RET  := HILS.SUCCESS;  // retorna codigo de SUCESSO na execução do comando
  // Fim do tratamento do comando de envio de setpoint da temperatura ambiente

  (*-----------------------------------------------------------------------------=
  | CMD: Envia Setpoint de Umidade para o controaldor Drixell ou
  |      Temperatua do evaporador para o controlador Fullgauge
  |
  | Parametros Entrada: 0 - Index do Controlador de 1 a 20
  |                     1 - Valor do SP
  | Parametros Saida  : Nenhum
  | Obs.: Comando executado na PUO MDB_CTRL
  *-------------------------------------------------------------------------------*)
  31001:

    IDX_COM := PUB_WCMD.CMD_GEN_PAR[0] - 1;
    APP_COMANDO[1] := TRUE;

    // Prepara parametros de retorno do comando
    PUB_WCMD.CMD_GEN_CODE := 0;        // reseta solicitação de comando
    PUB_WCMD.CMD_GEN_RET  := HILS.SUCCESS;  // retorna codigo de SUCESSO na execução do comando
  // Fim do tratamento do comando de envio de setpoint da temperatura do evaporador ou Umidade

  (*-----------------------------------------------------------------------------=
  | CMD: Envia comando para Forçar Degelo
  |
  | Parametros Entrada:  0 - Index do Controlador de 1 a 20
  |
  | Parametros Saida  : Nenhum
  | Obs.: Comando executado na PUO MDB_CTRL
  *-------------------------------------------------------------------------------*)
  31002:

    IDX_COM                 := PUB_WCMD.CMD_GEN_PAR[0] - 1;
    APP_COMANDO[2]              := TRUE;

    // Prepara parametros de retorno do comando
    PUB_WCMD.CMD_GEN_CODE := 0;        // reseta solicitação de comando
    PUB_WCMD.CMD_GEN_RET  := HILS.SUCCESS;  // retorna codigo de SUCESSO na execução do comando
  // Fim do tratamento do comando de forçar degelo

(*-----------------------------------------------------------------------------=
  | CMD: Envia comando para PARAR Forçar Degelo (SOMENTE PARA FULLGAUGE)
  |
  | Parametros Entrada:  0 - Index do Controlador de 1 a 20
  |
  | Parametros Saida  : Nenhum
  | Obs.: Comando executado na PUO MDB_CTRL
  *-------------------------------------------------------------------------------*)
  31003:

    IDX_COM                 := PUB_WCMD.CMD_GEN_PAR[0] - 1;
    APP_COMANDO[3]              := TRUE;

    // Prepara parametros de retorno do comando
    PUB_WCMD.CMD_GEN_CODE := 0;        // reseta solicitação de comando
    PUB_WCMD.CMD_GEN_RET  := HILS.SUCCESS;  // retorna codigo de SUCESSO na execução do comando
  // Fim do tratamento do comando de forçar degelo

  (*-----------------------------------------------------------------------------=
  | CMD: Envia comando para Ligar Controlador
  |
  | Parametros Entrada:  0 - Index do Controlador de 1 a 20
  |
  | Parametros Saida  : Nenhum
  | Obs.: Comando executado na PUO MDB_CTRL
  *-------------------------------------------------------------------------------*)
  31004:

    IDX_COM := PUB_WCMD.CMD_GEN_PAR[0] - 1;
    APP_COMANDO[4] := TRUE;

    // Prepara parametros de retorno do comando
    PUB_WCMD.CMD_GEN_CODE := 0;        // reseta solicitação de comando
    PUB_WCMD.CMD_GEN_RET  := HILS.SUCCESS;  // retorna codigo de SUCESSO na execução do comando
  // Fim do tratamento do comando ligar controlador

  (*-----------------------------------------------------------------------------=
  | CMD: Envia comando para Desligar Controlador
  |
  | Parametros Entrada:  0 - Index do Controlador de 1 a 20
  |
  | Parametros Saida  : Nenhum
  | Obs.: Comando executado na PUO MDB_CTRL
  *-------------------------------------------------------------------------------*)
  31005:

    IDX_COM := PUB_WCMD.CMD_GEN_PAR[0] - 1;
    APP_COMANDO[5] := TRUE;

    // Prepara parametros de retorno do comando
    PUB_WCMD.CMD_GEN_CODE := 0;        // reseta solicitação de comando
    PUB_WCMD.CMD_GEN_RET  := HILS.SUCCESS;  // retorna codigo de SUCESSO na execução do comando
  // Fim do tratamento do comando desligar controlador

  (*-----------------------------------------------------------------------------=
  | CMD: Envia tempo de intervalo para degelo
  |
  | Parametros Entrada: 0 - Index do Controlador de 1 a 20
  |                     1 - Valor do do intervalo em minutos
  | Parametros Saida  : Nenhum
  | Obs.: Comando executado na PUO MDB_CTRL
  *-------------------------------------------------------------------------------*)
  31006:

    IDX_COM := PUB_WCMD.CMD_GEN_PAR[0] - 1;
    APP_COMANDO[6] := TRUE;

    // Prepara parametros de retorno do comando
    PUB_WCMD.CMD_GEN_CODE := 0;        // reseta solicitação de comando
    PUB_WCMD.CMD_GEN_RET  := HILS.SUCCESS;  // retorna codigo de SUCESSO na execução do comando
  // Fim do tratamento do comando de envio de setpoint da temperatura do evaporador ou Umidade

(*-----------------------------------------------------------------------------=
  | CMD: Envia comando para Ligar Controlador por programação horária
  |
  | Parametros Entrada:  0 - Index do Controlador de 1 a 20
  |
  | Parametros Saida  : Nenhum
  | Obs.: Comando executado na PUO MDB_CTRL
  *-------------------------------------------------------------------------------*)
  31007:

    IDX_COM := PUB_WCMD.CMD_GEN_PAR[0];
    APP_COMANDO[7] := TRUE;

    // Prepara parametros de retorno do comando
    PUB_WCMD.CMD_GEN_CODE := 0;        // reseta solicitação de comando
    PUB_WCMD.CMD_GEN_RET  := HILS.SUCCESS;  // retorna codigo de SUCESSO na execução do comando
  // Fim do tratamento do comando ligar controlador

  (*-----------------------------------------------------------------------------=
  | CMD: Envia comando para Desligar Controlador por programação horária
  |
  | Parametros Entrada:  0 - Index do Controlador de 1 a 20
  |
  | Parametros Saida  : Nenhum
  | Obs.: Comando executado na PUO MDB_CTRL
  *-------------------------------------------------------------------------------*)
  31008:

    IDX_COM := PUB_WCMD.CMD_GEN_PAR[0];
    APP_COMANDO[8] := TRUE;

    // Prepara parametros de retorno do comando
    PUB_WCMD.CMD_GEN_CODE := 0;        // reseta solicitação de comando
    PUB_WCMD.CMD_GEN_RET  := HILS.SUCCESS;  // retorna codigo de SUCESSO na execução do comando
  // Fim do tratamento do comando desligar controlador


  (*-----------------------------------------------------------------------------=
  | CMD: Limpa valores de temperatura MINIMA e MAXIMA diária de todos os
  |      controladores
  |
  | Parametros Entrada:  Nenhum
  |
  | Parametros Saida  : Nenhum
  |
  *-------------------------------------------------------------------------------*)
  31100:

    // Seta comando para reinicializar a temperatura min./max. diaria de todos os controladores
    LOC_XAPP.CMD_CLEAR_MIN_MAX := true;

    // Prepara parametros de retorno do comando
    PUB_WCMD.CMD_GEN_CODE := 0;        // reseta solicitação de comando
    PUB_WCMD.CMD_GEN_RET  := HILS.SUCCESS;  // retorna codigo de SUCESSO na execução do comando
  // Fim do tratamento do comando desligar controlador


  (*-----------------------------------------------------------------------------=
  |  CMD: INVALIDO. Código de comando não reconhecido pelo sistema.
  *-------------------------------------------------------------------------------*)
 ELSE
    // codigo de comando não reconhecido, retorna codigo de erro
    PUB_WCMD.CMD_GEN_CODE := 0; // reseta solicitação de comando
    PUB_WCMD.CMD_GEN_RET  := AEC_CMD_INVALIDO; // retorna codigo de erro da execução do comando
  END_CASE;
END_IF;
