*&---------------------------------------------------------------------*
*& Include          ZAB_I_0003_PBO
*&---------------------------------------------------------------------*
MODULE status_0100 OUTPUT.
  SET PF-STATUS '0100'.
* SET TITLEBAR 'xxx'.

  PERFORM f_set_fcat.
  PERFORM f_set_layout.
  PERFORM f_set_parameter.
  PERFORM f_display_alv.
ENDMODULE.
