*&---------------------------------------------------------------------*
*& Report ZGDLESER_TEST_03
*&---------------------------------------------------------------------*
*& Data una stringa alfanumerica contare i numeri, e gli spazi.
*&---------------------------------------------------------------------*
REPORT zgdleser_test_03.


SELECTION-SCREEN BEGIN OF BLOCK a1.
  PARAMETERS p_str TYPE string.
SELECTION-SCREEN END OF BLOCK a1.

DATA: count1     TYPE i, "contatore ricerca stringa
      countnum   TYPE i, "contatore numeri
      countblank TYPE i, "contatore spazi
      countstr   TYPE i. "contatore lunghezza stringa

START-OF-SELECTION.

  countstr = strlen( p_str ).

  DO countstr TIMES.
    IF p_str+count1(1) CA '0123456789'.
      countnum = countnum + 1.

    ENDIF.
    count1 = count1 + 1.
  ENDDO.

  count1 = 0.

  DO countstr TIMES.
    IF p_str+count1(1) CA ' '.
      countblank = countblank + 1.
    ENDIF.
    count1 = count1 + 1.
  ENDDO.
  WRITE: / 'Numero di numeri nella stringa:', countnum , / 'Numero di sazi nella stringa:', countblank.