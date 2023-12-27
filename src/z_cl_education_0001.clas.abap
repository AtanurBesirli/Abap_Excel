class Z_CL_EDUCATION_0001 definition
  public
  final
  create public .

public section.

  methods SUM_NUMBERS
    importing
      value(IV_NUM1) type INT4 optional
      value(IV_NUM2) type INT4 optional
    exporting
      !EV_RESULT type INT4 .
protected section.
private section.
ENDCLASS.



CLASS Z_CL_EDUCATION_0001 IMPLEMENTATION.


  method SUM_NUMBERS.
    ev_result = iv_num1 + iv_num2.
  endmethod.
ENDCLASS.
