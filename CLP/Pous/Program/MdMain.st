============================================================================
Controle de alterações:

 Analises Pendentes:
 * Verficar se alinha as bases em 64 bits para contemplar data e hora ......

 Legenda para classes de alterações:
 ==== ======================== =====================================================================
 [I]  Versão inicial           inicia em 1.0.00 - 1: versão, 0: revisão maior, 00: revisão menor
 [F]  Novas funcionalidades    incrementa revisão menor da versão
 [D]  Documentação             incrementa revisão menor da versão
 [B]  Correção de erros        incrementa revisão maior da versão
 ==== ======================== =====================================================================
============================================================================
Aplicação Versão: 1.2.01     Data: 20/Ago/2024     Resp.: Alvim
Histudio  Versão: 2.0.31
Firmware NEON G5: 3.1.13

OBS.: Esta versão é compatível apenas com versão do supervisório 1.2.00 ou
      Superior

[F] - nesta versão as taxas de comunicação estão sendo zerada a cada mudança de dia,
      para isso os contadores foram alterados de INT para Real
      VER POU MDB_CTRL
         Variável: PUB_XAPP.TROCOU_DIA

============================================================================

============================================================================
Aplicação Versão: 1.2.00     Data: 15/Ago/2024     Resp.: Alvim
Histudio  Versão: 2.0.31
Firmware NEON G5: 3.1.13

OBS.: Esta versão é compatível apenas com versão do supervisório 1.2.00 ou
      Superior

[F] - Alterado a quantidade Máxima de controladores de temperatura de 20 para
      apenas 15, esta alteração foi solicitada pelo cliente para poder manter a
      aplicação com menos de 600 Tags para poder utilizar uma licença L4 para
      o supervisório HIScada Pro.

      Ver a variável global MAX_EQP.

============================================================================
============================================================================
Aplicação Versão: 1.1.00     Data: 26/Jul/2024     Resp.: Alvim
Histudio  Versão: 2.0.26
Firmware NEON G5: 3.1.13

OBS.: Esta versão é compatível apenas com versão do supervisório 1.1.00 ou
      Superior

[F] - Alterado a leitura dos controladores de temperatura via modbus, nesta versão
      os dados de leitura são lidos ao final de cada RD_ID e não ao final de todo o ciclo
     * Ver POU MDB_CRTL
       Variável: CTRL_MDB.RD_ID

[F] - Altera a estratégia de envio de comando para ser gerado individualmente para
      cada comando e controlador, para isso foi criado uma base de comandos e alterado
      a forma de envio de coamndo.
     * Ver POU MDB_CRTL
       Variável: CMD_WR
       Base de Variáveis: CMD_WR_T
       Máquina de estado do envio de comando: MQ_EST_WR

[F] - Criado taxa de comunicação com e sem sucesso
     * Ver POU MDB_CRTL
       Função: MDB_CALC_KPI

[F] - Criado um comando para repetir o envio de Ligar / desligar controladores
      na programação horária caso não obtenha sucesso na primeira tentativa.

[F] - Criado alarme para indicar que não houve sucesso na segunda tentativa de
      ligar / desligar o controlador de temperatura pela programação horária.

   Data: 30/Jul/2024     Resp.: Alvim / Paulo

[F] - Alterado a forma de realizar a leitura dos controladores para melhorar o sincronismo
      de atualização dos dados
     * Ver POU CTRL_MDB.END_CYC
           Função GET_NEXT_ENA

[F] - Alterado a forma de realizar de verificar se há comandos a serem executados,
      gerando prioridade para os comandos.
      de atualização dos dados
     * Ver POU CTRL_MDB.END_CYC
           Função CHK_CMD_WR

[F] - Ainda sobe os coamndos realizados foi gerado uma estratégia para sempre que
      houver um coamndo, voltar a leitura para o controle de temperatura anterior
      para dar tempo do controlador atualizar o seu status e ser lido pelo CLP no
      próximo ciclo de pooling
     * Ver POU CTRL_MDB.END_CYC
           Função GET_PREV_ENA
           Variável: END_CMD_WR_OK

============================================================================
Aplicação Versão: 1.0.08     Data: 26/Jun/2024     Resp.: Alvim
Histudio  Versão: 2.0.26
Firmware NEON G5: 3.1.13

      Data: 26/Jun/2024     Resp.: Alvim
[F] - Alteradoa gravação da base de configuração na memória flash, agora será
      monitorado 10s sem alterações antes de salvar a base de configuração na flash
      para garantir que mesmo com muitas alterações em pouco tempo todos os dados sejam
      gravados na memória flash
     * Ver POU MD_PERIODIC
       Variáveis: FLAG_ALT, RST_CONT

      Data: 26/Jun/2024     Resp.: Alvim
[F] - Incluída lógica de Retry onde caso não se consiga escrita com sucesso no
      controlador de temperatura tenta-se mais 2 vezes esta escrita antes de pular o
      comando.
     * Ver POU MDB_CRTL
       Variável: RETRY


============================================================================

============================================================================
Aplicação Versão: 1.0.07     Data: 18/Mar/2024     Resp.: Alvim
Histudio  Versão: 2.0.15
Firmware NEON G5: 3.1.09

      Data: 18/Mar/2024     Resp.: Alvim
[F] - Alterado o endereço de leitura do status de Desumidificação
     de: endereço 32891 bit 6
     para: endereço 32891 bit 4
     * Ver POU MDB_CTRL

============================================================================
Aplicação Versão: 1.0.06     Data: 05/Fev/2024     Resp.: Paulo Inazumi
Histudio  Versão: 2.0.12
Firmware NEON G5: 3.1.09

      Data: 05/Fev/2024     Resp.: Paulo Inazumi
[F] - Melhoria no processo de identificação de controlador ONLINE ou OFFLINE

      Data: 02/Fev/2024     Resp.: Paulo Inazumi
[F] - Melhoria na estratégia de identificação do status dos controladores
      estão ONLINE ou OFFLINE. Pois qualquer falha na comunicação com o controlador
      estava zerando as informações do mesmo, o que estava gerando um valor de
      temperatura minima com valor 0.
[F] - Alterado para publicar o min/max a cada hora. Estava a cada minuto.
      No sdcard estava a cada hora.

      Data: 01/Fev/2024     Resp.: Paulo Inazumi
[F] - Acréscimo de funcionalidade para salvar os valores de temperatura
      MINIMA e MAXIMA diaria no SDCARD, e publicar periodicamente para
      o suspervisorio a cada hora. Em caso de queda de energia os dados
      são preservados da ultima hora.
[F] - Criado comando 31100 para reinicializar a temperatura min./max.
      diaria de todos os controladores.
[B] - Ajuste no modulo TK_NOTIFY a estratégia para identificar se o portal
      de telemetria esta ON LINE.
============================================================================
Rev 1.0.05:
[N] - Alterações realizadas pela ColdLine

============================================================================
Rev 1.0.04:

============================================================================
Rev 1.0.03:    Liberaçao: 23/06/2023  Responsavel: Alvim
HIstudio: Ver. 1.7.13
Firmware: G5PLC.C911.SD V 3.1.04

[F] - COMPILADO PROGRAMA PARA A VERSÃO MAIOR 1.7 DO HISTUDIO
[B] - NO COMANDO DE INTERVALO DE DEGELO NA POU MDB_CTRL NÃO ERA ENVIADO O VALOR
      2 PARA A VARIÁVEL FIM INDICANDO QUE O COMANDO HAVIA TERMINADO, ASSIM SENDO,
      O PROGRAMA FICAVA TRAVADO NÃO DEIXANDO A COMUNICAÇÃO CONTINUAR COM OS
      CONTROLADORES.
============================================================================
Rev 1.0.02:
  12/06/2023 - Daniel Franco, HIstudio Ver. 1.6.05
  Firmware: G5PLC.C910.SD V 2.1.03
  - TK_NOTIFY: Somente publica dados de temperatura e umidade se controladores online
  - MDB_CTRL: Se controlador offline força zerar dados do controlador.

============================================================================
Rev 1.0.01:
  19/09/2019 - Alvim Alves Junior, HIstudio Ver. 1.4.03
  Firmware: G5PLC.C910.SD V 2.1.03

============================================================================
Rev 1.0.00:
  19/09/2019 - Alvim Alves Junior, HIstudio Ver. 1.4.03
  Firmware: G5PLC.C910.SD V 2.1.03
  - Implementação da aplicação.
============================================================================

Descrição geral:

    Esta aplicação tem como objetivo monitorar e controlar até 20 controladores de
temperatura / umidade,comunicando com um supervisório (HIScada Pro) ou pelo
Portal de Telemetria

Descricao:
---------------------------------------

  Para a monitoração/ controle dos controladores de temperatura/umidade foi criado
20 instâncias com 02 canais de comunicação Modbus. O CLP varre as 20 instâncias
buscando todos os controladores habilitados e assim que encontra um, faz a leitura
de suas variáveis e verifica se há algum comando a ser enviado a este controlador.

  Os comandos podem ser enviados pela programação horária (apenas liga ou desliga)
controlada pelo CLP ou então por comando externo vindo do supervisório ou portal de
telemetria.

  As configurações dos controladores e monitoramento são realizados pelo portal
Telemetria da HI ou então por supervisório (HIScadaPro)



Base de dados exportada do controlador
=======================================

As seguintes variáveis estão disponibilizadas para supervisão pela IHM e pelo portal de telemetria:

Variáveis gerais do processo

- Condição de porta aberta / fechada
- Status de Conexão
- Número de Instâncias

- O projeto possui 20 instâncias que podem mesclar, ou não, dois tipos de controaldores
 de temperatura/umidade

 Variáveis do controlador Drixell
 - SetPoint de temperatura ambiente
 - SetPoint de umidade
 - Temperatura Ambiente
 - Umidade Ambiente
 - Status Degelo
 - Status Desumidificação
 - Status Ventilação
 - Status Refrigeração
 - Comandos

  Variáveis do controlador Fullgauge
 - SetPoint de temperatura ambiente
 - SetPoint de temperatura do evaporador
 - Temperatura Ambiente
 - Temperatura do evaporador
 - Status Degelo
 - Status Ventilação
 - Status Refrigeração
 - Intervalo entre degelo
 - Comandos

 * Para mais informações sobre comandos verificar POU MD_PERIODIC

Geração de alarmes
========================

O programa do PLC ira monitorar as seguintes condições de alarme:

    1. Timeout de portas abertas
    2. Alarme de temperatura ambiente H
    3. Alarme de temperatura ambiente L
    4. Conexão com o controaldor Neon
    5. Conexão com os controladores de temperatura / umidade
    6. Controladores de temperatura/umidade em alarme.


Base de configuração da aplicação
=========================================

Valores default (fornecidos pelo cliente)
------------------------------------------
*Não há valores default para esta aplicação.


Variáveis exportadas de configuração (salvas em Flash)
==============================================================

As variáveis da estrutura PUB_WCFG estão sendo salvas na memória Flash.


Mapeamento de I/O da aplicação
=========================================

Interface de processo
-------------------------------------------------------------------------------------

Mapeamento de entradas e saídas

                                                         NEON [NEON-1S]
                                               +--------------------------+
                                  PORTA 01 ----|DI00                  DO00|---- RESERVA
                                               |                          |
                                  PORTA 02 ----|DI01                  DO01|---- RESERVA
                                               |                          |
                                  PORTA 03 ----|DI02                  DO02|---- RESERVA
                                               |                          |
                                  PORTA 04 ----|DI03                  DO03|---- RESERVA
                                               |                          |
                                  PORTA 05 ----|DI04                  DO04|---- RESERVA
                                               |                          |
                                  PORTA 06 ----|DI05                  DO05|---- RESERVA
                                               |                          |
                                  PORTA 07 ----|DI06                  DO06|---- RESERVA
                                               |                          |
                                  PORTA 08 ----|DI07                  DO07|---- RESERVA
                                               |                          |
    Canal contador em quadratura (encoder) ----|QCT00_COUNT     PWM00_FREQ|---- Frequencia (Hz x 10)
                                               |                          |
                     Canal contador rápido ----|FCT01_COUNT     PWM00_DUTY|---- Ciclo de trabalho (% x 10)
                                               |                          |
                     Canal contador rápido ----|FCT02_COUNT               |
                                               +--------------------------+



Modo de simulação do processo
=================================

A aplicação corrente implementa recursos para simular os sinais de processo para
auxilio no processo de validação da aplicação.
Para tanto, foram criadas variaveis no escopo do programa principal para permitir:

 - Definir o valor das variaveis de processo manualmente
 - Definir o valor das variaveis de processo automaticamente
 - Simular, falhas nos transmissores e das bombas
 - Simular condição de painel ligado/desligado

Para habilitar o modo de simulaçao faça SIMU = TRUE

A tabela abaixo apresenta as variaveis definidas para este processo.

==================  =============  =============  ============  ====================================================================
**Nome**            **Parâmetro**  **Tipo Dado**  **V. Ini.**   **Descrição**
------------------  -------------  -------------  ------------  --------------------------------------------------------------------
SIM_MODE            Local          BOOL           FALSE         Modo de simulacao do processo para depuracao
==================  =============  =============  ============  ====================================================================

