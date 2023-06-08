REPORT zgdleser_03.

* esercizio sull'op di condizione 

PARAMETERS p_str TYPE string.
DATA numstr TYPE string VALUE '1234567890'.

START-OF-SELECTION.


  IF p_str CA numstr.
    WRITE 'ci sono numeri'. "oppure usare il MESSAGE numero(classe).

  ELSE.
    WRITE 'non ci sono numeri'. "oppure usare il MESSAGE numero(classe).
  ENDIF.