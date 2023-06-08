*&---------------------------------------------------------------------*
*& Report ZCOMPGAET_01
*&---------------------------------------------------------------------*
* Inserire in imput due stringhe, stampare in output solo la più lunga, nel caso in cui le stirnghe siano uguali stampare in outpur 'Le stringhe hanno la stessa lunghezza' 
*&---------------------------------------------------------------------*
REPORT zcompgaet_01.

PARAMETERS str1 TYPE string.

PARAMETERS str2 TYPE string.

DATA: gv_lung1 TYPE i,
      gv_lung2 TYPE i.



START-OF-SELECTION.

  gv_lung1 = strlen( str1 ).

  gv_lung2 = strlen( str2 ).


  IF gv_lung1 > gv_lung2.
    WRITE: 'Stringa 1(', gv_lung1,')', ' è più lunga di Stringa 2(', gv_lung2, ')'.
  ELSEIF gv_lung2 > gv_lung1.
    WRITE: 'Stringa 2(', gv_lung2,')', ' è più lunga di Stringa 1(', gv_lung1, ')'.
  ELSE.
    WRITE: 'Stringa 1(', gv_lung1,')', ' e Stringa 2(', gv_lung2, ')', ' hanno la stessa lunghezza'.
  ENDIF.