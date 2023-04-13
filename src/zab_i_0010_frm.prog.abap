*&---------------------------------------------------------------------*
*& Include          ZSF_P_AB_0001_FRM
*&---------------------------------------------------------------------*
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
*& Form f_dynamic_screen
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM f_dynamic_screen .

  LOOP AT SCREEN.
    IF p_kunnr EQ 'X'.
      IF screen-group1 EQ 'GR1'.
        screen-active = 1.
        MODIFY SCREEN.
      ENDIF.
      IF screen-group1 EQ 'GR2'.
        screen-active = 0.
        MODIFY SCREEN.
      ENDIF.
    ENDIF.
    IF p_lifnr EQ 'X'.
      IF screen-group1 EQ 'GR2'.
        screen-active = 1.
        MODIFY SCREEN.
      ENDIF.
      IF screen-group1 EQ 'GR1'.
        screen-active = 0.
        MODIFY SCREEN.
      ENDIF.
    ENDIF.
    IF screen-group1 = 'FL1'.
      screen-input = 0.
      MODIFY SCREEN.
    ENDIF.
  ENDLOOP.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form f_get_cust_data
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM f_get_cust_data .
  DATA : lv_sgtxt TYPE char50.

  SELECT  bkpf~bukrs
          t001~butxt
          bkpf~belnr
          bkpf~gjahr
          bkpf~blart
          bkpf~bldat
          bseg~kunnr
          kna1~name1
          bseg~wrbtr
          bkpf~waers
          bseg~sgtxt
          kna1~stcd1
          kna1~stcd2
          zsf~z_send
    FROM bkpf
    INNER JOIN bseg ON bkpf~bukrs EQ bseg~bukrs
    AND bkpf~belnr EQ bseg~belnr AND bkpf~gjahr EQ bseg~gjahr
    INNER JOIN t001 ON bkpf~bukrs EQ t001~bukrs
    INNER JOIN kna1 ON bseg~kunnr EQ kna1~kunnr
    LEFT OUTER JOIN zsf_ab_t_0002 AS zsf ON bkpf~bukrs EQ zsf~bukrs
    AND bkpf~belnr EQ zsf~belnr AND bkpf~gjahr EQ zsf~gjahr
    INTO CORRESPONDING FIELDS OF TABLE gt_list.

  DELETE ADJACENT DUPLICATES FROM gt_list.

  LOOP AT gt_list INTO gs_list.
    IF gs_list-sgtxt IS INITIAL.
      CONCATENATE gs_list-bukrs '-' gs_list-belnr '-' gs_list-gjahr
       INTO lv_sgtxt.
      gs_list-sgtxt = lv_sgtxt.
      MODIFY gt_list FROM gs_list.
      CLEAR gs_list.
    ENDIF.
  ENDLOOP.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form f_set_cust_fcat
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM f_set_cust_fcat .

  CALL FUNCTION 'LVC_FIELDCATALOG_MERGE'
    EXPORTING
      i_structure_name       = 'ZSF_AB_S_0001'
    CHANGING
      ct_fieldcat            = gt_fcat
    EXCEPTIONS
      inconsistent_interface = 1                " Call parameter combination error
      program_error          = 2                " Program Errors
      OTHERS                 = 3.

  LOOP AT gt_fcat ASSIGNING <gfs_fcat>.
    CASE <gfs_fcat>-fieldname.
      WHEN 'BUKRS'.
        <gfs_fcat>-outputlen = 9.
      WHEN 'BUTXT'.
        <gfs_fcat>-outputlen = 16.
      WHEN 'BELNR'.
        <gfs_fcat>-hotspot = 'X'.
        <gfs_fcat>-outputlen = 11.
      WHEN 'GJAHR'.
        <gfs_fcat>-outputlen = 4.
      WHEN 'BLART'.
        <gfs_fcat>-outputlen = 4.
      WHEN 'BLDAT'.
        <gfs_fcat>-outputlen = 8.
      WHEN 'KUNNR'.
        <gfs_fcat>-outputlen = 9.
      WHEN 'LIFNR'.
        <gfs_fcat>-no_out = 'X'.
      WHEN 'NAME1'.
        <gfs_fcat>-outputlen = 14.
      WHEN 'WRBTR'.
        <gfs_fcat>-outputlen = 11.
      WHEN 'WAERS'.
        <gfs_fcat>-outputlen = 7.
      WHEN 'SGTXT'.
        <gfs_fcat>-outputlen = 19.
      WHEN 'STCD1'.
        <gfs_fcat>-outputlen = 11.
      WHEN 'STCD2'.
        <gfs_fcat>-outputlen = 11.
      WHEN 'Z_SEND'.
        <gfs_fcat>-outputlen = 3.
        <gfs_fcat>-seltext = TEXT-019.
        <gfs_fcat>-coltext = TEXT-020.
    ENDCASE.
  ENDLOOP.

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

  SET HANDLER go_event_receiver->handle_hotspot_click
              go_event_receiver->handle_toolbar
              go_event_receiver->handle_user_command
              go_event_receiver->handle_double_click FOR go_alv.

  PERFORM set_excluding.

  CALL METHOD go_alv->set_table_for_first_display
    EXPORTING
      is_layout            = gs_layout
      it_toolbar_excluding = gt_excluding
    CHANGING
      it_outtab            = gt_list
      it_fieldcatalog      = gt_fcat.

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
  gs_layout-col_opt = 'X'.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form f_get_comp_data
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM f_get_comp_data .
  DATA : lv_sgtxt TYPE char50.

  SELECT  bkpf~bukrs
          t001~butxt
          bkpf~belnr
          bkpf~gjahr
          bkpf~blart
          bkpf~bldat
          bseg~lifnr
          lfa1~name1
          bseg~wrbtr
          bkpf~waers
          bseg~sgtxt
          lfa1~stcd1
          lfa1~stcd2
          zsf~z_send
  FROM bkpf
  INNER JOIN bseg ON bkpf~bukrs EQ bseg~bukrs
  AND bkpf~belnr EQ bseg~belnr AND bkpf~gjahr EQ bseg~gjahr
  INNER JOIN t001 ON bkpf~bukrs EQ t001~bukrs
  INNER JOIN lfa1 ON bseg~lifnr EQ lfa1~lifnr
  LEFT OUTER JOIN zsf_ab_t_0002 AS zsf ON bkpf~bukrs EQ zsf~bukrs
  AND bkpf~belnr EQ zsf~belnr AND bkpf~gjahr EQ zsf~gjahr
  INTO CORRESPONDING FIELDS OF TABLE gt_list.

  DELETE ADJACENT DUPLICATES FROM gt_list.

  LOOP AT gt_list INTO gs_list.
    IF gs_list-sgtxt IS INITIAL.
      CONCATENATE gs_list-bukrs '-' gs_list-belnr '-' gs_list-gjahr
       INTO lv_sgtxt.
      gs_list-sgtxt = lv_sgtxt.
      MODIFY gt_list FROM gs_list.
      CLEAR gs_list.
    ENDIF.
  ENDLOOP.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form f_set_comp_fcat
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM f_set_comp_fcat .

  CALL FUNCTION 'LVC_FIELDCATALOG_MERGE'
    EXPORTING
      i_structure_name       = 'ZSF_AB_S_0001'
    CHANGING
      ct_fieldcat            = gt_fcat
    EXCEPTIONS
      inconsistent_interface = 1                " Call parameter combination error
      program_error          = 2                " Program Errors
      OTHERS                 = 3.

  LOOP AT gt_fcat ASSIGNING <gfs_fcat>.
    CASE <gfs_fcat>-fieldname.
      WHEN 'BUKRS'.
        <gfs_fcat>-outputlen = 9.
      WHEN 'BUTXT'.
        <gfs_fcat>-outputlen = 16.
      WHEN 'BELNR'.
        <gfs_fcat>-hotspot   = 'X'.
        <gfs_fcat>-outputlen = 11.
      WHEN 'GJAHR'.
        <gfs_fcat>-outputlen = 4.
      WHEN 'BLART'.
        <gfs_fcat>-outputlen = 4.
      WHEN 'BLDAT'.
        <gfs_fcat>-outputlen = 8.
      WHEN 'KUNNR'.
        <gfs_fcat>-no_out    = 'X'.
      WHEN 'LIFNR'.
        <gfs_fcat>-outputlen = 9.
      WHEN 'NAME1'.
        <gfs_fcat>-outputlen = 14.
      WHEN 'WRBTR'.
        <gfs_fcat>-outputlen = 11.
      WHEN 'WAERS'.
        <gfs_fcat>-outputlen = 7.
      WHEN 'SGTXT'.
        <gfs_fcat>-outputlen = 19.
      WHEN 'STCD1'.
        <gfs_fcat>-outputlen = 11.
      WHEN 'STCD2'.
        <gfs_fcat>-outputlen = 11.
      WHEN 'Z_SEND'.
        <gfs_fcat>-outputlen = 3.
        <gfs_fcat>-seltext = TEXT-019.
        <gfs_fcat>-coltext = TEXT-020.
    ENDCASE.
  ENDLOOP.

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
*& Form f_detail
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM f_detail .
  CALL SCREEN '0200'.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form f_set_detail_layout
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM f_set_detail_layout .
  CLEAR : gs_detail_layout.
  gs_detail_layout-zebra = 'X'.
  gs_detail_layout-sel_mode  = 'A'.
  gs_detail_layout-ctab_fname = 'CELL_COLOR'.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form f_display_detail_alv
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM f_display_detail_alv .

  CREATE OBJECT go_detail_cust
    EXPORTING
      container_name = 'CC_ALV1'.

  CREATE OBJECT go_detail_alv
    EXPORTING
      i_parent = go_detail_cust.

  CALL METHOD go_detail_alv->set_table_for_first_display
    EXPORTING
      is_layout       = gs_detail_layout
    CHANGING
      it_outtab       = gt_detail
      it_fieldcatalog = gt_detail_fcat.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form f_set_detail_fcat
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM f_set_detail_fcat .

  CALL FUNCTION 'LVC_FIELDCATALOG_MERGE'
    EXPORTING
      i_structure_name       = 'ZSF_AB_S_0002'
    CHANGING
      ct_fieldcat            = gt_detail_fcat
    EXCEPTIONS
      inconsistent_interface = 1                " Call parameter combination error
      program_error          = 2                " Program Errors
      OTHERS                 = 3.

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

  DATA : lv_bukrs   TYPE bukrs,
         lv_gjahr   TYPE gjahr,
         lv_stcd1   TYPE stcd1,
         lv_stcd2   TYPE stcd2,
         lv_belnr   TYPE belnr_d,
         lv_bldat   TYPE bldat,
         lv_sgtxt   TYPE sgtxt,
         lv_word    TYPE char100,
         lv_decword TYPE char50,
         lv_address TYPE char100,
         lv_name    TYPE char50,
         lv_total   LIKE bseg-wrbtr.

  READ TABLE gt_list INTO gs_list INDEX gv_row.
  lv_bukrs = gs_list-bukrs.
  lv_gjahr = gs_list-gjahr.
  lv_stcd1 = gs_list-stcd1.
  lv_stcd2 = gs_list-stcd2.
  lv_belnr = gs_list-belnr.
  lv_bldat = gs_list-bldat.
  gs_form-sgtxt = gs_list-sgtxt.
  gs_form-wrbtr = gs_list-wrbtr.
  gs_form-waers = gs_list-waers.
  APPEND gs_form TO gt_form.

  DATA : lv_lang  LIKE t002-spras,
         ls_spell TYPE spell.
  lv_lang = 'TR'.

  LOOP AT gt_form INTO gs_form.
    lv_total = lv_total + gs_form-wrbtr.
  ENDLOOP.

  CALL FUNCTION 'SPELL_AMOUNT'
    EXPORTING
      amount   = lv_total
      currency = 'TRY'
*     FILLER   = pFILLER
      language = lv_lang "SY-LANGU
    IMPORTING
      in_words = ls_spell.

  lv_word = ls_spell-word.
  lv_decword = ls_spell-decword.

  IF p_kunnr EQ 'X'.
    SELECT kna1~name1
           kna1~adrnr
           adrc~street
           adrc~city1
           adrc~city2
      FROM kna1
      INNER JOIN adrc ON kna1~adrnr EQ adrc~addrnumber
      INTO CORRESPONDING FIELDS OF TABLE gt_address
      WHERE kna1~name1 = gs_list-name1.
  ELSE.
    SELECT lfa1~name1
           lfa1~adrnr
           adrc~street
           adrc~city1
           adrc~city2
      FROM lfa1
      INNER JOIN adrc ON lfa1~adrnr EQ adrc~addrnumber
      INTO CORRESPONDING FIELDS OF TABLE gt_address
      WHERE lfa1~name1 = gs_list-name1.
  ENDIF.

  READ TABLE gt_address INTO gs_address INDEX 1.
  lv_name = gs_address-name1.
  CONCATENATE gs_address-street ' / ' gs_address-city1 ' / '
   gs_address-city2 INTO lv_address.

  gs_controls-no_dialog = 'X'.
  gs_controls-preview   = 'X'.
  gs_output-tddest      = 'ZPDF'.

  CALL FUNCTION 'SSF_FUNCTION_MODULE_NAME'
    EXPORTING
      formname           = 'ZSF_SF_AB_0001'
*     VARIANT            = ' '
*     DIRECT_CALL        = ' '
    IMPORTING
      fm_name            = gv_fm_name
    EXCEPTIONS
      no_form            = 1
      no_function_module = 2
      OTHERS             = 3.
  IF sy-subrc <> 0.
* Implement suitable error handling here
  ENDIF.


  CALL FUNCTION gv_fm_name
    EXPORTING
*     ARCHIVE_INDEX      =
*     ARCHIVE_INDEX_TAB  =
*     ARCHIVE_PARAMETERS =
      control_parameters = gs_controls
*     MAIL_APPL_OBJ      =
*     MAIL_RECIPIENT     =
*     MAIL_SENDER        =
      output_options     = gs_output
      user_settings      = ' '
      iv_bukrs           = lv_bukrs
      iv_gjahr           = lv_gjahr
      iv_stcd1           = lv_stcd1
      iv_stcd2           = lv_stcd2
      iv_belnr           = lv_belnr
      iv_bldat           = lv_bldat
      iv_sgtxt           = lv_sgtxt
      iv_word            = lv_word
      iv_decword         = lv_decword
      iv_total           = lv_total
      iv_name            = lv_name
      iv_address         = lv_address
      it_form            = gt_form
    IMPORTING
      job_output_info    = gs_job_output.

  CLEAR : gs_controls.
  CLEAR : gt_form.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form f_pdf_mail
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM f_pdf_mail .

  CALL FUNCTION 'POPUP_TO_GET_ONE_VALUE'
    EXPORTING
      textline1      = 'Lütfen 1 adet e-mail adresi giriniz.'
*     TEXTLINE2      = ' '
*     TEXTLINE3      = ' '
      titel          = 'Hosgeldiniz'
      valuelength    = 35
    IMPORTING
*     ANSWER         =
      value1         = gv_add
    EXCEPTIONS
      titel_too_long = 1
      OTHERS         = 2.
  IF sy-subrc <> 0.
* Implement suitable error handling here
  ENDIF.

  TRANSLATE gv_add TO LOWER CASE.

  gs_controls-getotf    = 'X'.
  PERFORM f_print.

  i_otf[] = gs_job_output-otfdata[].

  CALL FUNCTION 'CONVERT_OTF'
    EXPORTING
      format                = 'PDF'
      max_linewidth         = 132
    IMPORTING
      bin_filesize          = gv_len_in
    TABLES
      otf                   = i_otf
      lines                 = i_tline
    EXCEPTIONS
      err_max_linewidth     = 1
      err_format            = 2
      err_conv_not_possible = 3
      OTHERS                = 4.
  IF sy-subrc <> 0.
    MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
    WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
  ENDIF.

* Convert PDF from 132 to 255.
  LOOP AT i_tline.
* Replacing space by ~
    TRANSLATE i_tline USING ' ~'.
    CONCATENATE w_buffer i_tline INTO w_buffer.
  ENDLOOP.

* Replacing ~ by space
  TRANSLATE w_buffer USING '~ '.
  DO.
    i_record = w_buffer.
* Appending 255 characters as a record
    APPEND i_record.
    SHIFT w_buffer LEFT BY 255 PLACES.
    IF w_buffer IS INITIAL.
      EXIT.
    ENDIF.
  ENDDO.

  PERFORM f_mail_format.

  PERFORM f_send_mail.

ENDFORM.


FORM f_mail_format .

  DATA:lv_dash(1)         TYPE c VALUE '-'.
  DATA:lv_xtn(4)          TYPE c VALUE '.pdf'.
  CONSTANTS:lv_esacpe     TYPE so_escape  VALUE 'U'.
  CONSTANTS:lv_so_obj_tp  TYPE so_obj_tp  VALUE 'PDF'.
  CONSTANTS:lv_so_obj_tp1 TYPE so_obj_tp  VALUE 'RAW'.
  CONSTANTS:lv_so_obj_sns TYPE so_obj_sns VALUE 'F'.

* Get Email ID's

  REFRESH:i_reclist,
          i_objtxt,
          i_objbin,
          i_objpack.

  CLEAR w_objhead.

* Object with PDF.
  i_objbin[] = i_record[].

  DESCRIBE TABLE i_objbin[] LINES gv_lines_bin.

* Object with main text of the mail.
  i_objtxt = TEXT-017.
  APPEND i_objtxt.

  DESCRIBE TABLE i_objtxt LINES gv_lines_txt.

* Document information.
  w_doc_chng-obj_name = TEXT-005.
  w_doc_chng-expiry_dat = sy-datum + 10.

  CONCATENATE w_doc_chng-obj_descr 'Sipariş Detayları' INTO w_doc_chng-obj_descr.

  w_doc_chng-sensitivty = lv_so_obj_sns. "Functional object
  w_doc_chng-doc_size = gv_lines_txt * 255.

* Pack to main body as RAW.
* Obj. to be transported not in binary form
  CLEAR i_objpack-transf_bin.

* Start line of object header in transport packet
  i_objpack-head_start = 1.

* Number of lines of an object header in object packet
  i_objpack-head_num = 0.

* Start line of object contents in an object packet
  i_objpack-body_start = 1.

* Number of lines of the object contents in an object packet
  i_objpack-body_num = gv_lines_txt.

* Code for document class
  i_objpack-doc_type = lv_so_obj_tp1.

  APPEND i_objpack.

* Packing as PDF.
  i_objpack-transf_bin = 'X'.
  i_objpack-head_start = 1.
  i_objpack-head_num = 1.
  i_objpack-body_start = 1.
  i_objpack-body_num = gv_lines_bin.
  i_objpack-doc_type = lv_so_obj_tp.
  i_objpack-obj_name = TEXT-005.


  CONCATENATE w_doc_chng-obj_descr '.pdf' INTO i_objpack-obj_descr.
  i_objpack-doc_size = gv_lines_bin * 255.
  APPEND i_objpack.

* Document information.
  CLEAR : i_reclist.

* e-mail receivers.
*  LOOP AT gt_address INTO gw_adr6.
*    i_reclist-receiver = 'test@test1234.com'.
  i_reclist-receiver = gv_add.
  i_reclist-express =  'X'.
  i_reclist-rec_type = lv_esacpe. "Internet address
  APPEND i_reclist.
*  ENDLOOP.

ENDFORM.

FORM f_send_mail .

  CALL FUNCTION 'SO_NEW_DOCUMENT_ATT_SEND_API1'
    EXPORTING
      document_data              = w_doc_chng
      put_in_outbox              = ' '
    TABLES
      packing_list               = i_objpack[]
      object_header              = w_objhead[]
      contents_bin               = i_objbin[]
      contents_txt               = i_objtxt[]
      receivers                  = i_reclist[]
    EXCEPTIONS
      too_many_receivers         = 1
      document_not_sent          = 2
      document_type_not_exist    = 3
      operation_no_authorization = 4
      parameter_error            = 5
      x_error                    = 6
      enqueue_error              = 7
      OTHERS                     = 8.
  IF sy-subrc <> 0.
    MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
    WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
  ELSE.
    PERFORM f_fill_log_table.
    IF p_kunnr EQ 'X'..
      PERFORM f_get_cust_data.
    ELSE.
      PERFORM f_get_comp_data.
    ENDIF.
    MESSAGE TEXT-021 TYPE 'S'.
  ENDIF.

  COMMIT WORK.

  CLEAR : gv_add, i_objpack, w_doc_chng.
  CALL METHOD go_alv->refresh_table_display.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form f_exc_mail
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM f_exc_mail .

  gv_content = TEXT-022.
  gt_soli = cl_document_bcs=>string_to_soli( gv_content ).

  CALL METHOD go_gbt->set_main_html
    EXPORTING
      content = gt_soli.

*  go_doc_bcs = cl_document_bcs=>create_from_multirelated(
*                 i_subject          = 'Sipariş Detayları'
*                 i_multirel_service = go_gbt  ).
  TRY .
      go_doc_bcs = cl_document_bcs=>create_document(
                       i_type    = 'RAW'
                       i_text    = gt_soli
                       i_length  = '12'
                       i_subject = TEXT-023 ).
    CATCH cx_document_bcs. " BCS: Document Exceptions(

  ENDTRY.

  PERFORM f_exc_mail_data.

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
          i_attachment_subject  = TEXT-023                 " Attachment Title
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
    MESSAGE 'Mail başarıyla gönderildi.' TYPE 'S'.
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form f_fdf
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM f_pdf .

  gs_controls-getotf    = 'X'.
  PERFORM f_print.

*  CALL FUNCTION 'HR_IT_DISPLAY_WITH_PDF'
**   EXPORTING
**     IV_PDF          =
*    TABLES
*      otf_table = gs_job_output-otfdata.

  DATA : lv_bin_filesize TYPE i.

  gt_otf[] = gs_job_output-otfdata[].

  CALL FUNCTION 'CONVERT_OTF'
    EXPORTING
      format                = 'PDF'
      max_linewidth         = 132
    IMPORTING
      bin_filesize          = lv_bin_filesize
    TABLES
      otf                   = gt_otf
      lines                 = gt_pdf
    EXCEPTIONS
      err_max_linewidth     = 1
      err_format            = 2
      err_conv_not_possible = 3
      err_bad_otf           = 4
      OTHERS                = 5.
  IF sy-subrc <> 0.
* Implement suitable error handling here
  ENDIF.

  gv_file_filter = '.pdf'.
  PERFORM f_save_dialog.

  CLEAR : gv_fullpath.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form f_excel
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM f_excel .

  gv_file_filter = '*.xls'.
  PERFORM f_save_dialog.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form f_text_save
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM f_text_save .
  DATA : lv_wrbtr TYPE string.

  CONCATENATE 'C:\Users\HP\Desktop\siparis' '-' sy-uzeit '.txt' INTO gv_filename.

  IF p_kunnr EQ 'X'.
    PERFORM f_kunnr_excel.
  ELSE.
    PERFORM f_lifnr_excel.
  ENDIF.

  CALL FUNCTION 'SAP_CONVERT_TO_CSV_FORMAT'
    EXPORTING
      i_field_seperator    = ';'
*     I_LINE_HEADER        =
*     I_FILENAME           =
*     I_APPL_KEEP          = ' '
    TABLES
      i_tab_sap_data       = gt_excel
    CHANGING
      i_tab_converted_data = gt_excel1
    EXCEPTIONS
      conversion_failed    = 1
      OTHERS               = 2.
  IF sy-subrc <> 0.
* Implement suitable error handling here
  ENDIF.


  CALL FUNCTION 'GUI_DOWNLOAD'
    EXPORTING
      filename              = gv_filename
      filetype              = 'ASC'
      write_field_separator = 'X'
    TABLES
      data_tab              = gt_excel1.

  CLEAR : gt_excel.

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
*& Form f_create_excel
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM f_create_excel .

  CONCATENATE gv_fullpath '-' sy-uzeit '.xls' INTO gv_filename.

  IF p_kunnr EQ 'X'.
    PERFORM f_kunnr_excel.
  ELSE.
    PERFORM f_lifnr_excel.
  ENDIF.

  CALL FUNCTION 'GUI_DOWNLOAD'
    EXPORTING
      filename                = gv_filename
      filetype                = 'DBF'
      write_field_separator   = 'X'
    TABLES
      data_tab                = gt_excel
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

  CLEAR : gv_filename.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form f_kunnr_excel
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM f_kunnr_excel .
  LOOP AT gt_rows INTO gs_row.
    READ TABLE gt_list INTO gs_list INDEX gs_row-index.
    gs_excel-bukrs = gs_list-bukrs.
    gs_excel-butxt = gs_list-butxt.
    gs_excel-belnr = gs_list-belnr.
    gs_excel-gjahr = gs_list-gjahr.
    gs_excel-blart = gs_list-blart.
    gs_excel-bldat = gs_list-bldat.
    gs_excel-kunnr = gs_list-kunnr.
    gs_excel-name1 = gs_list-name1.
    gs_excel-wrbtr = gs_list-wrbtr.
    gs_excel-waers = gs_list-waers.
    gs_excel-sgtxt = gs_list-sgtxt.
    gs_excel-stcd1 = gs_list-stcd1.
    gs_excel-stcd2 = gs_list-stcd2.
    APPEND gs_excel TO gt_excel.
  ENDLOOP.

  gs_header-line = TEXT-002 .
  APPEND gs_header TO gt_header.
  gs_header-line = TEXT-003 .
  APPEND gs_header TO gt_header.
  gs_header-line = TEXT-004 .
  APPEND gs_header TO gt_header.
  gs_header-line = TEXT-005 .
  APPEND gs_header TO gt_header.
  gs_header-line = TEXT-006 .
  APPEND gs_header TO gt_header.
  gs_header-line = TEXT-007 .
  APPEND gs_header TO gt_header.
  gs_header-line = TEXT-008 .
  APPEND gs_header TO gt_header.
  gs_header-line = TEXT-009 .
  APPEND gs_header TO gt_header.
  gs_header-line = TEXT-010 .
  APPEND gs_header TO gt_header.
  gs_header-line = TEXT-011 .
  APPEND gs_header TO gt_header.
  gs_header-line = TEXT-012 .
  APPEND gs_header TO gt_header.
  gs_header-line = TEXT-013 .
  APPEND gs_header TO gt_header.
  gs_header-line = TEXT-014 .
  APPEND gs_header TO gt_header.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form f_lifnr_excel
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM f_lifnr_excel .

  LOOP AT gt_rows INTO gs_row.
    READ TABLE gt_list INTO gs_list INDEX gs_row-index.
    gs_excel-bukrs = gs_list-bukrs.
    gs_excel-butxt = gs_list-butxt.
    gs_excel-belnr = gs_list-belnr.
    gs_excel-gjahr = gs_list-gjahr.
    gs_excel-blart = gs_list-blart.
    gs_excel-bldat = gs_list-bldat.
    gs_excel-kunnr = gs_list-lifnr.
    gs_excel-name1 = gs_list-name1.
    gs_excel-wrbtr = gs_list-wrbtr.
    gs_excel-waers = gs_list-waers.
    gs_excel-sgtxt = gs_list-sgtxt.
    gs_excel-stcd1 = gs_list-stcd1.
    gs_excel-stcd2 = gs_list-stcd2.
    APPEND gs_excel TO gt_excel.
  ENDLOOP.

  gs_header-line = TEXT-002 .
  APPEND gs_header TO gt_header.
  gs_header-line = TEXT-003 .
  APPEND gs_header TO gt_header.
  gs_header-line = TEXT-004 .
  APPEND gs_header TO gt_header.
  gs_header-line = TEXT-005 .
  APPEND gs_header TO gt_header.
  gs_header-line = TEXT-006 .
  APPEND gs_header TO gt_header.
  gs_header-line = TEXT-007 .
  APPEND gs_header TO gt_header.
  gs_header-line = TEXT-015 .
  APPEND gs_header TO gt_header.
  gs_header-line = TEXT-016 .
  APPEND gs_header TO gt_header.
  gs_header-line = TEXT-010 .
  APPEND gs_header TO gt_header.
  gs_header-line = TEXT-011 .
  APPEND gs_header TO gt_header.
  gs_header-line = TEXT-012 .
  APPEND gs_header TO gt_header.
  gs_header-line = TEXT-013 .
  APPEND gs_header TO gt_header.
  gs_header-line = TEXT-014 .
  APPEND gs_header TO gt_header.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form f_create_pdf
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM f_create_pdf .

  CONCATENATE gv_fullpath '-' sy-uzeit '.pdf' INTO gv_filename.

  CALL FUNCTION 'GUI_DOWNLOAD'
    EXPORTING
      filename = gv_filename
      filetype = 'BIN'
    TABLES
      data_tab = gt_pdf.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form f_save_dialog
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM f_save_dialog .

  CALL METHOD cl_gui_frontend_services=>file_save_dialog
    EXPORTING
      window_title         = 'Dosya Seç'            " Window Title
      default_file_name    = 'Sipariş Detayları'      " Default File Name
      file_filter          = gv_file_filter                  " File Type Filter Table
      initial_directory    = 'C:\'                    " Initial Directory
      prompt_on_overwrite  = ' '
    CHANGING
      filename             = gv_file                  " File Name to Save
      path                 = gv_path                  " Path to File
      fullpath             = gv_fullpath              " Path + File Name
    EXCEPTIONS
      cntl_error           = 1                        " Control error
      error_no_gui         = 2                        " No GUI available
      not_supported_by_gui = 3                        " GUI does not support this
      OTHERS               = 4.
  IF sy-subrc <> 0.
    MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
      WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
  ENDIF.
  IF gv_action EQ 9.
    MESSAGE 'No File have been Selected' TYPE 'S'.
  ELSE.
    IF gv_file_filter EQ '.pdf'.
      PERFORM f_create_pdf.
      MESSAGE 'PDF Formatında Indirme Başarılı' TYPE 'S'.
    ELSE.
      PERFORM f_create_excel.
      MESSAGE 'XLS Formatında Indirme Başarılı' TYPE 'S'.
    ENDIF.
  ENDIF.
  CLEAR : gv_fullpath.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form f_get_log_data
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM f_get_log_data .
  SELECT * FROM zsf_ab_t_0002
    INTO CORRESPONDING FIELDS OF TABLE gt_log.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form f_set_log_fcat
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM f_set_log_fcat .

  CALL FUNCTION 'LVC_FIELDCATALOG_MERGE'
    EXPORTING
      i_structure_name       = 'ZSF_AB_T_0002'
    CHANGING
      ct_fieldcat            = gt_log_fcat
    EXCEPTIONS
      inconsistent_interface = 1
      program_error          = 2
      OTHERS                 = 3.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form f_set_log_layout
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM f_set_log_layout .

  CLEAR : gs_detail_layout.
  gs_detail_layout-zebra = 'X'.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form f_display_log_alv
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM f_display_log_alv .

  CREATE OBJECT go_log_cust
    EXPORTING
      container_name = 'CC_ALV2'.

  CREATE OBJECT go_log_alv
    EXPORTING
      i_parent = go_log_cust.

  CALL METHOD go_log_alv->set_table_for_first_display
    EXPORTING
      is_layout       = gs_layout                 " Layout
    CHANGING
      it_outtab       = gt_log                 " Output Table
      it_fieldcatalog = gt_log_fcat.                 " Field Catalog

ENDFORM.
*&---------------------------------------------------------------------*
*& Form f_fill_log_table
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM f_fill_log_table .

  READ TABLE gt_list INTO gs_list INDEX gv_row .
  gs_log-bukrs = gs_list-bukrs.
  gs_log-belnr = gs_list-belnr.
  gs_log-gjahr = gs_list-gjahr.
  gs_log-uname = syst-uname.
  gs_log-datum = syst-datum.
  gs_log-uzeit = syst-uzeit.
  IF p_kunnr EQ 'X'.
    gs_log-kunnr = gs_list-kunnr.
  ELSE.
    gs_log-kunnr = gs_list-lifnr.
  ENDIF.
  gs_log-address = gv_add.
  gs_log-z_send  = 'X'.
  INSERT INTO zsf_ab_t_0002 VALUES gs_log.
  COMMIT WORK AND WAIT.

  CLEAR : gv_add.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form f_exc_mail1
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM f_exc_mail1 .
  DATA : lv_wrbtr TYPE string.

  gv_content = '<!DOCTYPE html>                          '
           && '<html>                                    '
           && '  <head>                                  '
           && '    <meta charset = "utf-8">              '
           && '      <style>                             '
           && '        th{ background-color: red;        '
           && '               border: 1px solid;         '
           && '               }                          '
           && '        td{ background-color: yellow;     '
           && '               border: 1px solid;         '
           && '               }                          '
           && '      </style>                            '
           && '  </head>                                 '
           && '  <body>                                  '
           && '  <table>                                 '
           && '  <tr>                                    '
           && '  <th>Şirket Kodu</th>                    '
           && '  <th>Şirket Adı</th>                     '
           && '  <th>Belge No.</th>                      '
           && '  <th>Mali Yıl</th>                       '
           && '  <th>Belge Türü</th>                     '
           && '  <th>Belge Tarihi</th>                   '
           && '  <th>Müşt/Satıcı No</th>                 '
           && '  <th>Müşt/Satıcı Ad</th>                 '
           && '  <th>Tutar</th>                          '
           && '  <th>Para Birimi</th>                    '
           && '  <th>Açıklama</th>                       '
           && '  <th>Vergi Dairesi</th>                  '
           && '  <th>Vergi Numarası</th>                 '
           && '  </tr>                                   ' .

  LOOP AT gt_list INTO gs_list.
    gv_content = gv_content && '  <tr>                       '
                            && '  <td>' && gs_list-bukrs && '</td>                       '
                            && '  <td>' && gs_list-butxt && '</td>                       '
                            && '  <td>' && gs_list-belnr && '</td>                       '
                            && '  <td>' && gs_list-gjahr && '</td>                       '
                            && '  <td>' && gs_list-blart && '</td>                       '
                            && '  <td>' && gs_list-bldat && '</td>                       '.
    IF p_kunnr EQ 'X'.
      gv_content = gv_content && '  <td>' && gs_list-kunnr && '</td>                     '.
    ELSE.
      gv_content = gv_content && '  <td>' && gs_list-lifnr && '</td>                     '.
    ENDIF.
    gv_content = gv_content && '  <td>' && gs_list-name1 && '</td>                       '
                            && '  <td>' && gs_list-wrbtr && '</td>                       '
                            && '  <td>' && gs_list-waers && '</td>                       '
                            && '  <td>' && gs_list-sgtxt && '</td>                       '
                            && '  <td>' && gs_list-stcd1 && '</td>                       '
                            && '  <td>' && gs_list-stcd2 && '</td>                       '
                            && '  </tr>                                                  '.
  ENDLOOP.
  gv_content = gv_content && '  </table>                                                 '
                          && '  </body>                                                  '
                          && '</html>                                                    '
 .

  gt_soli = cl_document_bcs=>string_to_soli( gv_content ).

  CALL METHOD go_gbt->set_main_html
    EXPORTING
      content = gt_soli                 " Objcont and Objhead as Table Type
*     filename    =                  " File Name (Proposal Only)
*     description =                  " Short description of contents
    .
  TRY.
      go_doc_bcs = cl_document_bcs=>create_from_multirelated(
                  i_subject          = 'Siparis Detayları'
*             i_language         = space
*             i_importance       =
*             i_sensitivity      =
                  i_multirel_service = go_gbt
*             iv_vsi_profile     =
                ).
    CATCH cx_document_bcs. " BCS: Document Exceptions
    CATCH cx_bcom_mime.    " Exceptions in MIME Conversion Tool
    CATCH cx_gbt_mime.     " MIME Error
  ENDTRY.

  TRY.
      go_recipient = cl_cam_address_bcs=>create_internet_address(
                       i_address_string = 'ata@dogu.com'
*                  i_address_name   =
*                  i_incl_sapuser   =
                     ).
    CATCH cx_address_bcs. " BCS: Address Exceptions (OS Exception)
  ENDTRY.
  TRY.
      go_bcs = cl_bcs=>create_persistent( ).
    CATCH cx_send_req_bcs. " BCS: Send Request Exceptions
  ENDTRY.
  TRY.
      go_bcs->set_document( i_document = go_doc_bcs ).
    CATCH cx_send_req_bcs. " BCS: Send Request Exceptions
  ENDTRY.
  TRY.
      go_bcs->add_recipient(
        EXPORTING
          i_recipient  = go_recipient                 " Recipient of Message
*     i_express    =                  " Send As Express Message
*     i_copy       =                  " Send Copy
*     i_blind_copy =                  " Send As Blind Copy
*     i_no_forward =                  " No Forwarding
      ).
    CATCH cx_send_req_bcs. " BCS: Send Request Exceptions
  ENDTRY.
  TRY.
      gv_status = 'N'.
      CALL METHOD go_bcs->set_status_attributes
        EXPORTING
          i_requested_status = gv_status                 " Requested Status
*         i_status_mail      = 'E'              " Setting for Which Statuses Are Reported by Mail
        .
    CATCH cx_send_req_bcs. " BCS: Send Request Exceptions
  ENDTRY.
  TRY.
      go_bcs->send(
*     i_with_error_screen = space
      ).
    CATCH cx_send_req_bcs. " BCS: Send Request Exceptions
  ENDTRY.
  COMMIT WORK.

  IF sy-subrc EQ 0.
    MESSAGE 'Mail başarıyla gönderildi.' TYPE 'S'.
  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form f_excel_mail_popup
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM f_excel_mail_popup .

  DATA : lv_answer TYPE char1.

  CALL FUNCTION 'POPUP_WITH_2_BUTTONS_TO_CHOOSE'
    EXPORTING
      defaultoption = '1'
      diagnosetext1 = 'Lütfen Bir Mail Sablonu Seçiniz.'
*     DIAGNOSETEXT2 = ' '
*     DIAGNOSETEXT3 = ' '
      textline1     = ' '
*     TEXTLINE2     = ' '
*     TEXTLINE3     = ' '
      text_option1  = 'Attachment'
      text_option2  = 'Colored'
      titel         = 'Hoşgeldiniz'
    IMPORTING
      answer        = lv_answer.

  IF lv_answer EQ 1.
    PERFORM f_exc_mail.
  ELSEIF lv_answer EQ 2.
    PERFORM f_exc_mail1.
  ELSE.
    MESSAGE TEXT-018 TYPE 'W'.
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form f_exc_mail_data
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM f_exc_mail_data .
  DATA : lv_wrbtr TYPE string.

  IF p_kunnr EQ 'X'.
    CONCATENATE TEXT-002 TEXT-003 TEXT-004 TEXT-005
    TEXT-006 TEXT-007 TEXT-008 TEXT-009 TEXT-010
    TEXT-011 TEXT-012 TEXT-013 TEXT-014
     INTO gv_att_content
    SEPARATED BY cl_abap_char_utilities=>horizontal_tab.
    LOOP AT gt_list INTO gs_list.
      lv_wrbtr = gs_list-wrbtr.
      CONCATENATE gs_list-bukrs
                  gs_list-butxt
                  gs_list-belnr
                  gs_list-gjahr
                  gs_list-blart
                  gs_list-bldat
                  gs_list-kunnr
                  gs_list-name1
*                   gs_list-wrbtr
                  lv_wrbtr
                  gs_list-waers
                  gs_list-sgtxt
                  gs_list-stcd1
                  gs_list-stcd2
                    INTO gv_att_line
                    SEPARATED BY cl_abap_char_utilities=>horizontal_tab.

      CONCATENATE gv_att_content
                  gv_att_line
                  INTO gv_att_content
                  SEPARATED BY cl_abap_char_utilities=>newline.
      CLEAR : lv_wrbtr.
    ENDLOOP.
  ELSE.
    CONCATENATE TEXT-002 TEXT-003 TEXT-004 TEXT-005
    TEXT-006 TEXT-007 TEXT-015 TEXT-016 TEXT-010
    TEXT-011 TEXT-012 TEXT-013 TEXT-014
     INTO gv_att_content
    SEPARATED BY cl_abap_char_utilities=>horizontal_tab.
    LOOP AT gt_list INTO gs_list.
      lv_wrbtr = gs_list-wrbtr.
      CONCATENATE gs_list-bukrs
                  gs_list-butxt
                  gs_list-belnr
                  gs_list-gjahr
                  gs_list-blart
                  gs_list-bldat
                  gs_list-lifnr
                  gs_list-name1
*                   gs_list-wrbtr
                  lv_wrbtr
                  gs_list-waers
                  gs_list-sgtxt
                  gs_list-stcd1
                  gs_list-stcd2
                    INTO gv_att_line
                    SEPARATED BY cl_abap_char_utilities=>horizontal_tab.

      CONCATENATE gv_att_content
                  gv_att_line
                  INTO gv_att_content
                  SEPARATED BY cl_abap_char_utilities=>newline.
      CLEAR : lv_wrbtr.
    ENDLOOP.
  ENDIF.

ENDFORM.
