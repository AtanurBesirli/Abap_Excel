*&---------------------------------------------------------------------*
*& Report ZSF_P_AB_0001
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zab_p_0010.

INCLUDE zab_i_0010_top.
INCLUDE zab_i_0010_cls.
INCLUDE zab_i_0010_pbo.
INCLUDE zab_i_0010_pai.
INCLUDE zab_i_0010_frm.

INITIALIZATION.

AT SELECTION-SCREEN OUTPUT.

  PERFORM f_dynamic_screen.

START-OF-SELECTION.

  PERFORM f_screen.
