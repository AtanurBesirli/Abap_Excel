*&---------------------------------------------------------------------*
*& Report ZAB_EDU_0032
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zab_edu_0032.

CLASS lcl_main DEFINITION DEFERRED.
DATA : go_main TYPE REF TO lcl_main.
DATA : gv_result TYPE i.

SELECTION-SCREEN BEGIN OF BLOCK bl2 WITH FRAME TITLE TEXT-001.

  PARAMETERS : p_num1 TYPE i,
               p_num2 TYPE i.

SELECTION-SCREEN END OF BLOCK bl2.

CLASS lcl_main DEFINITION.
  PUBLIC SECTION.
    METHODS : sum_numbers IMPORTING iv_num1 TYPE i
                                    iv_num2 TYPE i
                          EXPORTING ev_sum  TYPE i.

ENDCLASS.

CLASS lcl_main IMPLEMENTATION.

  METHOD sum_numbers.

    ev_sum = iv_num1 + iv_num2.

  ENDMETHOD.

ENDCLASS.

START-OF-SELECTION.

  CREATE OBJECT go_main.

  go_main->sum_numbers(
    EXPORTING
      iv_num1 = p_num1
      iv_num2 = p_num2
    IMPORTING
      ev_sum  = gv_result
  ).

  WRITE gv_result.
