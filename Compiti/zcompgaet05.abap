*&---------------------------------------------------------------------*
*& Report ZRDESER10_1906
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zrdeser10_1906.

TABLES ever.
TABLES fkkvkp.
TABLES ztabraf1906.

data w_output like ztabraf1906.

*DATA: BEGIN OF w_output,
*        vertrag    LIKE ztabraf1906-vertrag,
*        vkont      LIKE ztabraf1906-vkont,
*        sparte     LIKE ztabraf1906-sparte,
*        einzdat    LIKE ztabraf1906-einzdat,
*        auszdat    LIKE ztabraf1906-auszdat,
*        gpart      LIKE ztabraf1906-gpart,
*        ezawe      LIKE ztabraf1906-ezawe,
*        z_ragiones LIKE ztabraf1906-z_ragiones,
*      END OF w_output.

DATA: w_fkkvkp LIKE fkkvkp,
      w_ever   LIKE ever.


DATA: i_fkkvkp LIKE STANDARD TABLE OF w_fkkvkp,
      i_ever   LIKE STANDARD TABLE OF w_ever,
      i_output LIKE STANDARD TABLE OF w_output.

SELECT-OPTIONS s_gpart FOR w_fkkvkp-gpart.

START-OF-SELECTION.

  PERFORM f_estrazione.
  PERFORM f_elaborazione.
  PERFORM f_output.

end-OF-SELECTION.

FORM f_estrazione.

  REFRESH i_fkkvkp.
  SELECT *
    FROM fkkvkp
    INTO TABLE @i_fkkvkp
    WHERE gpart IN @s_gpart.

  IF sy-subrc EQ 0.

    REFRESH i_ever.
    SELECT *
      FROM ever
      INTO TABLE @i_ever
      FOR ALL ENTRIES IN @i_fkkvkp
      WHERE vkonto EQ @i_fkkvkp-vkont.

    IF sy-subrc EQ 0.
    ENDIF.

  ENDIF.


ENDFORM.

FORM f_elaborazione.

  DATA lv_bp TYPE string.

  SORT i_ever BY vkonto.

  LOOP AT i_fkkvkp INTO w_fkkvkp.
    READ TABLE i_ever TRANSPORTING NO FIELDS
    WITH KEY vkonto = w_fkkvkp-vkont
    BINARY SEARCH.
    IF sy-subrc EQ 0.
      LOOP AT i_ever INTO w_ever FROM sy-tabix.
        IF w_ever-vkonto <> w_fkkvkp-vkont.
          EXIT.
        ENDIF.
        IF w_ever-vkonto = w_fkkvkp-vkont.
          w_output-vertrag = w_ever-vertrag.
          w_output-einzdat = w_ever-einzdat.
          w_output-auszdat = w_ever-auszdat.
          w_output-sparte  = w_ever-sparte.
          w_output-vkont   = w_fkkvkp-vkont.
          w_output-ezawe   = w_fkkvkp-ezawe.
          w_output-gpart   = w_fkkvkp-gpart.

          CALL FUNCTION 'ZESER_LDB'
            EXPORTING
              i_partner = w_output-gpart
            IMPORTING
              e_bp      = lv_bp
            EXCEPTIONS
              errore    = 1
              OTHERS    = 2.
          w_output-z_ragiones = lv_bp.

          insert ZTABRAF1906
          from w_output.

          if sy-subrc = 0.
            commit work.
            else. rollback work.
              endif.


        ENDIF.
        APPEND w_output TO i_output.
      ENDLOOP.
      CLEAR w_output.
    ENDIF.
  ENDLOOP.

ENDFORM.

FORM f_output.



ENDFORM.