*&---------------------------------------------------------------------*
*& Include          ZAB_I_0012_FRM
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

  SELECT mara~matnr         ,
         mara~mtart         ,
         mara~matkl         ,
         makt~maktx         ,
         zab_t_0006~zuse    ,
         zab_t_0006~zben    ,
         zab_t_0006~erdat   ,
         zab_t_0006~erzet   ,
         zab_t_0006~ernam   ,
         zab_t_0006~zupdate ,
         zab_t_0006~zuptime ,
         zab_t_0006~zupname ,
         zab_t_0006~zcountry
    UP TO 100 ROWS
    FROM mara
    LEFT JOIN makt ON makt~matnr EQ mara~matnr
    LEFT JOIN zab_t_0006 ON zab_t_0006~matnr EQ mara~matnr
    INTO CORRESPONDING FIELDS OF TABLE @gt_data
    WHERE makt~spras = @sy-langu.

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

  CALL SCREEN '0100'.

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
      i_structure_name       = 'ZAB_S_0012'
    CHANGING
      ct_fieldcat            = gt_fcat
    EXCEPTIONS
      inconsistent_interface = 1                " Call parameter combination error
      program_error          = 2                " Program Errors
      OTHERS                 = 3.

  LOOP AT gt_fcat ASSIGNING <gfs_fcat>.
    CASE <gfs_fcat>-fieldname.
      WHEN 'MATNR'.
        <gfs_fcat>-edit    = 'X'.
      WHEN 'MAKTX'.
        <gfs_fcat>-hotspot = 'X'.
      WHEN 'ZUSE'.
        <gfs_fcat>-coltext = TEXT-008.
        <gfs_fcat>-edit    = 'X'.
      WHEN 'ZBEN'.
        <gfs_fcat>-coltext = TEXT-009.
        <gfs_fcat>-edit    = 'X'.
      WHEN 'ZCOUNTRY'.
        <gfs_fcat>-edit    = 'X'.
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
  gs_layout-zebra      = 'X'.
  gs_layout-sel_mode   = 'A'.
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

  CREATE OBJECT go_event_receiver.
  CREATE OBJECT go_gbt.

  SET HANDLER go_event_receiver->handle_toolbar
              go_event_receiver->handle_user_command
              go_event_receiver->handle_hotspot_click
              go_event_receiver->handle_data_changed FOR go_alv.

  PERFORM set_excluding.

  CALL METHOD go_alv->set_table_for_first_display
    EXPORTING
      is_layout            = gs_layout
      it_toolbar_excluding = gt_excluding
    CHANGING
      it_outtab            = gt_data
      it_fieldcatalog      = gt_fcat.

  CALL METHOD go_alv->register_edit_event
    EXPORTING
      i_event_id = cl_gui_alv_grid=>mc_evt_modified.

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
*& Form f_dynamic_screen
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM f_dynamic_screen .

  LOOP AT SCREEN.
    IF p_rad1 EQ 'X'.
      IF screen-group1 EQ 'GR1'.
        screen-active = 1.
        MODIFY SCREEN.
      ENDIF.
      IF screen-group1 EQ 'GR2'.
        screen-active = 0.
        MODIFY SCREEN.
      ENDIF.
    ENDIF.
    IF p_rad2 EQ 'X'.
      IF screen-group1 EQ 'GR2'.
        screen-active = 1.
        MODIFY SCREEN.
      ENDIF.
      IF screen-group1 EQ 'GR1'.
        screen-active = 0.
        MODIFY SCREEN.
      ENDIF.
    ENDIF.
  ENDLOOP.

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

ENDFORM.
*&---------------------------------------------------------------------*
*& Form f_delete
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM f_delete .

  READ TABLE gt_data INTO gs_data INDEX gv_row.
  IF sy-subrc EQ 0.
    DELETE gt_data WHERE matnr EQ gs_data-matnr.
    gv_del_matnr = gs_data-matnr.
    PERFORM f_refresh_alv.
  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form f_mail
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM f_mail .

  gv_content = TEXT-025.
  gt_soli = cl_document_bcs=>string_to_soli( gv_content ).

  CALL METHOD go_gbt->set_main_html
    EXPORTING
      content = gt_soli.
  TRY .
      go_doc_bcs = cl_document_bcs=>create_document(
                       i_type    = 'RAW'
                       i_text    = gt_soli
                       i_length  = '12'
                       i_subject = TEXT-026 ).
    CATCH  cx_document_bcs . " BCS: Document Exceptions(
  ENDTRY.

  CONCATENATE TEXT-004 TEXT-005 TEXT-006 TEXT-007 TEXT-008 TEXT-009
  TEXT-010 TEXT-011 TEXT-012 TEXT-013 TEXT-014 TEXT-015 TEXT-016
  INTO gv_att_content
  SEPARATED BY cl_abap_char_utilities=>horizontal_tab.
  LOOP AT gt_rows INTO gs_row.
    READ TABLE gt_data INTO gs_data INDEX gs_row-index.
    IF sy-subrc EQ 0.
      CONCATENATE gs_data-matnr
                  gs_data-maktx
                  gs_data-mtart
                  gs_data-matkl
                  gs_data-zuse
                  gs_data-zben
                  gs_data-erdat
                  gs_data-erzet
                  gs_data-ernam
                  gs_data-zupdate
                  gs_data-zuptime
                  gs_data-zupname
                  gs_data-zcountry
                  INTO gv_att_line
                  SEPARATED BY cl_abap_char_utilities=>horizontal_tab.

      CONCATENATE gv_att_content
                  gv_att_line
                  INTO gv_att_content
                  SEPARATED BY cl_abap_char_utilities=>newline.
    ENDIF.
  ENDLOOP.

  TRY.
      cl_bcs_convert=>string_to_solix(
        EXPORTING
          iv_string   = gv_att_content                 " Input data
          iv_codepage = '4103'                 " Target Code Page in SAP Form  (Default = SAPconnect Setting)
          iv_add_bom  = 'X'                 " Add Byte-Order Mark
        IMPORTING
          et_solix    = gt_att_content_hex                   " Output data
          ev_size     = gv_attachment_size                  " Size of Document Content
      ).
    CATCH cx_bcs. " BCS: General Exceptions
  ENDTRY.

  TRY.
      go_doc_bcs->add_attachment(
        EXPORTING
          i_attachment_type     = 'CSV'                 " Document Class for Attachment
          i_attachment_subject  = TEXT-027                 " Attachment Title
          i_attachment_size     = gv_attachment_size                 " Size of Document Content
          i_att_content_hex     = gt_att_content_hex                 " Content (Binary)
      ).
    CATCH cx_document_bcs. " BCS: Document Exceptions
  ENDTRY.

  TRY.
      go_recipient = cl_cam_address_bcs=>create_internet_address( 'atanur_test@test.com' ).
    CATCH cx_address_bcs. " BCS: Address Exceptions (OS Exception)
  ENDTRY.
  TRY.
      go_bcs = cl_bcs=>create_persistent( ).
    CATCH cx_send_req_bcs. " BCS: Send Request Exceptions( ).
  ENDTRY.
  TRY.
      CALL METHOD go_bcs->set_document( i_document = go_doc_bcs ).
    CATCH cx_send_req_bcs. " BCS: Send Request Exceptions( ).
  ENDTRY.
  TRY.
      CALL METHOD go_bcs->add_recipient(
        EXPORTING
          i_recipient = go_recipient
      ).
    CATCH cx_send_req_bcs. " BCS: Send Request Exceptions( ).
  ENDTRY.

  gv_status = 'N'.
  TRY .

      CALL METHOD go_bcs->set_status_attributes
        EXPORTING
          i_requested_status = gv_status.
    CATCH cx_send_req_bcs. " BCS: Send Request Exceptions( ).
  ENDTRY.

  TRY .
      go_bcs->send(  ).
    CATCH cx_send_req_bcs. " BCS: Send Request Exceptions( ).
  ENDTRY.
  COMMIT WORK.

  IF sy-subrc EQ 0.
    MESSAGE TEXT-028 TYPE 'S'.
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form f_download_template
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM f_download_template .

  TYPES : BEGIN OF gty_header,
            line TYPE char30,
          END OF gty_header.

  DATA : gt_header TYPE TABLE OF gty_header,
         gs_header TYPE gty_header.

  gs_header-line = TEXT-004.
  APPEND gs_header TO gt_header.
  gs_header-line = TEXT-008.
  APPEND gs_header TO gt_header.
  gs_header-line = TEXT-009.
  APPEND gs_header TO gt_header.
  gs_header-line = TEXT-016.
  APPEND gs_header TO gt_header.

  CONCATENATE p_excel '\' 'template-' sy-uzeit '.xls' INTO gv_filename.

  CALL FUNCTION 'GUI_DOWNLOAD'
    EXPORTING
      filename                = gv_filename
*     filetype                = 'ASC'
      write_field_separator   = 'X'
    TABLES
      data_tab                = gt_data
      fieldnames              = gt_header
    EXCEPTIONS
      file_write_error        = 1
      no_batch                = 2
      gui_refuse_filetransfer = 3
      invalid_type            = 4
      no_authority            = 5
      unknown_error           = 6
      header_not_allowed      = 7
      separator_not_allowed   = 8
      filesize_not_allowed    = 9
      header_too_long         = 10
      dp_error_create         = 11
      dp_error_send           = 12
      dp_error_write          = 13
      unknown_dp_error        = 14
      access_denied           = 15
      dp_out_of_memory        = 16
      disk_full               = 17
      dp_timeout              = 18
      file_not_found          = 19
      dataprovider_exception  = 20
      control_flush_error     = 21
      OTHERS                  = 22.
  IF sy-subrc <> 0.
* Implement suitable error handling here
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form f_folder_directory
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM f_folder_directory .

  CALL METHOD cl_gui_frontend_services=>directory_browse
    CHANGING
      selected_folder      = p_excel                 " Folder Selected By User
    EXCEPTIONS
      cntl_error           = 1                " Control error
      error_no_gui         = 2                " No GUI available
      not_supported_by_gui = 3                " GUI does not support this
      OTHERS               = 4.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form f_upload_file
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM f_upload_file .

  TYPES : BEGIN OF gty_excel,
            matnr    TYPE matnr,
            zuse     TYPE string,
            zben     TYPE string,
            zcountry TYPE zab_de_country,
          END OF gty_excel.

  DATA : gt_excel     TYPE TABLE OF gty_excel,
         gs_excel     TYPE gty_excel,
         gt_raw_data  TYPE truxs_t_text_data,
         gv_filename1 TYPE rlgrap-filename,
         gs_excel1    TYPE zab_t_0006.

  gv_filename1 = gv_filename.

  CALL FUNCTION 'TEXT_CONVERT_XLS_TO_SAP'
    EXPORTING
*     I_FIELD_SEPERATOR    =
      i_line_header        = 'X'
      i_tab_raw_data       = gt_raw_data
      i_filename           = gv_filename1
    TABLES
      i_tab_converted_data = gt_excel
    EXCEPTIONS
      conversion_failed    = 1
      OTHERS               = 2.
  IF sy-subrc = 0.
    CLEAR p_excel.
  ENDIF.

  LOOP AT gt_excel INTO gs_excel.
    CALL FUNCTION 'CONVERSION_EXIT_MATN1_INPUT'
      EXPORTING
        input  = gs_excel-matnr
      IMPORTING
        output = gs_excel-matnr.

    SELECT COUNT(*) FROM mara
      WHERE matnr EQ gs_excel-matnr.
    IF  sy-subrc EQ 0.
      gs_excel1-matnr = gs_excel-matnr.
      gs_excel1-zuse  = gs_excel-zuse.
      gs_excel1-zben  = gs_excel-zben.
      gs_excel1-zcountry = gs_excel-zcountry.
      MODIFY zab_t_0006 FROM gs_excel1.
      COMMIT WORK.
      CONCATENATE gs_excel-matnr TEXT-029
       INTO DATA(lv_mess) SEPARATED BY space.
      MESSAGE lv_mess TYPE 'S'.
      CLEAR lv_mess.
    ENDIF.
  ENDLOOP.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form f_print
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM f_print .

  DATA : lt_data TYPE TABLE OF zab_s_0013,
         ls_data TYPE zab_s_0013.

  DATA : lv_output_opt TYPE ssfcompop,
         lv_control_pa TYPE ssfctrlop,
         lv_fm_name    TYPE rs38l_fnam.

  lv_control_pa-no_dialog = 'X'.
  lv_control_pa-preview   = 'X'.
  lv_output_opt-tddest    = 'LP01'.


  LOOP AT gt_rows INTO gs_row.
    READ TABLE gt_data INTO gs_data INDEX gs_row-index.
    IF sy-subrc EQ 0.
      ls_data-matnr = gs_data-matnr.
      ls_data-maktx = gs_data-maktx.
      ls_data-mtart = gs_data-mtart.
      ls_data-matkl = gs_data-matkl.
      APPEND ls_data TO lt_data.
    ENDIF.
  ENDLOOP.

  CALL FUNCTION 'SSF_FUNCTION_MODULE_NAME'
    EXPORTING
      formname           = 'ZAB_SF_HW12'
    IMPORTING
      fm_name            = lv_fm_name
    EXCEPTIONS
      no_form            = 1
      no_function_module = 2
      OTHERS             = 3.
  IF sy-subrc <> 0.
* Implement suitable error handling here
  ENDIF.

  CALL FUNCTION lv_fm_name
    EXPORTING
      control_parameters = lv_control_pa
      output_options     = lv_output_opt
      user_settings      = ' '
      it_data            = lt_data
    EXCEPTIONS
      formatting_error   = 1
      internal_error     = 2
      send_error         = 3
      user_canceled      = 4
      OTHERS             = 5.
  IF sy-subrc <> 0.
* Implement suitable error handling here
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form set_excluding
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM set_excluding .
  CLEAR gv_excluding.

  gv_excluding = cl_gui_alv_grid=>mc_fc_print.
  APPEND gv_excluding TO gt_excluding.

  gv_excluding = cl_gui_alv_grid=>mc_fc_sort_asc.
  APPEND gv_excluding TO gt_excluding.

  gv_excluding = cl_gui_alv_grid=>mc_fc_sort_dsc.
  APPEND gv_excluding TO gt_excluding.

  gv_excluding = cl_gui_alv_grid=>mc_fc_sort.
  APPEND gv_excluding TO gt_excluding.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form f_add
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM f_add .
  CLEAR : gs_data.
  IF gv_row IS INITIAL.
    gv_row = 1.
  ENDIF.
  INSERT gs_data INTO gt_data INDEX gv_row.
  PERFORM f_refresh_alv.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form f_save
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM f_save .
  DATA : ls_log TYPE zab_t_0007.
  CLEAR ls_log.

  DELETE FROM zab_t_0006 WHERE matnr EQ gv_del_matnr.
  IF sy-subrc EQ 0.
    MESSAGE TEXT-018 TYPE 'S'.

    READ TABLE gt_data INTO gs_data WITH KEY matnr = gv_del_matnr.
    ls_log-zlogdate = sy-datum.
    ls_log-zlogtime = sy-uzeit.
    ls_log-zlogname = sy-uname.
    ls_log-matnr    = gs_data-matnr.
    ls_log-zuse     = gs_data-zuse.
    ls_log-zben     = gs_data-zben.
    ls_log-zcountry = gs_data-zcountry.
    INSERT INTO zab_t_0007 VALUES ls_log.
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form f_add_log
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM f_add_log USING    p_ls_modi_row_id.

  DATA : ls_log TYPE zab_t_0007.
  CLEAR ls_log.
  READ TABLE gt_data INTO gs_data INDEX  p_ls_modi_row_id.
  ls_log-zlogdate = sy-datum.
  ls_log-zlogtime = sy-uzeit.
  ls_log-zlogname = sy-uname.
  ls_log-matnr    = gs_data-matnr.
  ls_log-zuse     = gs_data-zuse.
  ls_log-zben     = gs_data-zben.
  ls_log-zcountry = gs_data-zcountry.
  INSERT INTO zab_t_0007 VALUES ls_log.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form f_add_toolbar_button
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> E_OBJECT
*&---------------------------------------------------------------------*
FORM f_add_toolbar_button  USING    p_e_object TYPE REF TO cl_alv_event_toolbar_set.
  DATA : ls_toolbar TYPE stb_button.

  CLEAR : ls_toolbar.
  ls_toolbar-function = '&NADD'.
  ls_toolbar-text     = TEXT-020.
  ls_toolbar-icon     = '@CL@'.
  APPEND ls_toolbar TO p_e_object->mt_toolbar.

  CLEAR : ls_toolbar.
  ls_toolbar-function = '&NDEL'.
  ls_toolbar-text     = TEXT-021.
  ls_toolbar-icon     = '@11@'.
  APPEND ls_toolbar TO p_e_object->mt_toolbar.

  CLEAR : ls_toolbar.
  ls_toolbar-function = '&MAIL'.
  ls_toolbar-text     = TEXT-022.
  ls_toolbar-icon     = '@1S@'.
  APPEND ls_toolbar TO p_e_object->mt_toolbar.

  CLEAR : ls_toolbar.
  ls_toolbar-function = '&PRI'.
  ls_toolbar-text     = TEXT-023.
  ls_toolbar-icon     = '@0X@'.
  APPEND ls_toolbar TO p_e_object->mt_toolbar.

  CLEAR : ls_toolbar.
  ls_toolbar-function = '&NSAVE'.
  ls_toolbar-text     = TEXT-024.
  ls_toolbar-icon     = '@2L@'.
  APPEND ls_toolbar TO p_e_object->mt_toolbar.

ENDFORM.
