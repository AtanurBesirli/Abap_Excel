*&---------------------------------------------------------------------*
*& Include          ZSF_P_AB_0001_PBO
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
    IF p_kunnr EQ 'X'.
      PERFORM f_get_cust_data.
      PERFORM f_set_cust_fcat.
    ELSE.
      PERFORM f_get_comp_data.
      PERFORM f_set_comp_fcat.
    ENDIF.
    PERFORM f_set_layout.
    PERFORM f_display_alv.
  ELSE.
    CALL METHOD go_alv->refresh_table_display.
  ENDIF.

ENDMODULE.
*&---------------------------------------------------------------------*
*& Module STATUS_0200 OUTPUT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
MODULE status_0200 OUTPUT.
 SET PF-STATUS '0200'.
* SET TITLEBAR 'xxx'.

 IF go_detail_alv IS INITIAL.
   PERFORM f_set_detail_fcat.
   PERFORM f_set_detail_layout.
   PERFORM f_display_detail_alv.
   ELSE.
     CALL METHOD go_detail_alv->refresh_table_display.
 ENDIF.
ENDMODULE.
*&---------------------------------------------------------------------*
*& Module STATUS_0300 OUTPUT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
MODULE status_0300 OUTPUT.
 SET PF-STATUS '0300'.
* SET TITLEBAR 'xxx'.

 IF go_log_alv IS INITIAL.
   PERFORM f_get_log_data.
   PERFORM f_set_log_fcat.
   PERFORM f_set_log_layout.
   PERFORM f_display_log_alv.
   ELSE.
     CALL METHOD go_log_alv->refresh_table_display.
 ENDIF.
ENDMODULE.
