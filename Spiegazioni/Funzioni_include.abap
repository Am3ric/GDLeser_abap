INCLUDE zgdleser_top."contiente le dichiarazioni
INCLUDE zgdleser_screen. "contiene la screen
INCLUDE zgdleser_form. "contiene funzioni 
PERFORM esempio1. "richiamo funzione

PERFORM funzionecount CHANGING nomevariabilecasuale 

  DO countstr TIMES.
    IF p_str+count1(1) CA '0123456789'.
      countnum = countnum + 1.
      PERFORM funzionecount CHANGING countnum. "passaggio di parametri


    ENDIF.
    count1 = count1 + 1.
  ENDDO.



"funzione
*&---------------------------------------------------------------------*
*& Form esempio1
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM esempio1 .

ENDFORM.