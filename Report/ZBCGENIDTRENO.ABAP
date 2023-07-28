*&---------------------------------
*& Report ZBCGENIDTRENO
*&---------------------------------
*& Billing Creator
*& Developer: De Lucia Gaetano
*& Creation: 05/07/2023
*&---------------------------------
REPORT zbcgenidtreno.


INCLUDE zbcgenidtreno_top.
INCLUDE zbcgenidtreno_screen.
INCLUDE zbcgenidtreno_form.


START-OF-SELECTION.

  PERFORM select.
  PERFORM prepare_data.
  PERFORM alv TABLES gt_output.

END-OF-SELECTION.


*&---------------------------------------------------------------------*
*&Include          ZBCGENIDTRENO_TOP
*&---------------------------------------------------------------------*

*TABLES: zgbletman_arcerr, zgbchead, zgbcitem.

*TYPES

CONSTANTS lc_stato TYPE string VALUE '01'.

DATA: g_pdr     TYPE euitrans-ext_ui,
      g_portion TYPE portion.

DATA: l_intui  TYPE int_ui,
      l_anlage TYPE anlage,
      l_pdr TYPE zgbletman_arcerr-ext_ui,
      lv_new_idtreno TYPE zgbchead-idtreno.

TYPES: BEGIN OF ty_output.
TYPES: esito     TYPE icon_d.
       INCLUDE TYPE zgbchead.
TYPES: num_items TYPE i,
       mess      TYPE bapiret2-message,
       END OF ty_output,
       tt_output TYPE TABLE OF ty_output WITH NON-UNIQUE DEFAULT KEY.

DATA: gt_zgbletman_arcerr TYPE STANDARD TABLE OF zgbletman_arcerr,
      gt_zgbchead         TYPE STANDARD TABLE OF zgbchead,
      gt_zgbcitem         TYPE STANDARD TABLE OF zgbcitem,
      gt_zgb              TYPE STANDARD TABLE OF zgbchead,
      gt_output           TYPE                   tt_output.



*&---------------------------------------------------------------------*
*& Include          ZBCGENIDTRENO_SCREEN
*&---------------------------------------------------------------------*


SELECTION-SCREEN: BEGIN OF BLOCK a1 WITH FRAME TITLE text-004.

SELECT-OPTIONS: s_pdr  FOR g_pdr,
                s_port FOR g_portion.

SELECTION-SCREEN END OF BLOCK a1.




*&---------------------------------------
*& Include          ZBCGENIDTRENO_FORM
*&---------------------------------------
*&---------------------------------------
*& Form select
*&---------------------------------------
*& text
*&---------------------------------------
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------
FORM select .



    CLEAR gt_zgbletman_arcerr.
  
    SELECT *
      FROM zgbletman_arcerr
      WHERE ext_ui IN @s_pdr AND
            termschl IN @s_port
      ORDER BY ext_ui, createdat, createdtime
      INTO TABLE @gt_zgbletman_arcerr.
    IF sy-subrc <> 0.
      MESSAGE i003(zgbc_mess) WITH s_pdr s_port.
    ENDIF.
  
  
  
  
  
  ENDFORM.
  *&--------------------------------------
  *& Form prepare_data
  *&--------------------------------------
  *& text
  *&--------------------------------------
  *& -->  p1        text
  *& <--  p2        text
  *&--------------------------------------
  FORM prepare_data .
  
    LOOP AT gt_zgbletman_arcerr INTO DATA(ls_zgbletman_arcerr).
  
      IF l_pdr <> ls_zgbletman_arcerr-ext_ui.
        l_pdr  = ls_zgbletman_arcerr-ext_ui.
  
        DATA(ls_head) = CORRESPONDING zgbchead( ls_zgbletman_arcerr ).
        DATA(ls_out) = CORRESPONDING ty_output( ls_head ).
  
        ls_out-num_items = 1. "Si assegna un valore di 1 a NumItems
  
  *------------RICERCA DELL'IMPIANTO PER PDR------------*
        SELECT int_ui
          INTO l_intui
          FROM euitrans
          WHERE ext_ui = l_pdr.
        ENDSELECT.
  
        IF sy-subrc <> 0.
  *------------Messaggio di errore e icona se non trova int_ui per PDR------------*
          ls_out-esito = '@02@'.
          MESSAGE s004(zgbc_mess) INTO ls_out-mess WITH l_pdr.
        ELSE.
  
          SELECT anlage
          INTO l_anlage
          FROM euiinstln
          WHERE int_ui = l_intui.
          ENDSELECT.
  
          IF sy-subrc <> 0.
  *------------Messaggio di errore e icona se non trova anlage per int_ui------------*
            ls_out-esito = '@02@'.
            MESSAGE s004(zgbc_mess) INTO ls_out-mess WITH l_pdr.
          ELSE.
  *------------Se trova l'impianto per PDR assegna------------*
            ls_head-anlage = l_anlage.
            ls_out-anlage = l_anlage.
          ENDIF.
        ENDIF.
  
  *------------RICERCA PDR NELLA HEAD------------*
        SELECT *
          INTO TABLE gt_zgb
          FROM zgbchead
          WHERE ext_ui = ls_head-ext_ui.
  
        IF sy-subrc <> 0. "se non trova un pdr nella tabella crea un nuovo IDTRENO
  
          CLEAR lv_new_idtreno.
          CALL FUNCTION 'NUMBER_GET_NEXT'
            EXPORTING
              nr_range_nr             = '01'
              object                  = 'ZGBCIDTREN'
              quantity                = '1'
            IMPORTING
              number                  = lv_new_idtreno
            EXCEPTIONS
              interval_not_found      = 1
              number_range_not_intern = 2
              object_not_found        = 3
              quantity_is_0           = 4
              quantity_is_not_1       = 5
              interval_overflow       = 6
              buffer_overflow         = 7
              OTHERS                  = 8.
  
          IF sy-subrc <> 0.
  
            MESSAGE ID sy-msgid TYPE 'E' NUMBER sy-msgno
             WITH
             sy-msgv1
             sy-msgv2
             sy-msgv3
             sy-msgv4.
  
          ENDIF.
  
  *------------ASSEGNAZIONE IDTRENO SE PDR NON PRESENTE NELLA TAB ZGBCHEAD------------*
          ls_head-idtreno = lv_new_idtreno.
          ls_out-idtreno = lv_new_idtreno.
          ls_head-stato = lc_stato.
          ls_out-stato = lc_stato.
  
          IF ls_out-anlage IS INITIAL. "Se non trova l'anlage nella struttura cancella l'IDTRENO assegnato
  
            CLEAR: ls_out-idtreno, ls_head-idtreno.
  
          ELSE. "Assegna l'IDTRENO correttamente + Icona esito corretta con mess di successo
  
            ls_out-esito = '@01@'.
            MESSAGE s005(zgbc_mess) INTO ls_out-mess WITH ls_head-idtreno.
  
          ENDIF.
  
  *------------APPEND E INSERT CON CONTROLLO SU IDTRENO SE PRESENTE------------*
  *------------Viene sempre eseguito se il PDR non è presente in tab, ma senza IDTRENO l'insert non viene eseguito.------------*
          APPEND ls_out TO gt_output.
          APPEND ls_head TO gt_zgbchead.
  
          INSERT zgbchead FROM ls_head.
  
          IF sy-subrc EQ 0 AND ls_head-idtreno IS NOT INITIAL.
            COMMIT WORK.
          ELSE.
            ROLLBACK WORK.
          ENDIF.
  
        ELSE. "
  *------------Se trova già il PDR nella tab zgbchead non assegna l'IDTRENO e non fa l'insert ma viene appeso per stamparlo nell'ALV con messaggio corretto e icona X------------*
          ls_head-stato = lc_stato.
          ls_out-stato = lc_stato.
          ls_out-esito = '@00@'.
          MESSAGE s006(zgbc_mess) INTO ls_out-mess WITH ls_out-ext_ui.
          APPEND ls_out TO gt_output.
          APPEND ls_head TO gt_zgbchead.
  
  
        ENDIF.
  
      ELSE. "SE IL PDR è UGUALE AL PRECEDENTE = COUNTER ITEMS
  
        ls_out-num_items = ls_out-num_items + 1.
        APPEND ls_out TO gt_output.
  
      ENDIF.
  
  *------------INSERT TABELLA ITEM------------*
  
      IF ls_head-idtreno IS NOT INITIAL. " Controllo sull'IDTRENO che non viene generato se ci sono errori e l'insert non viene eseguito
  
        DATA(ls_item) = CORRESPONDING zgbcitem( ls_zgbletman_arcerr ).
        ls_item-idtreno = ls_head-idtreno.
        ls_item-stato = lc_stato.
  
        APPEND ls_item TO gt_zgbcitem.
  
        INSERT zgbcitem FROM ls_item.
  
        IF sy-subrc EQ 0.
          COMMIT WORK.
        ELSE.
          ROLLBACK WORK.
        ENDIF.
      ENDIF.
    ENDLOOP.
  
  *------------Sort Tab ALV per stampare Num Items corretti------------*
  
    SORT gt_output BY ext_ui ASCENDING num_items DESCENDING.
    DELETE ADJACENT DUPLICATES FROM gt_output COMPARING ext_ui.
  
  ENDFORM.
  
  
  FORM alv TABLES it_table TYPE table.
  
    DATA:
      lo_ref        TYPE REF TO cl_salv_table,
      lo_ref_func   TYPE REF TO cl_salv_functions_list,
      lo_selections TYPE REF TO cl_salv_selections,
      lo_columns    TYPE REF TO cl_salv_columns_table,
      lo_cols       TYPE REF TO cl_salv_columns,
      lo_column_h   TYPE REF TO cl_salv_column_list,
      lo_column     TYPE REF TO cl_salv_column,
      lo_layout     TYPE REF TO cl_salv_layout,
      ls_key        TYPE salv_s_layout_key,
      ls_row        TYPE i,
      lt_rows       TYPE salv_t_row.
  
    TRY.
        CALL METHOD cl_salv_table=>factory
          EXPORTING
            list_display = if_salv_c_bool_sap=>false
          IMPORTING
            r_salv_table = lo_ref
          CHANGING
            t_table      = it_table[].
      CATCH cx_salv_msg .
    ENDTRY.
  
  *     Attivazione dei pulsanti
    lo_ref_func = lo_ref->get_functions( ).
    lo_ref_func->set_all( ).
  
  *     Selezione dei campi
    lo_selections = lo_ref->get_selections( ).
    lo_selections->set_selection_mode( if_salv_c_selection_mode=>row_column ).
  
  *     Modifica della fieldcat
    lo_cols = lo_ref->get_columns( ).
    lo_cols->set_optimize( ).
    TRY.
  
        lo_column = lo_cols->get_column( 'CLIENT' ).
        lo_column->set_technical( if_salv_c_bool_sap=>true ).
  
  *      "Cambio etichetta
        lo_column = lo_cols->get_column( 'ESITO' ).
  *      "Modifica Etichetta
        lo_column->set_long_text( 'Esito' ).
        lo_column->set_medium_text( 'Esito' ).
        lo_column->set_short_text( 'Esito' ).
  *      "Cambio etichetta
        lo_column = lo_cols->get_column( 'NUM_ITEMS' ).
  *      "Modifica Etichetta
        lo_column->set_long_text( 'NumItem' ).
        lo_column->set_medium_text( 'NumeroItem' ).
        lo_column->set_short_text( 'NumeroItem' ).
      CATCH cx_salv_not_found.
    ENDTRY.
  *   Richiamo e salvataggio layout
  
    lo_layout = lo_ref->get_layout( ).
    ls_key-report = sy-repid.
    lo_layout->set_key( ls_key ).
    lo_layout->set_save_restriction( if_salv_c_layout=>restrict_none ).
  
  *     Stampa ALV
    CALL METHOD lo_ref->display.
  
  ENDFORM.