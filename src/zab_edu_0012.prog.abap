*&---------------------------------------------------------------------*
*& Report ZAB_EDU_0012
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zab_edu_0012.

DATA : gv_firstname TYPE char30,
       gv_lastname  TYPE char30,
       gv_birthdate TYPE datum,
       gv_age       TYPE int1,
       gv_iread     TYPE char1.

DATA : gv_gender1 TYPE char1,
       gv_gender2 TYPE char1.

DATA : gv_id     TYPE vrm_id,
       gt_values TYPE vrm_values,
       gs_value  TYPE vrm_value,
       gv_ind    TYPE int1.

DATA : gs_log TYPE zab_t_0001.

CONTROLS ts_id TYPE TABSTRIP.

START-OF-SELECTION.

  gv_iread = 'X'.

  CALL SCREEN 0100.

*&---------------------------------------------------------------------*
*& Module STATUS_0100 OUTPUT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
MODULE status_0100 OUTPUT.
  SET PF-STATUS '0100'.
* SET TITLEBAR 'xxx'.

  gv_id = 'GV_AGE'.

  gv_ind = 18.
  DO 50 TIMES.
    gs_value-key  = gv_ind.
    gs_value-text = gv_ind.
    APPEND gs_value TO gt_values.
    gv_ind = gv_ind + 1.
  ENDDO.

  CALL FUNCTION 'VRM_SET_VALUES'
    EXPORTING
      id     = gv_id
      values = gt_values.

ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_0100  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE user_command_0100 INPUT.
  CASE sy-ucomm.
    WHEN '&BCK'.
      LEAVE TO SCREEN 0.
    WHEN '&CLEAR'.
      PERFORM clear_data.
    WHEN '&SAVE'.
      PERFORM save_data.
    WHEN '&TB1'.
      ts_id-activetab = '&TB1'.
    WHEN '&TB2'.
      ts_id-activetab = '&TB2'.
  ENDCASE.
ENDMODULE.
*&---------------------------------------------------------------------*
*& Form clear_data
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM clear_data .
  CLEAR : gv_firstname,
          gv_lastname,
          gv_birthdate,
          gv_age,
          gv_iread,
          gv_gender2.
          gv_gender1 = 'X'.
  MESSAGE 'Cleared' TYPE 'S'.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form save_data
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM save_data .
  gs_log-z_firstname = gv_firstname.
  gs_log-z_lastname  = gv_lastname.
  gs_log-z_age       = gv_age.
  gs_log-z_birthdate = gv_birthdate.
  gs_log-z_iread     = gv_iread.
  IF gv_gender1 EQ 'X'.
    gs_log-z_gender  = 'W'.
  ELSE.
    gs_log-z_gender  = 'M'.
  ENDIF.
  INSERT zab_t_0001 FROM gs_log.
  COMMIT WORK AND WAIT.

  MESSAGE 'Saved' TYPE 'I'.
ENDFORM.
