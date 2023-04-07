*&---------------------------------------------------------------------*
*& Include          ZAB_I_0006_TOP
*&---------------------------------------------------------------------*

TABLES : mard, mara.

TYPES : BEGIN OF gty_mard,
          werks TYPE mard-werks,
          lgort TYPE mard-lgort,
          matnr TYPE mara-matnr,
          matkl TYPE mara-matkl,
          mtart TYPE mara-mtart,
          maktx TYPE makt-maktx,
          labst TYPE mard-labst,
          insme TYPE mard-insme,
          wgbez TYPE t023t-wgbez,
          meins TYPE mara-meins,
        END OF gty_mard.

TYPES : BEGIN OF gty_mchb,
          werks TYPE mchb-werks,
          lgort TYPE mchb-lgort,
          matnr TYPE mara-matnr,
          matkl TYPE mara-matkl,
          mtart TYPE mara-mtart,
          maktx TYPE makt-maktx,
          charg TYPE mchb-charg,
          clabs TYPE mchb-clabs,
          cinsm TYPE mchb-cinsm,
          wgbez TYPE t023t-wgbez,
          meins TYPE mara-meins,
        END OF gty_mchb.

DATA : go_alv  TYPE REF TO cl_gui_alv_grid,
       go_cust TYPE REF TO cl_gui_custom_container.

DATA : gt_data   TYPE TABLE OF zab_s_0006,
       gs_data   TYPE zab_s_0006,
       gt_fcat   TYPE lvc_t_fcat,
       gs_fcat   TYPE lvc_s_fcat,
       gs_layout TYPE lvc_s_layo.

FIELD-SYMBOLS : <gfs_fcat> TYPE lvc_s_fcat.

SELECTION-SCREEN BEGIN OF BLOCK bl1 WITH FRAME TITLE TEXT-001.
  PARAMETERS :     p_werks  TYPE mard-werks DEFAULT '1000'.
  SELECT-OPTIONS : so_matnr FOR mara-matnr,
                   so_mtart FOR mara-mtart,
                   so_matkl FOR mara-matkl.

SELECTION-SCREEN END OF BLOCK bl1.
