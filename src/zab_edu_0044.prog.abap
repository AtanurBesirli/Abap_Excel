*&---------------------------------------------------------------------*
*& Report ZAB_EDU_0044
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zab_edu_0044.

INCLUDE zab_i_0044_top.
INCLUDE zab_i_0044_pbo.
INCLUDE zab_i_0044_pai.
INCLUDE zab_i_0044_frm.

START-OF-SELECTION.
  PERFORM f_get_data.

  CALL SCREEN '0100'.
