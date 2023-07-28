*&---------------------------------------------------------------------*
*& Include          ZGBCCARICAMB_FORM
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*& Form loc file_file
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM loc_file .

  CALL FUNCTION 'GUI_UPLOAD'
    EXPORTING
      filename                = lv_file
      filetype                = 'ASC'
      has_field_separator     = ';'
    TABLES
      data_tab                = gt_file
    EXCEPTIONS
      file_open_error         = 1
      file_read_error         = 2
      no_batch                = 3
      gui_refuse_filetransfer = 4
      invalid_type            = 5
      no_authority            = 6
      unknown_error           = 7
      bad_data_format         = 8
      header_not_allowed      = 9
      separator_not_allowed   = 10
      header_too_long         = 11
      unknown_dp_error        = 12
      access_denied           = 13
      dp_out_of_memory        = 14
      disk_full               = 15
      dp_timeout              = 16
      OTHERS                  = 17.

  IF sy-subrc <> 0.
    MESSAGE s208(00) WITH TEXT-e02 DISPLAY LIKE 'E'.
    STOP.
  ELSE.

    LOOP AT gt_file INTO gs_file.
      IF sy-tabix EQ 1.
        SPLIT gs_file AT ';'
        INTO
        ls_head-idtreno
        ls_head-ext_ui
        ls_head-begabrpe
        ls_head-endabrpe
        ls_head-belzart
        ls_head-zonennr
        ls_head-preisbtr
        ls_head-abrmenge
        ls_head-mwskz.
        TRANSLATE ls_head TO UPPER CASE.

        IF ls_head-idtreno <> 'IDTRENO'   AND
        ls_head-ext_ui     <> 'EXT_UI'    AND
        ls_head-begabrpe   <> 'BEGABRPE'  AND
        ls_head-endabrpe   <> 'ENDABRPE'  AND
        ls_head-belzart    <> 'BELZART'   AND
        ls_head-zonennr    <> 'ZONENNR'   AND
        ls_head-preisbtr   <> 'PREISBTR'  AND
        ls_head-abrmenge   <> 'ABRMENGE'  AND
        ls_head-mwskz      <> 'MWSKZ'.

          MESSAGE e013(zgbc_mess) DISPLAY LIKE 'I'.
        ELSE.
          CONTINUE.
        ENDIF.
      ENDIF.

      SPLIT gs_file AT ';'
      INTO
      gs_csv-idtreno
      gs_csv-ext_ui
      gs_csv-begabrpe
      gs_csv-endabrpe
      gs_csv-belzart
      gs_csv-zonennr
      gs_csv-preisbtr
      gs_csv-abrmenge
      gs_csv-mwskz.

      CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
        EXPORTING
          input  = gs_csv-idtreno
        IMPORTING
          output = gs_csv-idtreno.

      IF gs_csv-idtreno  CO '1234567890 ' AND
         gs_csv-ext_ui   CO '0123456789 ' AND
         gs_csv-begabrpe CO '0123456789 ' AND
         gs_csv-endabrpe CO '0123456789 ' AND
         gs_csv-zonennr  CO '0123456789 ' AND
         gs_csv-preisbtr CO '0123456789., ' AND
         gs_csv-abrmenge CO '0123456789., '.
        APPEND gs_csv TO gt_csv.

      ELSE.
        err_count = 1.
        MESSAGE s014(zgbc_mess) INTO gs_err-err_message.
        MOVE-CORRESPONDING gs_csv TO gs_err.
        MOVE: err_count TO gs_err-err_number.
        APPEND gs_err TO gt_err.
        CLEAR: gs_csv, gs_err, err_count.
      ENDIF.
    ENDLOOP.
  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form serv_file
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM serv_file .

  OPEN DATASET lv_file FOR INPUT IN TEXT MODE ENCODING DEFAULT.
  IF sy-subrc IS INITIAL.
    DO.
      READ DATASET lv_file INTO gs_file.
      IF sy-subrc IS INITIAL.
        IF sy-tabix EQ 1.
          SPLIT gs_file AT ';'
          INTO
          ls_head-idtreno
          ls_head-ext_ui
          ls_head-begabrpe
          ls_head-endabrpe
          ls_head-belzart
          ls_head-zonennr
          ls_head-preisbtr
          ls_head-abrmenge
          ls_head-mwskz.
          TRANSLATE ls_head TO UPPER CASE.

          IF ls_head-idtreno <> 'IDTRENO'   AND
          ls_head-ext_ui     <> 'EXT_UI'    AND
          ls_head-begabrpe   <> 'BEGABRPE'  AND
          ls_head-endabrpe   <> 'ENDABRPE'  AND
          ls_head-belzart    <> 'BELZART'   AND
          ls_head-zonennr    <> 'ZONENNR'   AND
          ls_head-preisbtr   <> 'PREISBTR'  AND
          ls_head-abrmenge   <> 'ABRMENGE'  AND
          ls_head-mwskz      <> 'MWSKZ'.

            MESSAGE e013(zgbc_mess) DISPLAY LIKE 'I'.
          ELSE.
            CONTINUE.
          ENDIF.
        ENDIF.

        SPLIT gs_file AT ';'
        INTO
        gs_csv-idtreno
        gs_csv-ext_ui
        gs_csv-begabrpe
        gs_csv-endabrpe
        gs_csv-belzart
        gs_csv-zonennr
        gs_csv-preisbtr
        gs_csv-abrmenge
        gs_csv-mwskz.

        CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
          EXPORTING
            input  = gs_csv-idtreno
          IMPORTING
            output = gs_csv-idtreno.

        IF gs_csv-idtreno  CO '1234567890 ' AND
           gs_csv-ext_ui   CO '0123456789 ' AND
           gs_csv-begabrpe CO '0123456789 ' AND
           gs_csv-endabrpe CO '0123456789 ' AND
           gs_csv-zonennr  CO '0123456789 ' AND
           gs_csv-preisbtr CO '0123456789., ' AND
           gs_csv-abrmenge CO '0123456789., '.
          APPEND gs_csv TO gt_csv.

        ELSE.
          err_count = 1.
          MESSAGE s014(zgbc_mess) INTO gs_err-err_message.
          MOVE-CORRESPONDING gs_csv TO gs_err.
          MOVE: err_count TO gs_err-err_number.
          APPEND gs_err TO gt_err.
          CLEAR: gs_csv, gs_err, err_count.
        ENDIF.
      ENDIF.
    ENDDO.
  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form select
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM select.

  SELECT idtreno ext_ui
   FROM zgbchead
   INTO TABLE gt_zgbchead
   FOR ALL ENTRIES IN gt_csv
   WHERE idtreno = gt_csv-idtreno.

  SELECT belzart
    FROM te835
    INTO TABLE gt_belzart.

  SELECT mwskz
    FROM t007a
    INTO TABLE gt_mwskz.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form contr
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM contr.

  LOOP AT gt_csv INTO gs_csv.

    READ TABLE gt_zgbchead INTO gs_zgbchead WITH KEY idtreno = gs_csv-idtreno.
*    IF sy-subrc <> 0.
*      CLEAR gs_csv-idtreno.
*    ENDIF.

    SELECT SINGLE idtreno
    FROM zgbccarlog
    INTO gs_err
    WHERE idtreno = gs_csv-idtreno.
*    IF sy-subrc = 0.
*      MESSAGE s011(zgbc_mess) INTO gs_err-err_message WITH gs_csv-idtreno.
*    ENDIF.

    READ TABLE gt_mwskz INTO gs_mwskz WITH KEY mwskz = gs_csv-mwskz.
*    IF sy-subrc <> 0.
**      MESSAGE s008(zgbc_mess) INTO gs_err-err_message.
*      CLEAR gs_csv-mwskz.
*    ENDIF.


    READ TABLE gt_belzart INTO gs_belzart WITH KEY belzart = gs_csv-belzart.
*    IF sy-subrc <> 0.
**      MESSAGE s010(zgbc_mess) INTO gs_err-err_message.
*      CLEAR gs_csv-belzart.
*    ENDIF.

*--------CONTROLLO SU TUTTO POI CASCATA PER ASSEGNARE IL MESSAGGIO CORRETTO--------*
    IF gs_csv-idtreno <> gs_zgbchead-idtreno OR
       gs_csv-begabrpe > gs_csv-endabrpe     OR
       gs_csv-mwskz   <> gs_mwskz-mwskz      OR
       gs_csv-belzart <> gs_belzart-belzart  OR
       gs_csv-ext_ui  <> gs_zgbchead-ext_ui  OR
       gs_err-idtreno = gs_csv-idtreno       .

      CLEAR: err_count.

      IF gs_csv-idtreno <> gs_zgbchead-idtreno.
*        Identificativo treno non esistente
*        MESSAGE s009(zgbc_mess) INTO gs_err-err_message.
        err_count += 1.
        MESSAGE s009(zgbc_mess) INTO error-error2.
      ENDIF.

      IF gs_csv-begabrpe > gs_csv-endabrpe.
*        Date non coerenti con il treno letture
*        MESSAGE s007(zgbc_mess) INTO gs_err-err_message.
        err_count += 1.
        MESSAGE s007(zgbc_mess) INTO error-error3.
      ENDIF.

      IF gs_csv-mwskz   <> gs_mwskz-mwskz.
*        Codice IVA non esistente
*        MESSAGE s008(zgbc_mess) INTO gs_err-err_message.
        err_count += 1.
        MESSAGE s008(zgbc_mess) INTO error-error4.
      ENDIF.

      IF gs_csv-belzart <> gs_belzart-belzart.
*        Tipo riga non esistente
*        MESSAGE s010(zgbc_mess) INTO gs_err-err_message.
        err_count += 1.
        MESSAGE s010(zgbc_mess) INTO error-error5.
      ENDIF.

      IF gs_csv-ext_ui <> gs_zgbchead-ext_ui.
*        Identificativo treno associato al PDR &1 associato in IS-U
*        MESSAGE s012(zgbc_mess) INTO gs_err-err_message WITH gs_zgbchead-ext_ui.
        err_count += 1.
        MESSAGE s012(zgbc_mess) INTO error-error6 WITH gs_zgbchead-ext_ui.
      ENDIF.

      IF gs_err-idtreno = gs_csv-idtreno.
*        FILE per &IDTRENO già caricato
*        MESSAGE s011(zgbc_mess) INTO gs_err-err_message WITH gs_csv-idtreno.
        err_count += 1.
        MESSAGE s011(zgbc_mess) INTO error-error7 WITH gs_csv-idtreno.
      ENDIF.

      MOVE-CORRESPONDING gs_csv TO gs_err.
      CONCATENATE error-error1
                  error-error2
                  error-error3
                  error-error4
                  error-error5
                  error-error6
                  error-error7 INTO
                  lv_error RESPECTING BLANKS SEPARATED BY space.

      CONDENSE lv_error.
      MOVE: lv_error  TO gs_err-err_message,
            err_count TO gs_err-err_number.
      APPEND gs_err TO gt_err.
      CLEAR: gs_err, lv_error, error.

    ELSE.
      MOVE-CORRESPONDING gs_csv TO gs_zgbcmb.
      APPEND gs_zgbcmb TO gt_zgbcmb.
      CLEAR gs_zgbcmb.

    ENDIF.
  ENDLOOP.
ENDFORM.