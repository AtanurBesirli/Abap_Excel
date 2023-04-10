*&---------------------------------------------------------------------*
*& Include          ZMM_P_AB01_TOP
*&---------------------------------------------------------------------*

TYPE-POOLS icon.

TABLES : mara, makt, marc, mard.

DATA : go_alv  TYPE REF TO cl_gui_alv_grid,
       go_alv2 TYPE REF TO cl_gui_alv_grid,
       go_cust TYPE REF TO cl_gui_custom_container.

DATA : go_splitter TYPE REF TO cl_gui_splitter_container,
       go_gui1     TYPE REF TO cl_gui_container,
       go_gui2     TYPE REF TO cl_gui_container.

CLASS cl_event_receiver DEFINITION DEFERRED.
DATA : go_event_receiver TYPE REF TO cl_event_receiver.


TYPES : BEGIN OF gty_list,
          selkz  TYPE char1,
          matnr  TYPE mara-matnr,
          maktx  TYPE makt-maktx,
          mtart  TYPE mara-mtart,
          mtbez  TYPE t134t-mtbez,
          lgort  TYPE mard-lgort,
          lgobe  TYPE t001l-lgobe,
          labst  TYPE mard-labst,
          meins  TYPE mara-meins,
          lgort1 TYPE mard-lgort,
          labst1 TYPE mard-labst,
          werks  TYPE mard-werks,
          status TYPE icon_d,
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
  SELECT-OPTIONS : so_matnr  FOR mara-matnr,
                   so_mtart  FOR mara-mtart,
                   so_werks  FOR marc-werks.
SELECTION-SCREEN END OF BLOCK bl1.

SELECTION-SCREEN BEGIN OF BLOCK bl2 WITH FRAME TITLE TEXT-001.
  SELECT-OPTIONS : so_werk1  FOR marc-werks,
                   so_lgort  FOR mard-lgort.
SELECTION-SCREEN END OF BLOCK bl2.
