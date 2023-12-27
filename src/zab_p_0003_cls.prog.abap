*&---------------------------------------------------------------------*
*& Include          ZAB_P_0003_CLS
*&---------------------------------------------------------------------*

CLASS cl_event_receiver DEFINITION.
  PUBLIC SECTION.

    METHODS handle_top_of_page                                "TOP_OF_PAGE
      FOR EVENT top_of_page OF cl_gui_alv_grid
      IMPORTING
        e_dyndoc_id
        table_index.

    METHODS handle_hotspot_click                              "HOTSPOT_CLICK
      FOR EVENT hotspot_click OF cl_gui_alv_grid
      IMPORTING
        e_row_id
        e_column_id.

    METHODS handle_double_click                              "DOUBLE_CLICK
      FOR EVENT double_click OF cl_gui_alv_grid
      IMPORTING
        e_row
        e_column
        es_row_no.

    METHODS handle_data_changed                              "DATA_CHANGED
      FOR EVENT data_changed OF cl_gui_alv_grid
      IMPORTING
        er_data_changed
        e_onf4
        e_onf4_before
        e_onf4_after
        e_ucomm.

    METHODS handle_onf4                                         "ONF4
      FOR EVENT onf4 OF cl_gui_alv_grid
      IMPORTING
        e_fieldname
        e_fieldvalue
        es_row_no
        er_event_data
        et_bad_cells
        e_display.

    METHODS handle_button_click                                         "BUTTON_CLICK
      FOR EVENT button_click OF cl_gui_alv_grid
      IMPORTING
        es_col_id
        es_row_no.

    METHODS handle_toolbar                                         "TOOLBAR
      FOR EVENT toolbar OF cl_gui_alv_grid
      IMPORTING
        e_object
        e_interactive.

    METHODS handle_user_command                                        "USER_COMMAND
      FOR EVENT user_command OF cl_gui_alv_grid
      IMPORTING
        e_ucomm
        sender.

ENDCLASS.


CLASS cl_event_receiver IMPLEMENTATION.

  METHOD handle_top_of_page.
    BREAK-POINT.
  ENDMETHOD.

  METHOD handle_hotspot_click.
    CLEAR :gs_list.
    READ TABLE gt_list INTO gs_list INDEX e_row_id.
    IF sy-subrc EQ 0.
      CASE e_column_id.
        WHEN 'VBELN_VA'.
          SET PARAMETER ID 'AUN' FIELD gs_list-vbeln_va.
          CALL TRANSACTION 'VA03'.
        WHEN 'VBELN_VL'.
          IF gs_list-vbeln_vl IS INITIAL.
            PERFORM f_delivery.
          ELSE.
            SET PARAMETER ID 'VL' FIELD gs_list-vbeln_vl.
            CALL TRANSACTION 'VL03N'.
          ENDIF.
        WHEN 'VBELN_VF'.
          IF gs_list-vbeln_vf IS INITIAL.
            PERFORM f_billing.
          ELSE.
            SET PARAMETER ID 'VF' FIELD gs_list-vbeln_vf.
            CALL TRANSACTION 'VF03'.
          ENDIF.

      ENDCASE.

    ENDIF.
  ENDMETHOD.

  METHOD handle_double_click.
    BREAK-POINT.
  ENDMETHOD.

  METHOD handle_data_changed.
    BREAK-POINT.
  ENDMETHOD.

  METHOD handle_onf4.
    BREAK-POINT.
  ENDMETHOD.

  METHOD handle_toolbar.
    DATA : ls_toolbar TYPE stb_button.
    CLEAR : ls_toolbar.
    ls_toolbar-function = '&Exc'.
    ls_toolbar-text     = 'Excel'.
    ls_toolbar-icon     = '@77@'.
    APPEND ls_toolbar TO e_object->mt_toolbar.

    CLEAR : ls_toolbar.
    ls_toolbar-function = '&Ado'.
    ls_toolbar-text     = 'Adobe'.
    ls_toolbar-icon     = '@0X@'.
    APPEND ls_toolbar TO e_object->mt_toolbar.
  ENDMETHOD.

  METHOD handle_user_command.

    PERFORM selected_rows.

    LOOP AT gt_rows INTO gs_row.
      gv_row = gs_row-index.
    ENDLOOP.

    CASE e_ucomm.
      WHEN '&Exc'.
        PERFORM f_excel.
      WHEN '&Ado'.
        IF gv_row = 0.
          MESSAGE 'Bir Satır Seçiniz.' TYPE 'I' DISPLAY LIKE 'W'.
        ELSE.
          PERFORM f_adobe.
        ENDIF.
    ENDCASE.
  ENDMETHOD.

  METHOD handle_button_click.
    BREAK-POINT.
  ENDMETHOD.

ENDCLASS.
