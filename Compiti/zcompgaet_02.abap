REPORT zgdleser_03.

* esercizio sull'op di condizione 

SELECTION-SCREEN BEGIN OF BLOCK a2.
PARAMETERS p_str TYPE string.
SELECTION-SCREEN END OF BLOCK a2.

START-OF-SELECTION.


  IF p_str CA '0123456789'.
    WRITE 'ci sono numeri'.

  ELSE.
    WRITE 'non ci sono numeri'.
  ENDIF.