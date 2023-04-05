*&---------------------------------------------------------------------*
*& Include          ZAB_I_0004_TOP
*&---------------------------------------------------------------------*
TABLES : vbak, vbap.

DATA : go_alv  TYPE REF TO cl_gui_alv_grid,
       go_cust TYPE REF TO cl_gui_custom_container.

CLASS : cl_event_receiver DEFINITION DEFERRED.
DATA :  go_event_receiver TYPE REF TO cl_event_receiver.

DATA : gt_data   TYPE TABLE OF zab_s_0005,
       gs_data   TYPE zab_s_0005,
       gt_fcat   TYPE lvc_t_fcat,
       gs_fcat   TYPE lvc_s_fcat,
       gs_layout TYPE lvc_s_layo.

FIELD-SYMBOLS : <gfs_fcat> TYPE lvc_s_fcat.


SELECTION-SCREEN BEGIN OF BLOCK bl1 WITH FRAME TITLE TEXT-001.
  SELECT-OPTIONS : so_vbeln FOR vbak-vbeln.
  PARAMETERS :     p_auart  TYPE vbak-auart OBLIGATORY DEFAULT 'OR1'.
  SELECT-OPTIONS : so_vbtyp FOR vbak-vbtyp,
                   so_erdat FOR vbak-erdat,
                   so_kunnr FOR vbak-kunnr,
                   so_trvog FOR vbak-trvog,
                   so_matnr FOR vbap-matnr,
                   so_werks FOR vbap-werks,
                   so_lgort FOR vbap-lgort.
SELECTION-SCREEN END OF BLOCK bl1.

SELECTION-SCREEN BEGIN OF BLOCK bl2 WITH FRAME TITLE TEXT-002.
  PARAMETERS : p_rad1 RADIOBUTTON GROUP gr1,
               p_rad2 RADIOBUTTON GROUP gr1.

SELECTION-SCREEN END OF BLOCK bl2.
