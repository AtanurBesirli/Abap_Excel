*&---------------------------------------------------------------------*
*& Report ZAB_EDU_0021
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zab_edu_0021.

TABLES : bkpf , bseg.

PARAMETERS : p_kunnr RADIOBUTTON GROUP rgr1  DEFAULT 'X' USER-COMMAND s1,
             p_lifnr RADIOBUTTON GROUP rgr1.

SELECT-OPTIONS : so_belnr FOR bkpf-belnr,
                  so_kunnr FOR bseg-kunnr MODIF ID gr1,
                  so_lifnr FOR bseg-lifnr MODIF ID gr2,
                  so_gjahr FOR bkpf-gjahr,
                  so_bldat FOR bkpf-bldat.

INITIALIZATION.




AT SELECTION-SCREEN OUTPUT.

  LOOP AT SCREEN.
    IF p_kunnr EQ 'X'.
      IF screen-group1 EQ 'GR1'.
        screen-active = 1.
        MODIFY SCREEN.
      ENDIF.
      IF screen-group1 EQ 'GR2'.
        screen-active = 0.
        MODIFY SCREEN.
      ENDIF.
    ENDIF.
    IF p_lifnr EQ 'X'.
      IF screen-group1 EQ 'GR2'.
        screen-active = 1.
        MODIFY SCREEN.
      ENDIF.
      IF screen-group1 EQ 'GR1'.
        screen-active = 0.
        MODIFY SCREEN.
      ENDIF.
    ENDIF.
  ENDLOOP.

START-OF-SELECTION.
