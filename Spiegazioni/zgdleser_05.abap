*&---------------------------------------------------------------------*
*& Report ZPROVA_SALVO
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zprova_salvo.

DATA: wa_ever LIKE ever,
      wa_eanl LIKE eanl.

DATA: i_ever LIKE STANDARD TABLE OF wa_ever,
      i_eanl LIKE STANDARD TABLE OF wa_eanl.

SELECT-OPTIONS: s_anl FOR wa_eanl-anlage,
                s_ver FOR wa_ever-vertrag.

* MAIN

START-OF-SELECTION.

  SELECT *
      FROM ever
      INTO TABLE i_ever
      WHERE vertrag IN s_ver . "AND

  IF sy-subrc = 0.
    DATA lv_default(10).
    DATA lt_ever_per LIKE STANDARD TABLE OF wa_ever.
    REFRESH lt_ever_per.
    lt_ever_per[] = i_ever[].
    SORT lt_ever_per BY anlage.
    DELETE ADJACENT DUPLICATES FROM lt_ever_per COMPARING anlage.

    SELECT *
        FROM eanl
        INTO TABLE i_eanl
        FOR ALL ENTRIES IN lt_ever_per
        WHERE anlage = lt_ever_per-anlage.

    IF sy-subrc = 0.
      DATA: BEGIN OF wa_anl,
              sign   TYPE tvarv_sign,
              option TYPE tvarv_opti,
              low    TYPE anlage,
              high   TYPE anlage,
            END OF wa_anl,
            i_anl LIKE STANDARD TABLE OF wa_anl.

      i_anl[] = s_anl[].
      DATA lv_tabix LIKE sy-tabix.

      LOOP AT i_eanl INTO wa_eanl.

        lv_tabix = sy-tabix.

        READ TABLE i_anl INTO wa_anl " Eliminazione Impianto se pilotato da SO
        WITH KEY sign = 'E'
                 low = wa_eanl-anlage.
        IF sy-subrc = 0.
          DELETE i_eanl INDEX lv_tabix.
          lv_default = 'null'.
        ELSE.
          READ TABLE i_anl INTO wa_anl " Eliminazione Impianto se pilotato da SO
          WITH KEY sign = 'I'
                   low = wa_eanl-anlage.
          IF sy-subrc <> 0.
            DELETE i_eanl INDEX lv_tabix.
            lv_default = 'null'.
          ENDIF.
        ENDIF.
      ENDLOOP.
    ELSE.
      lv_default = 'null'.
    ENDIF.
    FREE lt_ever_per.


    WRITE: / ' Contratto', '|', '  Impianto', '|', '   Data In', '|', '  Edificio'.
    ULINE.
    LOOP AT i_ever INTO wa_ever.

      READ TABLE i_eanl INTO wa_eanl
      WITH KEY anlage = wa_ever-anlage.
      IF sy-subrc = 0.
        WRITE: / wa_ever-vertrag, '|', wa_eanl-anlage, '|', wa_ever-einzdat, '|', wa_eanl-vstelle.
      ELSE.
        WRITE: / wa_ever-vertrag, '|',lv_default, '|', wa_ever-einzdat, '|',lv_default.
      ENDIF.

    ENDLOOP.
  ENDIF.

end-of-selection.