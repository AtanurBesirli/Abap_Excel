*&---------------------------------------------------------------------*
*& Report ZAB_EDU_0025
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ZAB_EDU_0025.

DATA: it_fields TYPE TABLE OF sval,
      wa_fields TYPE sval.

START-OF-SELECTION.

REFRESH it_fields.
CLEAR wa_fields.
wa_fields-tabname = 'MARA'.
wa_fields-FIELDNAME = 'MATNR'.
APPEND wa_fields  TO it_fields.

wa_fields-tabname = 'MARC'.
wa_fields-FIELDNAME = 'WERKS'.
APPEND wa_fields  TO it_fields.

CALL FUNCTION 'POPUP_GET_VALUES_USER_CHECKED'
EXPORTING
formname = 'test'
popup_title = 'Aufträge Rückmelden'
programname = 'Doesnt_matter'


START_COLUMN = '5'
START_ROW = '5'
NO_CHECK_FOR_FIXED_VALUES = ' '
*IMPORTING
*RETURNCODE =
TABLES
fields = it_fields
EXCEPTIONS
error_in_fields = 1
OTHERS = 2
.

BREAK-POINT.
