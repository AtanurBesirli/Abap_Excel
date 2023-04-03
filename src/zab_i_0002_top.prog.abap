*&---------------------------------------------------------------------*
*& Include          ZAB_I_0004_TOP
*&---------------------------------------------------------------------*
TABLES : ekko, ekpo.

DATA : go_alv  TYPE REF TO cl_gui_alv_grid,
       go_cust TYPE REF TO cl_gui_custom_container.

DATA : gt_data   TYPE TABLE OF zab_s_0007,
       gs_data   TYPE zab_s_0007,
       gt_fcat   TYPE lvc_t_fcat,
       gs_fcat   TYPE lvc_s_fcat,
       gs_layout TYPE lvc_s_layo.

FIELD-SYMBOLS : <gfs_fcat> TYPE lvc_s_fcat.

SELECTION-SCREEN BEGIN OF BLOCK bl1 WITH FRAME TITLE TEXT-001.
  SELECT-OPTIONS :  so_ebeln FOR ekko-ebeln.
  PARAMETERS:       p_bukrs TYPE ekko-bukrs OBLIGATORY DEFAULT 'TR01' .
  SELECT-OPTIONS :  so_bsart FOR ekko-bsart,
                    so_aedat FOR ekko-aedat,
                    so_lifnr FOR ekko-lifnr,
                    so_ekgrp FOR ekko-ekgrp,
                    so_ekorg FOR ekko-ekorg,
                    so_matnr FOR ekpo-matnr,
                    so_werks FOR ekpo-werks,
                    so_lgort FOR ekpo-lgort.
  SELECTION-SCREEN END OF BLOCK bl1.
