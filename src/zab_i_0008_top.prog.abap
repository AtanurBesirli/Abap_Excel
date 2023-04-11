*&---------------------------------------------------------------------*
*& Include          ZAB_I_0008_TOP
*&---------------------------------------------------------------------*

TABLES : mara, marc.

DATA : go_alv  TYPE REF TO cl_gui_alv_grid,
       go_cust TYPE REF TO cl_gui_custom_container.

CLASS : cl_event_receiver DEFINITION DEFERRED.
DATA  : go_event_receiver TYPE REF TO cl_event_receiver.

DATA : gt_data   TYPE TABLE OF zab_s_0008,
       gs_data   TYPE zab_s_0008,
       gt_fcat   TYPE lvc_t_fcat,
       gs_fcat   TYPE lvc_s_fcat,
       gs_layout TYPE lvc_s_layo.

FIELD-SYMBOLS : <gfs_fcat> TYPE lvc_s_fcat.

DATA: gt_bdcdata TYPE TABLE OF bdcdata,
      gs_bdcdata TYPE bdcdata,
      gt_messtab TYPE TABLE OF bdcmsgcoll.

DATA : gv_index TYPE i.
TYPES : BEGIN OF gty_ind,
          gv_ind TYPE i,
        END OF gty_ind.
DATA : gt_ind TYPE TABLE OF gty_ind,
       gs_ind TYPE  gty_ind.

SELECTION-SCREEN BEGIN OF BLOCK bl1 WITH FRAME TITLE TEXT-001.
  SELECT-OPTIONS : s_matnr FOR mara-matnr,
                   s_werks FOR marc-werks.

SELECTION-SCREEN END OF BLOCK bl1.
