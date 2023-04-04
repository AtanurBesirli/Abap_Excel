*&---------------------------------------------------------------------*
*& Include          ZAB_I_0003_FRM
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*& Form display_alv
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM f_display_alv .
  IF go_alv IS INITIAL.
    CREATE OBJECT go_cust
      EXPORTING
        container_name = 'CC_ALV'.

    CREATE OBJECT go_alv
      EXPORTING
        i_parent = go_cust.

    CREATE OBJECT go_event_receiver.

    SET HANDLER go_event_receiver->handle_toolbar
                go_event_receiver->handle_user_command
                go_event_receiver->handle_hotspot_click FOR go_alv.

    CALL METHOD go_alv->set_table_for_first_display
      EXPORTING
        is_layout       = gs_layout
      CHANGING
        it_outtab       = gt_list
        it_fieldcatalog = gt_fcat.
  ELSE.
    CALL METHOD go_alv->refresh_table_display.

  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form get_data
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM f_get_data .
  CLEAR : gt_list.
  SELECT
    vbap~matnr,
    vbap~vbeln AS vbeln_va,
    vbap~posnr AS posnr_va,
    vbap~kwmeng,
    vbap~vrkme AS vrkme_va,
    vbap~netwr,
    vbap~waerk,
    lips~vbeln AS vbeln_vl,
    lips~posnr AS posnr_vl,
    lips~lfimg,
    lips~vrkme AS vrkme_vl,
    vbrk~vbeln AS vbeln_vf,
    vbrp~posnr AS posnr_vf
    FROM vbap
    INNER JOIN vbak ON vbap~vbeln EQ vbak~vbeln
    LEFT  JOIN lips ON vbap~vbeln EQ lips~vgbel AND vbap~posnr EQ lips~vgpos
    LEFT  JOIN vbrp ON vbap~vbeln EQ vbrp~aubel AND vbap~posnr EQ vbrp~aupos
    LEFT  JOIN vbrk ON vbap~vbeln EQ vbrk~vbeln
    INTO CORRESPONDING FIELDS OF TABLE @gt_list UP TO 50 ROWS
    WHERE vbap~vbeln IN @so_vbeln
    AND   vbap~matnr IN @so_matnr
    AND   vbap~werks IN @so_werks.


ENDFORM.
*&---------------------------------------------------------------------*
*& Form get_data2
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM f_get_data2 .
  CLEAR : gt_list.
  SELECT
    vbap~matnr,
    vbap~vbeln AS vbeln_va,
    vbap~posnr AS posnr_va,
    vbap~kwmeng,
    vbap~vrkme AS vrkme_va,
    vbap~netwr,
    vbap~waerk,
    lips~vbeln AS vbeln_vl,
    lips~posnr AS posnr_vl,
    lips~lfimg,
    lips~vrkme AS vrkme_vl,
    vbrk~vbeln AS vbeln_vf,
    vbrp~posnr AS posnr_vf
    FROM vbap
    INNER JOIN vbak ON vbap~vbeln EQ vbak~vbeln
    LEFT  JOIN lips ON vbap~vbeln EQ lips~vgbel AND vbap~posnr EQ lips~vgpos
    INNER JOIN vbrp ON vbap~vbeln EQ vbrp~aubel AND vbap~posnr EQ vbrp~aupos
    INNER JOIN vbrk ON vbrp~vbeln EQ vbrk~vbeln
    INTO CORRESPONDING FIELDS OF TABLE @gt_list
    WHERE vbap~vbeln IN @so_vbeln
    AND   vbap~matnr IN @so_matnr
    AND   vbap~werks IN @so_werks
    AND  (l_where).
ENDFORM.
*&---------------------------------------------------------------------*
*& Form set_fcat
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM f_set_fcat .
  CALL FUNCTION 'LVC_FIELDCATALOG_MERGE'
    EXPORTING
      i_structure_name = 'ZAB_S_HW_0006'
    CHANGING
      ct_fieldcat      = gt_fcat.

  LOOP AT gt_fcat ASSIGNING <gfs_fcat>.
    CASE <gfs_fcat>-fieldname.
      WHEN 'MATNR'.
        <gfs_fcat>-outputlen = 16.
      WHEN 'VBELN_VA'.
        <gfs_fcat>-outputlen = 12.
        <gfs_fcat>-hotspot   = 'X'.
      WHEN 'POSNR_VA'.
        <gfs_fcat>-outputlen = 7.
      WHEN 'KWMENG'.
        <gfs_fcat>-outputlen = 11.
      WHEN 'VRKME_VA'.
        <gfs_fcat>-outputlen = 6.
      WHEN 'NETWR'.
        <gfs_fcat>-outputlen = 10.
      WHEN 'WAERK'.
        <gfs_fcat>-outputlen = 8.
      WHEN 'VBELN_VL'.
        <gfs_fcat>-outputlen = 12.
        <gfs_fcat>-hotspot   = 'X'.
      WHEN 'POSNR_VL'.
        <gfs_fcat>-outputlen = 10.
      WHEN 'LFIMG'.
        <gfs_fcat>-outputlen = 12.
      WHEN 'VRKME_VL'.
        <gfs_fcat>-outputlen = 12.
      WHEN 'VBELN_VF'.
        <gfs_fcat>-outputlen = 12.
        <gfs_fcat>-hotspot   = 'X'.
      WHEN 'POSNR_VF'.
        <gfs_fcat>-outputlen = 10.
    ENDCASE.

  ENDLOOP.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form set_layout
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
*  gs_layout-col_opt = 'X'.
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

  CALL METHOD cl_gui_frontend_services=>file_save_dialog
    EXPORTING
      window_title         = 'Dosya Seç'            " Window Title
      default_file_name    = 'Sipariş Detayları'      " Default File Name
      file_filter          = '*.xls'                  " File Type Filter Table
      initial_directory    = 'C:\'                    " Initial Directory
      prompt_on_overwrite  = ' '
    CHANGING
      filename             = wf_file                  " File Name to Save
      path                 = wf_path                  " Path to File
      fullpath             = wf_fullpath              " Path + File Name
    EXCEPTIONS
      cntl_error           = 1                        " Control error
      error_no_gui         = 2                        " No GUI available
      not_supported_by_gui = 3                        " GUI does not support this
      OTHERS               = 4.
  IF sy-subrc <> 0.
    MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
      WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
  ENDIF.
  IF wf_action EQ 9.
    MESSAGE 'No File have been Selected' TYPE 'S'.
  ELSE.
    p_file = wf_fullpath.
    PERFORM f_create_excel.
  ENDIF.

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
  LOOP AT it_tabemp INTO p_file.
  ENDLOOP.
* START THE EXCEL APPLICATION
  CREATE OBJECT wf_excel 'EXCEL.APPLICATION'.

* PUT EXCEL IN FRONT
  SET PROPERTY OF wf_excel  'VISIBLE' = 1.

* CREATE AN EXCEL WORKBOOK OBJECT
  CALL METHOD OF wf_excel 'WORKBOOKS' = wf_mapl.

  SET PROPERTY OF wf_excel 'SheetsInNewWorkbook' = 1.

  CALL METHOD OF wf_mapl 'ADD' = wf_map.

*Assign the Delimiter to field  symbol.
  ASSIGN wf_deli TO <fs> TYPE 'X'.
  t_hex-l_tab = wl_c09.
  <fs> = t_hex-l_tab.

  IF gt_list IS NOT INITIAL.
    SELECT  v1~vbeln AS vbeln_va
            v1~posnr AS posnr_va
            v1~kwmeng
            v2~kunnr AS kunnr
            v3~kunnr AS kunnr1
         INTO CORRESPONDING FIELDS OF TABLE gt_excel
         FROM vbap AS v1
         INNER JOIN vbak AS v2 ON v1~vbeln = v2~vbeln
         LEFT  JOIN kna1 AS v3 ON v2~kunnr = v3~kunnr
         FOR ALL ENTRIES IN gt_list WHERE v1~vbeln EQ gt_list-vbeln_va.
  ENDIF.


  CONCATENATE TEXT-002
              TEXT-003
              TEXT-004
              TEXT-005
              TEXT-006
              INTO wa_matl
              SEPARATED BY wf_deli.
  APPEND wa_matl TO int_matl.

  LOOP AT gt_excel INTO gs_excel.
    gs_excel1 = gs_excel-kwmeng.
    CONCATENATE gs_excel-vbeln_va
                gs_excel-posnr_va
                gs_excel1
                gs_excel-kunnr
                gs_excel-kunnr1
                INTO wa_matl
                SEPARATED BY wf_deli .
    APPEND wa_matl TO int_matl.
    CLEAR wa_matl.
  ENDLOOP.

  DATA lv_line TYPE int4.

  lv_line = 1 .
  LOOP AT gt_excel INTO gs_excel .
    lv_line = sy-tabix + 1 .
    IF gs_excel-kwmeng > 5 .
      CALL METHOD OF wf_excel 'Cells' = wf_cell
      EXPORTING     #1 = lv_line
                    #2 = 3.
      GET PROPERTY OF wf_cell 'Interior' = wf_interior .
      SET PROPERTY OF wf_interior 'Color' = 255000355.
    ENDIF.
  ENDLOOP.



  MOVE int_matl TO int_matl1.

  PERFORM f_material_details
  TABLES int_matl
  USING  1.

  PERFORM f_material_details
  TABLES int_matl
  USING  2.

  GET PROPERTY OF wf_excel 'ActiveSheet' = wf_map.
  GET PROPERTY OF wf_excel 'ActiveWorkbook' = wf_mapl.

  CALL FUNCTION 'FLUSH'
    EXCEPTIONS
      cntl_system_error = 1
      cntl_error        = 2
      OTHERS            = 3.

  IF sy-subrc = 0.
    CALL METHOD OF wf_map 'SAVEAS'
      EXPORTING
        #1 = p_file.
  ENDIF.

  CALL METHOD OF wf_mapl 'CLOSE'.
  CALL METHOD OF wf_excel 'QUIT'.
  FREE OBJECT wf_mapl.
  FREE OBJECT wf_map.
  FREE OBJECT wf_excel.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form f_adobe
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM f_adobe .

  DATA: gt_form  TYPE TABLE OF zab_s_hw_0009 WITH HEADER LINE,
        gs_form  TYPE zab_s_hw_0009,
        lv_vbeln TYPE vbeln_vl,
        lv_kunnr TYPE kunnr,
        lv_sum   TYPE int4.

  READ TABLE gt_list INTO gs_list INDEX gv_row.
  lv_vbeln = gs_list-vbeln_vl.

  SELECT v1~kunnr
         v1~vbeln AS vbeln_vl
         v2~posnr AS posnr_vl
         v2~matnr
         v2~lfimg
         v2~meins
         v2~netwr
         v3~maktx
        INTO CORRESPONDING FIELDS OF TABLE gt_form
        FROM likp AS v1
        INNER JOIN lips AS v2 ON v1~vbeln = v2~vbeln
        INNER JOIN makt AS v3 ON v2~matnr = v3~matnr
        FOR ALL ENTRIES IN gt_list
        WHERE v1~vbeln EQ gt_list-vbeln_vl
        AND v1~vbeln EQ lv_vbeln.

  LOOP AT gt_form INTO gs_form.
    lv_kunnr = gs_form-kunnr.
    lv_sum = lv_sum + gs_form-posnr_vl.
  ENDLOOP.

  gs_outputparams-nodialog = 'X'.
  gs_outputparams-preview  = 'X'.
  gs_outputparams-dest     = 'LP01'.
  CALL FUNCTION 'FP_JOB_OPEN'
    CHANGING
      ie_outputparams = gs_outputparams.

  gv_name = 'ZAB_ADOBE_F_0001'.

  CALL FUNCTION 'FP_FUNCTION_MODULE_NAME'
    EXPORTING
      i_name     = gv_name
    IMPORTING
      e_funcname = gv_funcname.


  CALL FUNCTION gv_funcname
    EXPORTING
      /1bcdwb/docparams  = gs_docparams
      gt_form            = gt_form[]
      gv_vbeln           = lv_vbeln
      gv_kunnr           = lv_kunnr
      gv_sum             = lv_sum
    IMPORTING
      /1bcdwb/formoutput = gs_formoutput.

  CALL FUNCTION 'FP_JOB_CLOSE'
    EXCEPTIONS
      usage_error    = 1
      system_error   = 2
      internal_error = 3
      OTHERS         = 4.



ENDFORM.
*&---------------------------------------------------------------------*
*& Form f_vrm_set
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM f_vrm_set .

  CALL FUNCTION 'VRM_SET_VALUES'
    EXPORTING
      id     = gv_id
      values = gt_values.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form f_vrm_value
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM f_vrm_value .
  gv_id = 'P_GOS'.
  gs_value-key  = '>'.
  gs_value-text = '>'.
  APPEND gs_value TO gt_values.

  gs_value-key  = '<'.
  gs_value-text = '<'.
  APPEND gs_value TO gt_values.

  gs_value-key  = '='.
  gs_value-text = '='.
  APPEND gs_value TO gt_values.

  gs_value-key  = '>='.
  gs_value-text = '>='.
  APPEND gs_value TO gt_values.

  gs_value-key  = '<='.
  gs_value-text = '<='.
  APPEND gs_value TO gt_values.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form f_delivery
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM f_delivery .
  DATA: lf_vbeln  TYPE vbeln_va,
        lf_num    TYPE vbnum,
        ls_deli   TYPE bapishpdelivnumb,
        lt_deli   TYPE TABLE OF bapishpdelivnumb,
        ls_itm    TYPE bapidlvitemcreated,
        lt_itm    TYPE TABLE OF bapidlvitemcreated,
        ls_ext    TYPE bapiparex,
        lt_extin  TYPE TABLE OF bapiparex,
        lt_extout TYPE TABLE OF bapiparex,
        ls_return TYPE bapiret2,
        lt_return TYPE TABLE OF bapiret2,
        lv_date   TYPE datum.

  CLEAR lt_return.
  CLEAR gt_salesorder.
  gs_salesorder-ref_doc    = gs_list-vbeln_va.
  gs_salesorder-ref_item   = gs_list-posnr_va.
  APPEND gs_salesorder TO gt_salesorder.
  gt_ship = '1000'.
  lv_date = sy-datum.

  CALL FUNCTION 'BAPI_OUTB_DELIVERY_CREATE_SLS'
    EXPORTING
      ship_point        = gt_ship
      due_date          = lv_date " "'20191004'
    IMPORTING
      delivery          = gs_list-vbeln_va
    TABLES
      sales_order_items = gt_salesorder
      deliveries        = lt_deli
      created_items     = lt_itm
      return            = lt_return.
  LOOP AT lt_return INTO ls_return WHERE type ='A' OR type ='E'
    OR type ='X'.
    MESSAGE ls_return-message TYPE 'S' DISPLAY LIKE 'E'.
    EXIT.
  ENDLOOP.

  IF sy-subrc = 0.
    CALL FUNCTION 'BAPI_TRANSACTION_ROLLBACK'.
  ELSE.
    CALL FUNCTION 'BAPI_TRANSACTION_COMMIT'
      EXPORTING
        wait = 'X'.
  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form f_billing
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM f_billing .
  DATA : lt_return  TYPE TABLE OF bapiret1,
         ls_return  TYPE bapiret1,
         lt_success TYPE TABLE OF bapivbrksuccess.

  CLEAR : gs_billing.

  gt_billing-ref_doc    = gs_list-vbeln_vl.
  gt_billing-ref_item   = gs_list-posnr_vl.
  gt_billing-doc_number = gs_list-vbeln_va.
  gt_billing-itm_number = gs_list-posnr_va.
  gt_billing-req_qty    = gs_list-kwmeng.
  gt_billing-price_date = sy-datum.
  gt_billing-ref_doc_ca = 'J' .
  gt_billing-material   = gs_list-matnr.
  APPEND gs_billing TO gt_billing.

  CALL FUNCTION 'BAPI_BILLINGDOC_CREATEMULTIPLE'
    TABLES
      billingdatain = gt_billing
      return        = lt_return
      success       = lt_success.
  LOOP AT lt_return INTO ls_return WHERE type = 'A' OR type = 'E'.
    MESSAGE ls_return-message TYPE 'I' DISPLAY LIKE 'E'.
    EXIT.
  ENDLOOP.

  IF sy-subrc = 0.
    CALL FUNCTION 'BAPI_TRANSACTION_ROLLBACK'.
  ELSE.
    CALL FUNCTION 'BAPI_TRANSACTION_COMMIT'
      EXPORTING
        wait = 'X'.
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form f_gos_value
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM f_gos_value .
  DATA : aaa TYPE string.
  MOVE p_lfimg TO aaa.

  CONSTANTS: l_quote TYPE char1 VALUE ''''.

  CONCATENATE 'LFIMG' space p_gos space l_quote aaa l_quote space
         INTO l_where RESPECTING BLANKS.
  PERFORM f_get_data2.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form f_material_details
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> INT_MATL
*&      --> P_1
*&---------------------------------------------------------------------*
FORM f_material_details  TABLES   lint_matl USING l_sheet_no TYPE i.
  DATA: lv_lines          TYPE i,
        lv_sheet_name(50) TYPE c.

  wc_sheets = l_sheet_no.
  CASE l_sheet_no.
    WHEN 1.
      lv_sheet_name = 'Material_sheet1'.
    WHEN 2.
      lv_sheet_name = 'Material_sheet2'.
  ENDCASE.

*-- activating the worksheet and giving a  name to it
  CALL METHOD OF wf_excel 'WORKSHEETS' = wf_worksheet
    EXPORTING
    #1 = wc_sheets.
  CALL METHOD OF wf_worksheet 'ACTIVATE'.
  SET PROPERTY OF wf_worksheet 'NAME' = lv_sheet_name.

*--formatting the cells
  CALL METHOD OF wf_excel 'Cells' = wf_cell_from
    EXPORTING
    #1 = 1
    #2 = 1.
  DESCRIBE TABLE lint_matl LINES lv_lines.
  CALL METHOD OF wf_excel 'Cells' = wf_cell_to
    EXPORTING
    #1 = lv_lines
    #2 = 4.
*--range of cells to be formatted (in this case 1 to 4)
  CALL METHOD OF wf_excel 'Range' = wf_cell
    EXPORTING
    #1 = wf_cell_from
    #2 = wf_cell_to.

*--formatting the cells
  CALL METHOD OF wf_excel 'Cells' = wf_cell_from1
    EXPORTING
    #1 = 1
    #2 = 1.
  DESCRIBE TABLE lint_matl LINES lv_lines.
  CALL METHOD OF wf_excel 'Cells' = wf_cell_to1
    EXPORTING
    #1 = lv_lines
    #2 = 1.
  CALL METHOD OF wf_excel 'Range' = wf_cell1  " Cell range for first

    EXPORTING
    #1 = wf_cell_from1
    #2 = wf_cell_to1.

  SET PROPERTY OF wf_cell1 'NumberFormat' = '@'.

  DATA l_rc TYPE i.
*DATA download into excel first sheet
  CALL METHOD cl_gui_frontend_services=>clipboard_export
    IMPORTING
      data         = lint_matl[]
    CHANGING
      rc           = l_rc
    EXCEPTIONS
      cntl_error   = 1
      error_no_gui = 2
      OTHERS       = 4.

  CALL METHOD OF wf_worksheet 'Paste'.
  CALL METHOD OF wf_excel 'Columns' = wf_column1.
  CALL METHOD OF wf_column1 'Autofit'.
  FREE OBJECT wf_column1.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form set_parameter
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM f_set_parameter .
  IF p_rad1 EQ 'X'.
    IF p_lfimg IS NOT INITIAL.
      IF p_gos IS NOT INITIAL.
        PERFORM f_gos_value.
      ELSE.
        MESSAGE TEXT-007 TYPE 'I'.
      ENDIF.
    ELSE.
      PERFORM f_get_data2.
    ENDIF.
  ELSE.
    PERFORM f_get_data.
    LOOP AT gt_fcat ASSIGNING <gfs_fcat>.
      CASE <gfs_fcat>-fieldname.
        WHEN 'VBELN_VL'.
          <gfs_fcat>-no_out = 'X'.
        WHEN 'POSNR_VL'.
          <gfs_fcat>-no_out = 'X'.
        WHEN 'LFIMG'.
          <gfs_fcat>-no_out = 'X'.
        WHEN 'VRKME_VL'.
          <gfs_fcat>-no_out = 'X'.
        WHEN 'VBELN_VF'.
          <gfs_fcat>-no_out = 'X'.
        WHEN 'POSNR_VF'.
          <gfs_fcat>-no_out = 'X'.
      ENDCASE.
    ENDLOOP.
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form screen
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
*& Form selected_rows
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
