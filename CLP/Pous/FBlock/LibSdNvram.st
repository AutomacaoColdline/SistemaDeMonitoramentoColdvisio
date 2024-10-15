(* ============================================================================
 *                    PROJETO: Biblioteca HI Tecnologia
 *
 *   DESCRIÇÃO: Interface com sistema de arquivos
 *     CLIENTE: HI Tecnologia
 * RESPONSAVEL: Eng. de Aplicação da HI TECNOLOGIA
 *
 * =============================================================================
 *
 *   DESCRIÇÃO: Salva dados em arquivos no SDCARD.
 *
 * ============================================================================
 *)

(*
 ******************************************************************************
 ******************************************************************************

  Utilização do bloco FS_RECIPE para salvar dados da aplicação que deveriam ser
  preservados em NVRAM do PLC, serem preservados em arquivo de dados no SDCARD

 ******************************************************************************
 ******************************************************************************

 Opções de comandos para ler/escerver os dados da aplicação no SDCARD
 utilizando o SDCARD para salvar dados retentivos simulando uma NVRAM.

 OBS: Na inicialização é executado o comando CHECK = 2. Assim, caso não
 exista um arquivo '/NvXXXXX.dat', um novo arquivo é criado. Ao fim
 do processo de inicialização, realiza o processamento dos dados.

 ******************************************************************************
 *)

(*
 ******************************************************************************
 ******************************************************************************

           Maquina de Estado 1: POWERUP e SYSTEM COMMAND

 ******************************************************************************
 ******************************************************************************
 *)

//---------------------------------------------------------------------------
//---------------------------------------------------------------------------
// Maquina de estado POWERUP para arquivos NVRAM salvos no File System
//---------------------------------------------------------------------------
// Esta maquina de estado realiza os seguintes tratamentos:
//
//    1> No POWERUP do controlador realiza a letiura dos seguintes arquivos
//       que estão armazenados no SDCARD:
//         . Arquivo de dados de File 0
//         . Arquivo de dados de File 1
//         . Arquivo de dados de File 2
//
//    2> Ao término do POWERUP do controlador fica aguardando comandos
//       para salvar os dados dos mesmos arquivos que estão armazenados
//       no SDCARD:
//         . Arquivo de dados de File 0
//         . Arquivo de dados de File 1
//         . Arquivo de dados de File 2
//
//---------------------------------------------------------------------------
//---------------------------------------------------------------------------

//##############################################################################
// Estados para tratamento do arquivo em NVRAM
//##############################################################################

//---------------------------------------------------------------------------
// Estado INICIAL: Checar se arquivo Dados CORRENTE NVRAM existe. Se não existe cria-o
//---------------------------------------------------------------------------
// Arquivo de dados: File 0
//---------------------------------------------------------------------------
if (LOC_WAPP.STATE_POWERUP = 0) and (LOC_XAPP.POWERUP_OK) then

  // Apenas por segurança, aguarda tempo minimal inicial antes de iniciar o
  // acesso ao sistema de arquivo do controlador
  if (TICK_1S.EV) then

  {IFDEF SD_FILE_0}  // Se habilitado arquivo File 0 no SDCARD
    // Inicializa verificando se arquivo de NVRAM Data não existe, para
    // criar um arquivo com 1 receita, representando os dados da NVRAM
    PUB_WNVR.CMD_SD_NV_FILE[0] := SD_NVRAM_CMD_CHECK_E;
    // Proximo estado
    LOC_WAPP.STATE_POWERUP := 10;
  {ENDIF} // {SD_FILE_0}

  {IFNDEF SD_FILE_0}  // Se NÃO habilitado arquivo File 0 no SDCARD
    // Proximo estado
    LOC_WAPP.STATE_POWERUP := 1000;
  {ENDIF} // {SD_FILE_0}

  end_if;

//---------------------------------------------------------------------------
// Estado: Aguarda checar se arquivo File 0 NVRAM existe, para solicitar sua leitura
//---------------------------------------------------------------------------
// Arquivo de dados File 0 NVRAM
//---------------------------------------------------------------------------

//=.= =.= =.= =.= =.= =.= =.= =.= =.= =.= =.= =.= =.= =.= =.= =.= =.= =.= =.= =
{IFDEF SD_FILE_0}  // Se habilitado arquivo no SDCARD
//=.= =.= =.= =.= =.= =.= =.= =.= =.= =.= =.= =.= =.= =.= =.= =.= =.= =.= =.= =

elsif (LOC_WAPP.STATE_POWERUP = 10) then

  // Aguarda fim da checagem se arquivo de nvram existe
  if (SD_NVRAM_END = true) // já finalizou o tratamento do comando
  then
    // Solicita leitura do arquivo de dados salvo no sdcard
    PUB_WNVR.CMD_SD_NV_FILE[0] := SD_NVRAM_CMD_READ_E;
    // Proximo estado
    LOC_WAPP.STATE_POWERUP := 20;
  end_if;

//---------------------------------------------------------------------------
// Estado: Aguarda leitura do arquivo de dados File 0 do sdcard
//---------------------------------------------------------------------------
// Arquivo de dados: File 0 NVRAM
//---------------------------------------------------------------------------
elsif (LOC_WAPP.STATE_POWERUP = 20) then

  // Aguarda ler o arquivo de dados nvram existente no sdcard
  if (SD_NVRAM_END = true) // já finalizou o tratamento do comando
  then
     // Proximo estado
     LOC_WAPP.STATE_POWERUP := 30;
  end_if;

//---------------------------------------------------------------------------
// Estado: Avalia dados File 0 NVRAM lidos do sdcard
//---------------------------------------------------------------------------
// Arquivo de dados: File 0 NVRAM
//---------------------------------------------------------------------------
elsif (LOC_WAPP.STATE_POWERUP = 30) then

   // Salva o valor do CRC lido do arquivo
   AUX_CRC1 := PUB_WNVR.FILE_0.CRC;
   // Força zerar o CRC para calcular o CRC da base desta estrutura de dados
   PUB_WNVR.FILE_0.CRC := 0;
   AUX_CRC2 := HILS.DATA_CRC16(PUB_WNVR.FILE_0);
   PUB_WNVR.FILE_0.CRC := AUX_CRC1;             // restaura valor lido do CRC do arquivo

   // Testa se os dados lidos do arquivo NVRAM são VALIDOS, Se forem mantem os
   // valores lidos do arquivo como sendo dados validos em NVRAM, caso contrario,
   // sendo dados INVALIDOS, inicializa a respectiva base de dados em NVRAM
   //
      // Testa se CRC da estrutura de dados salva no arquivo é valida
   if (AUX_CRC1 <> AUX_CRC2) or             // CRC INVALIDO
      // Testa a data da ultima analise salva no arquivo NVRAM do sdcard é VALIDA
      (PUB_WNVR.FILE_0.ANO < ANO_VALIDO)    // Ano INVALIDO
   then
     // Dados lidos do arquivo no sdcard são INVALIDOS, NÃO pode utilizar estes dados
     // Reseta ou Inicializa dados da base NVRAM
     //
     HILS.DATA_CLEAR(PUB_WNVR.FILE_0);

     // OS campos abaixo já foram zerados atraves do comando acima
     //
     //PUB_WNVR.FILE_0.DIA := 0;
     //PUB_WNVR.FILE_0.MES := 0;
     //PUB_WNVR.FILE_0.ANO := 0;
     //PUB_WNVR.FILE_0.HOR := 0;
     //PUB_WNVR.FILE_0.MIN := 0;
     //PUB_WNVR.FILE_0.SEG := 0;

     // Contador de execução neste estado da maquina de estado
     INC_INT(DEB_SD_NVRAM[0]);

   end_if;

   // Determina o ultimo DIA que salvou os dados no arquivo na NVRAM para
   // detectar proxima mudança de DIA, visando salvar dados no arquivo
   //
      // Testa se CRC da estrutura de dados é valida
   if (AUX_CRC1 = AUX_CRC2) and
     // Testa a data da ultima analise salva no arquivo NVRAM do sdcard é VALIDA
     (PUB_WNVR.FILE_0.ANO >= ANO_VALIDO)
     //
     // OBS.: Não podemos testar o RTC do PLC, pois se o mesmo estiver sem
     //       bateria, no power-up vai entrar o RTC default, e desta forma
     //       invalidarai os dados lidos do sdcard
     //
     // // RTC do PLC é valida
     // and (LOC_XAPP.STS_INV_RTC = false)
     // // É a mesma DATA salva no SDCARD e no RTC do PLC
     // and (PUB_WNVR.FILE_0.DIA = LOC_WAPP.RTC_DIA)
     // and (PUB_WNVR.FILE_0.MES = LOC_WAPP.RTC_MES)
     //     (PUB_WNVR.FILE_0.ANO = LOC_WAPP.RTC_ANO)
   then
     // Data dos dados no arquivo no sdcard VALIDA, pode utilizar estes dados
     // mantem os dados lidos do arquivo como sendo os dados da NVRAM

     // Inicializa o ultimo dia do RTC para detectar transição de dia
     // com o dia lido do arquivo do sdcard
     LOC_WAPP.OLD_CUR_DAY := PUB_WNVR.FILE_0.DIA;
     LOC_WAPP.OLD_CUR_MIN := PUB_WNVR.FILE_0.MIN;

     // Contador de execução neste estado da maquina de estado
     INC_INT(DEB_SD_NVRAM[1]);

   else
     // Data dos dados no arquivo no sdcard INVALIDA, NÃO pode utilizar estes dados
     // Reseta codigo do ultimo dia do RTC para detectar transição de dia
     LOC_WAPP.OLD_CUR_DAY := 0;
     LOC_WAPP.OLD_CUR_MIN := 0;

     // Inicializa valores dos historicos de limites minimos e maximos de temperatura
     for J := 0 TO (MAX_EQP - 1) DO
       // Inicializa valores do novo dia com a temperatura atual
       PUB_WNVR.FILE_0.TEMP_MIN_DIA[J] := 0;
       PUB_WNVR.FILE_0.TEMP_MAX_DIA[J] := 0;
     end_for;

     // Contador de execução neste estado da maquina de estado
     INC_INT(DEB_SD_NVRAM[2]);
   end_if;

   // Transfere os valores dos dados lidos do SDCARD para a estrutura
   // de dados da aplicação

   // Copia valores dos historicos de limites minimos e maximos de temperatura
   // diarios lidos do sdcard para a base de dados da aplicação
   for J := 0 TO (MAX_EQP - 1) do
     // Inicializa valores do novo dia com a temperatura atual
     PUB_WAPP.BASE[J].TEMP_MIN_DIA := PUB_WNVR.FILE_0.TEMP_MIN_DIA[J];
     PUB_WAPP.BASE[J].TEMP_MAX_DIA := PUB_WNVR.FILE_0.TEMP_MAX_DIA[J];
   end_for;

   // Se existe uma DATA e HORA valida salva no arquivo NVRAM, e o RTC do PLC
   // é INVALIDA, então programa o RTC do PLC com  esta data e hora valida lida
   // do arquivo NVRAM
   //
      // Testa se CRC da estrutura de dados é valida
   if (AUX_CRC1 = AUX_CRC2) and
     // Testa a data da ultima analise salva no arquivo NVRAM do sdcard é VALIDA
     (PUB_WNVR.FILE_0.ANO >= ANO_VALIDO) and
     // RTC do PLC é INVALIDA
     (LOC_XAPP.STS_INV_RTC = true)
   then
        // Como a data e hora do PLC é invalida, apenas como medida provisória,
        // utiliza a ultima data e hora salva no arquivo do sdcard como
        // data e hora inicial do PLC, pois pelo menos os próximos dados publicados
        // para o portal de telemetria serão logados com uma data e hora com
        // sequencia temporal valida para o portal de telemetria, e desta forma
        // impedindo que estes dados sejam descartados devido uma data inválida,
        // "anterior" aos dados já existentes no portal.

        // F50 = Segundo corrente do equipamento (0..59)
        HILS.SET_SYSVAR(50, PUB_WNVR.FILE_0.SEG);
        // F51 = Minuto corrente do equipamento (0..59)
        HILS.SET_SYSVAR(51, PUB_WNVR.FILE_0.MIN);
        // F52 = Hora corrente do equipamento (0..23)
        HILS.SET_SYSVAR(52, PUB_WNVR.FILE_0.HOR);
        // F53 = Dia corrente do equipamento (1..31)
        HILS.SET_SYSVAR(53, PUB_WNVR.FILE_0.DIA);
        // F54 = Mês corrente do equipamento (1..12)
        HILS.SET_SYSVAR(54, PUB_WNVR.FILE_0.MES);
        // F55 = Ano corrente do equipamento (ex:2015)
        HILS.SET_SYSVAR(55, PUB_WNVR.FILE_0.ANO);
        // F57 = Programa o relógio com os valores previamente escritos nas variaveis F50..F55.
        //       O valor a ser escrito nesta memória deve ser 12345. Qualquer valor diferente
        //       deste é ignorado e a escrita não é realizada.
        HILS.SET_SYSVAR(57, 12345);

        // Inicializa codigo do ultimo dia do RTC para detectar transição de dia
        // com o dia lido do arquivo do sdcard
        LOC_WAPP.OLD_CUR_DAY := PUB_WNVR.FILE_0.DIA;
        LOC_WAPP.OLD_CUR_MIN := PUB_WNVR.FILE_0.MIN;

       // Contador de execução neste estado da maquina de estado
       INC_INT(DEB_SD_NVRAM[3]);

   end_if;

   LOC_WAPP.STATE_POWERUP := 40;

//---------------------------------------------------------------------------
// Estado: Finaliza processo de inicialização da leitura File 0 NVRAM
//---------------------------------------------------------------------------
// Arquivo de dados: File 0 NVRAM
//---------------------------------------------------------------------------
elsif (LOC_WAPP.STATE_POWERUP = 40) then

     // Proximo estado
     LOC_WAPP.STATE_POWERUP := 1000;


//=.= =.= =.= =.= =.= =.= =.= =.= =.= =.= =.= =.= =.= =.= =.= =.= =.= =.= =.= =
{ENDIF} //{SD_FILE_0}  // Se habilitado arquivo de File_0 SDCARD
//=.= =.= =.= =.= =.= =.= =.= =.= =.= =.= =.= =.= =.= =.= =.= =.= =.= =.= =.= =





//##############################################################################
// Estados para tratamento do arquivo: File_1 NVRAM
//##############################################################################


//---------------------------------------------------------------------------
// Estado INICIAL: Checar se arquivo Dados File_1 NVRAM existe. Se não existe cria-o
//---------------------------------------------------------------------------
// Arquivo de dados: File_1 NVRAM
//---------------------------------------------------------------------------
elsif (LOC_WAPP.STATE_POWERUP = 1000) then

  {IFDEF SD_FILE_1}  // Se habilitado arquivo no SDCARD
    // Apenas por segurança, aguarda tempo minimal inicial antes de iniciar um
    // novo acesso ao sistema de arquivo do controlador
    if (TICK_1S.EV) then
      // Inicializa verificando se arquivo de NVRAM Data não existe, para
      // criar um arquivo com 1 receita, representando os dados da NVRAM
      PUB_WNVR.CMD_SD_NV_FILE[1] := SD_NVRAM_CMD_CHECK_E;
      // Proximo estado
      LOC_WAPP.STATE_POWERUP := 1010;
    end_if;
  {ENDIF} // {SD_FILE_1}  // Se habilitado arquivo no SDCARD

  {IFNDEF SD_FILE_1}  // Se NÃO habilitado arquivo no SDCARD
    // Proximo estado
    LOC_WAPP.STATE_POWERUP := 2000;
  {ENDIF} // {SD_FILE_1}  // Se habilitado arquivo no SDCARD

//---------------------------------------------------------------------------
// Estado: Aguarda checar se arquivo existe, para solicitar sua leitura
//---------------------------------------------------------------------------
// Arquivo de dados File 1 NVRAM
//---------------------------------------------------------------------------

//=.= =.= =.= =.= =.= =.= =.= =.= =.= =.= =.= =.= =.= =.= =.= =.= =.= =.= =.= =
{IFDEF SD_FILE_1}  // Se habilitado arquivo no SDCARD
//=.= =.= =.= =.= =.= =.= =.= =.= =.= =.= =.= =.= =.= =.= =.= =.= =.= =.= =.= =

elsif (LOC_WAPP.STATE_POWERUP = 1010) then

  // Aguarda fim da checagem se arquivo de nvram existe
  if (SD_NVRAM_END = true) // já finalizou o tratamento do comando
  then
    // Solicita leitura do arquivo de dados salvo no sdcard
    PUB_WNVR.CMD_SD_NV_FILE[1] := SD_NVRAM_CMD_READ_E;
    // Proximo estado
    LOC_WAPP.STATE_POWERUP := 1020;
  end_if;

//---------------------------------------------------------------------------
// Estado: Aguarda leitura do arquivo de dados File 1 do sdcard
//---------------------------------------------------------------------------
// Arquivo de dados File 1 NVRAM
//---------------------------------------------------------------------------
elsif (LOC_WAPP.STATE_POWERUP = 1020) then

  // Aguarda ler o arquivo de dados nvram existente no sdcard
  if (SD_NVRAM_END = true) // já finalizou o tratamento do comando
  then
     // Proximo estado
     LOC_WAPP.STATE_POWERUP := 1030;
  end_if;

//---------------------------------------------------------------------------
// Estado: Avalia dados File 1 NVRAM lidos do sdcard
//---------------------------------------------------------------------------
// Arquivo de dados File 1 NVRAM
//---------------------------------------------------------------------------
elsif (LOC_WAPP.STATE_POWERUP = 1030) then

   // Salva o valor do CRC lido do arquivo
   AUX_CRC1 := PUB_WNVR.FILE_1.CRC;
   // Força zerar o CRC para calcular o CRC da base desta estrutura de dados
   PUB_WNVR.FILE_1.CRC := 0;
   AUX_CRC2 := HILS.DATA_CRC16(PUB_WNVR.FILE_1);
   PUB_WNVR.FILE_1.CRC := AUX_CRC1;             // restaura valor lido do CRC do arquivo

   // Testa se os dados lidos do arquivo NVRAM são VALIDOS, Se forem mantem os
   // valores lidos do arquivo como sendo dados validos em NVRAM, caso contrario,
   // sendo dados INVALIDOS, inicializa a respectiva base de dados em NVRAM
   //
      // Testa se CRC da estrutura de dados salva no arquivo é valida
   if (AUX_CRC1 <> AUX_CRC2) or       // CRC INVALIDO
      // Testa a data da ultima analise salva no arquivo NVRAM do sdcard é VALIDA
      (PUB_WNVR.FILE_1.ANO < ANO_VALIDO)    // Ano INVALIDO
   then

     // Dados lidos do arquivo no sdcard são INVALIDOS, NÃO pode utilizar estes dados
     // Reseta ou Inicializa dados da base NVRAM
     //
     HILS.DATA_CLEAR(PUB_WNVR.FILE_1);

     PUB_WNVR.FILE_1.DIA := 0;
     PUB_WNVR.FILE_1.MES := 0;
     PUB_WNVR.FILE_1.ANO := 0;
     PUB_WNVR.FILE_1.HOR := 0;
     PUB_WNVR.FILE_1.MIN := 0;
     PUB_WNVR.FILE_1.SEG := 0;

     // Contador de execução neste estado da maquina de estado
     INC_INT(DEB_SD_NVRAM[4]);

   end_if;

   // Transfere os valores dos dados lidos do SDCARD para a estrutura
   // de dados da aplicação

   PUB_RECEITA := PUB_WNVR.FILE_1.SD_RECEITA;

   // Se existe uma DATA e HORA valida salva no arquivo NVRAM, e o RTC do PLC
   // é INVALIDA, então programa o RTC do PLC com  esta data e hora valida lida
   // do arquivo NVRAM
   //
      // Testa se CRC da estrutura de dados é valida
   if (AUX_CRC1 = AUX_CRC2) and
     // Testa a data da ultima analise salva no arquivo NVRAM do sdcard é VALIDA
     (PUB_WNVR.FILE_1.ANO >= ANO_VALIDO) and
     // RTC do PLC é INVALIDA
     (PUB_XAPP.STS_INV_RTC = true)
   then
        // Utiliza a ultima data e hora salva no arquivo NVRAM do sdcard como
        // data e hora inicial do PLC

        // F50 = Segundo corrente do equipamento (0..59)
        HILS.SET_SYSVAR(50, PUB_WNVR.FILE_1.SEG);
        // F51 = Minuto corrente do equipamento (0..59)
        HILS.SET_SYSVAR(51, PUB_WNVR.FILE_1.MIN);
        // F52 = Hora corrente do equipamento (0..23)
        HILS.SET_SYSVAR(52, PUB_WNVR.FILE_1.HOR);
        // F53 = Dia corrente do equipamento (1..31)
        HILS.SET_SYSVAR(53, PUB_WNVR.FILE_1.DIA);
        // F54 = Mês corrente do equipamento (1..12)
        HILS.SET_SYSVAR(54, PUB_WNVR.FILE_1.MES);
        // F55 = Ano corrente do equipamento (ex:2015)
        HILS.SET_SYSVAR(55, PUB_WNVR.FILE_1.ANO);
        // F57 = Programa o relógio com os valores previamente escritos nas variaveis F50..F55.
        //       O valor a ser escrito nesta memória deve ser 12345. Qualquer valor diferente
        //       deste é ignorado e a escrita não é realizada.
        HILS.SET_SYSVAR(57, 12345);

       // Contador de execução neste estado da maquina de estado
       INC_INT(DEB_SD_NVRAM[5]);

   end_if;


   // Proximo estado
   LOC_WAPP.STATE_POWERUP := 2000; // Proximo estado


//=.= =.= =.= =.= =.= =.= =.= =.= =.= =.= =.= =.= =.= =.= =.= =.= =.= =.= =.= =
{ENDIF} //{SD_FILE_1}  // Se habilitado arquivo no SDCARD
//=.= =.= =.= =.= =.= =.= =.= =.= =.= =.= =.= =.= =.= =.= =.= =.= =.= =.= =.= =




//##############################################################################
// Estados para tratamento do arquivo File 2 NVRAM
//##############################################################################


//---------------------------------------------------------------------------
// Estado INICIAL: Checar se arquivo Dados File 2 NVRAM existe. Se não existe cria-o
//---------------------------------------------------------------------------
// Arquivo de dados File 2 NVRAM
//---------------------------------------------------------------------------
elsif (LOC_WAPP.STATE_POWERUP = 2000) then

  {IFDEF SD_FILE_2}  // Se habilitado arquivo no SDCARD
    // Apenas por segurança, aguarda tempo minimal inicial antes de iniciar um
    // novo acesso ao sistema de arquivo do controlador
    if (TICK_1S.EV) then
      // Inicializa verificando se arquivo de NVRAM Data não existe, para
      // criar um arquivo com 1 receita, representando os dados da NVRAM
      PUB_WNVR.CMD_SD_NV_FILE[2] := SD_NVRAM_CMD_CHECK_E;
      // Proximo estado
      LOC_WAPP.STATE_POWERUP := 2010;
    end_if;
  {ENDIF} // {SD_FILE_2}  // Se habilitado arquivo no SDCARD

  {IFNDEF SD_FILE_2}  // Se NÃO habilitado arquivo no SDCARD
      // Proximo estado
      LOC_WAPP.STATE_POWERUP := 3000;
  {ENDIF} // {SD_FILE_2}  // Se habilitado arquivo no SDCARD

//---------------------------------------------------------------------------
// Estado: Aguarda checar se arquivo File 2 NVRAM existe, para solicitar sua leitura
//---------------------------------------------------------------------------
// Arquivo de dados File 2 NVRAM
//---------------------------------------------------------------------------

//=.= =.= =.= =.= =.= =.= =.= =.= =.= =.= =.= =.= =.= =.= =.= =.= =.= =.= =.= =
{IFDEF SD_FILE_2}  // Se habilitado arquivo no SDCARD
//=.= =.= =.= =.= =.= =.= =.= =.= =.= =.= =.= =.= =.= =.= =.= =.= =.= =.= =.= =

elsif (LOC_WAPP.STATE_POWERUP = 2010) then

  // Aguarda fim da checagem se arquivo de nvram existe
  if (SD_NVRAM_END = true) // já finalizou o tratamento do comando
  then
    // Solicita leitura do arquivo de dados NVRAM salvo no sdcard
    PUB_WNVR.CMD_SD_NV_FILE[2] := SD_NVRAM_CMD_READ_E;
    // Proximo estado
    LOC_WAPP.STATE_POWERUP := 2020;
  end_if;

//---------------------------------------------------------------------------
// Estado: Aguarda leitura do arquivo de dados File 2 NVRAM do sdcard
//---------------------------------------------------------------------------
// Arquivo de dados File 2 NVRAM
//---------------------------------------------------------------------------
elsif (LOC_WAPP.STATE_POWERUP = 2020) then

  // Aguarda ler o arquivo de dados nvram existente no sdcard
  if (SD_NVRAM_END = true) // já finalizou o tratamento do comando
  then
     // Proximo estado
     LOC_WAPP.STATE_POWERUP := 2030;
  end_if;

//---------------------------------------------------------------------------
// Estado: Avalia dados File 2 NVRAM lidos do sdcard
//---------------------------------------------------------------------------
// Arquivo de dados File 2 NVRAM
//---------------------------------------------------------------------------
elsif (LOC_WAPP.STATE_POWERUP = 2030) then

   // Salva o valor do CRC lido do arquivo
   AUX_CRC1 := PUB_WNVR.FILE_2.CRC;
   // Força zerar o CRC para calcular o CRC da base desta estrutura de dados
   PUB_WNVR.FILE_2.CRC := 0;
   AUX_CRC2 := HILS.DATA_CRC16(PUB_WNVR.FILE_2);
   PUB_WNVR.FILE_2.CRC := AUX_CRC1;             // restaura valor lido do CRC do arquivo

   // Testa se os dados lidos do arquivo NVRAM são VALIDOS, Se forem mantem os
   // valores lidos do arquivo como sendo dados validos em NVRAM, caso contrario,
   // sendo dados INVALIDOS, inicializa a respectiva base de dados em NVRAM
   //
      // Testa se CRC da estrutura de dados salva no arquivo é valida
   if (AUX_CRC1 <> AUX_CRC2) or       // CRC INVALIDO
      // Testa a data da ultima analise salva no arquivo NVRAM do sdcard é VALIDA
      (PUB_WNVR.FILE_2.ANO < ANO_VALIDO)    // Ano INVALIDO
   then
     // Dados lidos do arquivo no sdcard são INVALIDOS, NÃO pode utilizar estes dados
     // Reseta ou Inicializa dados da base NVRAM
     //
     HILS.DATA_CLEAR(PUB_WNVR.FILE_2);

     // PUB_WNVR.FILE_2.MES := 0;
     // PUB_WNVR.FILE_2.MES := 0;
     // PUB_WNVR.FILE_2.ANO := 0;

     // PUB_WNVR.SD_FILE_2.HM[IDX_HM_SDC_VAC_MES_B1].SEC_TOT := 0;
     // PUB_WNVR.SD_FILE_2.HM[IDX_HM_SDC_VAC_MES_B2].SEC_TOT := 0;

     // Contador de execução neste estado da maquina de estado
     INC_INT(DEB_SD_NVRAM[6]);

   end_if;

   // OBS.: Os dados já estão atualizaados na propria estrutura PUB_WNVR.SD_FILE_2

   // Contador de execução neste estado da maquina de estado
   INC_INT(DEB_SD_NVRAM[7]);

   // Proximo estado
   LOC_WAPP.STATE_POWERUP := 3000; // Proximo estado


//=.= =.= =.= =.= =.= =.= =.= =.= =.= =.= =.= =.= =.= =.= =.= =.= =.= =.= =.= =
{ENDIF} //{SD_FILE_2}  // Se habilitado arquivo File 2 no SDCARD
//=.= =.= =.= =.= =.= =.= =.= =.= =.= =.= =.= =.= =.= =.= =.= =.= =.= =.= =.= =


//---------------------------------------------------------------------------
// Estado INICIAL: Proximo arquivo, se existir
//---------------------------------------------------------------------------
// Arquivo de dados:
//---------------------------------------------------------------------------
elsif (LOC_WAPP.STATE_POWERUP = 3000) then

  // Aguarda tick do RTC do PLC na POU INPUT
  if (TICK_1S.EV) then

   // Proximo estado
   LOC_WAPP.STATE_POWERUP := 9000; // Proximo estado

   // Atualiza DIA e MES corrente do sistema para detectar mudanda de DIA e MES
   PUB_WNVR.SDC_DIA := LOC_WAPP.RTC_DIA;
   PUB_WNVR.SDC_MES := LOC_WAPP.RTC_MES;

   // Seta flag de sistema inicializado
   LOC_XAPP.WARMUP_OK := true;

  end_if;

//##############################################################################
// Estados para tratamento de comandos para SALVAR arquivos de dados no SDCARD
//##############################################################################

//---------------------------------------------------------------------------
// Estado: Estado IDLE, Aguarda COMANDOS do sistema para salvar dados NVRAM em arquivos
//---------------------------------------------------------------------------
// Arquivo de dados: File 0 NVRAM
// Arquivo de dados: File 1 NVRAM
// Arquivo de dados: File 2 NVRAM
//---------------------------------------------------------------------------
elsif (LOC_WAPP.STATE_POWERUP = 9000) then

  // Testa se existe comando para salvar os dados
  // em arquivo no sdcard
  if (LOC_XAPP.APP_CMD_SD_NV_FILE[0] = true) then

     // Reseta o comando de solicitação para salvar os dados
     // NVRAM em arquivo no sdcard
     LOC_XAPP.APP_CMD_SD_NV_FILE[0] := false;

  {IFDEF SD_FILE_0}  // Se habilitado arquivo de horimitetro TOTAL no SDCARD

     // Atualiza o RTC corrente do PLC na estrutura de dados a ser  salva no
     // aquivo de dados no SDCARD

     // Segundo corrente do equipamento (0..59)
     PUB_WNVR.FILE_0.SEG := LOC_WAPP.RTC_SEG;
     // Minuto corrente do equipamento (0..59)
     PUB_WNVR.FILE_0.MIN := LOC_WAPP.RTC_MIN;
     // Hora corrente do equipamento (0..23)
     PUB_WNVR.FILE_0.HOR := LOC_WAPP.RTC_HOR;
     // Dia corrente do equipamento (1..31)
     PUB_WNVR.FILE_0.DIA := LOC_WAPP.RTC_DIA;
     // Mês corrente do equipamento (1..12)
     PUB_WNVR.FILE_0.MES := LOC_WAPP.RTC_MES;
     // Ano corrente do equipamento (ex:2015)
     PUB_WNVR.FILE_0.ANO := LOC_WAPP.RTC_ANO;

     // Transfere os valores dos dados corrente para a
     // estrutura de dados a ser salva no arquivo no sdcard

     // Copia valores dos historicos de limites minimos e maximos de temperatura
     // diarios para a estritura a salvar no sdcard
     for J := 0 TO (MAX_EQP - 1) do
       // Salva valores do dia com os limites minimos e amximos da temperatura atual
       PUB_WNVR.FILE_0.TEMP_MIN_DIA[J] := PUB_WAPP.BASE[J].TEMP_MIN_DIA;
       PUB_WNVR.FILE_0.TEMP_MAX_DIA[J] := PUB_WAPP.BASE[J].TEMP_MAX_DIA;
     end_for;

     // Força zerar o CRC para calcular o CRC da base desta estrutura de dados
     PUB_WNVR.FILE_0.CRC := 0;
     PUB_WNVR.FILE_0.CRC := HILS.DATA_CRC16(PUB_WNVR.FILE_0);

     // Solicita escrita do arquivo de dados File 0 no sdcard
     PUB_WNVR.CMD_SD_NV_FILE[0] := SD_NVRAM_CMD_WRITE_E;

     // Proximo estado
     LOC_WAPP.STATE_POWERUP := 9001;

     // Contador de execução neste estado da maquina de estado
     INC_INT(DEB_SD_NVRAM[8]);

  {ENDIF} // {FILE_0}  // Se habilitado arquivo de horimitetro TOTAL no SDCARD

  end_if;

  // Testa se existe comando para salvar os dados NVRAM
  // em arquivo no sdcard
  if (LOC_XAPP.APP_CMD_SD_NV_FILE[1] = true) and  // existe solicitação de comando
     (LOC_WAPP.STATE_POWERUP = 9000)                // não existe outro comando em tratamento
  then

     // Reseta o comando de solicitação para salvar os dados
     // NVRAM em arquivo no sdcard
     LOC_XAPP.APP_CMD_SD_NV_FILE[1] := false;

  {IFDEF SD_FILE_1}  // Se habilitado arquivo de horimetro DIA no SDCARD

     // Atualiza o DIA corrente do PLC para identificar o dia que salvou
     // os dados no sdcard, referente a estrutura de dados a ser salva no
     // arquivo de dados no SDCARD

	 // Segundo corrente do equipamento (0..59)
     PUB_WNVR.FILE_1.SEG := PUB_WAPP.RTC_SEG;
     // Minuto corrente do equipamento (0..59)
     PUB_WNVR.FILE_1.MIN := PUB_WAPP.RTC_MIN;
     // Hora corrente do equipamento (0..23)
     PUB_WNVR.FILE_1.HOR := PUB_WAPP.RTC_HOR;
     // Dia corrente do equipamento (1..31)
     PUB_WNVR.FILE_1.DIA := PUB_WAPP.RTC_DIA;
     // Mês corrente do equipamento (1..12)
     PUB_WNVR.FILE_1.MES := PUB_WAPP.RTC_MES;
     // Ano corrente do equipamento (ex:2015)
     PUB_WNVR.FILE_1.ANO := PUB_WAPP.RTC_ANO;

     // OBS.: Atualiza ss dados na propria estrutura PUB_WNVR.SD_FILE_1

     // Copia as RECEITAS da aplicação para a estrutura a ser salva no SDCARD
     PUB_WNVR.FILE_1.SD_RECEITA := PUB_RECEITA;

     // Força zerar o CRC para calcular o CRC da base desta estrutura de dados
     PUB_WNVR.FILE_1.CRC := 0;
     PUB_WNVR.FILE_1.CRC := HILS.DATA_CRC16(PUB_WNVR.FILE_1);

     // Solicita escrita do arquivo de dados no sdcard
     PUB_WNVR.CMD_SD_NV_FILE[1] := SD_NVRAM_CMD_WRITE_E;

     // Proximo estado
     LOC_WAPP.STATE_POWERUP := 9001;

     // Contador de execução neste estado da maquina de estado
     INC_INT(DEB_SD_NVRAM[9]);

  {ENDIF} // {SD_FILE_1}  // Se habilitado arquivo no SDCARD

  end_if;

  // Testa se existe comando para salvar os dados NVRAM
  // em arquivo no sdcard
  if (LOC_XAPP.APP_CMD_SD_NV_FILE[2] = true) and  // existe solicitação de coomando
     (LOC_WAPP.STATE_POWERUP = 9000)              // não existe outro comando em tratamento
  then

     // Reseta o comando de solicitação para salvar os dados
     // NVRAM em arquivo no sdcard
     LOC_XAPP.APP_CMD_SD_NV_FILE[2] := false;

  {IFDEF SD_FILE_2}  // Se habilitado arquivo no SDCARD

     // Atualiza o DIA e MES corrente do PLC para identificar quando salvou
     // os dados no sdcard, referente a estrutura de dados a ser salva no
     // arquivo de dados no SDCARD
     PUB_WNVR.FILE_2.DIA := PUB_WAPP.RTC_DIA;
     PUB_WNVR.FILE_2.MES := PUB_WAPP.RTC_MES;
     PUB_WNVR.FILE_2.ANO := PUB_WAPP.RTC_ANO;

     // OBS.: Os dados horimetros já estão atualizaados na propria estrutura PUB_WNVR.SD_FILE_2

     // Força zerar o CRC para calcular o CRC da base desta estrutura de dados
     PUB_WNVR.FILE_2.CRC := 0;
     PUB_WNVR.FILE_2.CRC := HILS.DATA_CRC16(PUB_WNVR.FILE_2);

     // Solicita escrita do arquivo de dados no sdcard
     PUB_WNVR.CMD_SD_NV_FILE[2] := SD_NVRAM_CMD_WRITE_E;

     // Proximo estado
     LOC_WAPP.STATE_POWERUP := 9001;

     // Contador de execução neste estado da maquina de estado
     INC_INT(DEB_SD_NVRAM[10]);

  {ENDIF} // {SD_FILE_2}  // Se habilitado arquivo de horimetro MES no SDCARD

  end_if;



  // Testa se existe comando para salvar os dados NVRAM
  // em arquivo no sdcard
  if (LOC_XAPP.APP_CMD_SD_NV_FILE[3] = true) and  // existe solicitação de coomando
     (LOC_WAPP.STATE_POWERUP = 9000)              // não existe outro comando em tratamento
  then

      // Reseta o comando de solicitação para salvar os dados
     // NVRAM em arquivo no sdcard
     LOC_XAPP.APP_CMD_SD_NV_FILE[3] := false;


   {IFDEF SD_FILE_0}  // Se habilitado arquivo File 0 no SDCARD
    // Inicializa verificando se arquivo de NVRAM Data não existe, para
    // criar um arquivo com 1 receita, representando os dados da NVRAM
    PUB_WNVR.CMD_SD_NV_FILE[0] := SD_NVRAM_CMD_CHECK_E;
    // Proximo estado
    LOC_WAPP.STATE_POWERUP := 10;
   {ENDIF} // {SD_FILE_0}


 end_if;

//---------------------------------------------------------------------------
// Estado: Aguarda escrita no arquivo de dados File 0,1,2 NVRAM do sdcard
//---------------------------------------------------------------------------
// Arquivo de dados File 0 NVRAM
// Arquivo de dados File 1 NVRAM
// Arquivo de dados File 3 NVRAM
//---------------------------------------------------------------------------
elsif (LOC_WAPP.STATE_POWERUP = 9001) then

  // Aguarda escrever no arquivo de dados nvram existente no sdcard
  if (SD_NVRAM_CMD <> SD_NVRAM_CMD_WRITE_E) and
     (SD_NVRAM_END = true)      // já finalizou o tratamento do comando
//   (SD_DATA_BLK.OUT = FALSE)  // já finalizou o tratamento do comando
  then
     // Proximo estado: retorna para aguardar novos comandos
     LOC_WAPP.STATE_POWERUP := 9000;

     // Contador de execução neste estado da maquina de estado
     INC_INT(DEB_SD_NVRAM[11]);
  end_if;

//---------------------------------------------------------------------------
// Estado: Inválido, força inicializar a maquina de estado
//---------------------------------------------------------------------------
else
  // Proximo estado: Inicializa maquina de estado
  LOC_WAPP.STATE_POWERUP := 0;

end_if;



// ******************************************************************************
// ******************************************************************************
//
//           Maquina de Estado 2: Comandos LOCAIS para o SDCARD
//
// ******************************************************************************
// ******************************************************************************


//..............................................................................
//..............................................................................
// Maquina de estado para tratar COMANDOS para arquivos NVRAM do File System
//..............................................................................
// Esta maquina de estado os tratamento dos seguintes comandos:
//     . PUB_WNVR.CMD_SD_NV_FILE[0] , associado ao arquivo :
//         . Arquivo de dados File 0
//     . PUB_WNVR.CMD_SD_NV_FILE[1], associado ao arquivo :
//         . Arquivo de dados File 1
//     . PUB_WNVR.CMD_SD_NV_FILE[2], associado ao arquivo :
//         . Arquivo de dados File 2
//
// Cada comando acima pode ser atribuido um dos seguintes códigos:
//   * 1  | Força a criação de um arquivo com "x" receitas
//   * 2  | Caso não exista, cria um arquivo com "x" receitas
//   * 3  | Lê dados de uma receita do arquivo
//   * 4  | Escreve dados de uma receita no arquivo
//   * 10 | Formata o sistema de arquivos
//   * 20 | Deleta o arquivo de dados do sdcard
//
//..............................................................................
//..............................................................................


//..............................................................................
// Estado INICIAL: Aguarda comando para acesso ao arquivo de dados no SDCARD
//..............................................................................
// Arquivo de de dados: File 0 NVRAM
// Arquivo de de dados: File 1 NVRAM
// Arquivo de de dados: File 2 NVRAM
//..............................................................................
if (LOC_WAPP.STATE_SD_NVRAM = 0) and  // maquina de estado esta livre
   (LOC_XAPP.POWERUP_OK) and          // sistema inicializado
   // Existe alguma solicitação de comando para tratamento
   ((PUB_WNVR.CMD_SD_NV_FILE[0] <> SD_NVRAM_CMD_NONE_E) or
    (PUB_WNVR.CMD_SD_NV_FILE[1] <> SD_NVRAM_CMD_NONE_E) or
    (PUB_WNVR.CMD_SD_NV_FILE[2] <> SD_NVRAM_CMD_NONE_E))
then

  // Inicializa flag de pulso fim de trtamento de comando
  SD_NVRAM_END := false;

  // Trata comando associado ao arquivo de dados corrente de HORIMETRO TOTAL
  if (PUB_WNVR.CMD_SD_NV_FILE[0] <> SD_NVRAM_CMD_NONE_E) then
    // Repassa comando para tratamento do arquivo no sdcard
    SD_NVRAM_CMD  := PUB_WNVR.CMD_SD_NV_FILE[0];
    SD_NVRAM_FILE := SD_FILE_NAME_0; // nome do arquivo de dados
    SD_NVRAM_TYPE := 0;              // seta arquivo Dados NVRAM
    // Proximo estado: Aguarda finalizar o comando
    LOC_WAPP.STATE_SD_NVRAM := 11;
  elsif (PUB_WNVR.CMD_SD_NV_FILE[1] <> SD_NVRAM_CMD_NONE_E) then
    // Repassa comando para tratamento do arquivo no sdcard
    SD_NVRAM_CMD  := PUB_WNVR.CMD_SD_NV_FILE[1];
    SD_NVRAM_FILE := SD_FILE_NAME_1; // nome do arquivo de dados
    SD_NVRAM_TYPE := 1;              // seta arquivo Dados NVRAM
    // Proximo estado: Aguarda finalizar o comando
    LOC_WAPP.STATE_SD_NVRAM := 12;
  elsif (PUB_WNVR.CMD_SD_NV_FILE[2] <> SD_NVRAM_CMD_NONE_E) then
    // Repassa comando para tratamento do arquivo no sdcard
    SD_NVRAM_CMD  := PUB_WNVR.CMD_SD_NV_FILE[2];
    SD_NVRAM_FILE := SD_FILE_NAME_2; // nome do arquivo de dados
    SD_NVRAM_TYPE := 2;              // seta arquivo Dados NVRAM
    // Proximo estado: Aguarda finalizar o comando
    LOC_WAPP.STATE_SD_NVRAM := 13;
  end_if;

//..............................................................................
// Estado: Aguarda execução do comando para arquivo de dados do sdcard
//..............................................................................
// Arquivo de de dados File 0 NVRAM
//..............................................................................
elsif (LOC_WAPP.STATE_SD_NVRAM = 11) then

  // Aguarda término da execução do comando do arquivo de dados nvram existente no sdcard
  if (SD_DATA_BLK.OUT = true) // já finalizou o tratamento do comando
  then
     // Proximo estado: Trata codigo de erro apos a execução do comando no proximo ciclo de scan
     LOC_WAPP.STATE_SD_NVRAM := 21;
  end_if;

//..............................................................................
// Estado: Aguarda execução do comando p/ arquivo de dados do sdcard
//..............................................................................
// Arquivo de de dados File 1 NVRAM
//..............................................................................
elsif (LOC_WAPP.STATE_SD_NVRAM = 12) then

  // Aguarda término da execução do comando do arquivo de dados nvram existente no sdcard
  if (SD_DATA_BLK.OUT = true) // já finalizou o tratamento do comando
  then
     // Proximo estado: Trata codigo de erro apos a execução do comando no proximo ciclo de scan
     LOC_WAPP.STATE_SD_NVRAM := 31;
  end_if;

//..............................................................................
// Estado: Aguarda execução do comando p/ arquivo de dados do sdcard
//..............................................................................
// Arquivo de de dados File 2 NVRAM
//..............................................................................
elsif (LOC_WAPP.STATE_SD_NVRAM = 13) then

  // Aguarda término da execução do comando do arquivo de dados nvram existente no sdcard
  if (SD_DATA_BLK.OUT = true) // já finalizou o tratamento do comando
  then
     // Proximo estado: Trata codigo de erro apos a execução do comando no proximo ciclo de scan
     LOC_WAPP.STATE_SD_NVRAM := 41;
  end_if;

//..............................................................................
// Estado: Reseta comando arquivo File 0 do sdcard
//..............................................................................
// Arquivo de de dados NVRAM
//..............................................................................
elsif (LOC_WAPP.STATE_SD_NVRAM = 21) then

  // Reseta comando para tratamento do arquivo no sdcard
  PUB_WNVR.CMD_SD_NV_FILE[0] := SD_NVRAM_CMD_NONE_E;

  // Proximo estado: Fim
  LOC_WAPP.STATE_SD_NVRAM := 3001;

//..............................................................................
// Estado: Reseta comando arquivo File 1 do sdcard
//..............................................................................
// Arquivo de de dados File 1 NVRAM
//..............................................................................
elsif (LOC_WAPP.STATE_SD_NVRAM = 31) then

  // Reseta comando para tratamento do arquivo sdcard
  PUB_WNVR.CMD_SD_NV_FILE[1] := SD_NVRAM_CMD_NONE_E;

  // Proximo estado: Fim
  LOC_WAPP.STATE_SD_NVRAM := 3001;

//..............................................................................
// Estado: Reseta comando arquivo File 2 do sdcard
//..............................................................................
// Arquivo de de dados File 2 NVRAM
//..............................................................................
elsif (LOC_WAPP.STATE_SD_NVRAM = 41) then

  // Reseta comando para tratamento do arquivo sdcard
  PUB_WNVR.CMD_SD_NV_FILE[2] := SD_NVRAM_CMD_NONE_E;

  // Proximo estado: Fim
  LOC_WAPP.STATE_SD_NVRAM := 3001;

//..............................................................................
// Estado: Sinaliza pulso de fim de comando executado
//..............................................................................
// Arquivo de de dados File 0
// Arquivo de de dados File 1
// Arquivo de de dados File 2
//..............................................................................
elsif (LOC_WAPP.STATE_SD_NVRAM = 3001) then

  SD_NVRAM_RET := SD_DATA_BLK.RESULT; // Salva código de retorno da execução do comando
  SD_NVRAM_CMD := 0;                  // Reseta comando para o file system

  // Set flag de pulso fim de tratamento de comando para a aplicação
  SD_NVRAM_END := true;

  // Proximo estado: Fim
  LOC_WAPP.STATE_SD_NVRAM := 3002;

//..............................................................................
// Estado: Reseta pulso de fim de comando executado e termina tratamento comando
//..............................................................................
elsif (LOC_WAPP.STATE_SD_NVRAM = 3002) then

  // Reseta flag de pulso fim de tratamento de comando
  SD_NVRAM_END := false;

  // Reseta tipo arquivo Dados NVRAM
  SD_NVRAM_TYPE := 0;   // nenhum arquivo da NVRAM

  // Proximo estado: Re-Inicia maquina de estado
  LOC_WAPP.STATE_SD_NVRAM := 0;

end_if;


//---------------------------------------------------------------------------
// Bloco que salva os dados NVRAM da aplicação como sendo em uma receita
// em arquivo no SDCARD, assim simulando uma NVRAM no sdcard
//---------------------------------------------------------------------------

// Processa fim da execução de comando do SDCARD
if (SD_DATA_BLK.OUT = true) then // já finalizou o tratamento do comando
  INC_INT(SD_NVRAM_CNT);         // incrementa contador de comandos processados para debug apenas
end_if;

// Processa comando destinado ao arquivo NVRAM no SDCARD
if (SD_NVRAM_TYPE = 0) then
  // Chamada do bloco de função FS_RECIPE_FILE para gerencia do arquivo NVRAM
  // com dados do File 0 NVRAM
  SD_DATA_BLK(  // FS_NV_DATA
    ENABLE    := LOC_XAPP.POWERUP_OK and (NOT SD_DATA_BLK.OUT),  // [BOOL] Habiiltação do bloco
    FILE_NAME := SD_NVRAM_FILE,  // [STRING] Nome do arquivo de dados no sdcard para simular NVRAM
    APP_CMD   := SD_NVRAM_CMD,   // [INT] Codigo do comando para o arquivo de dados
    APP_DATA  := PUB_WNVR.FILE_0 // [] Esrutura de dados com dados da aplicação
    );
elsif (SD_NVRAM_TYPE = 1) then
  // Chamada do bloco de função FS_RECIPE_FILE para gerencia do arquivo NVRAM
  // com dados do File 1 NVRAM
  SD_DATA_BLK(  // FS_NV_DATA
    ENABLE    := LOC_XAPP.POWERUP_OK and (NOT SD_DATA_BLK.OUT),  // [BOOL] Habiiltação do bloco
    FILE_NAME := SD_NVRAM_FILE,  // [STRING] Nome do arquivo de dados no sdcard para simular NVRAM
    APP_CMD   := SD_NVRAM_CMD,   // [INT] Codigo do comando para o arquivo de dados
    APP_DATA  := PUB_WNVR.FILE_1 // [] Esrutura de dados com dados da aplicação
    );
elsif (SD_NVRAM_TYPE = 2) then
  // Chamada do bloco de função FS_RECIPE_FILE para gerencia do arquivo NVRAM
  // com dados do File 2 NVRAM
  SD_DATA_BLK(  // FS_NV_DATA
    ENABLE    := LOC_XAPP.POWERUP_OK and (NOT SD_DATA_BLK.OUT),  // [BOOL] Habiiltação do bloco
    FILE_NAME := SD_NVRAM_FILE,  // [STRING] Nome do arquivo de dados no sdcard para simular NVRAM
    APP_CMD   := SD_NVRAM_CMD,   // [INT] Codigo do comando para o arquivo de dados
    APP_DATA  := PUB_WNVR.FILE_2 // [] Esrutura de dados com dados da aplicação
    );
end_if;

