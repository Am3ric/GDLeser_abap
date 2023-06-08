*&---------------------------------------------------------------------*
*& Report ZGDLESER_03
*&---------------------------------------------------------------------*
*& AUTORE: GAETANO DE LUCIA 08/06/2023
*& DESC:
*&
*&---------------------------------------------------------------------*
REPORT zgdleser_03.

TABLES zgdl. "richiamo tabellae i campi contenuti

*INITIALIZATION.

SELECTION-SCREEN BEGIN OF BLOCK a1 WITH FRAME TITLE text-001. "with frame abbellisce

  PARAMETERS p_nome TYPE c LENGTH 20.
  PARAMETERS p_cogno TYPE c LENGTH 20.
  SELECTION-SCREEN SKIP. "crea uno spazio
  SELECT-OPTIONS s_eta FOR zgdl-eta.
  SELECT-OPTIONS s_eta1 FOR zgdl-eta NO INTERVALS.
SELECTION-SCREEN END OF BLOCK a1.

START-OF-SELECTION.