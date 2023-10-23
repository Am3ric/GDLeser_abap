FORM select.

  LOOP AT gt_csv INTO gs_csv.

    SELECT *
      FROM zgbchead
      INTO gs_zgbchead
*      FOR ALL ENTRIES IN gt_csv
      WHERE idtreno = gs_csv-idtreno AND
             ext_ui = gs_csv-ext_ui.
    ENDSELECT.

    IF sy-subrc = 0.

*    Identificativo treno associato al PDR &PDR& associato in IS-U

    ELSEIF gs_zgbchead-idtreno IS INITIAL.

*      “Identificativo treno non esistente”

    ENDIF.

    SELECT *
      FROM zgbcmb
      INTO gs_zgbcmb
*      FOR ALL ENTRIES IN gt_csv
      WHERE idtreno = gt_csv-idtreno.
    ENDSELECT.

    IF sy-subrc = 0.

*       FILE per &Identificativo& già caricato

    ENDIF.



  ENDLOOP.
ENDFORM.

FORM select.



  SELECT idtreno ext_ui
    FROM zgbchead
    INTO TABLE gt_zgbchead
    FOR ALL ENTRIES IN gt_csv
    WHERE idtreno = gt_csv-idtreno and
          ext_ui = gt_csv-ext_ui.


  SELECT *
    FROM zgbcmb
    INTO TABLE gt_zgbcmb
    FOR ALL ENTRIES IN gt_csv
    WHERE idtreno = gt_csv-idtreno.
    
       IF sy-subrc = 0.




  LOOP AT gt_csv INTO gs_csv.

    READ TABLE gt_zgbchead INTO gs_zgbchead with key idtreno = gs_csv-idtreno.
    IF gs_zgbchead-idtreno .

    ENDIF.

  ENDLOOP.


ENDFORM.


FORM select.

  LOOP AT gt_csv INTO gs_csv.

    SELECT idtreno ext_ui
      FROM zgbchead
      INTO gs_zgbchead
*      FOR ALL ENTRIES IN gt_csv
      WHERE idtreno = gs_csv-idtreno AND
             ext_ui = gs_csv-ext_ui.
    ENDSELECT.

    IF sy-subrc = 0.

*    Identificativo treno associato al PDR &PDR& associato in IS-U
      MESSAGE s007(zgbc_mess) INTO gs_err-err_message WITH gs_zgbchead-idtreno.

          elseif gs_zgbchead-idtreno is initial.

*      “Identificativo treno non esistente”
      MESSAGE s007(zgbc_mess) INTO gs_err-err_message.
    ENDIF.

    SELECT idtreno
      FROM zgbcmb
      INTO gs_zgbcmb
*      FOR ALL ENTRIES IN gt_csv
      WHERE idtreno = gs_csv-idtreno.
    ENDSELECT.

    IF sy-subrc = 0.

*       FILE per &Identificativo& già caricato
      MESSAGE s007(zgbc_mess) INTO gs_err-err_message WITH gs_zgbchead-idtreno.
    ENDIF.




  ENDLOOP.
ENDFORM.