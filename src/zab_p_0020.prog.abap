*&---------------------------------------------------------------------*
*& Report ZAB_P_0020
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zab_p_0020.

INCLUDE zab_i_0020_top.
INCLUDE zab_i_0020_cls.
INCLUDE zab_i_0020_pbo.
INCLUDE zab_i_0020_pai.
INCLUDE zab_i_0020_frm.

START-OF-SELECTION.

  PERFORM f_get_data.
  PERFORM f_call_screen.
