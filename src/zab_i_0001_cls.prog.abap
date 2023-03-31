*&---------------------------------------------------------------------*
*& Include          ZLIB_P_AB_0001_CLS
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

    METHODS:
      generate_html_button,
      build_html
        RETURNING VALUE(rt_html) TYPE  w3_htmltab,
      on_sapevent
        FOR EVENT sapevent OF cl_gui_html_viewer
        IMPORTING action          " Action from button
                  frame
                  getdata
                  postdata
                  query_table.

ENDCLASS.


CLASS cl_event_receiver IMPLEMENTATION.

  METHOD handle_top_of_page.
    BREAK-POINT.
  ENDMETHOD.

  METHOD handle_hotspot_click.
    CLEAR :gs_book.
    READ TABLE gt_book INTO gs_book INDEX e_row_id.
    IF sy-subrc EQ 0.
      CASE e_column_id.
        WHEN 'BOOK_NAME'.
          PERFORM f_display_book_image.
          CALL SCREEN '0300'." STARTING AT 10 2
                              "ENDING AT 60 15.
*          CALL SCREEN '0111' STARTING AT 10 2
*                            ENDING AT   60 15.
      ENDCASE.
    ENDIF.
  ENDMETHOD.

  METHOD handle_double_click.
    BREAK-POINT.
  ENDMETHOD.

  METHOD handle_data_changed.
    DATA : ls_modi TYPE lvc_s_modi.

    LOOP AT er_data_changed->mt_good_cells INTO ls_modi.
      READ TABLE gt_borrow INTO gs_borrow WITH KEY borrow_id = ls_modi-row_id.
      gs_borrow-d_date = ls_modi-value.
      MODIFY zlib_ab_t_0003 FROM gs_borrow.
    ENDLOOP.
  ENDMETHOD.

  METHOD handle_onf4.
    BREAK-POINT.
  ENDMETHOD.

  METHOD handle_toolbar.
    BREAK-POINT.
  ENDMETHOD.

  METHOD handle_user_command.
    BREAK-POINT.
  ENDMETHOD.

  METHOD handle_button_click.
    BREAK-POINT.
  ENDMETHOD.

  METHOD generate_html_button.
    DATA: t_event_tab TYPE cntl_simple_events.
    DATA: ls_event LIKE LINE OF t_event_tab.
    DATA: doc_url(80),
          lt_html TYPE TABLE OF w3_html.

    CREATE OBJECT go_dock
      EXPORTING
        container_name = 'CC_ALV'.

    CREATE OBJECT go_html
      EXPORTING
        parent = go_dock.

* Build HTML
    lt_html = me->build_html( ).
*
* register event
    ls_event-eventid = go_html->m_id_sapevent.
    ls_event-appl_event = 'x'.
    APPEND ls_event TO t_event_tab.
    go_html->set_registered_events(
        EXPORTING
           events = t_event_tab ).
**
    SET HANDLER me->on_sapevent
                FOR go_html.
    go_html->load_data( IMPORTING assigned_url = doc_url
                          CHANGING  data_table = lt_html ).
**      lo_html->load_html_document(
*           EXPORTING
*                document_id  = lv_html_file_name
*           IMPORTING
*                assigned_url = doc_url
*           EXCEPTIONS
*                OTHERS       = 1 ).

    go_html->show_url( url = doc_url ).
*
    go_html->set_ui_flag( go_html->uiflag_no3dborder ).
  ENDMETHOD.

  METHOD build_html.

    DEFINE : add_html.

      APPEND &1 TO rt_html.
    END-OF-DEFINITION.

    add_html:
      '<html>',
      '<style type="text/css" >',
      'HTML { overflow: auto; height: 100%;}',
      'body{margin: 70;  padding: 60; background: #FFCC33; }',
      'input.fbutton{',
      ' font-size:16px;',
      ' font-weight:bold;',
      ' width:240px;',
      '	height:240px;',
      ' background-color: #FF0000; ',
      '	border-style:double;',
      'float:left;',
      'margin:10px 80;',
      '	cursor: pointer;}',
      '</style>',
      '<body>',
      '<FORM name="zzhtmlbutton"',
      '       method=post',
      '       action=SAPEVENT:MY_BUTTON_1?>',
      '<input type=submit name="TEST_BUTTON"',
      '      class="fbutton" value="Kitap Yönetimi"',
      '      title="">',
      '</form>',
      '<FORM name="zzhtmlbutton1"',
      '       method=post',
      '       action=SAPEVENT:MY_BUTTON_2?>',
      '<input type=submit name="TEST_BUTTON"',
      '      class="fbutton" value="Üyelik Yönetimi"',
      '      title="">',
      '</form>',
      '<FORM name="zzhtmlbutton2"',
      '       method=post',
      '       action=SAPEVENT:MY_BUTTON_3?>',
      '<input type=submit name="TEST_BUTTON"',
      '      class="fbutton" value="Adres Yönetimi"',
      '      title="">',
      '</form>',
      '</body>',
      '</html>'.

  ENDMETHOD.

  METHOD on_sapevent.
    CASE action.
      WHEN 'MY_BUTTON_1'.
        CALL SCREEN '110'.
      WHEN 'MY_BUTTON_2'.
        CALL SCREEN '120'.
      WHEN 'MY_BUTTON_3'.
        CALL SCREEN '130'.
    ENDCASE.
  ENDMETHOD.

ENDCLASS.
