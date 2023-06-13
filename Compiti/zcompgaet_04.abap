*&---------------------------------------------------------------------*
*& Report ZGDLESER_04
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&AUTORE: GDL
*&---------------------------------------------------------------------*
REPORT zgdleser_04.

TABLES: eanlh, ever.


DATA: BEGIN OF wa_eanlh,
        anlage LIKE eanlh-anlage,
        ab     LIKE eanlh-ab,
      END OF wa_eanlh.

DATA: BEGIN OF wa_ever,
        vertrag LIKE ever-vertrag,
        vkonto  LIKE ever-vkonto,
        einzdat LIKE ever-einzdat,
        auszdat LIKE ever-auszdat,

      END OF wa_ever.

DATA i_eanlh  LIKE STANDARD TABLE OF wa_eanlh.
DATA i_ever   LIKE STANDARD TABLE OF wa_ever.


** PARAMETRI D'INPUT

*PARAMETERS p_anl LIKE eanlh-anlage.
SELECTION-SCREEN BEGIN OF BLOCK a1 WITH FRAME TITLE TEXT-001.

  SELECT-OPTIONS s_anl FOR eanlh-anlage NO INTERVALS.
  SELECT-OPTIONS s_ab  FOR eanlh-ab.

SELECTION-SCREEN END OF BLOCK a1.

SELECTION-SCREEN SKIP.
SELECTION-SCREEN BEGIN OF BLOCK a2 WITH FRAME TITLE TEXT-002.

  SELECT-OPTIONS s_ver FOR ever-vertrag NO INTERVALS.
  SELECT-OPTIONS s_in FOR ever-einzdat.

SELECTION-SCREEN END OF BLOCK a2.
*LOOP AT SCREEN.
*
*  IF screen-name EQ 's_ab'.
*    screen-input = 0.
*  ENDIF.
*  MODIFY SCREEN.
*ENDLOOP.
*
*AT SELECTION-SCREEN.
*  IF s_ab IS INITIAL.
*    MESSAGE i208(00) WITH 'valorizzare data'.
*  ENDIF.

INITIALIZATION.

*** MAIN

START-OF-SELECTION.

*  DATA flag.
*  CLEAR flag.

  SELECT anlage ab
    FROM eanlh
    INTO TABLE i_eanlh
    WHERE  anlage IN s_anl AND
           ab     IN s_ab.

  IF sy-subrc = 0.
    MESSAGE s208(00) WITH 'Estrazione andata bene'.
  ELSE.
    MESSAGE s208(00) WITH 'Errore estrazione tabella'.
*    flag = 'X'.
  ENDIF.

  SELECT vertrag vkonto einzdat auszdat
   FROM ever
   INTO TABLE i_ever
   WHERE vertrag IN s_ver AND
         einzdat IN s_in.

  IF sy-subrc = 0.
    MESSAGE s208(00) WITH 'Estrazione andata bene'.
  ELSE.
    MESSAGE s208(00) WITH 'Errore estrazione tabella'.
  ENDIF.

*CHECK flag IS INITIAL . " = space




  LOOP AT i_eanlh INTO wa_eanlh.
    WRITE: / wa_eanlh-ab,
           wa_eanlh-anlage.
  ENDLOOP.

  LOOP AT i_ever INTO wa_ever.
    WRITE:/  wa_ever-vertrag,
             ever-auszdat,
             ever-einzdat,
             ever-vkonto.
  ENDLOOP.

END-OF-SELECTION.