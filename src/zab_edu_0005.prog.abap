*&---------------------------------------------------------------------*
*& Report ZAB_EDU_0005
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ZAB_EDU_0005.

CLASS math_op DEFINITION.
  PUBLIC SECTION.
    DATA : lv_num1   TYPE int4,
           lv_num2   TYPE int4,
           lv_result TYPE int4.
    METHODS : sum_numbers.
ENDCLASS.


CLASS math_op IMPLEMENTATION.
  METHOD sum_numbers.
    lv_result = lv_num1 + lv_num2.
  ENDMETHOD.
ENDCLASS.

CLASS math_op_diff DEFINITION INHERITING FROM math_op.
  PUBLIC SECTION.
  METHODS : numb_diff.
ENDCLASS.

CLASS math_op_diff IMPLEMENTATION.
  METHOD numb_diff.
    lv_result = lv_num1 - lv_num2.
  ENDMETHOD.
ENDCLASS.

DATA : go_math_op      TYPE REF TO math_op.
DATA : go_math_op_diff TYPE REF TO math_op_diff.

START-OF-SELECTION.

CREATE OBJECT : go_math_op.
CREATE OBJECT : go_math_op_diff.

go_math_op->lv_num1 = 5.
go_math_op->lv_num2 = 7.
go_math_op->sum_numbers( ).
WRITE : go_math_op->lv_result.

go_math_op_diff->lv_num1 = 22.
go_math_op_diff->lv_num2 = 11.
go_math_op_diff->numb_diff( ).
WRITE : / go_math_op_diff->lv_result.
