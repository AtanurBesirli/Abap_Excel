*&---------------------------------------------------------------------*
*& Include          ZAB_EDU_0015_TOP
*&---------------------------------------------------------------------*

DATA : go_alv  TYPE REF TO cl_gui_alv_grid,
       go_cont TYPE REF TO cl_gui_custom_container.

TYPES : BEGIN OF gty_likp,
          vbeln	TYPE vbeln_vl,
          ernam	TYPE ernam,
          erzet	TYPE erzet,
          erdat	TYPE erdat,
        END OF gty_likp.

DATA : gt_likp   TYPE TABLE OF gty_likp,
       gt_fcat   TYPE lvc_t_fcat,
       gs_fcat   TYPE lvc_s_fcat,
       gs_layout TYPE lvc_s_layo.

FIELD-SYMBOLS : <gfs_fcat> TYPE lvc_s_fcat.
