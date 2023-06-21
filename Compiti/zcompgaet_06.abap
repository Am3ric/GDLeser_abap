*&---------------------------------------------------------------------*
*& Report ZGDLESER_09
*&---------------------------------------------------------------------*
REPORT zgdleser_09.


INCLUDE zgdleser_09_top1.
INCLUDE zgdleser_09_screen.
INCLUDE zgdleser_form.






START-OF-SELECTION.

lv_file = p_file.

  IF p_file IS INITIAL.
    MESSAGE s208(00) WITH TEXT-001 DISPLAY LIKE 'E'.
    STOP.
  ENDIF.


IF rb_upl is not INITIAL.

PERFORM file_upl.

ELSEIF rb_downl is not INITIAL.

  PERFORM file_downl.


ENDIF.










end-of-SELECTION.




------------------------------------------------------------
*&---------------------------------------------------------------------*
*& Include          ZGDLESER_09_TOP1
*&---------------------------------------------------------------------*
TABLES BUT000.

DATA: gs_file TYPE string,
      gt_file LIKE STANDARD TABLE OF gs_file.


DATA: BEGIN OF gs_csv,
        bp      TYPE but000-partner,
        bpkind  LIKE but000-bpkind,
        type    TYPE but000-type,
        nome    TYPE but000-name_last,
        cognome TYPE but000-name_first,
      END OF gs_csv.
DATA gt_csv LIKE STANDARD TABLE OF gs_csv.

DATA: BEGIN OF gs_outtab,
        lv_string TYPE string,
      END OF gs_outtab.

DATA: gt_outtab LIKE STANDARD TABLE OF gs_outtab.

DATA lv_file TYPE string.


TYPES: BEGIN OF ty_errore,
         aufnr  TYPE aufk-aufnr,
         errore TYPE char100,
       END OF ty_errore.

DATA: gt_errore TYPE STANDARD TABLE OF ty_errore,
      gs_errore TYPE ty_errore.

DATA: wa_but000 LIKE but000,
      i_but000 LIKE STANDARD TABLE OF but000.


-------------------------------------------------------------------------------

*&---------------------------------------------------------------------*
*& Include          ZGDLESER_09_SCREEN
*&---------------------------------------------------------------------*

SELECTION-SCREEN: BEGIN OF BLOCK b1 WITH FRAME TITLE TEXT-t01.
  PARAMETERS: rb_upl   RADIOBUTTON GROUP g1 USER-COMMAND 123 DEFAULT 'X',
              rb_downl RADIOBUTTON GROUP g1.
  SELECTION-SCREEN SKIP.
  PARAMETERS: r_loc RADIOBUTTON GROUP g2 USER-COMMAND 123 DEFAULT 'X',
              r_ser RADIOBUTTON GROUP g2.

  PARAMETERS: p_file LIKE rlgrap-filename MODIF ID loc.
SELECTION-SCREEN: END OF BLOCK b1.

-----------------------------------------------------------------------------------------

&---------------------------------------------------------------------*
*& Include          ZGDLESER_FORM
*&---------------------------------------------------------------------*

FORM file_upl.




  IF r_loc IS NOT INITIAL.


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
        IF sy-tabix = 1.
          CONTINUE.
        ENDIF.
        SPLIT gs_file AT ';'
        INTO gs_csv-bp
        gs_csv-type
        gs_csv-nome
        gs_csv-cognome.
        APPEND gs_csv TO gt_csv.
        CLEAR gs_csv.

      ENDLOOP.

    ENDIF.
    WRITE: / ' BP', '|', '  Tipo', '|', '   Nome', '|', '  Cognome'.
    ULINE.
    LOOP AT gt_csv INTO gs_csv.
      WRITE:/ gs_csv-bp, gs_csv-type, gs_csv-nome, gs_csv-cognome.
    ENDLOOP.



  ELSEIF r_ser IS NOT INITIAL.


    OPEN DATASET lv_file FOR INPUT IN TEXT MODE ENCODING DEFAULT.
    IF sy-subrc IS INITIAL.
      DO.


        READ DATASET lv_file INTO gs_file.
        IF sy-subrc IS INITIAL.
          IF sy-index eq 1.
            continue.
           endif.
          SPLIT gs_file AT ';'
          INTO gs_csv-bp
          gs_csv-type
          gs_csv-nome
          gs_csv-cognome.
          APPEND gs_csv TO gt_csv.
          CLEAR gs_csv.

        ELSE.
          EXIT.
        ENDIF.

      ENDDO.
    ENDIF.
    WRITE: / ' BP', '|', '  Tipo', '|', '   Nome', '|', '  Cognome'.
    ULINE.
    LOOP AT gt_csv INTO gs_csv.
      WRITE:/ gs_csv-bp, gs_csv-type, gs_csv-nome, gs_csv-cognome.
    ENDLOOP.

  ENDIF.



ENDFORM.

FORM file_downl.


  IF r_loc IS NOT INITIAL.


    REFRESH i_but000.
    SELECT *
      FROM but000
      INTO TABLE @i_but000
      WHERE bpkind = '0001'.


    REFRESH gt_outtab[].

    CONCATENATE 'partner'
                'type'
                'nome'
                'cognome'
                INTO gs_outtab-lv_string
                SEPARATED BY ';'.
    APPEND gs_outtab TO gt_outtab.

    LOOP AT i_but000 INTO wa_but000.

      CONCATENATE wa_but000-partner
                  wa_but000-type
                  wa_but000-name_first
                  wa_but000-name_last
                  INTO gs_outtab-lv_string
                  SEPARATED BY ';'.
      APPEND gs_outtab TO gt_outtab.

    ENDLOOP.




    CALL FUNCTION 'GUI_DOWNLOAD'
      EXPORTING
*       BIN_FILESIZE            =
        filename                = lv_file
        filetype                = 'ASC'
*       APPEND                  = ' '
        write_field_separator   = ' '
*       HEADER                  = '00'
*       TRUNC_TRAILING_BLANKS   = ' '
*       WRITE_LF                = 'X'
*       COL_SELECT              = ' '
*       COL_SELECT_MASK         = ' '
*       DAT_MODE                = ' '
*       CONFIRM_OVERWRITE       = ' '
*       NO_AUTH_CHECK           = ' '
*       CODEPAGE                = ' '
*       IGNORE_CERR             = ABAP_TRUE
*       REPLACEMENT             = '#'
*       WRITE_BOM               = ' '
*       TRUNC_TRAILING_BLANKS_EOL       = 'X'
*       WK1_N_FORMAT            = ' '
*       WK1_N_SIZE              = ' '
*       WK1_T_FORMAT            = ' '
*       WK1_T_SIZE              = ' '
*       WRITE_LF_AFTER_LAST_LINE        = ABAP_TRUE
*       SHOW_TRANSFER_STATUS    = ABAP_TRUE
*       VIRUS_SCAN_PROFILE      = '/SCET/GUI_DOWNLOAD'
* IMPORTING
*       FILELENGTH              =
      TABLES
        data_tab                = gt_outtab
*       FIELDNAMES              =
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


  ELSEIF r_ser IS NOT INITIAL.

    REFRESH i_but000.
    SELECT *
      FROM but000
      INTO TABLE @i_but000
      WHERE bpkind = '0001'.

    TRANSLATE p_file TO LOWER CASE.
    OPEN DATASET p_file FOR OUTPUT IN TEXT MODE ENCODING DEFAULT.
    IF sy-subrc NE 0.
      MESSAGE e398(00) WITH TEXT-003 DISPLAY LIKE 'I'.
      EXIT.
    ENDIF.
    CONCATENATE 'partner'
              'type'
              'nome'
              'cognome'
              INTO gs_outtab-lv_string
              SEPARATED BY ';'.
    TRANSFER gs_outtab-lv_string TO p_file.

    LOOP AT i_but000 INTO wa_but000.

      CONCATENATE wa_but000-partner
                  wa_but000-type
                  wa_but000-name_first
                  wa_but000-name_last
                  INTO gs_outtab-lv_string
                  SEPARATED BY ';'.
      TRANSFER gs_outtab-lv_string TO p_file.

    ENDLOOP.
    CLOSE DATASET p_file.
  ENDIF.



ENDFORM.