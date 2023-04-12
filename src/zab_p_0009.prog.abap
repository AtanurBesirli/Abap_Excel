*&---------------------------------------------------------------------*
*& Report ZAB_P_0009
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zab_p_0009.

INCLUDE zab_i_0009_top.
INCLUDE zab_i_0009_pbo.
INCLUDE zab_i_0009_pai.
INCLUDE zab_i_0009_frm.

AT SELECTION-SCREEN OUTPUT.

START-OF-SELECTION.

  CREATE OBJECT go_gbt.
  PERFORM f_get_data.
  PERFORM f_call_screen.
