*&---------------------------------------------------------------------*
*& Report ZAB_P_0006
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zab_p_0006.

INCLUDE zab_i_0006_top.
INCLUDE zab_i_0006_pbo.
INCLUDE zab_i_0006_pai.
INCLUDE zab_i_0006_frm.

START-OF-SELECTION.

  PERFORM f_get_data.
*  PERFORM f_get_data1.
  PERFORM f_call_screen.
