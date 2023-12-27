*&---------------------------------------------------------------------*
*& Include          ZAB_I_0020_FRM
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

  SELECT * FROM zab_t_0020 AS z
    INTO CORRESPONDING FIELDS OF TABLE gt_data1
    WHERE z~marka        IN so_marka
    AND   z~vites        IN so_vites
    AND   z~yakit        IN so_yakit
    AND   z~model        IN so_model
    AND   z~tarih        IN so_tarih
    AND   z~kilometre    IN so_km
    AND   z~fiyat        IN so_fiyat
    AND   z~renk         IN so_renk
    AND   z~satis_tarihi IN so_satis
    AND   z~yil          IN so_yil.

  IF p_rad1 EQ 'X'.
    LOOP AT gt_data1 INTO gs_data WHERE satis_fiyati IS INITIAL.
      APPEND gs_data TO gt_data.
    ENDLOOP.
  ELSEIF p_rad2 EQ 'X'.
    LOOP AT gt_data1 INTO gs_data WHERE satis_fiyati IS NOT INITIAL.
      APPEND gs_data TO gt_data.
    ENDLOOP.
  ENDIF.

  PERFORM f_set_date.

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
      i_structure_name       = 'ZAB_S_0020'
    CHANGING
      ct_fieldcat            = gt_fcat          " Field Catalog with Field Descriptions
    EXCEPTIONS
      inconsistent_interface = 1                " Call parameter combination error
      program_error          = 2                " Program Errors
      OTHERS                 = 3.

  LOOP AT gt_fcat ASSIGNING <gfs_fcat>.
    CASE <gfs_fcat>-fieldname.
      WHEN 'ID'.
        <gfs_fcat>-outputlen = 4.
        <gfs_fcat>-coltext = TEXT-002.
      WHEN 'MARKA'.
        <gfs_fcat>-outputlen = 13.
        <gfs_fcat>-coltext = TEXT-003.
      WHEN 'MODEL'.
        <gfs_fcat>-outputlen = 14.
        <gfs_fcat>-coltext = TEXT-004.
      WHEN 'YIL'.
        <gfs_fcat>-outputlen = 4.
        <gfs_fcat>-coltext = TEXT-005.
      WHEN 'SASE'.
        <gfs_fcat>-outputlen = 15.
        <gfs_fcat>-coltext = TEXT-006.
      WHEN 'RENK'.
        <gfs_fcat>-outputlen = 8.
        <gfs_fcat>-coltext = TEXT-007.
      WHEN 'KILOMETRE'.
        <gfs_fcat>-outputlen = 6.
        <gfs_fcat>-coltext = TEXT-008.
      WHEN 'FIYAT'.
        <gfs_fcat>-outputlen = 9.
        <gfs_fcat>-coltext = TEXT-009.
      WHEN 'SATIS_FIYATI'.
        <gfs_fcat>-outputlen = 9.
        <gfs_fcat>-coltext = TEXT-010.
        <gfs_fcat>-edit       = 'X'.
      WHEN 'SATIS_TARIHI'.
        <gfs_fcat>-outputlen = 8.
        <gfs_fcat>-coltext = TEXT-016.
        <gfs_fcat>-edit       = 'X'.
      WHEN 'PARA_BIRIMI'.
        <gfs_fcat>-outputlen = 4.
        <gfs_fcat>-coltext = TEXT-011.
      WHEN 'YAKIT'.
        <gfs_fcat>-outputlen = 8.
        <gfs_fcat>-coltext = TEXT-012.
      WHEN 'VITES'.
        <gfs_fcat>-outputlen = 9.
        <gfs_fcat>-coltext = TEXT-013.
      WHEN 'TARIH'.
        <gfs_fcat>-outputlen = 8.
        <gfs_fcat>-coltext = TEXT-014.
      WHEN 'ESKI_SAHIBI'.
        <gfs_fcat>-outputlen = 18.
        <gfs_fcat>-coltext = TEXT-015.
    ENDCASE.
  ENDLOOP.

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
  gs_layout-sel_mode  = 'A'.
  gs_layout-info_fname  = 'LINE_COLOR'.
*  gs_layout-cwidth_opt = 'X'.

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

  CREATE OBJECT go_event_receiver.

  SET HANDLER go_event_receiver->handle_data_changed
              go_event_receiver->handle_toolbar
              go_event_receiver->handle_user_command FOR go_alv.

  CALL METHOD go_alv->set_table_for_first_display
    EXPORTING
      is_layout       = gs_layout
    CHANGING
      it_outtab       = gt_data
      it_fieldcatalog = gt_fcat.

  CALL METHOD go_alv->register_edit_event
    EXPORTING
      i_event_id = cl_gui_alv_grid=>mc_evt_enter.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form f_call_screen
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM f_call_screen .

  CALL SCREEN '100'.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form f_set_date
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM f_set_date .

  DATA : lv_date TYPE sy-datum.
  lv_date = syst-datum - 365.
  LOOP AT gt_data INTO gs_data.
    IF gs_data-tarih < lv_date.
      gs_data-line_color = 'C611'.
      MODIFY gt_data FROM gs_data.
    ENDIF.
  ENDLOOP.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form f_refresh_alv
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM f_refresh_alv .

  DATA: ls_stable TYPE lvc_s_stbl.
  CLEAR:ls_stable.

  ls_stable-row = 'X'.
  ls_stable-col = 'X'.

  CALL METHOD go_alv->refresh_table_display
    EXPORTING
      is_stable      = ls_stable
      i_soft_refresh = 'X'
    EXCEPTIONS
      finished       = 1
      OTHERS         = 2.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form f_send_email
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> ER_DATA_CHANGED
*&---------------------------------------------------------------------*
FORM f_send_email.

  DATA : lv_context     TYPE string,
         lv_context_all TYPE string.
  DATA : lt_receiver TYPE TABLE OF somlreci1,
         ls_receiver TYPE somlreci1.

  DATA : lt_contents TYPE TABLE OF  solisti1,
         ls_contents TYPE solisti1.

  DATA : lt_itab TYPE TABLE OF zab_s_0020,
         ls_itab TYPE  zab_s_0020.

  DATA : lv_add TYPE spop-varvalue1.

  CLEAR : ls_receiver, ls_contents, ls_itab.

  CALL FUNCTION 'POPUP_TO_GET_ONE_VALUE'
    EXPORTING
      textline1      = TEXT-017
*     TEXTLINE2      = ' '
*     TEXTLINE3      = ' '
      titel          = TEXT-018
      valuelength    = 35
    IMPORTING
*     ANSWER         =
      value1         = lv_add
    EXCEPTIONS
      titel_too_long = 1
      OTHERS         = 2.
  IF sy-subrc <> 0.
* Implement suitable error handling here
  ENDIF.

  TRANSLATE lv_add TO LOWER CASE.

  ls_receiver-receiver = lv_add.
  APPEND ls_receiver TO lt_receiver.

  CONCATENATE lv_context TEXT-020
  INTO lv_context_all SEPARATED BY space.

  ls_contents-line = lv_context_all.
  APPEND ls_contents TO lt_contents.

  CALL FUNCTION 'ZIMP_GLOBAL_F_0002'
    EXPORTING
      iv_subject        = TEXT-019
      iv_sender         = 'ab@improva.com.tr'
      it_contents       = lt_contents
      iv_table_type     = 'ZAB_S_0020'
      iv_commit_work    = 'X'
    TABLES
      it_internal_table = gt_data
      it_receivers      = lt_receiver
    EXCEPTIONS
      err_sendmail      = 1
      OTHERS            = 2.
  IF sy-subrc = 0.
* Implement suitable error handling here
    MESSAGE text-024 TYPE 'S'.
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form f_save_car
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM f_save_car .

  DATA : ls_data TYPE zab_t_0020.

  IF gs_data-eski_sahibi IS NOT INITIAL
    AND gs_data-fiyat IS NOT INITIAL
    AND gs_data-kilometre IS NOT INITIAL
    AND gs_data-marka IS NOT INITIAL
    AND gs_data-model IS NOT INITIAL
    AND gs_data-para_birimi IS NOT INITIAL
    AND gs_data-renk IS NOT INITIAL
    AND gs_data-sase IS NOT INITIAL
    AND gs_data-tarih IS NOT INITIAL
    AND gs_data-vites IS NOT INITIAL
    AND gs_data-yakit IS NOT INITIAL
    AND gs_data-yil IS NOT INITIAL.

    CONCATENATE gs_data-tarih+6(2) gs_data-sase+0(5) INTO DATA(lv_id).
    SELECT COUNT(*) FROM zab_t_0020 WHERE id EQ lv_id.
    IF sy-subrc EQ 0.
      CONCATENATE gs_data-tarih+6(1) gs_data-sase+0(6) INTO lv_id.
    ENDIF.
    gs_data-id = lv_id.
    MOVE-CORRESPONDING gs_data TO ls_data.
    INSERT zab_t_0020 FROM ls_data.
    COMMIT WORK.
    MESSAGE TEXT-022 TYPE 'S'.
  ELSE.
    MESSAGE TEXT-021 TYPE 'W'.

  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form f_selected_rows
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM f_selected_rows .

  CALL METHOD go_alv->get_selected_rows
    IMPORTING
      et_index_rows = gt_rows.

  READ TABLE gt_rows INTO gs_row INDEX 1.
  IF sy-subrc EQ 0.
    gv_row = gs_row-index.
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form f_del_car
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM f_del_car .

  READ TABLE gt_data INTO gs_data INDEX gv_row.

  DELETE FROM zab_t_0020 WHERE id EQ gs_data-id.
  IF sy-subrc EQ 0.
    MESSAGE TEXT-023 TYPE 'S'.
    PERFORM f_refresh_alv.
  ENDIF.
  COMMIT WORK.

ENDFORM.
