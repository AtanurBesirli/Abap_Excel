*&---------------------------------------------------------------------*
*& Include          ZAB_EDU_0015_FRM
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*& Form display_alv
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM display_alv .
  CREATE OBJECT go_cont
    EXPORTING
      container_name = 'CC_ALV'.


  CREATE OBJECT go_alv
    EXPORTING
      i_parent = go_cont.

  CALL METHOD go_alv->set_table_for_first_display
    EXPORTING
*     i_buffer_active  =                  " Buffering Active
*     i_bypassing_buffer            =                  " Switch Off Buffer
*     i_consistency_check           =                  " Starting Consistency Check for Interface Error Recognition
*      i_structure_name =                  " Internal Output Table Structure Name
*     is_variant       =                  " Layout
*     i_save           =                  " Save Layout
*     i_default        = 'X'              " Default Display Variant
     is_layout        = gs_layout                 " Layout
*     is_print         =                  " Print Control
*     it_special_groups             =                  " Field Groups
*     it_toolbar_excluding          =                  " Excluded Toolbar Standard Functions
*     it_hyperlink     =                  " Hyperlinks
*     it_alv_graphics  =                  " Table of Structure DTC_S_TC
*     it_except_qinfo  =                  " Table for Exception Quickinfo
*     ir_salv_adapter  =                  " Interface ALV Adapter
    CHANGING
      it_outtab        = gt_likp                 " Output Table
     it_fieldcatalog  = gt_fcat                 " Field Catalog
*     it_sort          =                  " Sort Criteria
*     it_filter        =                  " Filter Criteria
*    EXCEPTIONS
*     invalid_parameter_combination = 1                " Wrong Parameter
*     program_error    = 2                " Program Errors
*     too_many_lines   = 3                " Too many Rows in Ready for Input Grid
*     others           = 4
    .

ENDFORM.
*&---------------------------------------------------------------------*
*& Form get_data
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM get_data .
  SELECT likp~vbeln
         likp~ernam
         likp~erzet
         likp~erdat
     FROM likp INTO CORRESPONDING FIELDS OF TABLE gt_likp.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form set_fcat
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM set_fcat .
*  CLEAR : gs_fcat.
*  gs_fcat-fieldname = 'VBELN'.
*  gs_fcat-scrtext_s = 'Teslimat No'.
*  gs_fcat-scrtext_m = 'Teslimat Numarası'.
*  gs_fcat-scrtext_l = 'Teslimat Numarası'.
*  gs_fcat-key       = 'X'.
*  APPEND gs_fcat TO gt_fcat.
*
*  CLEAR : gs_fcat.
*  gs_fcat-fieldname = 'WADAT'.
*  gs_fcat-scrtext_s = 'Teslimat Tar.'.
*  gs_fcat-scrtext_m = 'Teslimat Tarihi'.
*  gs_fcat-scrtext_l = 'Teslimat Tarihi'.
*  APPEND gs_fcat TO gt_fcat.
*
*  CLEAR : gs_fcat.
*  gs_fcat-fieldname = 'VBELN'.
*  gs_fcat-scrtext_s = 'Sipariş No'.
*  gs_fcat-scrtext_m = 'Sipariş Numarası'.
*  gs_fcat-scrtext_l = 'Sipariş Numarası'.
*  APPEND gs_fcat TO gt_fcat.
*
*  CLEAR : gs_fcat.
*  gs_fcat-fieldname = 'MATNR'.
*  gs_fcat-scrtext_s = 'Malzeme No'.
*  gs_fcat-scrtext_m = 'Malzeme Numarası'.
*  gs_fcat-scrtext_l = 'Malzeme Numarası'.
*  APPEND gs_fcat TO gt_fcat.

  CALL FUNCTION 'LVC_FIELDCATALOG_MERGE'
   EXPORTING
     I_STRUCTURE_NAME             = 'LIKP'
*     I_INTERNAL_TABNAME           =
    CHANGING
      ct_fieldcat                  = gt_fcat
   EXCEPTIONS
     INCONSISTENT_INTERFACE       = 1
     PROGRAM_ERROR                = 2
     OTHERS                       = 3
            .
  IF sy-subrc <> 0.
* Implement suitable error handling here
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form set_layout
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM set_layout .
*  gs_layout-cwidth_opt = 'X'.
*  gs_layout-edit = ' '.
*  gs_layout-no_toolbar = ' '.
  gs_layout-zebra = 'X'.

ENDFORM.
