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