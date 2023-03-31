*&---------------------------------------------------------------------*
*& Include          ZLIB_P_AB_0001_PBO
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*& Module STATUS_0100 OUTPUT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
MODULE status_0100 OUTPUT.
  SET PF-STATUS '0100'.
  SET TITLEBAR '0100'.
    PERFORM f_get_data.
ENDMODULE.
*&---------------------------------------------------------------------*
*& Module STATUS_0110 OUTPUT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
MODULE status_0110 OUTPUT.
  SET PF-STATUS '0110'.
* SET TITLEBAR 'xxx'.

  IF go_alv IS INITIAL.
    PERFORM f_get_data_lim.
    PERFORM f_set_fcat.
    PERFORM f_display_alv.
    PERFORM f_set_layout.
    PERFORM f_set_dropdown.
  ELSE.
    CALL METHOD go_alv->refresh_table_display.
  ENDIF.
ENDMODULE.
*&---------------------------------------------------------------------*
*& Module STATUS_0120 OUTPUT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
MODULE status_0120 OUTPUT.
  SET PF-STATUS '0120'.
* SET TITLEBAR 'xxx'.

  IF go_mem IS INITIAL.
    PERFORM f_get_member_data.
    PERFORM f_set_member_fcat.
    PERFORM f_display_member_alv.
    PERFORM f_set_member_layout.
  ELSE.
    CALL METHOD go_member_alv->refresh_table_display.
  ENDIF.
ENDMODULE.
*&---------------------------------------------------------------------*
*& Module STATUS_0130 OUTPUT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
MODULE status_0130 OUTPUT.
  SET PF-STATUS '0130'.
* SET TITLEBAR 'xxx'.

ENDMODULE.
*&---------------------------------------------------------------------*
*& Module STATUS_0140 OUTPUT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
MODULE status_0140 OUTPUT.
  SET PF-STATUS '0140'.
* SET TITLEBAR 'xxx'.

  IF go_borr IS INITIAL.
    PERFORM f_get_borrow_data.
    PERFORM f_set_borrow_fcat.
    PERFORM f_display_borrow_alv.
    PERFORM f_set_borrow_layout.
  ELSE.
    CALL METHOD go_borrow_alv->refresh_table_display.
  ENDIF.
  PERFORM f_borrow_helper.

ENDMODULE.
*&---------------------------------------------------------------------*
*& Module STATUS_0111 OUTPUT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
MODULE status_0111 OUTPUT.
  SET PF-STATUS '0111'.
  SET TITLEBAR '0111'.
ENDMODULE.
*&---------------------------------------------------------------------*
*& Module STATUS_0300 OUTPUT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
MODULE status_0300 OUTPUT.
  SET PF-STATUS '0300'.
* SET TITLEBAR 'xxx'.
ENDMODULE.
