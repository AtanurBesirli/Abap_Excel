*&---------------------------------------------------------------------*
*& Include          ZAB_I_0044_TOP
*&---------------------------------------------------------------------*


TYPES : BEGIN OF gty_data,
        matnr TYPE mara-matnr,
        maktx TYPE makt-maktx,
        END OF gty_data.

DATA : gt_data TYPE TABLE OF gty_data,
       gs_data TYPE gty_data.

DATA : idx TYPE i,
       gv_maktx TYPE makt-maktx,
       line TYPE i,
       lines TYPE i,
       limit TYPE i,
       c TYPE i,
       p_num TYPE i,
       n1 TYPE i VALUE 1,
       n2 TYPE i,
       y_v_lim TYPE i,
       y_v_next TYPE i,
       y_v_prev TYPE i,
       ok_code TYPE sy-ucomm,
       save_ok TYPE sy-ucomm.
