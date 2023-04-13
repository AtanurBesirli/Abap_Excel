*&---------------------------------------------------------------------*
*& Include          ZSF_P_AB_0001_CLS
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
        WHEN 'BELNR'.
          SET PARAMETER ID 'BLN' FIELD gs_list-belnr.
          SET PARAMETER ID 'BUK' FIELD gs_list-bukrs.
          SET PARAMETER ID 'GJR' FIELD gs_list-gjahr.
          CALL TRANSACTION 'FB03' AND SKIP FIRST SCREEN.
      ENDCASE.
    ENDIF.
  ENDMETHOD.

  METHOD handle_double_click.

    DATA : lv_big TYPE p DECIMALS 2.

    READ TABLE gt_list INTO gs_list INDEX e_row-index.

    SELECT  bkpf~bukrs
            bkpf~belnr
            bkpf~gjahr
            bseg~buzei
            bseg~wrbtr
            bkpf~waers
    FROM bkpf
    INNER JOIN bseg ON bkpf~bukrs EQ bseg~bukrs
    AND bkpf~belnr EQ bseg~belnr AND bkpf~gjahr EQ bseg~gjahr
    INTO CORRESPONDING FIELDS OF TABLE gt_detail
    WHERE bkpf~bukrs EQ gs_list-bukrs
    AND   bkpf~belnr EQ gs_list-belnr
    AND   bkpf~gjahr EQ gs_list-gjahr.

    LOOP AT gt_detail ASSIGNING <gfs_detail>.
      IF <gfs_detail>-wrbtr > lv_big.
        lv_big = <gfs_detail>-wrbtr.
      ENDIF.
    ENDLOOP.
    LOOP AT gt_detail ASSIGNING <gfs_detail>.
      IF <gfs_detail>-wrbtr EQ lv_big.
        CLEAR : gs_cell_color.
        gs_cell_color-fname = 'WRBTR'.
        gs_cell_color-color-col = '6'.
        gs_cell_color-color-int = '1'.
        gs_cell_color-color-inv = '0'.
        APPEND gs_cell_color TO <gfs_detail>-cell_color.
      ENDIF.
    ENDLOOP.

    PERFORM f_detail.

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
    ls_toolbar-function = '&PRI'.
    ls_toolbar-text     = 'Yazdır'.
    ls_toolbar-icon     = '@0X@'.
    APPEND ls_toolbar TO e_object->mt_toolbar.

    CLEAR : ls_toolbar.
    ls_toolbar-function = '&PDF'.
    ls_toolbar-text     = 'Pdf İndir'.
    ls_toolbar-icon     = '@IT@'.
    APPEND ls_toolbar TO e_object->mt_toolbar.

    CLEAR : ls_toolbar.
    ls_toolbar-function = '&EXC'.
    ls_toolbar-text     = 'Excel İndir'.
    ls_toolbar-icon     = '@J2@'.
    APPEND ls_toolbar TO e_object->mt_toolbar.

    CLEAR : ls_toolbar.
    ls_toolbar-function = '&TXT'.
    ls_toolbar-text     = 'Kaydet'.
    ls_toolbar-icon     = '@OB@'.
    APPEND ls_toolbar TO e_object->mt_toolbar.

    CLEAR : ls_toolbar.
    ls_toolbar-function = '&PDM'.
    ls_toolbar-text     = 'Pdf Gönder'.
    ls_toolbar-icon     = '@J8@'.
    APPEND ls_toolbar TO e_object->mt_toolbar.

    CLEAR : ls_toolbar.
    ls_toolbar-function = '&EXM'.
    ls_toolbar-text     = 'Excel Gönder'.
    ls_toolbar-icon     = '@J1@'.
    APPEND ls_toolbar TO e_object->mt_toolbar.
  ENDMETHOD.

  METHOD handle_user_command.

    PERFORM f_selected_rows.

    LOOP AT gt_rows INTO gs_row.
      gv_row = gs_row-index.
    ENDLOOP.

    CASE e_ucomm.
      WHEN '&PRI'.
        PERFORM f_print.
      WHEN '&PDF'.
        PERFORM f_pdf.
      WHEN '&EXC'.
        PERFORM f_excel.
      WHEN '&TXT'.
        PERFORM f_text_save.
      WHEN '&PDM'.
        PERFORM f_pdf_mail.
      WHEN '&EXM'.
        PERFORM f_excel_mail_popup.
*        perform f_exc_mail.
*        perform f_exc_mail1.
    ENDCASE.
  ENDMETHOD.

  METHOD handle_button_click.
    BREAK-POINT.
  ENDMETHOD.


ENDCLASS.
