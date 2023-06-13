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
      "FOR ALL ENTRIES IN i_eanl
      WHERE vertrag IN s_ver . "AND
  "anlage  = i_eanl-anlage.

  IF sy-subrc = 0.
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
    "WHERE anlage IN s_anl.
    IF sy-subrc = 0.
    ENDIF.
    FREE lt_ever_per.
  ENDIF.

end-of-selection.