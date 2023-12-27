*&---------------------------------------------------------------------*
*& Report ZAB_EDU_38
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ZAB_EDU_38.

DATA : gt_scarr TYPE TABLE OF scarr,
       go_salv  TYPE REF TO cl_salv_table.


START-OF-SELECTION.

  SELECT * FROM scarr INTO TABLE gt_scarr.

  cl_salv_table=>factory(
    IMPORTING
      r_salv_table   =   go_salv
    CHANGING
      t_table        =    gt_scarr
  ).

DATA : lo_display TYPE REF TO cl_salv_display_settings,
       lo_cols TYPE REF TO cl_salv_columns,
       lo_col TYPE REF TO cl_salv_column,
       lo_func TYPE REF TO cl_salv_functions,
       lo_header TYPE REF TO cl_salv_form_layout_grid,
       lo_h_label TYPE REF TO cl_salv_form_label,
       lo_h_flow TYPE REF TO cl_salv_form_layout_flow.

CREATE OBJECT lo_header.



lo_display = go_salv->get_display_settings( ).
lo_cols    = go_salv->get_columns( ).
lo_col     = lo_cols->get_column( columnname = 'URL' ).
lo_func    = go_salv->get_functions( ).

TRY .
lo_display->set_list_header( value = 'Coco Jambo' ).
lo_display->set_striped_pattern( value = abap_true ).

lo_cols->set_optimize( value = abap_true ).

lo_col->set_long_text( value = 'Good Job' ).

lo_func->set_all( value = abap_true ).

lo_h_label = lo_header->create_label(
               row         = 1
               column      = 1
             ).
lo_h_label->set_text( value = 'Good Luck' ).

lo_h_flow = lo_header->create_flow(
              row     = 2
              column  = 1 ).
lo_h_flow->create_text(
  EXPORTING
    text     = 'Second'

).
CATCH cx_salv_not_found.

ENDTRY.

  go_salv->set_top_of_list( value = lo_header ).

*  go_salv->set_screen_popup(            pop up seklinde gösterir.
*    EXPORTING
*      start_column =
**      end_column   =
*      start_line   =
**      end_line     =
*  ).

  go_salv->display( ).
