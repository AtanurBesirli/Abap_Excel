*&---------------------------------------------------------------------*
*& Include          ZAB_I_0020_CLS
*&---------------------------------------------------------------------*
CLASS cl_event_receiver DEFINITION.
  PUBLIC SECTION.

    METHODS handle_top_of_page                                "TOP_OF_PAGE
      FOR EVENT top_of_page OF  cl_gui_alv_grid
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
    CLEAR : gs_data.
    LOOP AT er_data_changed->mt_good_cells INTO ls_modi.

      READ TABLE gt_data INTO gs_data INDEX ls_modi-row_id.
      CASE  ls_modi-fieldname.
        WHEN 'SATIS_FIYATI'.
          gs_data-satis_fiyati = ls_modi-value.
        WHEN 'SATIS_TARIHI'.
          gs_data-satis_tarihi = ls_modi-value.
          APPEND gs_data TO gt_data.
          PERFORM f_refresh_alv.
      ENDCASE.

    ENDLOOP.
    IF gs_data-satis_fiyati IS NOT INITIAL
      AND gs_data-satis_tarihi IS NOT INITIAL.
      UPDATE zab_t_0020 SET satis_fiyati = @gs_data-satis_fiyati,
                            satis_tarihi = @gs_data-satis_tarihi
                            WHERE id     = @gs_data-id.
      COMMIT WORK.
      PERFORM f_get_data.
      PERFORM f_refresh_alv.
    ENDIF.

  ENDMETHOD.

  METHOD handle_onf4.
    BREAK-POINT.
  ENDMETHOD.

  METHOD handle_toolbar.
    DATA : ls_toolbar TYPE stb_button.

    CLEAR : ls_toolbar.
    ls_toolbar-function = '&SEND1'.
    ls_toolbar-text     = 'E-Mail Gönder'.
    ls_toolbar-icon     = '@1S@'.
    ls_toolbar-quickinfo = 'Gönder'.
    APPEND ls_toolbar TO e_object->mt_toolbar.

    CLEAR : ls_toolbar.
    ls_toolbar-function = '&DEL'.
    ls_toolbar-text     = 'SİL'.
    ls_toolbar-icon     = '@11@'.
    ls_toolbar-quickinfo = 'Sil'.
    APPEND ls_toolbar TO e_object->mt_toolbar.
  ENDMETHOD.

  METHOD handle_user_command.

    PERFORM f_selected_rows.

    CASE e_ucomm.
      WHEN '&SEND1'.
        PERFORM f_send_email.
      WHEN '&DEL'.
        PERFORM f_del_car.
    ENDCASE.

  ENDMETHOD.

  METHOD handle_button_click.
    BREAK-POINT.
  ENDMETHOD.

ENDCLASS.
