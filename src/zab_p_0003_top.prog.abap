*&---------------------------------------------------------------------*
*& Include          ZAB_P_0003_TOP
*&---------------------------------------------------------------------*

TABLES : vbap, vbrk, lips.

TYPE-POOLS : ole2.

DATA : go_alv  TYPE REF TO cl_gui_alv_grid,
       go_cust TYPE REF TO cl_gui_custom_container.

DATA : gt_list   TYPE TABLE OF zab_s_hw_0006,
       gs_list   TYPE zab_s_hw_0006,
       gt_fcat   TYPE lvc_t_fcat,
       gs_fcat   TYPE lvc_s_fcat,
       gs_layout TYPE lvc_s_layo.

DATA : gv_id     TYPE vrm_id,
       gt_values TYPE vrm_values,
       gs_value  TYPE vrm_value.

DATA : gt_excel  TYPE TABLE OF zab_s_hw_0007,
       gs_excel  TYPE zab_s_hw_0007,
       gs_excel1 TYPE string.

DATA: wf_deli(1)  TYPE c,
      wf_action   TYPE i,
      wf_file     TYPE string,
      wf_path     TYPE string,
      wf_fullpath TYPE string.

DATA: wf_cell_from  TYPE ole2_object,
      wf_cell_from1 TYPE ole2_object,
      wf_cell_to    TYPE ole2_object,
      wf_cell_to1   TYPE ole2_object,
      wf_excel      TYPE ole2_object,
      wf_mapl       TYPE ole2_object,
      wf_map        TYPE ole2_object,
      wf_worksheet  TYPE ole2_object,
      wf_cell       TYPE ole2_object,
      wf_cell1      TYPE ole2_object,
      wf_range      TYPE ole2_object,
      wf_range2     TYPE ole2_object,
      wf_column1    TYPE ole2_object,
      wf_interior   TYPE ole2_object.

DATA: w_cell1 TYPE ole2_object,
      w_cell2 TYPE ole2_object.

TYPES: t_data1(1500) TYPE c,
       int_ty        TYPE TABLE OF t_data1.

DATA: int_matl  TYPE int_ty,
      int_matl1 TYPE int_ty,
      wa_matl   TYPE t_data1.

FIELD-SYMBOLS: <fs>.

DATA : gv_name       TYPE fpname,
       gv_funcname   TYPE funcname,
       gs_docparams  TYPE sfpdocparams,
       gs_formoutput TYPE fpformoutput.

DATA: wc_sheets       LIKE sy-index,
      gs_outputparams TYPE sfpoutputparams.

DATA: it_tabemp   TYPE filetable,
      gd_subrcemp TYPE i.

DATA: BEGIN OF t_hex,
        l_tab TYPE x,
      END OF t_hex.

DATA : l_where TYPE string.

CONSTANTS wl_c09(2) TYPE n VALUE 09.

DATA: gt_salesorder TYPE STANDARD TABLE OF bapidlvreftosalesorder,   "sales decleration for bapi
      gs_salesorder TYPE bapidlvreftosalesorder.

DATA: gt_ship    TYPE  bapidlvcreateheader-ship_point,
      gt_billing TYPE STANDARD TABLE OF bapivbrk WITH HEADER LINE,
      gs_billing TYPE bapivbrk.

CLASS cl_event_receiver DEFINITION DEFERRED.
DATA : go_event_receiver TYPE REF TO cl_event_receiver.

FIELD-SYMBOLS : <gfs_fcat> TYPE lvc_s_fcat.

 DATA : gt_rows TYPE lvc_t_row,
        gs_row TYPE lvc_s_row,
        gv_row type int4.


SELECTION-SCREEN BEGIN OF BLOCK bl1 WITH FRAME TITLE TEXT-001.
  SELECT-OPTIONS : so_vbeln  FOR vbap-vbeln,
                   so_matnr  FOR vbap-matnr,
                   so_werks  FOR vbap-werks.

  PARAMETERS     : p_lfimg TYPE lips-lfimg,
                   p_gos   AS LISTBOX VISIBLE LENGTH 10.

  SELECT-OPTIONS : so_vbel2  FOR vbrk-vbeln.

  PARAMETERS : p_rad1 RADIOBUTTON GROUP gr1 DEFAULT 'X',
               p_rad2 RADIOBUTTON GROUP gr1.
  PARAMETERS:  p_file LIKE rlgrap-filename NO-DISPLAY.
SELECTION-SCREEN END OF BLOCK bl1.
