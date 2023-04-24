*&---------------------------------------------------------------------*
*& Report ZAB_EDU_0003
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zab_edu_0003.

DATA : gv_empid     TYPE zab_employeeid_de,
       gv_empfn     TYPE zab_employeefirstname_de,
       gv_empln     TYPE zab_employeelastname_de,
       gv_empgender TYPE zab_employeegender_de,
       gs_employee  TYPE zab_emp_t,
       gt_employee  TYPE TABLE OF zab_emp_t.


*SELECT * from zab_emp_t INTO CORRESPONDING FIELDS OF TABLE gt_employee
*  WHERE emp_id eq 1.
*
*SELECT SINGLE * FROM zab_emp_t INTO gs_employee.
*
*SELECT SINGLE emp_id FROM zab_emp_t INTO gv_empid.
*
*UPDATE zab_emp_t SET emp_fn = 'KING'
*  WHERE emp_ln = 'HAMETT'.

*gs_employee-emp_id = 15.
*gs_employee-emp_fn = 'TARKAN'.
*gs_employee-emp_ln = 'TEVETOĞLU'.
*gs_employee-emp_gender = 'M'.
*INSERT zab_emp_t FROM gs_employee.

*DELETE FROM zab_emp_t WHERE emp_id eq 15.

*MODIFY zab_emp_t FROM gs_employee.

DATA : gv_int1 TYPE i VALUE 5,
       gv_int2 TYPE i VALUE 2,
       gv_int3 type i.

 gv_int3 = gv_int1 / gv_int2 .

WRITE gv_int3.

BREAK-POINT.
