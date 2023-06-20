*&---------------------------------------------------------------------*
*& Report ZGDLESER_09
*&---------------------------------------------------------------------*
**&creare un programma che abbia in input il file
*
*
*
*richiamare il FM GUI_UPLOAD
*
* filename                = lv_file
*      filetype                = 'ASC'
*      has_field_separator     = ';'
*
*    TABLES
*      data_tab                = gt_file
*
*controllare i dati che passate al FM altrimenti dumpa
*
*la GT_file conterrà i dati separati dal ;
*
*quindi splittare i dati all'interno della tabella interna gt_csv
*
*una volta popolata la gt_csv fare la write
*&---------------------------------------------------------------------*
REPORT zgdleser_09.


DATA: gs_file TYPE string,
      gt_file LIKE STANDARD TABLE OF gs_file.


DATA: BEGIN OF gs_csv,
        bp      TYPE but000-partner,
        type    TYPE but000-type,
        nome    TYPE but000-name_last,
        cognome TYPE but000-name_first,
      END OF gs_csv.
DATA gt_csv LIKE STANDARD TABLE OF gs_csv.


DATA lv_file TYPE string.

SELECTION-SCREEN: BEGIN OF BLOCK b1 WITH FRAME TITLE TEXT-t01.
  PARAMETERS p_file LIKE rlgrap-filename.
SELECTION-SCREEN: END OF BLOCK b1.

lv_file = p_file.

START-OF-SELECTION.

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
    MESSAGE s208(00) WITH TEXT-001 DISPLAY LIKE 'e'.

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

  WRITE: / 'BP', '|', 'Type', '|', 'Nome', '|', 'Cognome'.
  ULINE.
  LOOP AT gt_csv INTO gs_csv.

    WRITE: / gs_csv-bp, gs_csv-type, gs_csv-nome, gs_csv-cognome.

  ENDLOOP.


end-of-SELECTION.