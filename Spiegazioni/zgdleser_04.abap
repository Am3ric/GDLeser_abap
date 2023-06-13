"Data la tabella EVER e la tabella FKKVKP, importala nel report.
" iN INPUT HO IL CONTRATTO E LA DATA DI INIZIO. Es: servono i contratti che partono da una data nota.
"Move in e Move out

" Per la tabella EVER mi serve il VKONTO come chiave esterna. Mi servono anche i campi VERTRAG/EINZDAT/AUSDAT/VKONTO/ANLAGE
" Per FKKVKP mi serve il VKONT come chiave primaria per recuperare i dati.

" RECUPERO DELLA TABELLA EVER DA DB.
TABLES ever.

" DICHIARAZIONE  DELL'AREA DI MEMORIA ASSOCIATA ALLA TABELLA, LA WORK AREA.
DATA: BEGIN OF wa_ever,
        vertrag LIKE ever-vertrag,
        vkonto  LIKE ever-vkonto,
        anlage  LIKE ever-anlage,
        einzdat LIKE ever-einzdat,
        auszdat LIKE ever-auszdat,
      END OF wa_ever.

DATA i_ever LIKE STANDARD TABLE OF wa_ever.

PARAMETERS p_ver LIKE ever-vertrag. "nometabella-chiavetabella
PARAMETERS p_in LIKE ever-einzdat.

SELECT-OPTIONS s_ver FOR ever-vertrag NO INTERVALS.
SELECT-OPTIONS s_in FOR ever-einzdat.

INITIALIZATION.

  LOOP AT SCREEN.

    IF screen-name EQ 'P_VER'.
      screen-input = 0.
    ENDIF.
    MODIFY SCREEN.
  ENDLOOP.

AT SELECTION-SCREEN.
  IF s_in IS INITIAL.
    MESSAGE i208(00) WITH 'valorizzare data'.
  ENDIF.

START-OF-SELECTION.

  SELECT vertrag vkonto anlage einzdat auszdat
    FROM ever
    INTO TABLE i_ever
    WHERE "vertrag = p_ver AND
    "einzdat = p_in.
    einzdat IN s_in.

  " viene valorizzato con 0 è tutto ok, se è diverso da 0, c'è un problema.
  IF sy-subrc = 0.
    MESSAGE s208(00) WITH 'Estrazione andata bene'.
  ELSE.
    MESSAGE s208(00) WITH 'Errore estrazione tabella ever'.
  ENDIF.

END-OF-SELECTION.

  "" la wa_ever è la work area, la i_ever è la header line.