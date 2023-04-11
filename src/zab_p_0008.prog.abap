*&---------------------------------------------------------------------*
*& Report ZAB_P_0008
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zab_p_0008.

INCLUDE zab_i_0008_top.
INCLUDE zab_i_0008_cls.
INCLUDE zab_i_0008_pbo.
INCLUDE zab_i_0008_pai.
INCLUDE zab_i_0008_frm.

START-OF-SELECTION.

  PERFORM f_get_data.
  PERFORM f_screen.
