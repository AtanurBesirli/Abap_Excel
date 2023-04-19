*&---------------------------------------------------------------------*
*& Include          ZAB_I_0012_PBO
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*& Module STATUS_0100 OUTPUT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
MODULE status_0100 OUTPUT.
  SET PF-STATUS '0100'.
* SET TITLEBAR 'xxx'.

  IF go_alv IS INITIAL.
    PERFORM f_set_fcat.
    PERFORM f_set_layout.
    PERFORM f_display_alv.
  ELSE.
    PERFORM f_refresh_alv.
  ENDIF.
ENDMODULE.
