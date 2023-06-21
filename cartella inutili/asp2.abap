TABLES: eanl, ever, fkkvkp.

DATA: BEGIN OF wa_eanl,
        anlage   LIKE eanl-anlage,
        sparte   LIKE eanl-sparte,
        vstelle  LIKE eanl-vstelle,
        ablsperr LIKE eanl-ablsperr,
      END OF wa_eanl.

DATA: BEGIN OF wa_ever,
        vertrag LIKE ever-vertrag,
        kostl   LIKE ever-kostl,
        einzdat LIKE ever-einzdat,
        auszdat LIKE ever-auszdat,
      END OF wa_ever.

DATA: BEGIN OF wa_fkkvkp,
        vkont LIKE fkkvkp-vkont,
        gpart LIKE fkkvkp-gpart,
        stdbk LIKE fkkvkp-stdbk,
      END OF wa_fkkvkp.





DATA: BEGIN OF wa_output,
        anlage    LIKE eanl-anlage,
        sparte    LIKE eanl-sparte,
        vstelle   LIKE eanl-vstelle,
        ablsperr  LIKE eanl-ablsperr,
        vertrag   LIKE ever-vertrag,
        kostl     LIKE ever-kostl,
        einzdat   LIKE ever-einzdat,
        auszdat   LIKE ever-auszdat,
        vkont     LIKE fkkvkp-vkont,
        gpart     LIKE fkkvkp-gpart,
        stdbk     LIKE fkkvkp-stdbk,
        esito(10) TYPE c,
      END OF wa_output.

SELECTION-SCREEN BEGIN OF BLOCK a1.
  SELECT-OPTIONS: s_anlage FOR eanl-anlage,
                    s_vert FOR ever-vertrag,
                   s_einzd FOR ever-einzdat.
SELECTION-SCREEN END OF BLOCK a1.

DATA: i_out    LIKE STANDARD TABLE OF wa_output,
      i_eanl   LIKE STANDARD TABLE OF wa_eanl,
      i_ever   LIKE STANDARD TABLE OF wa_ever,
      i_fkkvkp LIKE STANDARD TABLE OF wa_fkkvkp.

START-OF-SELECTION.

  SELECT anlage sparte sparte ablsperr
    FROM eanl
    INTO TABLE i_eanl
    WHERE anlage IN s_anlage.

  IF sy-subrc = 0.
    MESSAGE s208(00) WITH 'Estrazione andata bene'.
  ELSE.
    MESSAGE s208(00) WITH 'Errore estrazione'.
  ENDIF.


  IF i_eanl[] IS NOT INITIAL.



    SELECT vertrag kostl einzdat auszdat
      FROM ever
      INTO TABLE i_ever
      FOR ALL ENTRIES IN i_eanl
      WHERE anlage IN i_eanl-anlage.







  IF i_ever is NOT INITIAL.



  SELECT vkont gpart stdbk
  FROM fkkvkp
  INTO TABLE i_fkkvkp
  for all entries in i_ever
    WHERE vkont = i_ever-vkont.
  ENDIF.
   ENDIF.