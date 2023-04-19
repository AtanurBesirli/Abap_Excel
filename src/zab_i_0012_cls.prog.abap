*&---------------------------------------------------------------------*
*& Include          ZAB_I_0012_CLS
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

    READ TABLE gt_data INTO gs_data INDEX e_row_id.
    IF sy-subrc EQ 0.
      CASE e_column_id.
        WHEN 'MAKTX'.
          SET PARAMETER ID 'MAT' FIELD gs_data-matnr.
          CALL TRANSACTION 'MM02' AND SKIP FIRST SCREEN.
      ENDCASE.

    ENDIF.
  ENDMETHOD.

  METHOD handle_double_click.
    BREAK-POINT.
  ENDMETHOD.

  METHOD handle_data_changed.

    DATA : ls_modi TYPE lvc_s_modi,
           ls_data TYPE zab_t_0006.
    CLEAR : gs_data.
    LOOP AT er_data_changed->mt_good_cells INTO ls_modi.

      READ TABLE gt_data INTO gs_data INDEX ls_modi-row_id.
      SELECT COUNT(*) FROM mara
          WHERE matnr EQ ls_modi-value.
      IF  sy-subrc EQ 0.
        SELECT SINGLE mara~matnr
           mara~mtart
           mara~matkl
           makt~maktx
      FROM mara
      INNER JOIN makt ON makt~matnr EQ mara~matnr
      INTO CORRESPONDING FIELDS OF gs_data
      WHERE mara~matnr = ls_modi-value
      AND makt~spras = sy-langu.
        MODIFY gt_data FROM gs_data INDEX ls_modi-row_id.
        PERFORM f_refresh_alv.
      ENDIF.

    ENDLOOP.
    CASE e_ucomm.
      WHEN '&NSAVE'.
        CLEAR : ls_data.
        READ TABLE gt_data INTO gs_data INDEX ls_modi-row_id.
        IF sy-subrc EQ 0.
          ls_data-matnr = gs_data-matnr.
          ls_data-zuse = gs_data-zuse.
          ls_data-zben = gs_data-zben.
          ls_data-ernam = sy-uname.
          ls_data-erdat = sy-datum.
          ls_data-erzet = sy-uzeit.
          ls_data-zupname = sy-uname.
          ls_data-zupdate = sy-datum.
          ls_data-zuptime = sy-uzeit.
          ls_data-zcountry = gs_data-zcountry.
          INSERT INTO zab_t_0006 VALUES ls_data.
          IF sy-subrc EQ 0.
            MESSAGE TEXT-019 TYPE 'S'.
            PERFORM f_add_log USING ls_modi-row_id.
          ENDIF.
          COMMIT WORK.
        ENDIF.
    ENDCASE.

  ENDMETHOD.

  METHOD handle_onf4.
    BREAK-POINT.
  ENDMETHOD.

  METHOD handle_toolbar.
    PERFORM f_add_toolbar_button USING e_object.
  ENDMETHOD.

  METHOD handle_user_command.
    PERFORM f_selected_rows.

    LOOP AT gt_rows INTO gs_row.
      gv_row = gs_row-index.
    ENDLOOP.

    CASE e_ucomm.
      WHEN '&NADD'.
        PERFORM f_add.
      WHEN '&NDEL'.
        PERFORM f_delete.
      WHEN '&MAIL'.
        PERFORM f_mail.
      WHEN '&PRI'.
        PERFORM f_print.
      WHEN '&NSAVE'.
        PERFORM f_save.
    ENDCASE.
  ENDMETHOD.

  METHOD handle_button_click.
    BREAK-POINT.
  ENDMETHOD.

ENDCLASS.
