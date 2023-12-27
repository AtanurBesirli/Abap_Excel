*&---------------------------------------------------------------------*
*& Report ZAB_P_0003
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zab_p_0003.

INCLUDE zab_i_0003_top.
INCLUDE zab_i_0003_cls.
INCLUDE zab_i_0003_pbo.
INCLUDE zab_i_0003_pai.
INCLUDE zab_i_0003_frm.

INITIALIZATION.
PERFORM f_vrm_value.

AT SELECTION-SCREEN OUTPUT.
PERFORM f_vrm_set.

START-OF-SELECTION.
PERFORM f_screen.

END-OF-SELECTION.
