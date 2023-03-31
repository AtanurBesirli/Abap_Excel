*&---------------------------------------------------------------------*
*& Report ZLIB_P_AB_0001
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zab_p_0001.

INCLUDE zab_i_0001_top.
INCLUDE zab_i_0001_cls.
INCLUDE zab_i_0001_pbo.
INCLUDE zab_i_0001_pai.
INCLUDE zab_i_0001_frm.

INITIALIZATION.
  PERFORM f_generate_button.

AT SELECTION-SCREEN OUTPUT.

START-OF-SELECTION.
  PERFORM f_screen.

END-OF-SELECTION.
