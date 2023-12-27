*&---------------------------------------------------------------------*
*& Report ZAB_EDU_0028
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zab_edu_0028.

INCLUDE ZAB_EDU_0028_top.
INCLUDE ZAB_EDU_0028_cls.
INCLUDE ZAB_EDU_0028_cls1.
INCLUDE ZAB_EDU_0028_pbo.
INCLUDE ZAB_EDU_0028_pai.
INCLUDE ZAB_EDU_0028_frm.

INITIALIZATION.

AT SELECTION-SCREEN OUTPUT.

START-OF-SELECTION.

PERFORM f_screen.

END-OF-SELECTION.
