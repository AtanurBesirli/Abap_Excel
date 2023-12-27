*&---------------------------------------------------------------------*
*& Include          ZAB_EDU_0028_FRM
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

  SELECT * FROM scarr INTO CORRESPONDING FIELDS OF TABLE gt_list.

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
      i_structure_name       = 'ZAB_S_028'
    CHANGING
      ct_fieldcat            = gt_fcat
    EXCEPTIONS
      inconsistent_interface = 1
      program_error          = 2
      OTHERS                 = 3.

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
  CLEAR gs_layout.
  gs_layout-zebra = 'X'.
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

  CREATE OBJECT go_main.
  go_main->sum_numbers(
    EXPORTING
      iv_num1 = p_num1
      iv_num2 = p_num2
*    IMPORTING
*      ev_sum  =
  ).



  CALL METHOD go_alv->set_table_for_first_display
    EXPORTING
*     i_buffer_active               =                  " Buffering Active
*     i_bypassing_buffer            =                  " Switch Off Buffer
*     i_consistency_check           =                  " Starting Consistency Check for Interface Error Recognition
*     i_structure_name              =                  " Internal Output Table Structure Name
*     is_variant                    =                  " Layout
*     i_save                        =                  " Save Layout
*     i_default                     = 'X'              " Default Display Variant
      is_layout                     = gs_layout                " Layout
*     is_print                      =                  " Print Control
*     it_special_groups             =                  " Field Groups
*     it_toolbar_excluding          =                  " Excluded Toolbar Standard Functions
*     it_hyperlink                  =                  " Hyperlinks
*     it_alv_graphics               =                  " Table of Structure DTC_S_TC
*     it_except_qinfo               =                  " Table for Exception Quickinfo
*     ir_salv_adapter               =                  " Interface ALV Adapter
    CHANGING
      it_outtab                     = gt_list                 " Output Table
      it_fieldcatalog               = gt_fcat                 " Field Catalog
*     it_sort                       =                  " Sort Criteria
*     it_filter                     =                  " Filter Criteria
    EXCEPTIONS
      invalid_parameter_combination = 1                " Wrong Parameter
      program_error                 = 2                " Program Errors
      too_many_lines                = 3                " Too many Rows in Ready for Input Grid
      OTHERS                        = 4.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form f_screen
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM f_screen .
  CALL SCREEN '0100'.
ENDFORM.
