*&---------------------------------------------------------------------*
*& Include          ZMM_P_AB01_CLS
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
        e_ucomm.

ENDCLASS.


CLASS cl_event_receiver IMPLEMENTATION.

  METHOD handle_top_of_page.
    BREAK-POINT.
  ENDMETHOD.

  METHOD handle_hotspot_click.
    BREAK-POINT.
  ENDMETHOD.

  METHOD handle_double_click.
    BREAK-POINT.
  ENDMETHOD.

  METHOD handle_data_changed.
    DATA : ls_modi TYPE lvc_s_modi.
    CLEAR : gs_list.
    LOOP AT er_data_changed->mt_good_cells INTO ls_modi.

      READ TABLE gt_list2 INTO gs_list INDEX ls_modi-row_id.
      CASE  ls_modi-fieldname.
        WHEN 'LGORT1'.
          gs_list-lgort1 = ls_modi-value.
        WHEN 'LABST1'.
          gs_list-labst1 = ls_modi-value.
          IF gs_list-labst < gs_list-labst1.
            MESSAGE 'Stok Yetersiz.' TYPE 'I'.
          ELSE.
            IF gs_list-labst1 <> 0 AND gs_list-lgort1 <> 0.
              APPEND gs_list TO gt_list.
              CALL METHOD go_alv->refresh_table_display.
            ENDIF.
          ENDIF.

      ENDCASE.

    ENDLOOP.
  ENDMETHOD.

  METHOD handle_onf4.
    TYPES : BEGIN OF lty_value_tab,
              lgort1 TYPE lgort_d,
              lgobe  TYPE lgobe,
            END OF lty_value_tab.

    DATA : lt_value_tab TYPE TABLE OF lty_value_tab,
           ls_value_tab TYPE lty_value_tab.

    DATA : lt_return_tab TYPE TABLE OF ddshretval,
           ls_return_tab TYPE ddshretval.

    CLEAR : ls_value_tab.
    ls_value_tab-lgort1 = '1001'.
    ls_value_tab-lgobe = 'Ana Ambar'.
    APPEND ls_value_tab TO lt_value_tab.

    CLEAR : ls_value_tab.
    ls_value_tab-lgort1 = '1002'.
    ls_value_tab-lgobe = 'Hurda Ambar'.
    APPEND ls_value_tab TO lt_value_tab.

    CLEAR : ls_value_tab.
    ls_value_tab-lgort1 = '1003'.
    ls_value_tab-lgobe = 'Koltuk Ambar'.
    APPEND ls_value_tab TO lt_value_tab.

    CLEAR : ls_value_tab.
    ls_value_tab-lgort1 = '1004'.
    ls_value_tab-lgobe = 'Dış Depo'.
    APPEND ls_value_tab TO lt_value_tab.

    CLEAR : ls_value_tab.
    ls_value_tab-lgort1 = '1005'.
    ls_value_tab-lgobe = 'İade Depo'.
    APPEND ls_value_tab TO lt_value_tab.

    CLEAR : ls_value_tab.
    ls_value_tab-lgort1 = '1006'.
    ls_value_tab-lgobe = 'Yardımcı Depo'.
    APPEND ls_value_tab TO lt_value_tab.


    CALL FUNCTION 'F4IF_INT_TABLE_VALUE_REQUEST'
      EXPORTING
        retfield     = 'LGORT1'
        window_title = 'Hedef Depo'
        value_org    = 'S'
      TABLES
        value_tab    = lt_value_tab
        return_tab   = lt_return_tab.

    READ TABLE lt_return_tab INTO ls_return_tab WITH KEY fieldname = 'F0001'.
    IF sy-subrc EQ 0.
      READ TABLE gt_list2 ASSIGNING <gfs_list> INDEX es_row_no-row_id.
      <gfs_list>-lgort1 = ls_return_tab-fieldval.
      go_alv2->refresh_table_display( ).
    ENDIF.
    er_event_data->m_event_handled = 'X'.

  ENDMETHOD.

  METHOD handle_toolbar.
    DATA : ls_toolbar TYPE stb_button.

    CLEAR : ls_toolbar.
    ls_toolbar-function = '&SAV'.
    ls_toolbar-text     = 'KAYDET'.
    ls_toolbar-icon     = '@2L@'.
    APPEND ls_toolbar TO e_object->mt_toolbar.
  ENDMETHOD.

  METHOD handle_user_command.
    CASE e_ucomm.
      WHEN '&SAV'.

        PERFORM f_bapi_fonk.
    ENDCASE.
  ENDMETHOD.

  METHOD handle_button_click.
    BREAK-POINT.
  ENDMETHOD.

ENDCLASS.
