*&---------------------------------------------------------------------*
*& Report ZAB_EDU_0015
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zab_edu_0015.

INCLUDE zab_edu_0015_top.
INCLUDE zab_edu_0015_pbo.
INCLUDE zab_edu_0015_pai.
INCLUDE zab_edu_0015_frm.

START-OF-SELECTION.

PERFORM get_data.
PERFORM set_fcat.
PERFORM set_layout.

CALL SCREEN 0100.
