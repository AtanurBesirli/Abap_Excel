*&---------------------------------------------------------------------*
*& Include          ZAB_I_0009_PBO
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*& Module STATUS_0100 OUTPUT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
MODULE status_0100 OUTPUT.
  SET PF-STATUS '0100'.
* SET TITLEBAR 'xxx'.

  PERFORM f_s_data.

ENDMODULE.
*&---------------------------------------------------------------------*
*& Module STATUS_0200 OUTPUT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
MODULE status_0200 OUTPUT.
SET PF-STATUS '0200'.
* SET TITLEBAR 'xxx'.

ENDMODULE.