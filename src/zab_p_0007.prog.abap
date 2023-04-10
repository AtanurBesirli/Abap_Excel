*&---------------------------------------------------------------------*
*& Report ZMM_P_AB01
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zab_p_0007.

INCLUDE zab_i_0007_top.
INCLUDE zab_i_0007_cls.
INCLUDE zab_i_0007_pbo.
INCLUDE zab_i_0007_pai.
INCLUDE zab_i_0007_frm.

START-OF-SELECTION.

  PERFORM f_get_data.
  PERFORM f_call_screen.
