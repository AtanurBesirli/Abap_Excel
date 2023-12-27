*&---------------------------------------------------------------------*
*& Report ZAB_EDU_0043
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ZAB_EDU_0043.

include zzzzzzaaa.
DATA : gv_int TYPE i.
select-OPTIONS s_ad FOR gv_int NO-DISPLAY.
PARAMETERS p_ad TYPE char30 NO-DISPLAY.

START-OF-SELECTION.
call SCREEN '100'.
