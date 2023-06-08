*&---------------------------------------------------------------------*
*& Report ZGDLESER_03
*&---------------------------------------------------------------------*
*& AUTORE: GAETANO DE LUCIA 08/06/2023
*& DESC: classi di mex e select opt
*&
*&---------------------------------------------------------------------*
REPORT zgdleser_03.

TABLES zgdl. "richiamo tabellae i campi contenuti

*INITIALIZATION.

SELECTION-SCREEN BEGIN OF BLOCK a1 WITH FRAME TITLE TEXT-002. "with frame abbellisce, text 001 è un testo personalizzato e per modificarlo si va in text elements indicando il numero a sinistra

  PARAMETERS p_nome TYPE c LENGTH 20.
  PARAMETERS p_cogno TYPE c LENGTH 20.
  SELECTION-SCREEN SKIP. "crea uno spazio
  SELECT-OPTIONS s_eta FOR zgdl-eta.
  SELECT-OPTIONS s_eta1 FOR zgdl-eta NO INTERVALS.
SELECTION-SCREEN END OF BLOCK a1.

START-OF-SELECTION.
  IF p_nome IS NOT INITIAL. "IS NOT INITIAL controlla che sia piena, se IS INITIAL controlla se è vuota
    MESSAGE i208(00) WITH text-001. "i: è informativo (serve per dire che funziona), s: messaggio informativo in OK (giù a sinistra) , e: arresta il programma -- & è un carattere casuale
  ELSE. "si possono creare classi di messaggi transazione SE91. sintassi: numerotext(classe) esempio: 001(Z_CLASS_MESS_GAETANO)
    MESSAGE s208(00) WITH text-003 DISPLAY LIKE 'E'. "display like serve per displayare s come fosse E (scrivere in maiusc)
  ENDIF.