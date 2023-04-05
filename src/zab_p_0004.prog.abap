*&---------------------------------------------------------------------*
*& Report ZAB_P_0004
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zab_p_0004.

INCLUDE zab_i_0004_top.
INCLUDE zab_i_0004_cls.
INCLUDE zab_i_0004_pbo.
INCLUDE zab_i_0004_pai.
INCLUDE zab_i_0004_frm.

START-OF-SELECTION.

  PERFORM f_get_data.
  PERFORM f_call_screen.
