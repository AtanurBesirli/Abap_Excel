*&---------------------------------------------------------------------*
*& Report ZSD_P_AB01
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zab_p_0005.

INCLUDE zab_i_0005_top.
INCLUDE zab_i_0005_cls.
INCLUDE zab_i_0005_pbo.
INCLUDE zab_i_0005_pai.
INCLUDE zab_i_0005_frm.

START-OF-SELECTION.

  PERFORM f_get_data.
  PERFORM f_set_fcat.
  PERFORM f_set_fcat2.
  PERFORM f_set_layout.
  PERFORM f_set_layout2.

  CALL SCREEN 0100.
