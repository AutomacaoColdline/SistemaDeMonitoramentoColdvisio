(*==============================================================================

DESCRIÇÃO: Inicialização da base de configuração da aplicação com valores DEFAULT.
           Detalhes e historico de liberações consulte a aba "Documentação"

================================================================================*)

RESULT := HILS.SUCCESS;

(*==============================================================================
   Inicializa base de configuração da aplicação com valores DEFAULT
 *==============================================================================*)

// inicaliza base de configuração com valores DEFAULT especificados com os
// valores default definidos na definição da estrutura de dados

CFG_XAPP := CFG_XAPP_DEFAULT; // inicializa base BITS com valores default na definição da estrutura
CFG_WAPP := CFG_WAPP_DEFAULT; // inicializa base WORDS com valores default na definição da estrutura

(*==============================================================================
   Inicializa VETORES das estruturas de configuração da aplicação
 *==============================================================================*)

// resultado da inicialização da base de configuração da aplicação
MD_CFG_DEFAULT := RESULT;
