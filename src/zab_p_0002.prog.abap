*&---------------------------------------------------------------------*
*& Report ZAB_P_0004
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zab_p_0002.

INCLUDE zab_i_0002_top.
INCLUDE zab_i_0002_cls.
INCLUDE zab_i_0002_pbo.
INCLUDE zab_i_0002_pai.
INCLUDE zab_i_0002_frm.

START-OF-SELECTION.

  PERFORM f_get_data.
  PERFORM f_call_screen.
