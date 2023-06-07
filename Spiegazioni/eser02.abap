*&---------------------------------------------------------------------*
*& Report ZESERGAET_02
*&---------------------------------------------------------------------*
*
*&---------------------------------------------------------------------*
REPORT zesergaet_02.




*scan
PARAMETERS p_value TYPE string.

DATA v_count TYPE i.

*Dichiarazione tipi
TYPES: BEGIN OF ty_adrc,
         addrnumber TYPE adrc-addrnumber,
         name1      TYPE adrc-name1,
         city1      TYPE adrc-city1,
       END OF ty_adrc.

* creazione tabelle
DATA: st_adrc     TYPE ty_adrc,
      tb_adrc     TYPE STANDARD TABLE OF ty_adrc,
      tb_adrc_old LIKE STANDARD TABLE OF tb_adrc.



* dichiarazioni var in linea
DATA: v_count2 TYPE i,
      v_count3 TYPE i,
      v_count4 TYPE i.




START-OF-SELECTION.

  st_Adrc-addrnumber = '70127'.
  st_adrc-city1 = 'Napoli'.
  st_adrc-name1 = 'Gaet'.

  APPEND st_adrc TO tb_adrc.
  CLEAR st_adrc. "pulisce le st_adrc

  st_Adrc-addrnumber = '70126'.
  st_adrc-city1 = 'Bari'.
  st_adrc-name1 = 'Gaetano'.

  APPEND st_adrc TO tb_adrc.
  CLEAR st_adrc.

  LOOP AT tb_adrc INTO st_adrc WHERE city1 = 'Napoli'. "loop inserisce solo Napoli.
*    IF st_adrc-city1 = 'Roma'. " se città roma salta l'inserimento nella tab.
*      CONTINUE.  "Torna alla riga del loop
*    ENDIF.
    WRITE: 'Address: ', st_adrc-addrnumber, /.
    WRITE: 'Name: ', st_adrc-city1, /.
    WRITE: 'City: ', st_adrc-name1, /.
*    EXIT.  fuori loop


  ENDLOOP.




* if, else elseif
  IF p_value > 10.
    WRITE 'maggiore di 10'.
  ELSEIF p_value = 22.
    WRITE 'sei 22'.
  ELSE.
    WRITE 'minore di 10'.


  ENDIF.
*switch
  CASE p_value.
    WHEN 23.
      WRITE '23'.
    WHEN 44.
      WRITE '44'.
  ENDCASE.

* lung stringa
  v_count = strlen( p_value ).

  WRITE v_count.


* ciclo do + write con spazi e var
  v_count = strlen( p_value ).

  DO v_count TIMES.

    WRITE: 'gg ', p_value, /.



  ENDDO.