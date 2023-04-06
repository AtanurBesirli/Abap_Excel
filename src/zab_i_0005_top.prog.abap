*&---------------------------------------------------------------------*
*& Include          ZSD_P_AB01_TOP
*&---------------------------------------------------------------------*
TABLES : likp, vbak, vbap.

DATA : go_alv  TYPE REF TO cl_gui_alv_grid,
       go_alv2 TYPE REF TO cl_gui_alv_grid,
       go_cust TYPE REF TO cl_gui_custom_container.

DATA : go_splitter TYPE REF TO cl_gui_splitter_container,
       go_gui1     TYPE REF TO cl_gui_container,
       go_gui2     TYPE REF TO cl_gui_container.

CLASS cl_event_receiver DEFINITION DEFERRED.
DATA : go_event_receiver TYPE REF TO cl_event_receiver.

TYPES : BEGIN OF gty_list,
          delete TYPE char10,
          vbeln  TYPE likp-vbeln,
          posnr  TYPE lips-posnr,
          kunnr  TYPE likp-kunnr,
          name1  TYPE kna1-name1,
          kunag  TYPE likp-kunag,
          name2  TYPE kna1-name1,
          matnr  TYPE vbap-matnr,
          lfimg  TYPE lips-lfimg,
          meins  TYPE lips-meins,
          vbeln2 TYPE vbak-vbeln,
          vbeln3 TYPE vbfa-vbeln,
          posnr1 TYPE vbap-posnr,
          erdat  TYPE vbak-erdat,
          kwmeng TYPE vbap-kwmeng,
          vrkme  TYPE vbap-vrkme,
        END OF gty_list.


DATA : gt_list    TYPE TABLE OF gty_list,
       gs_list    TYPE gty_list,
       gt_list2   TYPE TABLE OF gty_list,
       gt_fcat    TYPE lvc_t_fcat,
       gt_fcat2   TYPE lvc_t_fcat,
       gs_fcat    TYPE lvc_s_fcat,
       gs_layout  TYPE lvc_s_layo,
       gs_layout2 TYPE lvc_s_layo.

FIELD-SYMBOLS : <gfs_fcat> TYPE lvc_s_fcat,
                <gfs_list> TYPE gty_list.

SELECTION-SCREEN BEGIN OF BLOCK bl1 WITH FRAME TITLE TEXT-001.
  SELECT-OPTIONS : so_vbeln  FOR likp-vbeln,
                   so_wadat  FOR likp-wadat,
                   so_vbel2  FOR vbak-vbeln,
                   so_matnr  FOR vbap-matnr.
SELECTION-SCREEN END OF BLOCK bl1.
