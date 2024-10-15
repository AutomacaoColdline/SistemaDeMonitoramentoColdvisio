(* ============================================================================
 *                    PROJETO COLDLINE
 *
 *   DESCRIÇÃO: SISTEMA DE RESFRIAMENTO - CONTROLE E MONITORAMENTO
 *     CLIENTE: COLDLINE
 * RESPONSAVEL: Eng. de Aplicação da HI TECNOLOGIA
 *
 * ============================================================================
 *)

 (*
   ESTA POU A AQUISIÇÃO DAS VARIÁVEIS DOS CONTROLADORES POR MEIO DE COMUNICAÇÃO
   MODBUS.
   PARA MAIORES IMFORMAÇÕES VIDE DOCIMENTAÇÃO DESTA POU.
    *** MDB_CTRL ***
  *)

// Teste se sistema inicializado
if (LOC_XAPP.WARMUP_OK = false) then
  // Aguarda sistema inicializar, para habilitar a comunicação
  return;
end_if;



// O MODELO DO CONTROLADOR INDICARÁ QUAL MAPEAMENTO SERÁ UTILIZADO
// CANAL DE MAPEAMENTO 1 - DRIXEL
// CANAL DE MAPEAMENTO 2 - FULLGAUGE
MAP := INT_TO_USINT(PRI_CFG.FDB.DAT.W.CONF_CTRL[ID_CTRL].MODELO);

{IFDEF SIMU}
  {WARNING 'Desabilitada comunicação Modbus devido a diretiva de simulação SIMU no projeto'}
   // Simula dosi controladores on line para depuração
   PUB_WAPP.BASE[0].CONECTADO := 1; // simula controlador ON LINE
   PUB_WAPP.BASE[1].CONECTADO := 1; // simula controlador ON LINE

    // Simula temperatura inicial
//    if (PUB_WAPP.BASE[0].TEMP_TA <= 0) then
//      PUB_WAPP.BASE[0].TEMP_TA := 10.0;
//    end_if;
//    if (PUB_WAPP.BASE[1].TEMP_TA <= 0) then
//      PUB_WAPP.BASE[1].TEMP_TA := 11.0;
//    end_if;
    if (PUB_WAPP.BASE[0].TEMP_TA <= 0.0) or (PUB_WAPP.BASE[0].TEMP_TA > 50.0) then
       PUB_WAPP.BASE[0].TEMP_TA := 1.5;
    end_if;
    if (PUB_WAPP.BASE[1].TEMP_TA <= 0.0) or (PUB_WAPP.BASE[1].TEMP_TA > 90.0) then
       PUB_WAPP.BASE[1].TEMP_TA := 2.5;
    end_if;

    if (PUB_WAPP.BASE[0].UMID <= 0) or (PUB_WAPP.BASE[0].UMID > 70) then
       PUB_WAPP.BASE[0].UMID := 1;
    end_if;
    if (PUB_WAPP.BASE[1].UMID <= 0) or (PUB_WAPP.BASE[1].UMID > 90) then
       PUB_WAPP.BASE[1].UMID := 5;
    end_if;

    // Flag para simular um ciclo de leitura modbus
    if (TICK_1S.EV) then
      SIMULA_CICLO_RD := true;
      PUB_WAPP.BASE[0].TEMP_TA := PUB_WAPP.BASE[0].TEMP_TA + 0.001;
      PUB_WAPP.BASE[1].TEMP_TA := PUB_WAPP.BASE[1].TEMP_TA + 0.005;

      PUB_WAPP.BASE[0].UMID := PUB_WAPP.BASE[0].UMID + 1;
      PUB_WAPP.BASE[1].UMID := PUB_WAPP.BASE[1].UMID + 2;

    end_if;
   // Desabilita bloco de comunicação Modbus
   ENABLE := false;
{ENDIF}

//******************************************************************************
// CONFIGURAÇÃO DO ID DA REMOTA
//SEMPRE QUE FOR HAVER UM EVENTO DE LEITURA
IF CTRL_MDB.BRT_EV  THEN
// só troca o Id do controlador de temperatura se houver um ID de controlador válido
 if ID_CTRL <> 255 then
// SINALIZA PARA O BLOCO QUE É PARA USAR O ENDEREÇO ID DA REMOTA INDICADO PELA
// VARIÁVEL TESTE.NEW_RD_ID
     CHG_RD_ID := TRUE;
// CARREGA VALOR REFERENTE AO ID DA REMOTA ATUAL
     NEW_RD_ID := INT_TO_UINT(PRI_CFG.FDB.DAT.W.CONF_CTRL[ID_CTRL].END_EQUIP);
 end_if;
END_IF;

//SEMPRE QUE FOR HAVER UM EVENTO DE ESCRITA
IF CTRL_MDB.BWT_EV THEN
// só troca o Id do controlador de temperatura se houver um ID de controlador válido
 if ID_CTRL <> 255 then
// SINALIZA PARA O BLOCO QUE É PARA USAR O ENDEREÇO ID DA REMOTA INDICADO PELA
// VARIÁVEL TESTE.NEW_RD_ID
     CHG_WR_ID := TRUE;
// CARREGA VALOR REFERENTE AO ID DA REMOTA ATUAL
     NEW_WR_ID := INT_TO_UINT(PRI_CFG.FDB.DAT.W.CONF_CTRL[ID_CTRL].END_EQUIP);
 end_if;
END_IF;

// FIM DA CONFIGURAÇÃO DO ID DA REMOTA


// BLOCO DE CONTROLE MODBUS PARA COMUNICAÇÃO COM OS CONTROLADORES.
CTRL_MDB(  // MDB_GATEWAY
    START     := START and (ID_CTRL <>255),             // [BOOL] Inicia operação do gateway
    EN_SCAN   := TRUE,              // [BOOL] Habilita o polling de dados do equipamento remoto
    SKIP_RD   := FALSE,             // [BOOL] Quando habilitada imediatamente após um evento BRT_EV cancela a transação  de leitura corrente
    CHG_RD_ID := CHG_RD_ID,         // [BOOL] Quando BRT_EV estiver ativo habilita alterar o ID de comunicação da proxima transação de leitura
    CHG_WR_ID := CHG_WR_ID,         // [BOOL] Quando BWT_EV estiver ativo habilita alterar o ID de comunicação da proxima transação de leitura
    NEW_RD_ID := NEW_RD_ID,         // [UINT] Quando BRT_EV  estiver ativo permite definir um ID de comunicação diferente do programado da proxima transação de leitura
    NEW_WR_ID := NEW_WR_ID,         // [UINT] Quando BRT_EV  estiver ativo permite definir um ID de comunicação diferente do programado da proxima transação de escrita
    DMAP_ID   := MAP,               // [USINT] Id do mapeamento de dados associado ao bloco
    COMM_SRC  := HILS.COM1_PORT_ID, // [USINT] Canal de comunicação utilizado para acesso equipamento Modbus  (ex: COM1_PORT_ID)
    IPOLL_TME := T#100MS,           // [TIME] Tempo entre um ciclo de comunicação
    IPACK_TME := T#100MS,           // [TIME] Tempo entre pacotes de comunicação
    W_CACHE   := W_CACHE            // [] Cache de items a serem enviados ao equipamento remoto (deve ser fornecido um vetor de tipos INT)
    );
//******************************************************************************
// Contabiliza ciclos de leitura de dados do equipamento remoto
IF CTRL_MDB.RD_EV THEN

   RD_ID        := CTRL_MDB.RD_ID;    // identificador associado ao ultimo ciclo de leitura
   RD_ERR       := CTRL_MDB.RD_CODE;  // codigo de erro associado ao ultimo ciclo de leitura
   RD_COUNT     := RD_COUNT + 1;     // contador de ciclos de leitura

    // Obtem o indice do controlador 0..19
    I := UINT_TO_INT(ID_CTRL);

    // Contabiliza ciclo de leitura de um item do mapeamento de dados
    INC_INT(MDB_DEBUG_RD[I].END_CYC);

    // Monitora erro na execução de um mapeamento de dados de leitura
    if (CTRL_MDB.RD_CODE <> HILS.SUCCESS) then

      // incrementa leitura de um item do mapeamento com erro
      INC_INT(MDB_DEBUG_RD[I].EV_NOK);          // contador absoluto de todos os ciclos de processamento
      INC_INT(MDB_DEBUG_RD[I].CNT_CUR_CYC_NOK); // contador relativo a este ciclo de mapeamento

      // incrementa contador de erros consecutivos
      INC_INT(MDB_DEBUG_RD[I].CNT_CONSECUTIVOS_NOK); // contador relativo a este ciclo de mapeamento

      // reseta contador de sucesso
      MDB_DEBUG_RD[I].CNT_CUR_CYC_OK := 0; // contador relativo a este ciclo de mapeamento

      // salva ultimo codigo de erro na escrita de um item do mapeamento de dados
      MDB_DEBUG_RD[I].LAST_ERR := CTRL_MDB.RD_CODE;
      MDB_DEBUG_RD[I].LAST_ID  := CTRL_MDB.RD_ID;

    else

      // incrementa contador de leitura de um item do mapeamento com SUCESSO
      INC_INT(MDB_DEBUG_RD[I].EV_OK);           // contador absoluto de todos os ciclos de processamento
      INC_INT(MDB_DEBUG_RD[I].CNT_CUR_CYC_OK);  // contador relativo a este ciclo de mapeamento

      // reseta contador de erros consecutivos
      MDB_DEBUG_RD[I].CNT_CONSECUTIVOS_NOK := 0; // contador relativo a este ciclo de mapeamento

    end_if;

    // Testa se houve todas as leituras com sucesso neste ciclo de mapeamento
    // com 1o equipamento remoto escravo
    //
    // OBS.: Previsão de 3 mapeamentos de dados para este equipamento remoto
    //
    if (MDB_DEBUG_RD[I].CNT_CUR_CYC_OK >= 3) then
       PUB_WAPP.BASE[I].CONECTADO := 1;  // Seta comunicação ON LINE
    else
       // somente considera falha na comunicação se ocorrer mais de "x" erros
       // consecutivos, para filtrar eventuais erros espurios na comunicação
       if (MDB_DEBUG_RD[I].CNT_CONSECUTIVOS_NOK > 3) then
         PUB_WAPP.BASE[I].CONECTADO := 0;  // Set comunicação OFF LINE
       end_if;
    end_if;


   // Se erro de timeout neste ciclo de leitura, força trocar para
   // o proximo controlador
   IF (RD_ERR = HILS.CO_REC_TMO)   OR   // Erro 79 = Timeout na recepção do caracter
      (RD_ERR = HILS.COM_RFRM_TMO) THEN // Erro 94 = Timeout na recepção do frame
     TROCA := TRUE;
   end_if;

   // Teste se controlador esta OFF LINE, para resetar as informações
   if (PUB_WAPP.BASE[I].CONECTADO = 0) then
       INC_INT(CNT_MIN_MAX[0]); // contador para debug
       PUB_WAPP.BASE[ID_CTRL].TEMP_TA     := 0.0;
       PUB_WAPP.BASE[ID_CTRL].TEMP_EV     := 0.0;
       PUB_WAPP.BASE[ID_CTRL].STS_VENT    := 0;
       PUB_WAPP.BASE[ID_CTRL].STS_REFRI   := 0;
       PUB_WAPP.BASE[ID_CTRL].STS_DEGELO  := 0;
       PUB_WAPP.BASE[ID_CTRL].STS_DESUMID := 0;
       PUB_WAPP.BASE[ID_CTRL].STS_PHP     := 0;
       PUB_WAPP.BASE[ID_CTRL].STS_ON_OFF  := 0;
       PUB_WAPP.BASE[ID_CTRL].ALM         := 0;
       PUB_WAPP.BASE[ID_CTRL].SP_TA       := 0.0;
       PUB_WAPP.BASE[ID_CTRL].SP_TEV      := 0.0;
       PUB_WAPP.BASE[ID_CTRL].UMID        := 0;
       PUB_WAPP.BASE[ID_CTRL].SP_UMID     := 0;
   END_IF;

   IF (NOT TROCA) THEN
// MAPEAMENTO DAS VARIÁVEIS CASO SEJA CONTROLADOR TIPO DRIXELL E ESTEJA CONECTADO
      IF MAP = 1 AND (PUB_WAPP.BASE[ID_CTRL].CONECTADO = 1) THEN
				//-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
                // LEITURA DA TEMPERATURA AMBIENTE
                IF (CTRL_MDB.RD_ID = 1) then
	  	            // ATRIBUI VALORES RECEBIDOS DO CANAL DE MAPEAMENTO PARA A BASE DE EXPORTAÇÃO
	                  PUB_WAPP.BASE[ID_CTRL].TEMP_TA     := INT_TO_REAL(COM_DRIXELL.TEMP);
	            // LEITURA DA UMIDADE
	            ELSIF (CTRL_MDB.RD_ID = 2) then
	  	        	// ATRIBUI VALORES RECEBIDOS DO CANAL DE MAPEAMENTO PARA A BASE DE EXPORTAÇÃO
                      PUB_WAPP.BASE[ID_CTRL].UMID        := COM_DRIXELL.UMID;
	  	        //-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
	            // LEITURA DOS STATUS
	            // - VENTILAÇÃO
	            // - REFRIGERAÇÃO
	            // - DESUMIDIFICAÇÃO
	            ELSIF (CTRL_MDB.RD_ID = 3) then
                      // CONVERTE A VARIÁVEL DE STATUS PARA UINT (PARÂMETRO DA FUNÇÃO DEMUX)
	  	        	STATUS_UINT_DIXELL := INT_TO_UINT(COM_DRIXELL.STATUS);
	  	        	// CHAMA FUNÇÃO DEMUX PARA SEPARAR STATUS RECEBIDOS NOS BITS DESTE INTEIRO.
	  	        	DEMUX_STS_DIXELL   := DEMUX16(UINT_TO_WORD(STATUS_UINT_DIXELL),STATUS_VET_DIXELL);
	  	        	// ATRIBUI VALORES RECEBIDOS DO CANAL DE MAPEAMENTO PARA A BASE DE EXPORTAÇÃO
	  	        	PUB_WAPP.BASE[ID_CTRL].STS_VENT    := BOOL_TO_INT(STATUS_VET_DIXELL[2]);
	  	        	PUB_WAPP.BASE[ID_CTRL].STS_REFRI   := BOOL_TO_INT(STATUS_VET_DIXELL[0]);
	  	        	PUB_WAPP.BASE[ID_CTRL].STS_DESUMID := BOOL_TO_INT(STATUS_VET_DIXELL[4]);
	  	        //-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
	            // LEITURA DO STATUS DO PHP
	            ELSIF (CTRL_MDB.RD_ID = 4) then
                      // CONVERTE A VARIÁVEL DE STATUS PHP PARA UINT (PARÂMETRO DA FUNÇÃO DEMUX)
                      STATUS_UINT_DIXELL_PHP := INT_TO_UINT(COM_DRIXELL.STATUS_PHP);
                      // CHAMA FUNÇÃO DEMUX PARA SEPARAR STATUS PHP RECEBIDOS NOS BITS DESTE INTEIRO.
                      DEMUX_STS_DIXELL_PHP   := DEMUX16(UINT_TO_WORD(STATUS_UINT_DIXELL_PHP),STATUS_VET_DIXELL_PHP);
                      // ATRIBUI VALORES RECEBIDOS DO CANAL DE MAPEAMENTO PARA A BASE DE EXPORTAÇÃO
                      PUB_WAPP.BASE[ID_CTRL].STS_PHP     := BOOL_TO_INT(STATUS_VET_DIXELL_PHP[12]);
	            //-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
	            // LEITURA DO STATUS DE ON / OFF
	            ELSIF (CTRL_MDB.RD_ID = 5) then
                      // CONVERTE A VARIÁVEL DE STATUS ON OFF PARA UINT (PARÂMETRO DA FUNÇÃO DEMUX)
                      ONOFF_UINT_DIXELL := INT_TO_UINT(COM_DRIXELL.STS_ONOFF);
                      // CHAMA FUNÇÃO DEMUX PARA SEPARAR STATUS RECEBIDOS NOS BITS DESTE INTEIRO.
                      DEMUX_ONOFF_DIXELL   := DEMUX16(UINT_TO_WORD(ONOFF_UINT_DIXELL),ONOFF_VET_DIXELL);
                      // ATRIBUI VALORES RECEBIDOS DO CANAL DE MAPEAMENTO PARA A BASE DE EXPORTAÇÃO
                      PUB_WAPP.BASE[ID_CTRL].STS_ON_OFF  := BOOL_TO_INT(ONOFF_VET_DIXELL[0]);
	            //-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
	            // LEITURA DO STATUS DE ALARME
                ELSIF (CTRL_MDB.RD_ID = 6) then
	                  // ATRIBUI VALORES RECEBIDOS DO CANAL DE MAPEAMENTO PARA A BASE DE EXPORTAÇÃO
	                  PUB_WAPP.BASE[ID_CTRL].ALM         := COM_DRIXELL.ALM;
	            //-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
	            // LEITURA DO SETPOIJNT DE TEMPERATURA AMBIENTE
	            ELSIF (CTRL_MDB.RD_ID = 7) then
                      // ATRIBUI VALORES RECEBIDOS DO CANAL DE MAPEAMENTO PARA A BASE DE EXPORTAÇÃO
	                  PUB_WAPP.BASE[ID_CTRL].SP_TA       := INT_TO_REAL(COM_DRIXELL.SP_TEMP)/10;
	            //-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
	            // LEITURA DO SETPOINT DE UMIDADE
	            ELSIF (CTRL_MDB.RD_ID = 8) then
                      // ATRIBUI VALORES RECEBIDOS DO CANAL DE MAPEAMENTO PARA A BASE DE EXPORTAÇÃO
                      PUB_WAPP.BASE[ID_CTRL].SP_UMID     := COM_DRIXELL.SP_UMID/2;
	  	        //-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
	            // LEITURA DO STATUS DE DEGELO
	            ELSIF (CTRL_MDB.RD_ID = 9) then
	                  // CONVERTE A VARIÁVEL DE STATUS DE DEGELO PARA UINT (PARÂMETRO DA FUNÇÃO DEMUX)
	                  STATUS_UINT_DIXELL_DG := INT_TO_UINT(COM_DRIXELL.COMANDO);
	                  // CHAMA FUNÇÃO DEMUX PARA SEPARAR STATUS DEGELO RECEBIDOS NOS BITS DESTE INTEIRO.
	                  DEMUX_STS_DIXELL_DG   := DEMUX16(UINT_TO_WORD(STATUS_UINT_DIXELL_DG),STATUS_VET_DIXELL_DG);
	                  // ATRIBUI VALORES RECEBIDOS DO CANAL DE MAPEAMENTO PARA A BASE DE EXPORTAÇÃO
	                  PUB_WAPP.BASE[ID_CTRL].STS_DEGELO  := BOOL_TO_INT(STATUS_VET_DIXELL_DG[9]);
                END_IF;
//**********************************************************************************************************************
// MAPEAMENTO DAS VARIÁVEIS CASO SEJA CONTROLADOR TIPO FULLGAUGE E ESTEJA CONECTADO
      ELSIF MAP = 2 AND (PUB_WAPP.BASE[ID_CTRL].CONECTADO = 1) THEN
			//-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
                // LEITURA DA TEMPERATURA AMBIENTE
                IF (CTRL_MDB.RD_ID = 1) then
	                  // ATRIBUI VALORES RECEBIDOS DO CANAL DE MAPEAMENTO PARA A BASE DE EXPORTAÇÃO
					  PUB_WAPP.BASE[ID_CTRL].TEMP_TA     := INT_TO_REAL(COM_FULL.TEMP_TA)/10;
               //-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
			   // LEITURA DA TEMPERATURA DO EVAPORADOR
	            ELSIF (CTRL_MDB.RD_ID = 2) then
				      // ATRIBUI VALORES RECEBIDOS DO CANAL DE MAPEAMENTO PARA A BASE DE EXPORTAÇÃO
				      PUB_WAPP.BASE[ID_CTRL].TEMP_EV     := INT_TO_REAL(COM_FULL.TEMP_EV)/10;
				//-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
				// LEITURA DE STATUS
				// - VENTILAÇÃO
				// - REFRIGERAÇÃO
				// - DEGELO
				// - ON / OFF
	            ELSIF (CTRL_MDB.RD_ID = 3) then
                      // CONVERTE A VARIÁVEL DE STATUS PARA UINT (PARÂMETRO DA FUNÇÃO DEMUX)
                      STATUS_UINT_FULL := INT_TO_UINT(COM_FULL.STATUS);
                      // CONVERTE A VARIÁVEL DE STATUS PARA UINT (PARÂMETRO DA FUNÇÃO DEMUX)
                      DEMUX_STS_FULL  := DEMUX16(UINT_TO_WORD(STATUS_UINT_FULL),STATUS_VET_FULL);
                      // ATRIBUI VALORES RECEBIDOS DO CANAL DE MAPEAMENTO PARA A BASE DE EXPORTAÇÃO
                      PUB_WAPP.BASE[ID_CTRL].STS_VENT    := BOOL_TO_INT(STATUS_VET_FULL[1]);
					  PUB_WAPP.BASE[ID_CTRL].STS_REFRI   := BOOL_TO_INT(STATUS_VET_FULL[0]);
				      PUB_WAPP.BASE[ID_CTRL].STS_DEGELO  := BOOL_TO_INT(STATUS_VET_FULL[2]);
				      PUB_WAPP.BASE[ID_CTRL].STS_ON_OFF  := BOOL_TO_INT(NOT STATUS_VET_FULL[7]);
				//-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
				// LEITURA DE STATUS2
				// - BITS DE ALARMES
	            ELSIF (CTRL_MDB.RD_ID = 4) then
				      // CHAMA FUNÇÃO DEMUX PARA SEPARAR STATUS RECEBIDOS NOS BITS DESTE INTEIRO.
				      STATUS_UINT2_FULL := INT_TO_UINT(COM_FULL.STATUS2);
				      // CONVERTE A VARIÁVEL DE STATUS 2 PARA UINT (PARÂMETRO DA FUNÇÃO DEMUX)
				      DEMUX_STS2_FULL := DEMUX16(UINT_TO_WORD(STATUS_UINT2_FULL),STATUS_VET2_FULL);
	     		//-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
				// LEITURA DE STATUS3
				// - BITS DE ALARMES
	            ELSIF (CTRL_MDB.RD_ID = 5) then
				      // CHAMA FUNÇÃO DEMUX PARA SEPARAR STATUS RECEBIDOS NOS BITS DESTE INTEIRO.
				      STATUS_UINT3_FULL := INT_TO_UINT(COM_FULL.STATUS3);
				      // CONVERTE A VARIÁVEL DE STATUS 3 PARA UINT (PARÂMETRO DA FUNÇÃO DEMUX)
				      DEMUX_STS3_FULL := DEMUX16(UINT_TO_WORD(STATUS_UINT3_FULL),STATUS_VET3_FULL);

				//-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
				// LEITURA DO SETPOINT DA TEMPERATURA AMBIENTE
	            ELSIF (CTRL_MDB.RD_ID = 6) then
				      // ATRIBUI VALORES RECEBIDOS DO CANAL DE MAPEAMENTO PARA A BASE DE EXPORTAÇÃO
				      PUB_WAPP.BASE[ID_CTRL].SP_TA       := INT_TO_REAL(COM_FULL.SP_TA)/10;

				//-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
				// LEITURA DO SETPOINT DA TEMPERATURA DO EVAPORADOR
	            ELSIF (CTRL_MDB.RD_ID = 7) then
				      // ATRIBUI VALORES RECEBIDOS DO CANAL DE MAPEAMENTO PARA A BASE DE EXPORTAÇÃO
				      PUB_WAPP.BASE[ID_CTRL].SP_TEV      := INT_TO_REAL(COM_FULL.SP_EV)/10;

				//-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
				// LEITURA DO INTERVALO DE DEGELO
	            ELSIF (CTRL_MDB.RD_ID = 8) then
				      // ATRIBUI VALORES RECEBIDOS DO CANAL DE MAPEAMENTO PARA A BASE DE EXPORTAÇÃO
				      PUB_WAPP.BASE[ID_CTRL].INT_DEGELO  := COM_FULL.INT_DEGELO;
				END_IF;
				//-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
	            // ATRIBUI ALARMES RECEBIDOS PARA UMA VARIÁVEL DE ALARME GERAL
				ALARME := STATUS_VET2_FULL[0] OR STATUS_VET2_FULL[1] OR STATUS_VET2_FULL[7] OR
				          STATUS_VET3_FULL[0] OR STATUS_VET3_FULL[1] OR STATUS_VET3_FULL[2] OR
				          STATUS_VET3_FULL[3] OR STATUS_VET3_FULL[5] OR STATUS_VET3_FULL[6] OR
	                      STATUS_VET3_FULL[12] OR STATUS_VET3_FULL[13];
				// ATRIBUI VALORES RECEBIDOS DO CANAL DE MAPEAMENTO PARA A BASE DE EXPORTAÇÃO
				PUB_WAPP.BASE[ID_CTRL].ALM         := BOOL_TO_INT(ALARME);
				//-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
				// PHP NÃO UTILIZADO NO CONTROLADOR DE TEMPERATURA FULL GAUGE
				PUB_WAPP.BASE[ID_CTRL].STS_PHP     := -1;
				// DESUMIDIFICAÇÃO NÃO UTILIZADO NO CONTROLADOR DE TEMPERATURA FULL GAUGE
				PUB_WAPP.BASE[ID_CTRL].STS_DESUMID := -1;

// CASO ESTEJA DESABILITADO
      ELSE
        // Teste se controlador esta OFF LINE, para somente então resetar as informações
        if (PUB_WAPP.BASE[I].CONECTADO = 0) then
          INC_INT(CNT_MIN_MAX[1]); // contador para debug
          PUB_WAPP.BASE[ID_CTRL].TEMP_TA     := 0.0;
          PUB_WAPP.BASE[ID_CTRL].TEMP_EV     := 0.0;
          PUB_WAPP.BASE[ID_CTRL].STS_VENT    := 0;
          PUB_WAPP.BASE[ID_CTRL].STS_REFRI   := 0;
          PUB_WAPP.BASE[ID_CTRL].STS_DEGELO  := 0;
          PUB_WAPP.BASE[ID_CTRL].STS_DESUMID := 0;
          PUB_WAPP.BASE[ID_CTRL].STS_PHP     := 0;
          PUB_WAPP.BASE[ID_CTRL].STS_ON_OFF  := 0;
          PUB_WAPP.BASE[ID_CTRL].ALM         := 0;
          PUB_WAPP.BASE[ID_CTRL].SP_TA       := 0.0;
          PUB_WAPP.BASE[ID_CTRL].SP_TEV      := 0.0;
          PUB_WAPP.BASE[ID_CTRL].UMID        := 0;
          PUB_WAPP.BASE[ID_CTRL].SP_UMID     := 0;
          PUB_WAPP.BASE[ID_CTRL].INT_DEGELO  := 0;
        end_if;
      END_IF;
   END_IF;
END_IF; // FIM DA CONDIÇÃO DE FIM DE LEITURA

// Monitora limites de temperatura
if (LOC_XAPP.WARMUP_OK = true) and
   ( (CTRL_MDB.RD_EV) or         // Ciclo de leitura dos dados modbus
     (SIMULA_CICLO_RD = true)    // Flag para simular um ciclo de leitura
   )
THEN
// FAZ A AQUISIÇÃO DAS TEMPERATURAS MÍNIMAS E MÁXIMAS DO DIA.
  if (PUB_WAPP.BASE[ID_CTRL].CONECTADO = 1) then

      // Trata mudança de dia, inicializa valor da primeira temperatura
      IF LOC_XAPP.PRIMEIRA_TEMP_DIA[ID_CTRL]  THEN
         INC_INT(CNT_MIN_MAX[2]); // contador para debug
         // Inicializa valores do novo dia com a temperatura atual
         PUB_WAPP.BASE[ID_CTRL].TEMP_MIN_DIA := PUB_WAPP.BASE[ID_CTRL].TEMP_TA;
         PUB_WAPP.BASE[ID_CTRL].TEMP_MAX_DIA := PUB_WAPP.BASE[ID_CTRL].TEMP_TA;
         LOC_XAPP.PRIMEIRA_TEMP_DIA[ID_CTRL] := FALSE;
      ELSE
            // Verifica temperatura minima DIARIA
         if (PUB_WAPP.BASE[ID_CTRL].TEMP_TA < PUB_WAPP.BASE[ID_CTRL].TEMP_MIN_DIA) or
            // valor da temperatura minima ainda não inicializada
            (PUB_WAPP.BASE[ID_CTRL].TEMP_MIN_DIA <= 0)
         THEN
           INC_INT(CNT_MIN_MAX[3]); // contador para debug
           // atualiza novo valor para a temperatura MINIMA DIARIA para este controlador
           PUB_WAPP.BASE[ID_CTRL].TEMP_MIN_DIA := PUB_WAPP.BASE[ID_CTRL].TEMP_TA;
         end_if;

            // Verifica temperatura maxima DIARIA
         if (PUB_WAPP.BASE[ID_CTRL].TEMP_TA > PUB_WAPP.BASE[ID_CTRL].TEMP_MAX_DIA) or
            // valor da temperatura maxima ainda não inicializada
            (PUB_WAPP.BASE[ID_CTRL].TEMP_MAX_DIA <= 0)
         THEN
           INC_INT(CNT_MIN_MAX[4]); // contador para debug
           // atualiza novo valor para a temperatura MAXIMA DIARIA para este controlador
           PUB_WAPP.BASE[ID_CTRL].TEMP_MAX_DIA := PUB_WAPP.BASE[ID_CTRL].TEMP_TA;
         end_if;
      END_IF;


      // Lógicas para debug apenas
      if (PUB_WAPP.BASE[ID_CTRL].TEMP_MIN_DIA <= 0) then
           INC_INT(CNT_MIN_MAX[5]); // contador para debug
      end_if;
      if (PUB_WAPP.BASE[ID_CTRL].TEMP_MAX_DIA <= 0) then
           INC_INT(CNT_MIN_MAX[6]); // contador para debug
      end_if;

  end_if;


  // Lógicas para debug apenas
  if (ID_CTRL = 0) or (ID_CTRL = 1) then
    if (PUB_WAPP.BASE[ID_CTRL].TEMP_MIN_DIA <= 0) then
           INC_INT(CNT_MIN_MAX[7]); // contador para debug
    end_if;
    if (PUB_WAPP.BASE[ID_CTRL].TEMP_MAX_DIA <= 0) then
           INC_INT(CNT_MIN_MAX[8]); // contador para debug
    end_if;
  end_if;


// VERIFICA CONDIÇÃO DE ALARME DE TEMPERATURA ALTA
      IF PUB_WAPP.BASE[ID_CTRL].TEMP_TA > PRI_CFG.FDB.DAT.W.CONF_CTRL[ID_CTRL].TEMP_H THEN
       PUB_XAPP.ALM_TEMP_MAX[ID_CTRL] := TRUE;
      ELSE
       PUB_XAPP.ALM_TEMP_MAX[ID_CTRL] := FALSE;
      END_IF;
// VERIFICA CONDIÇÃO DE ALARME DE TEMPERATURA BAIXA
      IF PUB_WAPP.BASE[ID_CTRL].TEMP_TA < PRI_CFG.FDB.DAT.W.CONF_CTRL[ID_CTRL].TEMP_L THEN
       PUB_XAPP.ALM_TEMP_MIN[ID_CTRL] := TRUE;
      ELSE
       PUB_XAPP.ALM_TEMP_MIN[ID_CTRL] := FALSE;
      END_IF;
END_IF; // FIM DA CONDIÇÃO DE FIM DE LEITURA

//******************************************************************************
//
//      Tratamento das escritas de comandos e SP.
//
//******************************************************************************

// Contabiliza ciclos de escrita de dados no equipamento remoto
IF CTRL_MDB.WR_EV THEN
   WR_ID    := CTRL_MDB.WR_ID;    // identificador associado ao ultimo ciclo de escrita
   WR_ERR   := CTRL_MDB.WR_CODE;  // codigo de erro associado ao ultimo ciclo de escrita
   WR_COUNT := WR_COUNT + 1;     // contador de ciclos de escrita

   // Obtem o indice do controlador 0..19
    J := UINT_TO_INT(ID_CTRL);

    // Contabiliza ciclo de leitura de um item do mapeamento de dados
    INC_INT(MDB_DEBUG_WR[I].END_CYC);

    // Monitora erro na execução de um mapeamento de dados de leitura
    if (CTRL_MDB.WR_CODE <> HILS.SUCCESS) then

      // incrementa leitura de um item do mapeamento com erro
      INC_INT(MDB_DEBUG_WR[I].EV_NOK);          // contador absoluto de todos os ciclos de processamento
      INC_INT(MDB_DEBUG_WR[I].CNT_CUR_CYC_NOK); // contador relativo a este ciclo de mapeamento

      // incrementa contador de erros consecutivos
      INC_INT(MDB_DEBUG_WR[I].CNT_CONSECUTIVOS_NOK); // contador relativo a este ciclo de mapeamento

      // reseta contador de sucesso
      MDB_DEBUG_WR[I].CNT_CUR_CYC_OK := 0; // contador relativo a este ciclo de mapeamento

      // salva ultimo codigo de erro na escrita de um item do mapeamento de dados
      MDB_DEBUG_WR[I].LAST_ERR := CTRL_MDB.RD_CODE;
      MDB_DEBUG_WR[I].LAST_ID  := CTRL_MDB.RD_ID;

    else

      // incrementa contador de leitura de um item do mapeamento com SUCESSO
      INC_INT(MDB_DEBUG_WR[I].EV_OK);           // contador absoluto de todos os ciclos de processamento
      INC_INT(MDB_DEBUG_WR[I].CNT_CUR_CYC_OK);  // contador relativo a este ciclo de mapeamento

      // reseta contador de erros consecutivos
      MDB_DEBUG_WR[I].CNT_CONSECUTIVOS_NOK := 0; // contador relativo a este ciclo de mapeamento

    end_if;

// Caso tenha sucesso na leitura ou já tenha excedido o retry em 3 vezes (0 a 2)
   IF (WR_ERR = 0) OR (RETRY > 2) THEN
// Verifica se é o último comando a ser realizado ou se excedeu 3 tentativas de escrita
            IF (FIM = 2) OR (RETRY > 2) THEN
                 ENVIA_COMANDO := FALSE;
                 FIM           := 0;
            END_IF;
			// Envia comando de falha de execução de coamndo
			if (RETRY > 2) then
			     FALHA_COM := true;
			else
			     FALHA_COM := false;
			end_if;
			// Envia comando de sucesso de execução de coamndo
			if (WR_ERR = 0) then
			     SUCES_COM := true;
			else
			     SUCES_COM := false;
			end_if;
// Zera contador de tentativas
            RETRY  := 0;

// Caso não tenha obtido uma escrita de sucesso
   ELSE
// incrementa o contador de tentativas e zera tags do comando, neste caso o próprio
// comando fica ativo para nova tentativa
            RETRY         := RETRY+1;
            FIM           := 0;
            ENVIA_COMANDO := true;
   END_IF;
END_IF;
IF PUB_XAPP.TROCOU_DIA THEN
       PUB_XAPP.TROCOU_DIA := false;
       FOR  K := 0 TO (MAX_EQP-1) DO
            MDB_DEBUG_RD[K].EV_OK   := 0.0;
            MDB_DEBUG_RD[K].EV_NOK  := 0.0;
            MDB_DEBUG_RD[K].END_CYC := 0.0;
            MDB_DEBUG_WR[K].EV_OK   := 0.0;
            MDB_DEBUG_WR[K].EV_NOK  := 0.0;
            MDB_DEBUG_WR[K].END_CYC := 0.0;
       END_FOR;

END_IF;
// Soma leituras e escritas OKs
SUM_COM[0] := (MDB_DEBUG_RD[ID_CTRL].EV_OK + MDB_DEBUG_WR[ID_CTRL].EV_OK);
// Soma leituras e escritas NOKs
SUM_COM[1] := (MDB_DEBUG_RD[ID_CTRL].EV_NOK + MDB_DEBUG_WR[ID_CTRL].EV_NOK);
// Cálculo do percentual de taxa de comunicação OK e NOK.
MDB_CALC_KPI(
  SUM_COM[0],   // EV_OK [REAL] = Entrada: Contador de ciclos de comunicação OK
  SUM_COM[1], // EV_NOK [REAL] = Entrada: Contador de ciclos de comunicação NOK
  TAXA_COM.KPI_OK[ID_CTRL],                                // KPI_OK [INT] = Saida: Procentagem de taxa de comunicação OK (0..100%)
  TAXA_COM.KPI_NOK[ID_CTRL]                                // KPI_NOK [INT] = Saida: Procentagem de taxa de comunicação NOK (0..100%)
  );

AGUARDA_CMD(  // TON
  IN := (MQ_EST_WR = 0) and (LOC_XAPP.WARMUP_OK),  // [BOOL] Entrada de habilitação da temporização
  PT := T#100MS   // [TIME] Tempo de atraso para ligar
  );



(*==============================================================================
          TRATA OS ENVIOS DE COMANDO PARA OS CONTROLADORES
--------------------------------------------------------------------------------*)
// Caso a máquina de estado de comando de escrita estiver no estado 0,
// tenha um ID de controlador de temperatura válido (0 a 19)
// E o ID do controlador de temperatura para escrita for diferente de 255 (255 indica sem comando)
if (MQ_EST_WR = 0) and (ID_CTRL <> 255) and (ID_CMD_WR <> 255) then
//if AGUARDA_CMD.Q then
        // Verifica se há comandos para o controlador atual
        if    (CMD_WR[ID_CTRL].SP_TEMP      <> 0) then
                if (CMD_WR[ID_CTRL].SP_TEMP = 1) then
                   CMD_CODE  := 100;
        		   MQ_EST_WR := 100;
                else
                   CMD_WR[ID_CTRL].SP_TEMP := 0;
                   CMD_WR[ID_CTRL].RESULT  := 1000;
                end_if;
//******************************************************************************
        elsif (CMD_WR[ID_CTRL].SP_PROC      <> 0) then
                if (CMD_WR[ID_CTRL].SP_PROC = 1) then
                   CMD_CODE  := 200;
        		   MQ_EST_WR := 200;
                else
                   CMD_WR[ID_CTRL].SP_PROC := 0;
                   CMD_WR[ID_CTRL].RESULT  := 1001;
                end_if;
//******************************************************************************
        elsif (CMD_WR[ID_CTRL].DEGELO       <> 0) then
                if (CMD_WR[ID_CTRL].DEGELO = 1) then
                   CMD_CODE  := 300;
        		   MQ_EST_WR := 300;
                else
                   CMD_WR[ID_CTRL].DEGELO := 0;
                   CMD_WR[ID_CTRL].RESULT := 1002;
                end_if;
//******************************************************************************
        elsif (CMD_WR[ID_CTRL].PARAR_DEGELO <> 0) then
                if (CMD_WR[ID_CTRL].PARAR_DEGELO = 1) then
                   CMD_CODE  := 400;
        		   MQ_EST_WR := 400;
                else
                   CMD_WR[ID_CTRL].PARAR_DEGELO := 0;
                   CMD_WR[ID_CTRL].RESULT       := 1003;
                end_if;
//******************************************************************************
        elsif (CMD_WR[ID_CTRL].LIGAR        <> 0) then
                if (CMD_WR[ID_CTRL].LIGAR = 1) then
                   CMD_CODE  := 500;
        		   MQ_EST_WR := 500;
                else
                   CMD_WR[ID_CTRL].LIGAR   := 0;
                   CMD_WR[ID_CTRL].RESULT  := 1004;
                end_if;
//******************************************************************************
        elsif (CMD_WR[ID_CTRL].DESLIGAR     <> 0) then
                if (CMD_WR[ID_CTRL].DESLIGAR = 1) then
                   CMD_CODE  := 600;
        		   MQ_EST_WR := 600;
                else
                   CMD_WR[ID_CTRL].DESLIGAR := 0;
                   CMD_WR[ID_CTRL].RESULT   := 1005;
                end_if;
//******************************************************************************
        elsif (CMD_WR[ID_CTRL].LIGAR_PH     <> 0) then
                if (CMD_WR[ID_CTRL].LIGAR_PH = 1) then
                   CMD_CODE  := 500;
        		   MQ_EST_WR := 500;
                else
                   CMD_WR[ID_CTRL].LIGAR_PH := 0;
                   CMD_WR[ID_CTRL].RESULT   := 1006;
                end_if;
//******************************************************************************
        elsif (CMD_WR[ID_CTRL].DESLIGAR_PH  <> 0) then
                if (CMD_WR[ID_CTRL].DESLIGAR_PH = 1) then
                   CMD_CODE  := 600;
        		   MQ_EST_WR := 600;
                else
                   CMD_WR[ID_CTRL].DESLIGAR_PH := 0;
                   CMD_WR[ID_CTRL].RESULT      := 1007;
                end_if;
//******************************************************************************
        elsif (CMD_WR[ID_CTRL].INT_DEGELO   = 1) then
                if (CMD_WR[ID_CTRL].INT_DEGELO = 1) then
                   CMD_CODE  := 700;
        		   MQ_EST_WR := 700;
                else
                   CMD_WR[ID_CTRL].INT_DEGELO := 0;
                   CMD_WR[ID_CTRL].RESULT     := 1008;
                end_if;
//******************************************************************************
        else
                CMD_CODE := 0;
        end_if;
end_if;



// Máquina de estado para execução de comandos.
case MQ_EST_WR of
    // Estado 0
    // Caso estiver sem comando (1) zera tag para garantir integridade.
    0:

//******************************************************************************
// Estado 100
// Comando para enviar SETPOINT de Temperatura Ambiente
	100:
		  // VERIFICA O MODELO DO CONTROLADOR 1 - DIXELL E 2 - FULLGAUGE
		  IF MAP = 1 THEN
		      COM_DRIXELL.SP_TEMP := CMD_WR[ID_CTRL].VALOR_SP_TEMP;
		      FIM := 2;
		  END_IF;
		  IF MAP = 2 THEN
		      COM_FULL.SP_TA      := CMD_WR[ID_CTRL].VALOR_SP_TEMP;
		      FIM := 2;
		  END_IF;
          // ENVIA COMANDO PELO CANAL DE MAPEAMENTO
          HILS.COMM_NOTIFY_ITEM(1, W_CACHE);
          // Vai para o estado 101
          MQ_EST_WR     := 101;
          // Zera Timeout de envio de comando
          CMD_TON[0](  // TON
                       IN := false);

    // Estado 101
    // Aguarda finalização do envio do comando
	101:
          // Caso acuse falha (Após 3 tentativas) Retorna código deFalha para
          // o supervisório zera comando e vai para o estado 1000
		  if FALHA_COM then
		            CMD_WR[ID_CTRL].RESULT  := WR_ERR; // falha de comunicação
					CMD_WR[ID_CTRL].SP_TEMP := 0;
					FALHA_COM				:= false;
					MQ_EST_WR				:= 1000;
          // Caso acuse sucesso Retorna códido de sucesso para o supervisório
          // zera comando e vai para o estado 1000
          elsif SUCES_COM then
			        CMD_WR[ID_CTRL].RESULT  := 0; // falha de comunicação
					CMD_WR[ID_CTRL].SP_TEMP := 0;
                    SUCES_COM               := false;
					MQ_EST_WR				:= 1000;
          // Caso ocorra falha no envio do comando e a quantidade de tentativas
          // ainda é menor que 3 vai para o estado 100 para reenviar comando
          elsif ENVIA_COMANDO then
                    MQ_EST_WR			    := 100;
                    ENVIA_COMANDO           := false;
          end_if;
          // Iniciando temporização de estouro sem resposta do bloco de comunicação
          CMD_TON[0](  // TON
                     IN := true,  // [BOOL] Entrada de habilitação da temporização
                     PT := T#2S   // [TIME] Tempo de atraso para ligar
                     );
          // caso haja o estouro sem resposta volta para o estado 100 para reenviar o comando
          if CMD_TON[0].Q then
                    MQ_EST_WR			    := 100;
          end_if;
//******************************************************************************
// Estado 200
// COMANDO PARA ENVIAR VALOR DE SP DE TEMPERATURA DO EVAPORADOR (PARA FULLGAUGE) OU
// UMIDADE (PARA DRIXELL)
	200:
		  // VERIFICA O MODELO DO CONTROLADOR 1 - DIXELL E 2 - FULLGAUGE
		  IF MAP = 1 THEN
		      COM_DRIXELL.SP_UMID := CMD_WR[ID_CTRL].VALOR_SP_PROC;
		      FIM := 2;
		  END_IF;
		  IF MAP = 2 THEN
		      COM_FULL.SP_EV      := CMD_WR[ID_CTRL].VALOR_SP_PROC;
		      FIM := 2;
		  END_IF;
          // ENVIA COMANDO PELO CANAL DE MAPEAMENTO
          HILS.COMM_NOTIFY_ITEM(2, W_CACHE);
          // Vai para o estado 201
          MQ_EST_WR     := 201;
          // Zera Timeout de envio de comando
          CMD_TON[1](  // TON
                       IN := false);

    // Estado 201
    // Aguarda finalização do envio do comando
	201:
          // Caso acuse falha (Após 3 tentativas) Retorna código deFalha para
          // o supervisório zera comando e vai para o estado 1000
		  if FALHA_COM then
			        CMD_WR[ID_CTRL].RESULT  := WR_ERR; // falha de comunicação
					CMD_WR[ID_CTRL].SP_PROC := 0;
					FALHA_COM				:= false;
					MQ_EST_WR				:= 1000;
          // Caso acuse sucesso Retorna códido de sucesso para o supervisório
          // zera comando e vai para o estado 1000
     	  elsif SUCES_COM then
			        CMD_WR[ID_CTRL].RESULT  := 0; // falha de comunicação
					CMD_WR[ID_CTRL].SP_PROC := 0;
                    SUCES_COM               := false;
					MQ_EST_WR				:= 1000;
          // Caso ocorra falha no envio do comando e a quantidade de tentativas
          // ainda é menor que 3 vai para o estado 100 para reenviar comando
          elsif ENVIA_COMANDO then
                    MQ_EST_WR			    := 200;
                    ENVIA_COMANDO           := false;
          end_if;
               // Iniciando temporização de estouro sem resposta do bloco de comunicação
          CMD_TON[1](  // TON
                     IN := true,  // [BOOL] Entrada de habilitação da temporização
                     PT := T#2S   // [TIME] Tempo de atraso para ligar
                     );
          // caso haja o estouro sem resposta volta para o estado 100 para reenviar o comando
          if CMD_TON[1].Q then
                    MQ_EST_WR			    := 200;
          end_if;
//******************************************************************************
// Estado 300
// COMANDO PARA FORÇAR DEGELO
	300:
          // VERIFICA O MODELO DO CONTROLADOR 1 - DIXELL E 2 - FULLGAUGE
          IF MAP = 1 THEN    // Dixell
                     COM_DRIXELL.COMANDO := 514;
                     // ENVIA COMANDO PELO CANAL DE MAPEAMENTO
                     HILS.COMM_NOTIFY_ITEM(3, W_CACHE);
                     FIM                 := 2;
                     MQ_EST_WR		     := 310;
                     CMD_EXEC[0]         := 0;
          END_IF;
          IF MAP = 2 THEN  // FullGauge
                     COM_FULL.HAB_TEST   := 1;
                     HILS.COMM_NOTIFY_ITEM(3, W_CACHE);
                     FIM                 := 1;
                     MQ_EST_WR           := 301;
                     CMD_EXEC[0]         := 1;
          END_IF;
          // reseta temporizador
          T_DEGELO(IN := FALSE);
          // Zera Timeout de envio de comando
          CMD_TON[2](  // TON
                       IN := false);
          count := count+1;
// Estado 301
// Aguarda tempo para enviar o segundo comando quando for Controlador
// Fullgauge
    301:
          T_DEGELO(  // TON
              IN := TRUE,  // [BOOL] Entrada de habilitação da temporização
              PT := TEMPO_CMD   // [TIME] Tempo de atraso para ligar
              );
          IF T_DEGELO.Q THEN
              COM_FULL.DEGELO     := 1;
              HILS.COMM_NOTIFY_ITEM(4, W_CACHE);
              FIM := 2;
              MQ_EST_WR           := 310;
              CMD_EXEC[0]         := 0;
          END_IF;
// Estado 310
// Aguarda resultado do comando enviado
    310:
          // Caso acuse falha (Após 3 tentativas) Retorna código deFalha para
          // o supervisório zera comando e vai para o estado 1000
		  if FALHA_COM then
			        CMD_WR[ID_CTRL].RESULT  := WR_ERR; // falha de comunicação
					CMD_WR[ID_CTRL].DEGELO  := 0;
					FALHA_COM				:= false;
					MQ_EST_WR				:= 1000;
          // Caso acuse sucesso Retorna códido de sucesso para o supervisório
          // zera comando e vai para o estado 1000
     	  elsif SUCES_COM then
			        CMD_WR[ID_CTRL].RESULT  := 0; // falha de comunicação
                    CMD_WR[ID_CTRL].DEGELO  := 0;
                    MQ_EST_WR			    := 1000;
                    SUCES_COM               := false;
          // Caso ocorra falha no envio do comando e a quantidade de tentativas
          // ainda é menor que 3 vai para o estado 100 para reenviar comando
          elsif ENVIA_COMANDO or CMD_TON[2].Q then
                    MQ_EST_WR	  := 300;
                    ENVIA_COMANDO := false;
          end_if;
          // Iniciando temporização de estouro sem resposta do bloco de comunicação
          CMD_TON[2](  // TON
                   IN := true,  // [BOOL] Entrada de habilitação da temporização
                   PT := T#2S   // [TIME] Tempo de atraso para ligar
                   );
//******************************************************************************
// Estado 400
// COMANDO PARA PARARRR FORÇAR DEGELO
// (SOMENTE PARA O CONTROLADOR FULLGAUGE)
	400:
          COM_FULL.HAB_TEST   := 0;
          HILS.COMM_NOTIFY_ITEM(3, W_CACHE);
          FIM                 := 1;
          MQ_EST_WR           := 401;
          CMD_EXEC[1]         := 1;
          // Zera Timeout de envio de comando
          CMD_TON[3](  // TON
                       IN := false);
          T_DEGELO_PARAR(IN := FALSE);
// Estado 401
// Aguarda tempo para enviar o segundo comando quando for Controlador
// Fullgauge
    401:
          T_DEGELO_PARAR(  // TON
              IN := TRUE,  // [BOOL] Entrada de habilitação da temporização
              PT := TEMPO_CMD   // [TIME] Tempo de atraso para ligar
              );
          IF T_DEGELO_PARAR.Q THEN
              COM_FULL.DEGELO     := 0;
              HILS.COMM_NOTIFY_ITEM(4, W_CACHE);
              FIM := 2;
              MQ_EST_WR           := 410;
              CMD_EXEC[1]         := 0;
          END_IF;
// Estado 410
// Aguarda resultado do comando enviado
    410:
          // Caso acuse falha (Após 3 tentativas) Retorna código deFalha para
          // o supervisório zera comando e vai para o estado 1000
		  if FALHA_COM then
			        CMD_WR[ID_CTRL].RESULT        := WR_ERR; // falha de comunicação
					CMD_WR[ID_CTRL].PARAR_DEGELO  := 0;
					FALHA_COM				      := false;
					MQ_EST_WR				      := 1000;
          // Caso acuse sucesso Retorna códido de sucesso para o supervisório
          // zera comando e vai para o estado 1000
     	  elsif SUCES_COM then
			        CMD_WR[ID_CTRL].RESULT        := 0; // falha de comunicação
                    CMD_WR[ID_CTRL].PARAR_DEGELO  := 0;
                    MQ_EST_WR				      := 1000;
                    SUCES_COM                     := false;
          // Caso ocorra falha no envio do comando e a quantidade de tentativas
          // ainda é menor que 3 vai para o estado 100 para reenviar comando
          elsif ENVIA_COMANDO or CMD_TON[3].Q then
                    MQ_EST_WR	  := 400;
                    ENVIA_COMANDO := false;
          end_if;
          // Iniciando temporização de estouro sem resposta do bloco de comunicação
          CMD_TON[3](  // TON
                       IN := true,  // [BOOL] Entrada de habilitação da temporização
                       PT := T#2S   // [TIME] Tempo de atraso para ligar
                       );
//******************************************************************************
// Estado 500
// COMANDO PARA LIGAR CONTROLADOR
	500:
          // VERIFICA O MODELO DO CONTROLADOR 1 - DIXELL E 2 - FULLGAUGE
          IF MAP = 1 THEN
                     COM_DRIXELL.COMANDO := 257;
                     // ENVIA COMANDO PELO CANAL DE MAPEAMENTO
                     HILS.COMM_NOTIFY_ITEM(3, W_CACHE);
                     FIM := 2;
                     MQ_EST_WR		     := 510;
                     CMD_EXEC[2]         := 0;
          END_IF;
          IF MAP = 2 THEN  // FullGauge
                     COM_FULL.T_DESL     := 1;
                     HILS.COMM_NOTIFY_ITEM(6, W_CACHE);
                     FIM                 := 1;
                     MQ_EST_WR           := 501;
                     CMD_EXEC[2]         := 1;
          END_IF;

          // Zera Timeout de envio de comando
          CMD_TON[4](  // TON
                       IN := false);
          T_LIGA(IN := FALSE);
// Estado 501
// Aguarda tempo para enviar o segundo comando quando for Controlador
// Fullgauge
    501:
          T_LIGA(  // TON
                   IN := TRUE,  // [BOOL] Entrada de habilitação da temporização
                   PT := TEMPO_CMD   // [TIME] Tempo de atraso para ligar
                   );
          IF T_LIGA.Q THEN
                   SUCES_COM        := false;
                   COM_FULL.AC_DESL := 0;
                   HILS.COMM_NOTIFY_ITEM(7, W_CACHE);
                   FIM              := 2;
                   MQ_EST_WR        := 510;
                   CMD_EXEC[2]      := 0;
          END_IF;


// Estado 510
// Aguarda resultado do comando enviado
    510:
          // Caso acuse falha (Após 3 tentativas) Retorna código deFalha para
          // o supervisório zera comando e vai para o estado 1000
		  if FALHA_COM then
			        CMD_WR[ID_CTRL].RESULT        := WR_ERR; // falha de comunicação
					CMD_WR[ID_CTRL].LIGAR         := 0;
                    CMD_WR[ID_CTRL].LIGAR_PH      := 0;
					FALHA_COM				      := false;
					MQ_EST_WR				      := 1000;
          // Caso acuse sucesso Retorna códido de sucesso para o supervisório
          // zera comando e vai para o estado 1000
     	  elsif SUCES_COM then
			        CMD_WR[ID_CTRL].RESULT   := 0; // falha de comunicação
                    CMD_WR[ID_CTRL].LIGAR    := 0;
                    CMD_WR[ID_CTRL].LIGAR_PH := 0;
                    MQ_EST_WR			     := 1000;
                    SUCES_COM                := false;
          // Caso ocorra falha no envio do comando e a quantidade de tentativas
          // ainda é menor que 3 vai para o estado 100 para reenviar comando
          elsif ENVIA_COMANDO or CMD_TON[4].Q then
                    MQ_EST_WR	  := 500;
                    ENVIA_COMANDO := false;
          end_if;
          // Iniciando temporização de estouro sem resposta do bloco de comunicação
          CMD_TON[4](  // TON
                       IN := true,  // [BOOL] Entrada de habilitação da temporização
                       PT := T#2S   // [TIME] Tempo de atraso para ligar
                       );
//******************************************************************************
// Estado 600
// COMANDO PARA DESLIGAR CONTROLADOR
	600:
          // VERIFICA O MODELO DO CONTROLADOR 1 - DIXELL E 2 - FULLGAUGE
          IF MAP = 1 THEN
                     COM_DRIXELL.COMANDO := 1;
                     // ENVIA COMANDO PELO CANAL DE MAPEAMENTO
                     HILS.COMM_NOTIFY_ITEM(3, W_CACHE);
                     FIM := 2;
                     MQ_EST_WR		     := 610;
                     CMD_EXEC[3]         := 0;
          END_IF;
          IF MAP = 2 THEN  // FullGauge
                     COM_FULL.T_DESL     := 1;
                     HILS.COMM_NOTIFY_ITEM(6, W_CACHE);
                     FIM                 := 1;
                     MQ_EST_WR           := 601;
                     CMD_EXEC[3]         := 1;
          END_IF;

          // Zera Timeout de envio de comando
          CMD_TON[5](  // TON
                       IN := false);
          T_DESLIGA(IN := FALSE);
// Estado 601
// Aguarda tempo para enviar o segundo comando quando for Controlador
// Fullgauge
    601:
          T_DESLIGA(  // TON
              IN := TRUE,  // [BOOL] Entrada de habilitação da temporização
              PT := TEMPO_CMD   // [TIME] Tempo de atraso para ligar
              );
          IF T_DESLIGA.Q THEN
              COM_FULL.AC_DESL := 10;
              HILS.COMM_NOTIFY_ITEM(7, W_CACHE);
              FIM              := 2;
              MQ_EST_WR        := 610;
              CMD_EXEC[3]      := 0;
          END_IF;
// Estado 610
// Aguarda resultado do comando enviado
    610:
          T_DESLIGA(IN := FALSE);
          // Caso acuse falha (Após 3 tentativas) Retorna código deFalha para
          // o supervisório zera comando e vai para o estado 1000
		  if FALHA_COM then
			        CMD_WR[ID_CTRL].RESULT        := WR_ERR; // falha de comunicação
					CMD_WR[ID_CTRL].DESLIGAR      := 0;
                    CMD_WR[ID_CTRL].DESLIGAR_PH   := 0;
					FALHA_COM				      := false;
					MQ_EST_WR				      := 1000;
          // Caso acuse sucesso Retorna códido de sucesso para o supervisório
          // zera comando e vai para o estado 1000
     	  elsif SUCES_COM then
			        CMD_WR[ID_CTRL].RESULT      := 0; // falha de comunicação
                    CMD_WR[ID_CTRL].DESLIGAR_PH := 0;
                    CMD_WR[ID_CTRL].DESLIGAR    := 0;
                    MQ_EST_WR			        := 1000;
                    SUCES_COM                   := false;
          // Caso ocorra falha no envio do comando e a quantidade de tentativas
          // ainda é menor que 3 vai para o estado 100 para reenviar comando
          elsif ENVIA_COMANDO or CMD_TON[5].Q then
                    MQ_EST_WR	  := 600;
                    ENVIA_COMANDO := false;
          end_if;
          // Iniciando temporização de estouro sem resposta do bloco de comunicação
          CMD_TON[5](  // TON
                       IN := true,  // [BOOL] Entrada de habilitação da temporização
                       PT := T#2S   // [TIME] Tempo de atraso para ligar
                       );
//******************************************************************************
// Estado 700
// COMANDO PARA ENVIAR INTERVALO DE DEGELO EM MINUTOS para FULLGAUGE
	700:
          COM_FULL.INT_DEGELO   := CMD_WR[ID_CTRL].VALOR_INT_DEGELO;
          HILS.COMM_NOTIFY_ITEM(5, W_CACHE);
          // Vai para o estado 701
          MQ_EST_WR     := 701;
          // Zera Timeout de envio de comando
          CMD_TON[6](  // TON
                       IN := false);

    // Estado 701
    // Aguarda finalização do envio do comando
	701:
          // Caso acuse falha (Após 3 tentativas) Retorna código deFalha para
          // o supervisório zera comando e vai para o estado 1000
		  if FALHA_COM then
		            CMD_WR[ID_CTRL].RESULT     := WR_ERR; // falha de comunicação
					CMD_WR[ID_CTRL].INT_DEGELO := 0;
					FALHA_COM				   := false;
					MQ_EST_WR				   := 1000;
          // Caso acuse sucesso Retorna códido de sucesso para o supervisório
          // zera comando e vai para o estado 1000
          elsif SUCES_COM then
			        CMD_WR[ID_CTRL].RESULT     := 0; // falha de comunicação
					CMD_WR[ID_CTRL].INT_DEGELO := 0;
                    SUCES_COM                  := false;
					MQ_EST_WR				   := 1000;
          // Caso ocorra falha no envio do comando e a quantidade de tentativas
          // ainda é menor que 3 vai para o estado 700 para reenviar comando
          elsif ENVIA_COMANDO then
                    MQ_EST_WR			    := 700;
                    ENVIA_COMANDO           := false;
          end_if;
          // Iniciando temporização de estouro sem resposta do bloco de comunicação
          CMD_TON[6](  // TON
                     IN := true,  // [BOOL] Entrada de habilitação da temporização
                     PT := T#2S   // [TIME] Tempo de atraso para ligar
                     );
          // caso haja o estouro sem resposta volta para o estado 100 para reenviar o comando
          if CMD_TON[6].Q then
                    MQ_EST_WR			    := 700;
          end_if;
    // Estado 1000
    // Fim do tratamento de comando com erro ou sucesso
	1000:
          // Seta a flag cado tenha sucesso na execução da escrita do comando
          END_CMD_WR_OK := (CMD_WR[ID_CTRL].RESULT = 0);
          // Volta para o estado 0
          MQ_EST_WR := 0;
end_case;


// No fim de cada ciclo de leitura
IF CTRL_MDB.END_CYC THEN
// Verifica se houve uma escrita de comando no controlador de temperatura
    IF (END_CMD_WR_OK = true) then
// Executa função para retornar qual é o controlador de temperatura anterior a ele que está
// Habilitadop e com modelo de controlar correto
// Seta o valor desse controlador para o próximo ID a ser lido, dessa forma força a ler o ID anterior
// e logo depois ler o controlador com ID da escrita realizada, isso parfa dar tempo
// do coamndo ser processado pelo controlador e poder atualizar mais depressa
// o Statusno supervisório.
         ID_CTRL       := GET_PREV_ENA(ID_CTRL);
         END_CMD_WR_OK := false;
    ELSE
// caso não tenha vindo de um comando anterior calcula o checksun da base de comandos
         CRC_CMD_CALC :=  HILS.DATA_CRC16(CMD_WR);
// Caso seja diferente do último cálculo realizado
// Chama a função  CHK_CMD_WR para verificar se há algum comando pendente a ser
// Executado
// Atualiza CRC calculado
         IF (CRC_CMD <> CRC_CMD_CALC) THEN
            ID_CMD_WR := CHK_CMD_WR();
            CRC_CMD   := CRC_CMD_CALC;
         ELSE
// Caso não haja comando seta o valor 255 para o ID de escrita
            ID_CMD_WR := 255;
         END_IF;
// Se o ID de escrita for diferente de 255 indica que há comando então vai para o ID do controlador com comando a ser realizado.
         IF ID_CMD_WR <> 255 THEN
            ID_CTRL := ID_CMD_WR;
         END_IF;
    END_IF;
END_IF;


// INCREMENTA O ID DA REMOTA SEMPRE AO FINAL DO CICLO DO BLOCO MODBUS
// Ou se houver falha de comunicação com o controlador atual seta aflag Troca que irpá trocar ID do controlador
// Para a troca do ID a máquina de estado de escrita de coamndo deve estar no Estado 0
// ou seja, não executando comando.
// Se não encontrar um controlador de temperatura habilitado e com modelo correto
//  ID_CTRL = 255 fica varrendo base até ser configurado um controlador corretamente.
IF  (((CTRL_MDB.END_CYC OR TROCA) AND (MQ_EST_WR = 0) AND (ID_CMD_WR = 255)) OR
    (ID_CTRL = 255))
THEN
      ID_CTRL := GET_NEXT_ENA(ID_CTRL);
      TROCA   := FALSE;
END_IF;


// Inicia o bloco de comunicação.
// Inicializa dos IDX
IF NOT START THEN
   START     := TRUE;
   ID_CTRL   := GET_NEXT_ENA(19);
   ID_CMD_WR := 255;
END_IF;










