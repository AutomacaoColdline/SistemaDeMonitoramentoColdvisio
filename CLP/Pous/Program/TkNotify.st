(* ============================================================================
 *                    PROJETO COLDLINE
 *
 *   DESCRIÇÃO: SISTEMA DE RESFRIAMENTO - CONTROLE E MONITORAMENTO
 *     CLIENTE: COLDLINE
 * RESPONSAVEL: Eng. de Aplicação da HI TECNOLOGIA
 *
 * ============================================================================

      Bloco responsavel por identificar alteracões de status e alarmes e
     notifica-las para o portal de telemetria da HI Tecnologia.
*)

// Ticks para controle do programa
TICK_CYEV(RUN := LOC_XAPP.WARMUP_OK, TM := T#5M);


(* = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =
 *   Interface com o portal de telemetria
 * = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =
 *)

(* --- Trata remoção de eventos pelo portal de telemetria -----
 * Se o nro de elementos da FIFO for menor que 0 indica que o portal de telemetria
 * removeu o nro de elementos especificados pelo valor negativo
 * Nesta condição, remove estes elementos do buffer de mensagens do portal
 *
 * IMPORTANTE: Este bloco deve ser chamado antes da chamada do bloco de função
 *             HI_PORTAL (caso seja utilizado) pois o mesmo recebe este bloco
 *             como parâmetro.
 *)

HI_TEL_GATEWAY(  // TEL_GATEWAY
  INS       := FALSE,      // [BOOL] Escrita de um registro no buffer
  DEL       := -MSG_EVTS,  // [INT] Nro. de elementos a remover do buffer
  CMD       := FILE_CMD,   // [INT] Comando associado ao arquivo de dados
  DATA_FILE := FILE_NAME,  // [STRING] Nome do arquivo para armazenamento de dados
  CACHE     := MSG_CACHE,  // [ANY] CACHE para armazenaos regisstros de dados a serem publicados para o portal
  FIFO      := MSG_FIFO    // [ANY] FIFO - área onde serão armazenados os registros
  );

MSG_EVTS := UINT_TO_INT(HI_TEL_GATEWAY.ELEM);

// RECEBE O NÚMERO DE INSTÂNCIAS E UTILIZA COMO INDEX MÁXIMO DO FOR
IDX := PRI_CFG.FDB.DAT.W.NRO_INST - 1;
// CONSISTE O VALOR DE IDX
IF IDX < 0 THEN
      IDX := 0;
ELSIF IDX > (MAX_EQP-1) THEN
      IDX := (MAX_EQP-1);
END_IF;

// Eventos a serem notificados sempre que houver alteração
IF (TICK_1S.EV) AND (LOC_XAPP.WARMUP_OK) THEN

        // Trata publicação da temperatura MINIMA / MAXIMA diária para supervisorio
        IF (LOC_XAPP.NOTIFICA_MIN_MAX) THEN
              FOR I := 0 TO IDX DO
                // Somente publica dados se o controlador estiver online
                IF PUB_WAPP.BASE[I].CONECTADO = 1 THEN

  // DEBUG
  if (I = 0) then
    inc_int(CNT_NOTIFY[0]);
  end_if;
  if (I = 1) then
    inc_int(CNT_NOTIFY[1]);
  end_if;

                  // Publicação da temperatura MINIMA diária
                  R_VALUE := PUB_WAPP.BASE[I].TEMP_MIN_DIA;
                  HI_TEL_PUBLISH(EV_ID := I + 1, DATA := R_VALUE, TEL_GAT := HI_TEL_GATEWAY);

  // DEBUG
  if (R_VALUE <= 0.0) and (I = 0) then
    inc_int(CNT_NOTIFY[2]);
  end_if;
  if (R_VALUE <= 0.0) and (I = 1) then
    inc_int(CNT_NOTIFY[3]);
  end_if;

                  // Publicação da temperatura MAXIMA diária
                  R_VALUE := PUB_WAPP.BASE[I].TEMP_MAX_DIA;
                  HI_TEL_PUBLISH(EV_ID := I + 101, DATA := R_VALUE, TEL_GAT := HI_TEL_GATEWAY);

  // DEBUG
  if (R_VALUE <= 0.0) and (I = 0) then
    inc_int(CNT_NOTIFY[4]);
  end_if;
  if (R_VALUE <= 0.0) and (I = 1) then
    inc_int(CNT_NOTIFY[5]);
  end_if;

                END_IF;
              END_FOR;
              LOC_XAPP.NOTIFICA_MIN_MAX := FALSE;
        END_IF;
// Notifica abertura de porta
        FOR I := 0 TO 7 DO
                PORTA_TR[I](CLK := PORTA[I]);
                IF (PORTA_TR[I].Q) THEN
                   B_VALUE := PORTA[I];
                   HI_TEL_PUBLISH(EV_ID := I + 501, DATA := B_VALUE, TEL_GAT := HI_TEL_GATEWAY);
                END_IF;
        END_FOR;
// Notifica falha ao ligar ou desligar controladores de temperatura por programação horária
        FOR I := 0 TO (MAX_EQP-1) DO
                F_PH_LIGAR[I](CLK := FAIL_PH.F_LIGAR[I]);
                IF F_PH_LIGAR[I].Q THEN
                   B_VALUE := FAIL_PH.F_LIGAR[I];
                   HI_TEL_PUBLISH(EV_ID := I + 601, DATA := B_VALUE, TEL_GAT := HI_TEL_GATEWAY);
                   FAIL_PH.F_LIGAR[I] := FALSE;
                END_IF;
                F_PH_DESLIGAR[I](CLK := FAIL_PH.F_DESLI[I]);
                IF F_PH_DESLIGAR[I].Q THEN
                   B_VALUE := FAIL_PH.F_DESLI[I];
                   HI_TEL_PUBLISH(EV_ID := I + 701, DATA := B_VALUE, TEL_GAT := HI_TEL_GATEWAY);
                   FAIL_PH.F_DESLI[I] := FALSE;
                END_IF;
        END_FOR;
END_IF;

// Envia dados operacionais para o portal a cada 5 minutos
IF (TICK_CYEV.EV) AND (LOC_XAPP.WARMUP_OK) THEN
     FOR I := 0 TO IDX DO
        // Somente publica dados se o controlador estiver online
        IF PUB_WAPP.BASE[I].CONECTADO = 1 THEN
         R_VALUE := PUB_WAPP.BASE[I].TEMP_TA;
         HI_TEL_PUBLISH(EV_ID := I + 201, DATA := R_VALUE, TEL_GAT := HI_TEL_GATEWAY);
         R_VALUE := PUB_WAPP.BASE[I].TEMP_EV;
         HI_TEL_PUBLISH(EV_ID := I + 301, DATA := R_VALUE, TEL_GAT := HI_TEL_GATEWAY);
         I_VALUE := PUB_WAPP.BASE[I].UMID;
         HI_TEL_PUBLISH(EV_ID := I + 401, DATA := I_VALUE, TEL_GAT := HI_TEL_GATEWAY);
        END_IF;
    END_FOR;
END_IF;



//==============================================================================
//     MANTEM ESTADO DE CONEXAO COM O PORTAL DE TELEMETRIA
//===============================================================================

// = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =
//   Obtem status de conexão do portal de telemetria
// = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =


IF TICK_1S.EV THEN  // avalia a conexao a cada segundo


  // E utilzada a variavel de sistema que le o status do soquete na qual foi
  // configurado para o acesso ao portal de telemetria. Por exemplo, se
  // considerarmos que o soquete 1 foi configurado como auto conexão
  // para acesso ao portal devemos consultar a seguinte variavel de sistema:
  //
  //  . F 380 .. F 399	Socket ethernet 1, onde devemos testar o seguinte bit:
  //
  //    .bit 4	= COF_CON_TCP = Quando canal é um socket ethernet, indica
  //              canal com conexão TCP estabelecida. Reserva para os demais
  //              tipos de canais.
  //
  // Se necessario podemos tambem consultar o bit 5, referente a auttencticação
  // V1 com o portal de telemetria:
  //	.bit 5	=  COF_AUTH_V1 = Indica se o canal esta habilitado para
  //               autenticação V1. Este contexto se aplica também aos canais
  //               seriais quando conectados internamente a módulos de Modem.

  // Le informações do soquete 1: F 380 .. F 399	Socket Ethernet 1.
  // considerando que o mesmo é que esta configurado para acesso ao
  // portal de telemetria, com auto conexão habilitado
  W_VAL := INT_TO_WORD(HILS.GET_SYSVAR(380));
  // Filtra status do bit 4 do soquete, para verificar o status de
  // existencia de conexão TCP neste respectivo soquete
  W_VAL := HILS._AND(W_VAL, 16#0010);  // filtra bit 4
  IF (W_VAL <> 0) THEN
    PUB_XAPP.PORTAL_CONNECT := TRUE;    // existe conexão TCP ativa neste soquete
  ELSE
    PUB_XAPP.PORTAL_CONNECT := FALSE;   // Não existe conexão ativa neste soquete
  END_IF;

  // Calcula o percentual de utilizacao do buffer de mensagens do portal
  IF (HI_TEL_GATEWAY.TOTAL <> 0) THEN
    MSG_PERC := UINT_TO_INT((HI_TEL_GATEWAY.ELEM * 100) / HI_TEL_GATEWAY.TOTAL);
  ELSE
    MSG_PERC := 0;
  END_IF;

  {ifdef SIMUL_MODE}
    PUB_XAPP.PORTAL_CONNECT := SIM_CONNECTED;
  {endif}

END_IF;
