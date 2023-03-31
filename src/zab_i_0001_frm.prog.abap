*&---------------------------------------------------------------------*
*& Include          ZLIB_P_AB_0001_FRM
*&---------------------------------------------------------------------*

*&---------------------------------------------------------------------*
*& Form generate_button
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM f_generate_button .
  CREATE OBJECT go_report.
  go_report->generate_html_button( ).
ENDFORM.
*&---------------------------------------------------------------------*
*& Form f_create_alv
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM f_display_alv .
  CREATE OBJECT go_cust
    EXPORTING
      container_name = 'CC_ALV1'.

  CREATE OBJECT go_alv
    EXPORTING
      i_parent = go_cust.

  CREATE OBJECT go_event_receiver.

  SET HANDLER go_event_receiver->handle_hotspot_click FOR go_alv.

  CALL METHOD go_alv->set_table_for_first_display
    EXPORTING
      is_layout       = gs_layout
    CHANGING
      it_outtab       = gt_bookl
      it_fieldcatalog = gt_fcat.
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
      i_buffer_active  = 'X'
      i_structure_name = 'ZLIB_AB_S_0001'
    CHANGING
      ct_fieldcat      = gt_fcat.

  LOOP AT gt_fcat ASSIGNING <gfs_fcat>.
    CASE <gfs_fcat>-fieldname.
      WHEN 'BOOK_ID'.
        <gfs_fcat>-outputlen = 6.
      WHEN 'SHELF_ID'.
        <gfs_fcat>-outputlen = 10.
      WHEN 'BOOK_NAME'.
        <gfs_fcat>-outputlen = 29.
        <gfs_fcat>-hotspot   = 'X'.
      WHEN 'AUTHOR'.
        <gfs_fcat>-outputlen = 22.
      WHEN 'BOOK_EDATE'.
        <gfs_fcat>-outputlen = 9.
      WHEN 'CATEGORY'.
        <gfs_fcat>-outputlen = 12.
      WHEN 'ISBN'.
        <gfs_fcat>-outputlen = 12.
    ENDCASE.

  ENDLOOP.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form f_get_data
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM f_get_data .
  CLEAR : gs_book.
  SELECT book_id
         shelf_id
         book_name
         author
         isbn
         book_edate
         category FROM zlib_ab_t_0001
    INTO CORRESPONDING FIELDS OF TABLE gt_book.
  SORT gt_book BY book_id.

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
ENDFORM.
*&---------------------------------------------------------------------*
*& Form f_data_search
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM f_data_search .

  IF  gv_bookname   IS INITIAL
  AND gv_shelfid    IS INITIAL
  AND gv_author     IS INITIAL
  AND gv_bookid     IS INITIAL
  AND gv_category   IS INITIAL
  AND gv_book_edate IS INITIAL
  AND gv_isbn       IS INITIAL.
    PERFORM f_get_data_lim.
    MESSAGE TEXT-016 TYPE 'I' DISPLAY LIKE 'E'.

  ELSEIF gv_bookid IS NOT INITIAL.
    CLEAR : gv_book_edate,
            gv_isbn.
    PERFORM f_book_search.
  ELSEIF gv_book_edate IS NOT INITIAL.
    CLEAR : gv_isbn.
    PERFORM f_book_search.
  ELSEIF gv_isbn IS NOT INITIAL.
    PERFORM f_book_search.
  ELSE.
    PERFORM f_books_search.
  ENDIF.
  CLEAR : gv_bookid,
          gv_book_edate.
  CALL METHOD go_alv->refresh_table_display.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form f_set_dropdown
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM f_set_dropdown .
  CLEAR : gt_values.
  DATA : lv_str TYPE string.
  gv_cat = 'GV_CATEGORY'.

  LOOP AT gt_book INTO gs_book GROUP BY gs_book-category.
    gs_value-key  = gs_book-category.
    gs_value-text = gs_book-category.
    APPEND gs_value TO gt_values.

  ENDLOOP.

  CALL FUNCTION 'VRM_SET_VALUES'
    EXPORTING
      id     = gv_cat
      values = gt_values.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form f_data_save
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM f_data_save .
  IF  gv_bookname   IS NOT INITIAL
  AND gv_author     IS NOT INITIAL
  AND gv_book_edate IS NOT INITIAL
  AND gv_category   IS NOT INITIAL
  AND gv_shelfid    IS NOT INITIAL
  AND gv_bookid     IS NOT INITIAL.

    READ TABLE gt_book INTO gs_book WITH KEY book_id = gv_bookid.
    IF sy-subrc <> 0.
      READ TABLE gt_book INTO gs_book WITH KEY shelf_id = gv_shelfid.
      IF sy-subrc <> 0.
        PERFORM f_get_shelf_data.
        READ TABLE gt_shelf INTO gs_shelf WITH KEY shelf_id = gv_shelfid.
        IF sy-subrc EQ 0.

          gs_book-book_id     = gv_bookid.
          gs_book-shelf_id    = gv_shelfid.
          gs_book-book_name   = gv_bookname.
          gs_book-author      = gv_author.
          gs_book-isbn        = gv_isbn.
          gs_book-book_edate  = gv_book_edate.
          gs_book-category    = gv_category.

          INSERT INTO zlib_ab_t_0001 VALUES gs_book.
          MESSAGE TEXT-004 TYPE 'I' DISPLAY LIKE 'S'.
          PERFORM f_get_data.
          CLEAR:  gv_bookid,
                  gv_bookname,
                  gv_author,
                  gv_category,
                  gv_isbn,
                  gv_book_edate,
                  gv_shelfid.
        ELSE.
          MESSAGE TEXT-022 TYPE 'I'.
        ENDIF.
      ELSE.
        MESSAGE TEXT-003 TYPE 'I' DISPLAY LIKE 'E'.
      ENDIF.
    ELSE.
      MESSAGE TEXT-002 TYPE 'I' DISPLAY LIKE 'E'.
    ENDIF.
  ELSE.
    MESSAGE TEXT-001 TYPE 'I' DISPLAY LIKE 'E'.
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form f_data_del
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM f_data_del .
  IF  gv_bookid   IS NOT INITIAL.
    IF gv_bookname IS NOT INITIAL.
      READ TABLE gt_book INTO gs_book WITH KEY book_id = gv_bookid
                                             book_name = gv_bookname .
      IF sy-subrc EQ 0.
        DELETE FROM zlib_ab_t_0001 WHERE book_id   EQ gv_bookid
                           AND book_name EQ gv_bookname.
        COMMIT WORK AND WAIT.
        PERFORM f_get_data.
        MESSAGE TEXT-006 TYPE 'I' DISPLAY LIKE 'S'.
      ELSE.
        MESSAGE TEXT-008 TYPE 'I' DISPLAY LIKE 'E'.
      ENDIF.
    ELSE.
      MESSAGE TEXT-007 TYPE 'I' DISPLAY LIKE 'E'.
    ENDIF.
  ELSE.
    MESSAGE TEXT-005 TYPE 'I' DISPLAY LIKE 'E'.
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form f_data_sall
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM f_data_sall .

  CALL FUNCTION 'F4_FILENAME'
    EXPORTING
      field_name = 'P_FILE'
    IMPORTING
      file_name  = p_file.


  CALL FUNCTION 'TEXT_CONVERT_XLS_TO_SAP'
    EXPORTING
*     I_FIELD_SEPERATOR    =
      i_line_header        = 'X'
      i_tab_raw_data       = gt_raw_data
      i_filename           = p_file
    TABLES
      i_tab_converted_data = gt_itab
    EXCEPTIONS
      conversion_failed    = 1
      OTHERS               = 2.
  IF sy-subrc <> 0.
* Implement suitable error handling here
  ENDIF.

  LOOP AT gt_itab INTO gs_itab.
    INSERT INTO zlib_ab_t_0001 VALUES gs_itab.
  ENDLOOP.

  PERFORM f_get_data.

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
*&---------------------------------------------------------------------*
*& Form f_member_save
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM f_member_save .

  DATA : lv_int TYPE i.
  IF   gv_fname   IS NOT INITIAL
   AND gv_lname   IS NOT INITIAL
   AND gv_age     IS NOT INITIAL
   AND gv_address IS NOT INITIAL
   AND gv_memdate IS NOT INITIAL.

    LOOP AT gt_member INTO gs_member .
      lv_int += 1.
      IF lv_int <> gs_member-id.
        EXIT.
      ENDIF.
    ENDLOOP.

    SELECT COUNT(*) FROM zlib_ab_t_0002
  WHERE id EQ lv_int.
    IF  sy-subrc EQ 0.
      lv_int += 1.
    ENDIF.

    gs_member-id              = lv_int.
    gs_member-firstname       = gv_fname.
    gs_member-lastname        = gv_lname.
    gs_member-age             = gv_age.
    gs_member-address         = gv_address.
    gs_member-membership_date = gv_memdate.

    INSERT INTO zlib_ab_t_0002 VALUES gs_member.
    MESSAGE TEXT-004 TYPE 'S'.
    PERFORM f_get_member_data.

    CLEAR : gv_id,
            gv_fname,
            gv_lname,
            gv_age,
            gv_address,
            gv_memdate.
  ELSE.
    MESSAGE TEXT-001 TYPE 'I' DISPLAY LIKE 'E'.
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form f_member_del
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM f_member_del .

  CALL METHOD go_member_alv->get_selected_rows
    IMPORTING
      et_index_rows = gt_rows.

  IF gt_rows IS INITIAL.
    MESSAGE TEXT-009 TYPE 'S' DISPLAY LIKE 'I'.
  ELSE.
    LOOP AT gt_rows INTO gs_row.
      CLEAR gs_member.
      READ TABLE gt_member INTO gs_member INDEX gs_row-index.
      IF sy-subrc EQ 0.
        DELETE FROM zlib_ab_t_0002 WHERE id EQ gs_member-id.
        COMMIT WORK AND WAIT.
      ENDIF.
    ENDLOOP.
    MESSAGE TEXT-006 TYPE 'S'.
    PERFORM f_get_member_data.

  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form f_member_search
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM f_member_search .

  IF   gv_id      IS INITIAL
   AND gv_fname   IS INITIAL
   AND gv_lname   IS INITIAL
   AND gv_age     IS INITIAL
   AND gv_address IS INITIAL
   AND gv_memdate IS INITIAL.

    MESSAGE TEXT-012 TYPE 'S' DISPLAY LIKE 'I'.
    PERFORM f_get_member_data.
  ELSE.
    CLEAR : gt_member.
    SELECT id
    firstname
    lastname
    age
    address
    membership_date FROM zlib_ab_t_0002
    INTO CORRESPONDING FIELDS OF TABLE gt_member
    WHERE id EQ gv_id
    OR firstname EQ gv_fname
    OR lastname EQ gv_lname
    OR age EQ gv_age
    OR address EQ gv_address
    OR membership_date EQ gv_memdate.
  ENDIF.


ENDFORM.
*&---------------------------------------------------------------------*
*& Form f_get_member_data
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM f_get_member_data .
  CLEAR gt_member.
  SELECT * FROM zlib_ab_t_0002
    INTO CORRESPONDING FIELDS OF TABLE gt_member.

  SORT gt_member BY id.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form f_set_member_fcat
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM f_set_member_fcat .

  CLEAR : gt_mem_fcat.
  CALL FUNCTION 'LVC_FIELDCATALOG_MERGE'
    EXPORTING
      i_structure_name = 'ZLIB_AB_S_0002'
    CHANGING
      ct_fieldcat      = gt_mem_fcat.

  LOOP AT gt_mem_fcat ASSIGNING <gfs_fcat>.
    CASE <gfs_fcat>-fieldname.
      WHEN 'ID'.
        <gfs_fcat>-outputlen = 8.
      WHEN 'FIRSTNAME'.
        <gfs_fcat>-outputlen = 22.
      WHEN 'LASTNAME'.
        <gfs_fcat>-outputlen = 22.
      WHEN 'AGE'.
        <gfs_fcat>-outputlen = 7.
      WHEN 'ADDRESS'.
        <gfs_fcat>-outputlen = 32.
      WHEN 'MEMBERSHIP_DATE'.
        <gfs_fcat>-outputlen = 10.
      WHEN 'LOEKZ'.
        <gfs_fcat>-edit = 'X'.
        <gfs_fcat>-no_out = 'X'.
    ENDCASE.
  ENDLOOP.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form f_display_member_alv
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM f_display_member_alv .
  CREATE OBJECT go_mem
    EXPORTING
      container_name = 'CC_ALV2'.

  CREATE OBJECT go_member_alv
    EXPORTING
      i_parent = go_mem.

  CALL METHOD go_member_alv->set_table_for_first_display
    EXPORTING
      is_layout       = gs_member_layout
    CHANGING
      it_outtab       = gt_member
      it_fieldcatalog = gt_mem_fcat.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form f_set_member_layout
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM f_set_member_layout .
  CLEAR : gs_member_layout.
  gs_member_layout-zebra = 'X'.
*  gs_member_layout-sel_mode = 'A'.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form f_shelf_create
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM f_shelf_create .
  IF   gv_kno   IS NOT INITIAL
   AND gv_rno   IS NOT INITIAL
   AND gv_rkat  IS NOT INITIAL
   AND gv_rsira IS NOT INITIAL.

    CONCATENATE 'K' gv_kno 'R' gv_rno 'RK' gv_rkat 'S' gv_rsira INTO gv_shelfid.
    PERFORM f_get_shelf_data.
  ELSE.
    MESSAGE TEXT-001 TYPE 'S' DISPLAY LIKE 'I'.
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form f_shelf_save
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM f_shelf_save .
  IF gv_shelfid IS NOT INITIAL.
    READ TABLE gt_shelf INTO gs_shelf WITH KEY shelf_id = gv_shelfid.
    IF sy-subrc <> 0.

      gs_shelf-kat_no   = gv_kno.
      gs_shelf-raf_no   = gv_rno.
      gs_shelf-raf_kat  = gv_rkat.
      gs_shelf-raf_sira = gv_rsira.
      gs_shelf-shelf_id = gv_shelfid.

      INSERT INTO zlib_ab_t_0004 VALUES gs_shelf.
      MESSAGE TEXT-004 TYPE 'S'.
      PERFORM f_clear_shelf .
    ELSE.
      MESSAGE TEXT-019 TYPE 'S' DISPLAY LIKE 'I'.
    ENDIF.
  ELSE.
    MESSAGE TEXT-001 TYPE 'S' DISPLAY LIKE 'I'.
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form f_shelf_delete
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM f_shelf_delete .
  IF gv_shelfid IS NOT INITIAL.
    READ TABLE gt_shelf INTO gs_shelf WITH KEY shelf_id = gv_shelfid.
    IF sy-subrc EQ 0.
      DELETE FROM zlib_ab_t_0004 WHERE shelf_id EQ gv_shelfid.
      MESSAGE TEXT-006 TYPE 'I' DISPLAY LIKE 'S'.
      PERFORM f_clear_shelf .
    ELSE.
      MESSAGE TEXT-020 TYPE 'I' DISPLAY LIKE 'E'.
    ENDIF.
  ELSE.
    MESSAGE TEXT-001 TYPE 'I' DISPLAY LIKE 'E'.
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form f_data_bor
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM f_data_bor .
  CALL SCREEN '0140'.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form f_get_borrow_data
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM f_get_borrow_data .
  CLEAR : gs_borrow,
          gt_borrow.

  SELECT borrow_id
         book_id_bo
         book_name_bo
         firstname_bo
         lastname_bo
         address_bo
         b_date
         d_date FROM zlib_ab_t_0003
    INTO CORRESPONDING FIELDS OF TABLE gt_borrow.
  PERFORM f_get_member_data.

  SORT gt_borrow BY borrow_id.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form f_set_borrow_fcat
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM f_set_borrow_fcat .
  CALL FUNCTION 'LVC_FIELDCATALOG_MERGE'
    EXPORTING
      i_structure_name = 'ZLIB_AB_S_0003'
    CHANGING
      ct_fieldcat      = gt_borr_fcat.

  LOOP AT gt_borr_fcat ASSIGNING <gfs_fcat>.
    CASE <gfs_fcat>-fieldname.
      WHEN 'BOOK_ID_BO'.
        <gfs_fcat>-outputlen = 10.
      WHEN 'BOOK_NAME_BO'.
        <gfs_fcat>-outputlen = 23.
      WHEN 'FIRSTNAME_BO'.
        <gfs_fcat>-outputlen = 20.
      WHEN 'LASTNAME_BO'.
        <gfs_fcat>-outputlen = 20.
      WHEN 'ADDRESS_BO'.
        <gfs_fcat>-outputlen = 20.
        <gfs_fcat>-no_out    = 'X'.
      WHEN 'B_DATE'.
        <gfs_fcat>-outputlen = 12.
      WHEN 'D_DATE'.
        <gfs_fcat>-outputlen = 12.
        <gfs_fcat>-edit = 'X'.
    ENDCASE.
  ENDLOOP.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form f_display_borrow_alv
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM f_display_borrow_alv .
  CREATE OBJECT go_borr
    EXPORTING
      container_name = 'CC_ALV3'.

  CREATE OBJECT go_borrow_alv
    EXPORTING
      i_parent = go_borr.

  SET HANDLER go_event_receiver->handle_data_changed FOR go_borrow_alv.

  CALL METHOD go_borrow_alv->set_table_for_first_display
    EXPORTING
      is_layout       = gs_borrow_layout
    CHANGING
      it_outtab       = gt_borrow
      it_fieldcatalog = gt_borr_fcat.

  CALL METHOD go_borrow_alv->register_edit_event
    EXPORTING
      i_event_id = cl_gui_alv_grid=>mc_evt_modified.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form f_set_borrow_layout
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM f_set_borrow_layout .
  CLEAR : gs_borrow_layout.
  gs_borrow_layout-zebra = 'X'.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form f_borrow_save
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM f_borrow_save .
  TYPES : BEGIN OF lty_borrow,
            z_book_id_bo TYPE zlib_ab_de_bid,
          END OF lty_borrow.
  DATA : lv_row_count TYPE i,
         lt_borrow    TYPE TABLE OF lty_borrow,
         ls_borrow    TYPE lty_borrow.
  CLEAR : lt_borrow,
          ls_borrow,
          gs_borrow-d_date.

  IF  gv_bdate IS NOT INITIAL.

    gs_borrow-book_id_bo   = gv_bookid_bo.
    gs_borrow-book_name_bo = gv_bname_bo.
    gs_borrow-firstname_bo = gv_fname_bo.
    gs_borrow-lastname_bo  = gv_lname_bo.
    gs_borrow-b_date       = gv_bdate.
    gs_borrow-address_bo   = gv_addr_bo.

    READ TABLE gt_book INTO gs_book WITH KEY book_id   = gv_bookid_bo
                                             book_name = gv_bname_bo.
    IF sy-subrc EQ 0.
      READ TABLE gt_member INTO gs_member WITH KEY id        = gv_id
                                                   firstname = gv_fname_bo
                                                   lastname  = gv_lname_bo.
      IF sy-subrc EQ 0.

        SELECT book_id_bo FROM zlib_ab_t_0003 WHERE d_date IS INITIAL
        INTO TABLE @lt_borrow.

        READ TABLE lt_borrow INTO ls_borrow WITH KEY z_book_id_bo = gv_bookid_bo.
        IF sy-subrc <> 0.
          DESCRIBE TABLE gt_borrow LINES lv_row_count.
          gs_borrow-borrow_id = lv_row_count + 1.
          INSERT INTO zlib_ab_t_0003 VALUES gs_borrow.
          COMMIT WORK AND WAIT.
          MESSAGE TEXT-004 TYPE 'I' DISPLAY LIKE 'S'.
        ELSE.
          MESSAGE TEXT-021 TYPE 'I' DISPLAY LIKE 'E'.
        ENDIF.
      ELSE.
        MESSAGE TEXT-015 TYPE 'I' DISPLAY LIKE 'E'.
      ENDIF.
    ELSE.
      MESSAGE TEXT-014 TYPE 'I' DISPLAY LIKE 'E'.
    ENDIF.
    PERFORM f_get_borrow_data.
    CALL METHOD go_borrow_alv->refresh_table_display.
  ELSE.
    MESSAGE TEXT-018 TYPE 'I' DISPLAY LIKE 'E'.
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form f_display_book_image
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM f_display_book_image .

  DATA : lv_url(250) TYPE c.
  lv_url = 'https://productimages.hepsiburada.net/s/7/550/9063041138738.jpg'.

  CREATE OBJECT go_pict
    EXPORTING
      container_name = 'CC_IMAGE1'.

  CREATE OBJECT go_picture
    EXPORTING
      parent = go_pict.

  CALL METHOD go_picture->set_3d_border
    EXPORTING
      border = 1.                " Frame (1 = Yes, 0 = No)

  CALL METHOD go_picture->set_display_mode
    EXPORTING
      display_mode = cl_gui_picture=>display_mode_fit_center.

  CALL METHOD go_picture->load_picture_from_url
    EXPORTING
      url    = lv_url
    IMPORTING
      result = gv_result.                 " Load Successful (0 = No, 1 = Yes)

  CALL METHOD cl_gui_cfw=>flush
    EXCEPTIONS
      cntl_system_error = 1
      cntl_error        = 2.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form f_book_search
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM f_book_search .
  CLEAR : gt_book.
  DATA : lv_isbn TYPE int8.
  lv_isbn = gv_isbn.

  SELECT book_id
     shelf_id
     book_name
     author
     isbn
     book_edate
     category
FROM zlib_ab_t_0001
INTO CORRESPONDING FIELDS OF TABLE gt_bookl
WHERE book_edate EQ gv_book_edate
OR book_id EQ gv_bookid
OR isbn EQ lv_isbn.
  IF sy-subrc <> 0.
    MESSAGE TEXT-017 TYPE 'I' DISPLAY LIKE 'E'.
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form f_books_search
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM f_books_search .
  CLEAR : gt_bookl,
          gs_book.
  DATA : lv_bon TYPE string,
         lv_sid TYPE string,
         lv_aut TYPE string.

  CONCATENATE '%' gv_bookname '%' INTO lv_bon.
  CONCATENATE '%' gv_shelfid  '%' INTO lv_sid.
  CONCATENATE '%' gv_author   '%' INTO lv_aut.

  IF gv_category IS INITIAL.
    SELECT book_id,
           shelf_id,
           book_name,
           author,
           isbn,
           book_edate,
           category
    FROM zlib_ab_t_0001
    WHERE book_name LIKE @lv_bon
    AND shelf_id LIKE @lv_sid
    AND author LIKE @lv_aut
    INTO CORRESPONDING FIELDS OF TABLE @gt_bookl.
    IF sy-subrc <> 0.
      MESSAGE TEXT-017 TYPE 'I' DISPLAY LIKE 'E'.
    ENDIF.
  ELSE.
    SELECT book_id,
           shelf_id,
           book_name,
           author,
           isbn,
           book_edate,
           category
     FROM zlib_ab_t_0001
     WHERE book_name LIKE @lv_bon
     AND shelf_id LIKE @lv_sid
     AND author LIKE @lv_aut
     AND category LIKE @gv_category
     INTO CORRESPONDING FIELDS OF TABLE @gt_bookl.
    IF sy-subrc <> 0.
      MESSAGE TEXT-017 TYPE 'I' DISPLAY LIKE 'E'.
    ENDIF.
  ENDIF.
  CLEAR : gv_bookname,
          gv_author,
          gv_category,
          gv_shelfid.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form f_clear_var
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM f_clear_var .
  CLEAR : gv_bookid_bo,
          gv_bname_bo,
          gv_id,
          gv_fname_bo,
          gv_lname_bo,
          gv_bdate,
          gt_member.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form f_borrow_helper
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM f_borrow_helper .

  IF gv_bookid_bo IS NOT INITIAL.
    READ TABLE gt_book INTO gs_book WITH KEY book_id = gv_bookid_bo.
    gv_bname_bo = gs_book-book_name.
    IF sy-subrc <> 0.
      CLEAR : gv_bname_bo.
    ENDIF.
  ENDIF.
  IF gv_id IS NOT INITIAL.
    READ TABLE gt_member INTO gs_member WITH KEY id = gv_id.
    gv_fname_bo   = gs_member-firstname.
    gv_lname_bo   = gs_member-lastname.
    gv_addr_bo    = gs_member-address.
    IF sy-subrc <> 0.
      CLEAR : gv_fname_bo,
              gv_lname_bo,
              gv_addr_bo.
    ENDIF.
  ENDIF.
  IF gv_bdate IS NOT INITIAL.
    DATA : v_iprkz LIKE mara-iprkz.
    v_iprkz = 'D'.

    CALL FUNCTION 'CONVERSION_EXIT_PERKZ_INPUT'
      EXPORTING
        input  = v_iprkz
      IMPORTING
        output = v_iprkz.

    CALL FUNCTION 'ADD_TIME_TO_DATE'
      EXPORTING
        i_idate = gv_bdate
        i_time  = 15
        i_iprkz = v_iprkz
      IMPORTING
        o_idate = gv_dtbdel.

  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form f_get_shelf_data
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM f_get_shelf_data .
  CLEAR : gt_shelf,
          gs_shelf.
  SELECT shelf_id
    FROM zlib_ab_t_0004
    INTO CORRESPONDING FIELDS OF TABLE gt_shelf.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form f_clear_shelf
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM f_clear_shelf .
  CLEAR : gv_kno,
          gv_rno,
          gv_rkat,
          gv_rsira,
          gv_shelfid.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form f_clear_member
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM f_clear_member .
  CLEAR : gv_id,
          gv_fname,
          gv_lname,
          gv_address,
          gv_age,
          gv_memdate.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form f_get_data_lim
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM f_get_data_lim .
  CLEAR : gs_book.
  SELECT book_id
         shelf_id
         book_name
         author
         isbn
         book_edate
         category UP TO 100 ROWS FROM zlib_ab_t_0001
    INTO CORRESPONDING FIELDS OF TABLE gt_bookl.
  SORT gt_book BY book_id.

ENDFORM.
