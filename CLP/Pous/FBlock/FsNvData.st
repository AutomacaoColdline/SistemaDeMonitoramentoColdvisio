(*
 ******************************************************************************
 ******************************************************************************

  Utilização do bloco FS_RECIPE para salvar dados da aplicação que deveriam ser
  preservados em NVRAM do PLC, serem preservados em arquivo de dados no SDCARD

 ******************************************************************************
 ******************************************************************************

 Opções de comandos para ler/escerver os dados da aplicação no SDCARD
 utilizando o SDCARD para salvar dados retentivos simulando uma NVRAM.

   * SD_CMD = 1  | Força a criação de um arquivo com "x" receitas
   * SD_CMD = 2  | Caso não exista, cria um arquivo com "x" receitas
   * SD_CMD = 3  | Lê dados de uma receita do arquivo
   * SD_CMD = 4  | Escreve dados de uma receita no arquivo
   * SD_CMD = 10 | Formata o sistema de arquivos
   * SD_CMD = 20 | Deleta o arquivo '/NvRamData.dat'

 OBS: Na inicialização é executado SD_CMD = 2. Assim, caso não
 exista um arquivo '/NvRamData.dat', um novo arquivo é criado. Ao fim
 do processo de inicialização, realiza o processamento dos dados ligod.

 ******************************************************************************
 *)

//---------------------------------------------------------------------------
// Estado INICIAL: Checar se arquivo de NVRAM existe. Se não existe cria-o
//---------------------------------------------------------------------------
if (ENABLE) and (STATE = 0) and (APP_CMD <> 0) then

   //-------------------------------------------------------------------------
   // SD_NVRAM_CMD_FORMAT_E;  10;  Formata o sistema de arquivos;
   // SD_NVRAM_CMD_DELETE_E;  20;  Deleta o arquivo de receitas;
   // SD_NVRAM_CMD_CREATE_E;  1;   Força a criação de um arquivo com "x" receitas;
   // SD_NVRAM_CMD_CHECK_E;   2;   Caso não exista, cria um arquivo com "x" receitas;
   // SD_NVRAM_CMD_READ_E;    3;   Lê dados de uma receita do arquivo;
   // SD_NVRAM_CMD_WRITE_E;   4;   Escreve dados de uma receita no arquivo;
   //-------------------------------------------------------------------------

   // Seta comando para bloco FS_RECIPE para o sistema de arquivo
   LOC_FS_CMD := APP_CMD;
   // reseta pulso de saida do bloco
   OUT := false;
   // Proximo estado
   STATE := 10;

//---------------------------------------------------------------------------
// Estado: Aguarda finalizar o comando de acesso ao arquivo ao file system
//---------------------------------------------------------------------------
elsif (STATE = 10) then

  // aguarda pulso de finalização do tratamento do comando
  if (BLK_FS_RECIPE.DONE = true)  // já finalizaou o tratamento do comando
  then
   // salva codigo da execução do comando para retornar para aplicação
   RESULT  := BLK_FS_RECIPE.RESULT; // Salva código de retorno

   // Proximo estado
   STATE := 20;
 end_if;

//---------------------------------------------------------------------------
// Estado: Gera pulso de saida de término da tratamento do comando
//---------------------------------------------------------------------------
elsif (STATE = 20) then
  // Ja executou mais um ciclo de scan do PLC apos o término da aexecuã
  if (BLK_FS_RECIPE.DONE = false)  // já finalizaou o tratamento do comando
  then
   // reseta codigo do comando, para aguardar novo comando
   LOC_FS_CMD := 0;   // por segurança, reseta codigo de comando para bloco file system
   APP_CMD    := 0;   // reseta codigo do comando da aplicação

   // gera pulso de saida do bloco
   OUT := true;

   // Proximo estado
   STATE := 1000;
 end_if;

//---------------------------------------------------------------------------
// Estado: Resta pulso de fim de execução
//---------------------------------------------------------------------------
elsif (STATE = 1000) then

   // reseta  pulso de saida do bloco
   OUT := false;

   // Proximo estado: Reinicializa maquina de estado
   STATE := 0;

//---------------------------------------------------------------------------
// Estado: Inválido, força inicializar a maquina de estado
//---------------------------------------------------------------------------
else
  // Proximo estado: Inicializa maquina de estado
  STATE := 0;

end_if;


//---------------------------------------------------------------------------
// Função que salva os dados NVRAM da aplicação como sendo em uma receita
// em arquivo no SDCARD, assim simulando uma NVRAM no sdcard
//---------------------------------------------------------------------------

// Testa Habilitação de entrada
if ((ENABLE = true) and (APP_CMD <> 0)) then       // [BOOL] Habilitação de entrada
  // Chamada do bloco de função FS_RECIPE_FILE para gerencia do arquivo NVRAM
  BLK_FS_RECIPE(  // FS_RECIPE_FILE
    // aguarda tempo minimal antes de iniciar o acesso ao sistema de arquivo do controlador
  //EN        := (ENABLE = true) and (APP_CMD <> 0),       // [BOOL] Habilitação de entrada
    ID        := 1,            // [INT] Identificador da receita UNICA, arquivo NVRAM
    CMD       := LOC_FS_CMD,   // [INT] Comando associado ao arquivo NVRAM
    DATA_FILE := FILE_NAME,    // [STRING] Nome do arquivo 'NvRamData.dat'
    DATA      := APP_DATA      // [ANY] Registro com dados da NVRAM
    );
end_if;