*&---------------------------------------------------------------------*
*& Report ZAB_EDU_0055
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zab_edu_0055.

DATA : gt_data       TYPE TABLE OF scarr,
       gs_data       TYPE scarr,
       lv_dynp       TYPE help_info-dynprofld,
       lt_return_tab TYPE TABLE OF ddshretval,
       ls_return_tab TYPE ddshretval,
       lt_mapping    TYPE TABLE OF dselc,
       ls_mapping    TYPE dselc.

*lv_dynp       = 'GS_DATA-CARRID'.

SELECT * FROM scarr INTO TABLE gt_data.

*  LOOP AT gt_data INTO gs_data.
*
*  ENDLOOP.

*READ TABLE gt_data INTO gs_data WITH KEY carrid = 'AC'.

*AT SELECTION-SCREEN ON VALUE-REQUEST FOR gs_data-carrid.

ls_mapping-fldname = 'F0002'.
ls_mapping-dyfldname = 'F0002'.
APPEND ls_mapping TO lt_mapping.

ls_mapping-fldname = 'F0003'.
APPEND ls_mapping TO lt_mapping.

ls_mapping-fldname = 'F0004'.
APPEND ls_mapping TO lt_mapping.

ls_mapping-fldname = 'F0005'.
APPEND ls_mapping TO lt_mapping.

CALL FUNCTION 'F4IF_INT_TABLE_VALUE_REQUEST'
  EXPORTING
    retfield        = 'CARRID'
    dynpprog        = sy-repid
    dynpnr          = sy-dynnr
    dynprofield     = lv_dynp
    value_org       = 'S'
  TABLES
    value_tab       = gt_data
    return_tab      = lt_return_tab
    dynpfld_mapping = lt_mapping
  EXCEPTIONS
    parameter_error = 1
    no_values_found = 2
    OTHERS          = 3.
IF sy-subrc <> 0.
* Implement suitable error handling here
ENDIF.

READ TABLE lt_return_tab INTO ls_return_tab INDEX 1.
gs_data-carrid = ls_return_tab-fieldval.
READ TABLE lt_return_tab INTO ls_return_tab INDEX 2.
gs_data-carrname = ls_return_tab-fieldval.
READ TABLE lt_return_tab INTO ls_return_tab INDEX 3.
gs_data-currcode = ls_return_tab-fieldval.
READ TABLE lt_return_tab INTO ls_return_tab INDEX 4.
gs_data-url = ls_return_tab-fieldval.


START-OF-SELECTION.
  CALL SCREEN 0100.





















*&---------------------------------------------------------------------*
*& Module STATUS_0100 OUTPUT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
MODULE status_0100 OUTPUT.
  SET PF-STATUS '0100'.
* SET TITLEBAR 'xxx'.
ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_0100  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE user_command_0100 INPUT.

  CASE sy-ucomm.
    WHEN '&BACK'.
      LEAVE TO SCREEN 0.
  ENDCASE.

ENDMODULE.
