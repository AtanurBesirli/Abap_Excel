*&---------------------------------------------------------------------*
*& Include          ZAB_I_0004_FRM
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*& Form f_get_data
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM f_get_data .

  SELECT ekko~ebeln ,
         ekko~bukrs ,
         ekko~bsart ,
         ekko~aedat ,
         ekko~lifnr ,
         ekko~ekgrp ,
         ekko~ekorg ,
         ekpo~matnr ,
         ekpo~werks ,
         ekpo~lgort ,
         lfa1~name1 ,
         mara~mtart ,
         makt~maktx ,
         ekpo~ebelp ,
         ekpo~menge ,
         ekpo~meins
         UP TO 33 ROWS
        FROM ekko
        INNER JOIN ekpo ON ekko~ebeln = ekpo~ebeln
        INNER JOIN lfa1 ON ekko~lifnr = lfa1~lifnr
        INNER JOIN mara ON ekpo~matnr = mara~matnr
        LEFT OUTER JOIN makt ON mara~matnr = makt~matnr
        INTO CORRESPONDING FIELDS OF TABLE @gt_data
        WHERE  " ekko~bukrs  =   p_bukrs  AND
         ekko~ebeln  IN  @so_ebeln
     AND ekko~bsart  IN  @so_bsart
     AND ekko~aedat  IN  @so_aedat
     AND ekko~lifnr  IN  @so_lifnr
     AND ekko~ekgrp  IN  @so_ekgrp
     AND ekko~ekorg  IN  @so_ekorg
     AND ekpo~matnr  IN  @so_matnr
     AND ekpo~werks  IN  @so_werks
     AND ekpo~lgort  IN  @so_lgort
     AND makt~spras  = @sy-langu.

  SORT gt_data.
  DELETE ADJACENT DUPLICATES FROM gt_data.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form f_set_fcat
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM f_set_fcat .

  CALL FUNCTION 'LVC_FIELDCATALOG_MERGE'
    EXPORTING
      i_structure_name       = 'ZAB_S_0007'
    CHANGING
      ct_fieldcat            = gt_fcat          " Field Catalog with Field Descriptions
    EXCEPTIONS
      inconsistent_interface = 1                " Call parameter combination error
      program_error          = 2                " Program Errors
      others                 = 3
    .

ENDFORM.
*&---------------------------------------------------------------------*
*& Form f_set_layout
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM f_set_layout .
  CLEAR : gs_layout.
  gs_layout-zebra = 'X'.
  gs_layout-sel_mode  = 'A'.
  gs_layout-cwidth_opt = 'X'.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form f_display_alv
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM f_display_alv .

  CREATE OBJECT go_cust
    EXPORTING
      container_name = 'CC_ALV'.

  CREATE OBJECT go_alv
    EXPORTING
      i_parent = go_cust.

*  CREATE OBJECT go_alv
*    EXPORTING
*      i_parent = cl_gui_container=>screen0.

  CALL METHOD go_alv->set_table_for_first_display
    EXPORTING
      is_layout       = gs_layout
    CHANGING
      it_outtab       = gt_data
      it_fieldcatalog = gt_fcat.


ENDFORM.
*&---------------------------------------------------------------------*
*& Form f_call_screen
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM f_call_screen .
  CALL SCREEN '100'.
ENDFORM.
