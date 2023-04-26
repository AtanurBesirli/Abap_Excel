*&---------------------------------------------------------------------*
*& Report ZAB_EDU_0004
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zab_edu_0004.

*DATA : gv_empid TYPE zab_employeeid_de.
*TABLES zab_emp_t.
*
*PARAMETERS : p_num1  TYPE int1,
*             p_empfn TYPE zab_employeefirstname_de.
*
*SELECT-OPTIONS : s_empid  FOR gv_empid,
*                 s_empgen FOR zab_emp_t-emp_gender.
*
*PARAMETERS : p_cbox1 AS CHECKBOX.
*
*SELECTION-SCREEN BEGIN OF BLOCK bl1 WITH FRAME TITLE text-001.
*PARAMETERS : p_rad1 RADIOBUTTON GROUP gr1,
*             p_rad2 RADIOBUTTON GROUP gr1,
*             p_rad3 RADIOBUTTON GROUP gr1.
*SELECTION-SCREEN END OF BLOCK bl1.
*
*SELECTION-SCREEN BEGIN OF BLOCK bl2 WITH FRAME TITLE text-002.
*PARAMETERS : p_rad4 RADIOBUTTON GROUP gr2,
*             p_rad5 RADIOBUTTON GROUP gr2,
*             p_rad6 RADIOBUTTON GROUP gr2.
*SELECTION-SCREEN END OF BLOCK bl2.

*&---------------------------------------------------------------------*

*DATA : gv_num1   TYPE int4,
*       gv_num2   TYPE int4,
*       gv_result TYPE int4.
*
*gv_num1 = 20.
*gv_num2 = 20.
*
*CALL FUNCTION 'ZAB_EDU_F_0001'
* EXPORTING
*   IV_NUM1         = gv_num1
*   IV_NUM2         = gv_num2
* IMPORTING
*   EV_RESULT       = gv_result
*          .
*
*WRITE : gv_result.

*&---------------------------------------------------------------------*

*DATA : go_edu_cl TYPE REF TO z_cl_education_0001.
*DATA : gv_num1   TYPE int4,
*       gv_num2   TYPE int4,
*       gv_result TYPE int4.
*
*START-OF-SELECTION.
*
*  CREATE OBJECT go_edu_cl.
*
*  go_edu_cl->sum_numbers(
*    EXPORTING
*      iv_num1   = gv_num1                 " 4 Byte Signed Integer
*      iv_num2   = gv_num2                 " 4 Byte Signed Integer
*    IMPORTING
*      ev_result = gv_result                 " 4 Byte Signed Integer
*  ).
*  WRITE : gv_result.
