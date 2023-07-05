*&---------------------------------------------------------------------*
*& Report ZLAST_EXERC_GDL
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zlast_exerc_gdl.



INCLUDE ZLAST_EXERC_GDL_top1.
INCLUDE ZLAST_EXERC_GDL_screen.
INCLUDE ZLAST_EXERC_GDL_form.



START-OF-SELECTION.

IF p_loc is INITIAL.
  lv_file = p_ser.
  else.
    lv_file = p_loc.
ENDIF.

lv_ora = sy-uzeit.
lv_data = sy-datum.

IF rb_car is NOT INITIAL.

    PERFORM estr.
    else.
      PERFORM step2.
ENDIF.






*        IF line_exists( gt_ad[ adr = gw_la-adr ] ).
*
*          gw_ad = gt_ad[ adr = gw_la-adr ].








end-of-SELECTION.

*&---------------------------------------------------------------------*
*& Include          ZLAST_EXERC_GDL_TOP1
*&---------------------------------------------------------------------*
TABLES: lfa1, adrc, ztab_forn_gdl.

DATA: lv_file TYPE string,
      lv_ora TYPE tims,
      lv_data TYPE dats.


DATA: BEGIN OF gw_la,
        lifnr TYPE lfa1-lifnr,
        adr   TYPE lfa1-adrnr,
        land1 TYPE lfa1-land1,
        ort01 TYPE lfa1-ort01,
        ort02 TYPE lfa1-ort02,
      END OF gw_la.

DATA: BEGIN OF gw_ad,
        adr    TYPE adrc-addrnumber,
        name1  TYPE adrc-name1,
        city1  TYPE adrc-city1,
        street TYPE adrc-street,
        hsn1   TYPE adrc-house_num1,
      END OF gw_ad.

DATA: BEGIN OF gw_ztab1,
        mandt  TYPE ztab_forn_gdl-mandt,
        lifnr  TYPE ztab_forn_gdl-lifnr,
        land1  TYPE ztab_forn_gdl-land1,
        regio  TYPE ztab_forn_gdl-regio,
        adr    TYPE ztab_forn_gdl-adrnr,
        nome   TYPE ztab_forn_gdl-nome,
        city1  TYPE ztab_forn_gdl-city1,
        street TYPE ztab_forn_gdl-street,
        hsn1   TYPE ztab_forn_gdl-house_num1,
        datac  TYPE ztab_forn_gdl-data_car,
        orac   TYPE ztab_forn_gdl-ora_car,
      END OF gw_ztab1.

      DATA: BEGIN OF gw_ztab2,
        mandt  like ztab_forn_gdl-mandt,
        lifnr  like ztab_forn_gdl-lifnr,
        land1  like ztab_forn_gdl-land1,
        regio  like ztab_forn_gdl-regio,
        adr    like ztab_forn_gdl-adrnr,
        nome   like ztab_forn_gdl-nome,
        city1  like ztab_forn_gdl-city1,
        street like ztab_forn_gdl-street,
        hsn1   like ztab_forn_gdl-house_num1,
        datac  like ztab_forn_gdl-data_car,
        orac   like ztab_forn_gdl-ora_car,
      END OF gw_ztab2.

DATA: BEGIN OF gw_out,
        lifnr TYPE lfa1-lifnr,
        land1 TYPE lfa1-land1,
        city1 TYPE ztab_forn_gdl-city1,
      END OF gw_out.

DATA: gt_la   LIKE STANDARD TABLE OF gw_la,
      gt_ad   LIKE STANDARD TABLE OF gw_ad,
      gt_ztab1   LIKE STANDARD TABLE OF gw_ztab1,
      gt_out  LIKE STANDARD TABLE OF gw_out,
      gt_ztab2 LIKE STANDARD TABLE OF gw_ztab2.

DATA: BEGIN OF gs_outtab,
        lv_string TYPE string,
      END OF gs_outtab.

DATA: gt_outtab LIKE STANDARD TABLE OF gs_outtab.


*&---------------------------------------------------------------------*
*& Include          ZLAST_EXERC_GDL_SCREEN
*&---------------------------------------------------------------------*

SELECTION-SCREEN BEGIN OF BLOCK a1 WITH FRAME TITLE TEXT-001.

  PARAMETERS: rb_car  RADIOBUTTON GROUP g1 USER-COMMAND uc2 DEFAULT 'X',
              rb_view RADIOBUTTON GROUP g1.

SELECTION-SCREEN END OF BLOCK a1.

SELECTION-SCREEN SKIP.

SELECTION-SCREEN BEGIN OF BLOCK a2 WITH FRAME TITLE TEXT-002.

  PARAMETERS: rb_loc RADIOBUTTON GROUP a1 USER-COMMAND uc1 DEFAULT 'X' MODIF ID m11,
              p_loc  TYPE string MODIF ID m1.

  PARAMETERS: rb_ser RADIOBUTTON GROUP a1 MODIF ID m22,
              p_ser  TYPE string MODIF ID m2.

SELECTION-SCREEN END OF BLOCK a2.

SELECTION-SCREEN SKIP.

SELECTION-SCREEN BEGIN OF BLOCK a3 WITH FRAME TITLE TEXT-003.

  SELECT-OPTIONS s_forn FOR lfa1-lifnr.
  SELECT-OPTIONS s_paese FOR lfa1-land1 VISIBLE LENGTH 2.
  SELECT-OPTIONS s_cit FOR lfa1-ort01.

SELECTION-SCREEN END OF BLOCK a3.


AT SELECTION-SCREEN OUTPUT.
  LOOP AT SCREEN.

    IF rb_car is INITIAL  AND ( screen-group1 = 'M1' or screen-group1 = 'M2' or screen-group1 = 'M11' or screen-group1 = 'M22').
      screen-active = 0.
      MODIFY SCREEN.

    else.
    IF rb_ser <> 'X' AND screen-group1 = 'M2' OR rb_loc <> 'X' AND screen-group1 = 'M1' .

      screen-input = 0.
      MODIFY SCREEN.
    ELSE.
      screen-input = 1.
      MODIFY SCREEN.
    ENDIF.

    ENDIF.
  ENDLOOP.

  *&---------------------------------------------------------------------*
*& Include          ZLAST_EXERC_GDL_FORM
*&---------------------------------------------------------------------*

FORM estr.

  CLEAR: gt_la,
         gt_ad,
         gt_ztab1,
         gt_out,
         gt_ztab2.

  SELECT lifnr adrnr land1 ort01 ort02
    FROM lfa1
    INTO TABLE gt_la
    WHERE lifnr IN s_forn AND
          land1 IN s_paese AND
          ort01 IN s_cit.

  IF sy-subrc EQ 0.

    SELECT addrnumber name1 city1 street house_num1
      FROM adrc
      INTO TABLE gt_ad
      FOR ALL ENTRIES IN gt_la
      WHERE addrnumber = gt_la-adr.


    IF sy-subrc EQ 0.

      LOOP AT gt_la INTO gw_la.


        READ TABLE gt_ad
        INTO gw_ad
        WITH KEY adr = gw_la-adr.

        MOVE: gw_la-lifnr TO gw_out-lifnr,
              gw_la-land1 TO gw_out-land1,
              gw_la-ort02 TO gw_out-city1.

        APPEND gw_out TO gt_out.

*    APPEND  VALUE  #(    lifnr  = gw_ztab21-lifnr
*                         land1  = gw_ztab21-land1
*                         ort02  = gw_ztab21-regio
*                         adr    = gw_ztab21-adr
*                         name1  = gw_ztab21-nome
*                         ort01  = gw_ztab21-city1
*                         street = gw_ztab21-street
*                         hsn1   = gw_ztab21-hsn1
*                          )  TO gt_ztab21.


        MOVE: gw_la-lifnr  TO gw_ztab1-lifnr,
              gw_la-land1  TO gw_ztab1-land1,
              gw_la-ort02  TO gw_ztab1-regio,
              gw_ad-adr    TO gw_ztab1-adr,
              gw_ad-name1  TO gw_ztab1-nome,
              gw_ad-city1  TO gw_ztab1-city1,
              gw_ad-street TO gw_ztab1-street,
              gw_ad-hsn1   TO gw_ztab1-hsn1,
              lv_data      TO gw_ztab1-datac,
              lv_ora       TO gw_ztab1-orac.

        APPEND gw_ztab1 TO gt_ztab1.

        MODIFY ztab_forn_gdl FROM gw_ztab1.
        COMMIT WORK.
      ENDLOOP.

      IF rb_loc IS NOT INITIAL.

        REFRESH gt_outtab[].

        CONCATENATE 'Codice Fornitore'
                    'Paese'
                    'Città'
                    INTO gs_outtab-lv_string
                    SEPARATED BY ';'.
        APPEND gs_outtab TO gt_outtab.

        LOOP AT gt_out INTO gw_out.

          CONCATENATE gw_out-lifnr
                      gw_out-land1
                      gw_out-city1
                      INTO gs_outtab-lv_string
                      SEPARATED BY ';'.
          APPEND gs_outtab TO gt_outtab.

        ENDLOOP.




        CALL FUNCTION 'GUI_DOWNLOAD'
          EXPORTING
            filename                = lv_file
            filetype                = 'ASC'
            write_field_separator   = ' '
          TABLES
            data_tab                = gt_out
*           FIELDNAMES              =
          EXCEPTIONS
            file_write_error        = 1
            no_batch                = 2
            gui_refuse_filetransfer = 3
            invalid_type            = 4
            no_authority            = 5
            unknown_error           = 6
            header_not_allowed      = 7
            separator_not_allowed   = 8
            filesize_not_allowed    = 9
            header_too_long         = 10
            dp_error_create         = 11
            dp_error_send           = 12
            dp_error_write          = 13
            unknown_dp_error        = 14
            access_denied           = 15
            dp_out_of_memory        = 16
            disk_full               = 17
            dp_timeout              = 18
            file_not_found          = 19
            dataprovider_exception  = 20
            control_flush_error     = 21
            OTHERS                  = 22.
        IF sy-subrc <> 0.
* Implement suitable error handling here
        ENDIF.


      ELSEIF rb_ser IS NOT INITIAL.

        TRANSLATE p_ser TO LOWER CASE.
        OPEN DATASET p_ser
        FOR OUTPUT IN TEXT MODE ENCODING DEFAULT.
        IF sy-subrc NE 0.
          MESSAGE e398(00) WITH TEXT-003 DISPLAY LIKE 'I'.
          EXIT.
        ENDIF.
        CONCATENATE 'Codice Fornitore'
                  'Paese'
                  'Città'
                  INTO gs_outtab-lv_string
                  SEPARATED BY ';'.
        TRANSFER gs_outtab-lv_string TO p_ser.

        LOOP AT gt_out INTO gw_out.

          CONCATENATE gw_out-lifnr
                      gw_out-land1
                      gw_out-city1
                      INTO gs_outtab-lv_string
                      SEPARATED BY ';'.
          TRANSFER gs_outtab-lv_string TO p_ser.

        ENDLOOP.
        CLOSE DATASET p_ser.
      ENDIF.
    ENDIF.
  ENDIF.






ENDFORM.

FORM step2.

  SELECT *
    FROM ztab_forn_gdl
    INTO TABLE gt_ztab2
    WHERE lifnr IN s_forn AND
          land1 IN s_paese AND
          city1 IN s_cit.


  IF sy-subrc EQ 0.

     DATA: gt_fieldcat TYPE  slis_t_fieldcat_alv.
  FIELD-SYMBOLS <fs_field> LIKE LINE OF gt_fieldcat.
  DATA gs_field LIKE LINE OF gt_fieldcat.
  REFRESH gt_fieldcat[].

  CALL FUNCTION 'REUSE_ALV_FIELDCATALOG_MERGE'
    EXPORTING
      i_program_name         = sy-repid
      i_internal_tabname     = 'GW_ZTAB2'
      i_client_never_display = 'X'
      i_inclname             = sy-repid
    CHANGING
      ct_fieldcat            = gt_fieldcat[]
    EXCEPTIONS
      inconsistent_interface = 1
      program_error          = 2
      OTHERS                 = 3.
  IF sy-subrc <> 0.
* Implement suitable error handling here
  ENDIF.

  CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
    EXPORTING
      i_callback_program = sy-repid
      it_fieldcat        = gt_fieldcat
    TABLES
      t_outtab           = gt_ztab2
    EXCEPTIONS
      program_error      = 1
      OTHERS             = 2.
  IF sy-subrc <> 0.
* Implement suitable error handling here
  ENDIF.

  ENDIF.
ENDFORM.