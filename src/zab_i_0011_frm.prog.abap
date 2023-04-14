*&---------------------------------------------------------------------*
*& Include          ZAB_I_0011_FRM
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*& Form f_soru_1
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM f_soru_1 .

  SELECT FROM zab_t_0011
    FIELDS stu_no,
           stu_fname,
           stu_lname,
           stu_gen,
           stu_birth,
           stu_class,
           stu_score
  ORDER BY stu_no
  INTO TABLE @DATA(lt_student)  .

  cl_demo_output=>begin_section( TEXT-001 ).
  cl_demo_output=>display( lt_student ).

ENDFORM.
*&---------------------------------------------------------------------*
*& Form f_soru_2
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM f_soru_2 .

  SELECT stu_fname ,
         stu_lname ,
         stu_class
  FROM zab_t_0011
  INTO TABLE @DATA(lt_student).

  cl_demo_output=>begin_section( TEXT-002 ).
  cl_demo_output=>display( lt_student ).

ENDFORM.
*&---------------------------------------------------------------------*
*& Form f_soru_3
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM f_soru_3 .

  SELECT * FROM zab_t_0011
  INTO TABLE @DATA(lt_student)
  WHERE stu_gen = 'K'  .

  cl_demo_output=>begin_section( TEXT-003 ).
  cl_demo_output=>display( lt_student ).

ENDFORM.
*&---------------------------------------------------------------------*
*& Form f_soru_4
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM f_soru_4 .

  SELECT DISTINCT stu_class FROM zab_t_0011
  INTO TABLE @DATA(lt_student).

  cl_demo_output=>begin_section( TEXT-004 ).
  cl_demo_output=>display( lt_student ).

ENDFORM.
*&---------------------------------------------------------------------*
*& Form f_soru_5
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM f_soru_5 .

  SELECT * FROM zab_t_0011
  INTO TABLE @DATA(lt_student)
  WHERE stu_class = '1'
    AND stu_gen   = 'K' .

  cl_demo_output=>begin_section( TEXT-005 ).
  cl_demo_output=>display( lt_student ).

ENDFORM.
*&---------------------------------------------------------------------*
*& Form f_soru_6
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM f_soru_6 .

  SELECT stu_fname ,
         stu_lname ,
         stu_class
  FROM zab_t_0011
  INTO TABLE @DATA(lt_student)
  WHERE stu_class = '1' OR
        stu_class = '2' .

  cl_demo_output=>begin_section( TEXT-006 ).
  cl_demo_output=>display( lt_student ).

ENDFORM.
*&---------------------------------------------------------------------*
*& Form f_soru_7
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM f_soru_7 .

  SELECT stu_fname ,
         stu_lname ,
         stu_no AS Okul_Numarası
  FROM zab_t_0011
  INTO TABLE @DATA(lt_student)
  ORDER BY Okul_Numarası.

  cl_demo_output=>begin_section( TEXT-007 ).
  cl_demo_output=>display( lt_student ).

ENDFORM.
*&---------------------------------------------------------------------*
*& Form f_soru_8
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM f_soru_8 .

  SELECT concat( stu_fname, stu_lname ) AS Ad_Soyad
  FROM zab_t_0011
  INTO TABLE @DATA(lt_student).

  cl_demo_output=>begin_section( TEXT-008 ).
  cl_demo_output=>display( lt_student ).

ENDFORM.
*&---------------------------------------------------------------------*
*& Form f_soru_9
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM f_soru_9 .

  SELECT * FROM zab_t_0011
  INTO TABLE @DATA(lt_student)
  WHERE stu_fname LIKE 'A%'.

  cl_demo_output=>begin_section( TEXT-009 ).
  cl_demo_output=>display( lt_student ).

ENDFORM.
*&---------------------------------------------------------------------*
*& Form f_soru_10
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM f_soru_10 .

  SELECT book_name ,
         page_no
  FROM zab_t_0008
  INTO TABLE @DATA(lt_book)
  WHERE page_no BETWEEN 50 AND 200.

  cl_demo_output=>begin_section( TEXT-010 ).
  cl_demo_output=>display( lt_book ).

ENDFORM.
*&---------------------------------------------------------------------*
*& Form f_soru_11
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM f_soru_11 .

  SELECT * FROM zab_t_0011
  INTO TABLE @DATA(lt_student)
  WHERE stu_fname EQ 'ATANUR'
     OR stu_fname EQ 'DOĞU'
     OR stu_fname EQ 'ANGELINA'.

  cl_demo_output=>begin_section( TEXT-011 ).
  cl_demo_output=>display( lt_student ).

ENDFORM.
*&---------------------------------------------------------------------*
*& Form f_soru_12
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM f_soru_12 .

  SELECT * FROM zab_t_0011
  INTO TABLE @DATA(lt_student)
  WHERE stu_fname LIKE 'A%'
     OR stu_fname LIKE 'D%'
     OR stu_fname LIKE 'K%'.

  cl_demo_output=>begin_section( TEXT-012 ).
  cl_demo_output=>display( lt_student ).

ENDFORM.
*&---------------------------------------------------------------------*
*& Form f_soru_13
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM f_soru_13 .

  SELECT stu_fname ,
         stu_lname ,
         stu_class ,
         stu_gen
  FROM zab_t_0011
  INTO TABLE @DATA(lt_student)
  WHERE ( stu_class = '1' AND stu_gen = 'E' )
     OR ( stu_class = '2' AND stu_gen = 'K' ).

  cl_demo_output=>begin_section( TEXT-013 ).
  cl_demo_output=>display( lt_student ).

ENDFORM.
*&---------------------------------------------------------------------*
*& Form f_soru_14
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM f_soru_14 .

  SELECT stu_fname ,
         stu_lname ,
         stu_class
  FROM zab_t_0011
  INTO TABLE @DATA(lt_student)
  WHERE ( stu_class = '1' OR stu_class = '2' )
    AND stu_gen = 'E'.

  cl_demo_output=>begin_section( TEXT-014 ).
  cl_demo_output=>display( lt_student ).

ENDFORM.
*&---------------------------------------------------------------------*
*& Form f_soru_15
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM f_soru_15 .

  SELECT * FROM zab_t_0011
  INTO TABLE @DATA(lt_student)
  WHERE stu_birth BETWEEN '20230101' AND '20230531'.

  cl_demo_output=>begin_section( TEXT-015 ).
  cl_demo_output=>display( lt_student ).

ENDFORM.
*&---------------------------------------------------------------------*
*& Form f_soru_16
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM f_soru_16 .

  SELECT * FROM zab_t_0011
  INTO TABLE @DATA(lt_student)
  WHERE stu_gen = 'K'
  AND stu_no BETWEEN '3' AND '5'.

  cl_demo_output=>begin_section( TEXT-016 ).
  cl_demo_output=>display( lt_student ).

ENDFORM.
*&---------------------------------------------------------------------*
*& Form f_soru_17
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM f_soru_17 .

  SELECT * FROM zab_t_0011
  INTO TABLE @DATA(lt_student)
  ORDER BY stu_fname.

  cl_demo_output=>begin_section( TEXT-017 ).
  cl_demo_output=>display( lt_student ).

ENDFORM.
*&---------------------------------------------------------------------*
*& Form f_soru_18
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM f_soru_18 .

  SELECT * FROM zab_t_0011
  INTO TABLE @DATA(lt_student)
  ORDER BY stu_fname , stu_lname.

  cl_demo_output=>begin_section( TEXT-018 ).
  cl_demo_output=>display( lt_student ).

ENDFORM.
*&---------------------------------------------------------------------*
*& Form f_soru_19
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM f_soru_19 .

  SELECT * FROM zab_t_0011
  INTO TABLE @DATA(lt_student)
  WHERE stu_class = '1'
  ORDER BY stu_no DESCENDING.

  cl_demo_output=>begin_section( TEXT-019 ).
  cl_demo_output=>display( lt_student ).

ENDFORM.
*&---------------------------------------------------------------------*
*& Form f_soru_20
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM f_soru_20 .

  SELECT * UP TO 10 ROWS
  FROM zab_t_0011
  INTO TABLE @DATA(lt_student).

  cl_demo_output=>begin_section( TEXT-020 ).
  cl_demo_output=>display( lt_student ).

ENDFORM.
*&---------------------------------------------------------------------*
*& Form f_soru_21
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM f_soru_21 .

  SELECT stu_fname ,
         stu_lname ,
         stu_birth
  UP TO 10 ROWS
  FROM zab_t_0011
  INTO TABLE @DATA(lt_student).

  cl_demo_output=>begin_section( TEXT-021 ).
  cl_demo_output=>display( lt_student ).

ENDFORM.
*&---------------------------------------------------------------------*
*& Form f_soru_22
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM f_soru_22 .

  SELECT *
  UP TO 1 ROWS
  FROM zab_t_0008
  INTO TABLE @DATA(lt_student)
  ORDER BY page_no DESCENDING.

  cl_demo_output=>begin_section( TEXT-022 ).
  cl_demo_output=>display( lt_student ).


ENDFORM.
*&---------------------------------------------------------------------*
*& Form f_soru_23
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM f_soru_23 .

  SELECT *
  UP TO 1 ROWS
  FROM zab_t_0011
  INTO TABLE @DATA(lt_student)
  ORDER BY stu_birth DESCENDING.

  cl_demo_output=>begin_section( TEXT-023 ).
  cl_demo_output=>display( lt_student ).

ENDFORM.
*&---------------------------------------------------------------------*
*& Form f_soru_24
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM f_soru_24 .

  SELECT *
  UP TO 1 ROWS
  FROM zab_t_0011
  INTO TABLE @DATA(lt_student)
  WHERE stu_class = '1'
  ORDER BY stu_birth.

  cl_demo_output=>begin_section( TEXT-024 ).
  cl_demo_output=>display( lt_student ).

ENDFORM.
*&---------------------------------------------------------------------*
*& Form f_soru_25
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM f_soru_25 .

  SELECT *
  FROM zab_t_0008
  INTO TABLE @DATA(lt_book)
  WHERE book_name LIKE '_O%'.

  cl_demo_output=>begin_section( TEXT-025 ).
  cl_demo_output=>display( lt_book ).

ENDFORM.
*&---------------------------------------------------------------------*
*& Form f_soru_26
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM f_soru_26 .

  SELECT *
  FROM zab_t_0011
  INTO TABLE @DATA(lt_student)
  ORDER BY stu_class.

  cl_demo_output=>begin_section( TEXT-026 ).
  cl_demo_output=>display( lt_student ).

ENDFORM.
*&---------------------------------------------------------------------*
*& Form f_soru_27
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM f_soru_27 .

  SELECT *
  FROM zab_t_0011
  INTO TABLE @DATA(lt_student)
  ORDER BY stu_class.

  cl_demo_output=>begin_section( TEXT-027 ).
  cl_demo_output=>display( lt_student ).

ENDFORM.
*&---------------------------------------------------------------------*
*& Form f_soru_28
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM f_soru_28 .

  DATA : lv_value  TYPE qf00-ran_int,
         lv_value1 TYPE numc4,
         lv_stu    TYPE qf00-ran_int.

  SELECT COUNT(*)
  FROM zab_t_0011
  INTO lv_stu.

  CALL FUNCTION 'QF05_RANDOM_INTEGER'
    EXPORTING
      ran_int_max   = lv_stu              " Greatest required value
      ran_int_min   = 1                " Smallest required value
    IMPORTING
      ran_int       = lv_value                 " Random number
    EXCEPTIONS
      invalid_input = 1                " RAN_INT_MIN > RAN_INT_MAX
      OTHERS        = 2.

  lv_value1 = lv_value.

  SELECT *
  FROM zab_t_0011
  INTO TABLE @DATA(lt_student)
  WHERE stu_no = @lv_value1.

  cl_demo_output=>begin_section( TEXT-028 ).
  cl_demo_output=>display( lt_student ).

ENDFORM.
*&---------------------------------------------------------------------*
*& Form f_soru_29
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM f_soru_29 .

  SELECT stu_no ,
         stu_fname ,
         stu_lname ,
         stu_class
  UP TO 1 ROWS
  FROM zab_t_0011
  INTO TABLE @DATA(lt_student)
  WHERE stu_class = '1'.

  cl_demo_output=>begin_section( TEXT-029 ).
  cl_demo_output=>display( lt_student ).

ENDFORM.
*&---------------------------------------------------------------------*
*& Form f_soru_30
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM f_soru_30 .

  DATA ls_author TYPE zab_t_0010.

  ls_author-author_id    = '9'.
  ls_author-author_fname = 'KEMAL'.
  ls_author-author_lname = 'UYUMAZ'.
*  INSERT zab_t_0010 FROM ls_author.

  MESSAGE TEXT-030 TYPE 'S'.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form f_soru_31
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM f_soru_31 .

  DATA ls_category TYPE zab_t_0009.

  ls_category-category_id = '8'.
  ls_category-category    = 'BIYOGRAFI'.
*  INSERT zab_t_0009 FROM ls_category.

  MESSAGE TEXT-031 TYPE 'S'.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form f_soru_32
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM f_soru_32 .

  DATA ls_student TYPE zab_t_0011.

  ls_student-stu_no    = '9'.
  ls_student-stu_fname = 'ÇAĞLAR'.
  ls_student-stu_lname = 'ÜZÜMCÜ'.
  ls_student-stu_gen   = 'E'.
  ls_student-stu_birth = '20100102'.
  ls_student-stu_class = '1'.
  ls_student-stu_score = 22.
*  INSERT zab_t_0011 FROM ls_student.

  MESSAGE TEXT-032 TYPE 'S'.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form f_soru_33
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM f_soru_33 .

  DATA : ls_author TYPE zab_t_0010.

  SELECT SINGLE *
  FROM zab_t_0011
  INTO @DATA(ls_student).

  ls_author-author_fname = ls_student-stu_fname.
  ls_author-author_lname = ls_student-stu_lname.
*  INSERT zab_t_0010 FROM ls_author.

  MESSAGE TEXT-033 TYPE 'S'.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form f_soru_34
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM f_soru_34 .

  DATA : ls_author TYPE zab_t_0010,
         lt_author TYPE TABLE OF zab_t_0010.

  SELECT *
  FROM zab_t_0011
  INTO TABLE @DATA(lt_student)
  WHERE stu_no BETWEEN '3' AND '5' .

  LOOP AT lt_student INTO DATA(ls_student).
    ls_author-author_id    = ls_student-stu_no + 21.
    ls_author-author_fname = ls_student-stu_fname.
    ls_author-author_lname = ls_student-stu_lname.
    APPEND ls_author TO lt_author.
  ENDLOOP.
*  INSERT zab_t_0010 FROM TABLE lt_author.

  MESSAGE TEXT-034 TYPE 'S'.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form f_soru_35
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM f_soru_35 .

  SELECT SINGLE author_id
  FROM zab_t_0010
  INTO @DATA(lv_author_id)
  WHERE author_fname = 'MAURO'.

  MESSAGE TEXT-035 TYPE 'S'.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form f_soru_36
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM f_soru_36 .

  UPDATE zab_t_0011 SET stu_class ='7' WHERE stu_no = '1'.

  MESSAGE TEXT-036 TYPE 'S'.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form f_soru_37
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM f_soru_37 .

  UPDATE zab_t_0011 SET stu_class ='6' WHERE stu_class ='2'.

  MESSAGE TEXT-037 TYPE 'S'.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form f_soru_38
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM f_soru_38 .

  UPDATE zab_t_0011 SET stu_score = stu_score + 5.

  MESSAGE TEXT-038 TYPE 'S'.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form f_soru_39
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM f_soru_39 .

*  DELETE FROM zab_t_0011 WHERE stu_no = '5'.

  MESSAGE TEXT-039 TYPE 'S'.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form f_soru_40
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM f_soru_40 .

  SELECT * FROM zab_t_0011
  WHERE stu_birth IS INITIAL
  INTO TABLE @DATA(lt_student).

  cl_demo_output=>begin_section( TEXT-040 ).
  cl_demo_output=>display( lt_student ).

ENDFORM.
*&---------------------------------------------------------------------*
*& Form f_soru_41
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM f_soru_41 .

  SELECT stu_fname ,
         stu_lname ,
         b_date
  FROM zab_t_0011 AS stu
  INNER JOIN zab_t_0012 AS pro ON pro~stu_no EQ stu~stu_no
  INTO TABLE @DATA(lt_student).

  cl_demo_output=>begin_section( TEXT-041 ).
  cl_demo_output=>display( lt_student ).

ENDFORM.
*&---------------------------------------------------------------------*
*& Form f_soru_42
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM f_soru_42 .

  SELECT book_name ,
         category
  FROM zab_t_0008 AS bo
  INNER JOIN zab_t_0009 AS tu ON tu~category_id EQ bo~category_id
  WHERE category = 'ROMAN'
     OR category = 'ANI'
  INTO TABLE @DATA(lt_student).

  cl_demo_output=>begin_section( TEXT-042 ).
  cl_demo_output=>display( lt_student ).

ENDFORM.
*&---------------------------------------------------------------------*
*& Form f_soru_43
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM f_soru_43 .

  SELECT stu~stu_no ,
         stu_fname ,
         stu_lname ,
         book_name
  FROM zab_t_0011 AS stu
  INNER JOIN zab_t_0012 AS pro ON stu~stu_no EQ pro~stu_no
  INNER JOIN zab_t_0008 AS boo ON boo~book_id EQ pro~book_id
  WHERE stu_class = '1'
     OR stu_class = '2'
  INTO TABLE @DATA(lt_student).

  cl_demo_output=>begin_section( TEXT-043 ).
  cl_demo_output=>display( lt_student ).

ENDFORM.
*&---------------------------------------------------------------------*
*& Form f_soru_44
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM f_soru_44 .

  SELECT DISTINCT
         stu~stu_no ,
         stu_fname  ,
         stu_lname  ,
         book_name
  FROM zab_t_0011 AS stu
  INNER JOIN zab_t_0012 AS pro ON stu~stu_no      EQ pro~stu_no
  INNER JOIN zab_t_0008 AS boo ON boo~book_id     EQ pro~book_id
  INNER JOIN zab_t_0009 AS cat ON cat~category_id EQ boo~category_id
  WHERE category = 'ROMAN'
  INTO TABLE @DATA(lt_student).

  cl_demo_output=>begin_section( TEXT-044 ).
  cl_demo_output=>display( lt_student ).

ENDFORM.
*&---------------------------------------------------------------------*
*& Form f_soru_45
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM f_soru_45 .

  SELECT DISTINCT
         stu_fname  ,
         stu_lname  ,
         b_date
  FROM zab_t_0011 AS stu
  INNER JOIN zab_t_0012 AS pro ON stu~stu_no EQ pro~stu_no
  INTO TABLE @DATA(lt_student).

  cl_demo_output=>begin_section( TEXT-045 ).
  cl_demo_output=>display( lt_student ).

ENDFORM.
*&---------------------------------------------------------------------*
*& Form f_soru_46
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM f_soru_46 .

  SELECT book_name ,
         category
  FROM zab_t_0008 AS boo
  INNER JOIN zab_t_0009 AS cat ON cat~category_id EQ boo~category_id
  INTO TABLE @DATA(lt_student)
  WHERE category = 'HIKAYE'
     OR category = 'ANI'.

  cl_demo_output=>begin_section( TEXT-046 ).
  cl_demo_output=>display( lt_student ).

ENDFORM.
*&---------------------------------------------------------------------*
*& Form f_soru_47
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM f_soru_47 .

  SELECT DISTINCT
         stu~stu_no ,
         stu_fname ,
         stu_lname ,
         book_name
  FROM zab_t_0011 AS stu
  INNER JOIN zab_t_0012 AS pro ON stu~stu_no  EQ pro~stu_no
  INNER JOIN zab_t_0008 AS boo ON boo~book_id EQ pro~book_id
  INTO TABLE @DATA(lt_student)
  WHERE stu_class = '1'
     OR stu_class = '2'
  ORDER BY stu_fname.

  cl_demo_output=>begin_section( TEXT-047 ).
  cl_demo_output=>display( lt_student ).

ENDFORM.
*&---------------------------------------------------------------------*
*& Form f_soru_48
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM f_soru_48 .

  SELECT stu_fname ,
         stu_lname ,
         b_date
  FROM zab_t_0011 AS stu
  LEFT JOIN zab_t_0012 AS pro ON pro~stu_no EQ stu~stu_no
  GROUP BY stu_fname, stu_lname, b_date
  INTO TABLE @DATA(lt_student).

  cl_demo_output=>begin_section( TEXT-048 ).
  cl_demo_output=>display( lt_student ).

ENDFORM.
*&---------------------------------------------------------------------*
*& Form f_soru_49
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM f_soru_49 .

  SELECT stu_fname ,
         stu_lname ,
         b_date
  FROM zab_t_0011 AS stu
  LEFT JOIN zab_t_0012 AS pro ON pro~stu_no EQ stu~stu_no
  WHERE b_date IS INITIAL
  INTO TABLE @DATA(lt_student).

  cl_demo_output=>begin_section( TEXT-049 ).
  cl_demo_output=>display( lt_student ).

ENDFORM.
*&---------------------------------------------------------------------*
*& Form f_soru_50
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM f_soru_50 .

  SELECT COUNT(*) AS Odunc_Alma_Sayısı,
         pro~book_id ,
         boo~book_name
    FROM zab_t_0012 AS pro
    LEFT JOIN zab_t_0008 AS boo ON boo~book_id = pro~book_id
    GROUP BY pro~book_id, book_name
    ORDER BY pro~book_id
    INTO TABLE @DATA(lt_student).

  cl_demo_output=>begin_section( TEXT-050 ).
  cl_demo_output=>display( lt_student ).

ENDFORM.
*&---------------------------------------------------------------------*
*& Form f_soru_51
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM f_soru_51 .

  SELECT COUNT( pro~trans_no ) AS Odunc_Alma_Sayısı,
       boo~book_id ,
       boo~book_name
  FROM zab_t_0008 AS boo
  LEFT JOIN zab_t_0012 AS pro ON boo~book_id = pro~book_id
  GROUP BY boo~book_id, book_name, pro~book_id
  ORDER BY Odunc_Alma_Sayısı
  INTO TABLE @DATA(lt_student).

  cl_demo_output=>begin_section( TEXT-051 ).
  cl_demo_output=>display( lt_student ).

ENDFORM.
*&---------------------------------------------------------------------*
*& Form f_soru_52
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM f_soru_52 .

  SELECT stu_fname ,
         stu_lname ,
         book_name
  FROM zab_t_0011 AS stu
  LEFT JOIN zab_t_0012 AS pro ON stu~stu_no  = pro~stu_no
  LEFT JOIN zab_t_0008 AS boo ON boo~book_id = pro~book_id
  INTO TABLE @DATA(lt_student).

  cl_demo_output=>begin_section( TEXT-052 ).
  cl_demo_output=>display( lt_student ).

ENDFORM.
*&---------------------------------------------------------------------*
*& Form f_soru_53
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM f_soru_53 .

  SELECT stu_fname ,
         stu_lname ,
         book_name ,
         author_fname ,
         author_lname ,
         category ,
         b_date
  FROM zab_t_0012 AS pro
  INNER JOIN zab_t_0008 AS boo ON boo~book_id = pro~book_id
  RIGHT JOIN zab_t_0011 AS stu ON stu~stu_no = pro~stu_no
  LEFT JOIN  zab_t_0009 AS cat ON cat~category_id = boo~category_id
  LEFT JOIN  zab_t_0010 AS aut ON aut~author_id = boo~author_id
  INTO TABLE @DATA(lt_student).

  cl_demo_output=>begin_section( TEXT-053 ).
  cl_demo_output=>display( lt_student ).

ENDFORM.
*&---------------------------------------------------------------------*
*& Form f_soru_54
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM f_soru_54 .

  SELECT stu_fname ,
         stu_lname ,
         book_name ,
         author_fname ,
         author_lname ,
         category ,
         b_date
  FROM zab_t_0012 AS pro
  INNER JOIN zab_t_0008 AS boo ON boo~book_id = pro~book_id
  RIGHT JOIN zab_t_0011 AS stu ON stu~stu_no = pro~stu_no
  LEFT JOIN  zab_t_0009 AS cat ON cat~category_id = boo~category_id
  LEFT JOIN  zab_t_0010 AS aut ON aut~author_id = boo~author_id
  INTO TABLE @DATA(lt_student).

  cl_demo_output=>begin_section( TEXT-054 ).
  cl_demo_output=>display( lt_student ).

ENDFORM.
*&---------------------------------------------------------------------*
*& Form f_soru_55
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM f_soru_55 .

  SELECT stu_fname ,
         stu_lname ,
         COUNT( pro~trans_no ) AS Odunc_alma_sayısı
  FROM zab_t_0011 AS stu
  LEFT JOIN zab_t_0012 AS pro ON stu~stu_no = pro~stu_no
  WHERE stu_class IN ( '1' , '2' )
  GROUP BY stu_class, stu_fname, stu_lname
  INTO TABLE @DATA(lt_student).

  cl_demo_output=>begin_section( TEXT-055 ).
  cl_demo_output=>display( lt_student ).

ENDFORM.
*&---------------------------------------------------------------------*
*& Form f_soru_56
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM f_soru_56 .

  SELECT * UP TO 1 ROWS
  FROM zab_t_0008
  INTO TABLE @DATA(lt_student)
  ORDER BY page_no DESCENDING.

  cl_demo_output=>begin_section( TEXT-056 ).
  cl_demo_output=>display( lt_student ).

*  SELECT *
*  FROM zab_t_0008
*  INTO TABLE @DATA(lt_student)
*  WHERE page_no In ( SELECT max( page_no ) from zab_t_0008 ).

*  cl_demo_output=>begin_section( TEXT-056 ).
*  cl_demo_output=>display( lt_student ).

ENDFORM.
*&---------------------------------------------------------------------*
*& Form f_soru_57
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM f_soru_57 .

  DATA lv_avg1 TYPE i.
  SELECT AVG( page_no ) FROM zab_t_0008 INTO @DATA(lv_avg).
  lv_avg1 = lv_avg.

  SELECT *
  FROM zab_t_0008
  INTO TABLE @DATA(lt_book)
  WHERE page_no > @lv_avg1.

  cl_demo_output=>begin_section( TEXT-057 ).
  cl_demo_output=>display( lt_book ).

ENDFORM.
*&---------------------------------------------------------------------*
*& Form f_soru_58
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM f_soru_58 .

  SELECT *
  FROM zab_t_0008
  INTO TABLE @DATA(lt_book)
  WHERE category_id =
  ( SELECT ( category_id ) FROM zab_t_0009 WHERE category = 'ROMAN' ).

  cl_demo_output=>begin_section( TEXT-058 ).
  cl_demo_output=>display( lt_book ).

ENDFORM.
*&---------------------------------------------------------------------*
*& Form f_soru_59
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM f_soru_59 .

  SELECT *
  FROM zab_t_0008
  INTO TABLE @DATA(lt_book)
  WHERE author_id IN
  ( SELECT ( author_id ) FROM zab_t_0010 WHERE author_fname LIKE 'E%' ).

  cl_demo_output=>begin_section( TEXT-059 ).
  cl_demo_output=>display( lt_book ).

ENDFORM.
*&---------------------------------------------------------------------*
*& Form f_soru_60
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM f_soru_60 .

  SELECT *
  FROM zab_t_0011
  WHERE stu_no NOT IN ( SELECT ( stu_no ) FROM zab_t_0012 )
  INTO TABLE @DATA(lt_book).

  cl_demo_output=>begin_section( TEXT-060 ).
  cl_demo_output=>display( lt_book ).

ENDFORM.
*&---------------------------------------------------------------------*
*& Form f_soru_61
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM f_soru_61 .

  SELECT *
  FROM zab_t_0008
  WHERE book_id NOT IN ( SELECT ( book_id ) FROM zab_t_0012 )
  INTO TABLE @DATA(lt_book).

  cl_demo_output=>begin_section( TEXT-061 ).
  cl_demo_output=>display( lt_book ).

ENDFORM.
*&---------------------------------------------------------------------*
*& Form f_soru_62
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM f_soru_62 .

  SELECT *
  FROM zab_t_0008
  WHERE book_id NOT IN ( SELECT ( book_id ) FROM zab_t_0012 )"WHERE month( b_date ) = 5
  INTO TABLE @DATA(lt_book).

  cl_demo_output=>begin_section( TEXT-062 ).
  cl_demo_output=>display( lt_book ).

ENDFORM.
*&---------------------------------------------------------------------*
*& Form f_soru_63
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM f_soru_63 .

  SELECT AVG( page_no ) AS Ortalama_Sayfa_Sayısı
  FROM zab_t_0008
  INTO TABLE @DATA(lt_book).

  cl_demo_output=>begin_section( TEXT-063 ).
  cl_demo_output=>display( lt_book ) .

ENDFORM.
*&---------------------------------------------------------------------*
*& Form f_soru_64
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM f_soru_64 .

  DATA : lv_page1 TYPE i.

  SELECT AVG( page_no ) FROM zab_t_0008 INTO @DATA(lv_page).
  lv_page1 = lv_page.

  SELECT *
  FROM zab_t_0008
  INTO TABLE @DATA(lt_book)
  WHERE page_no > @lv_page1.

  cl_demo_output=>begin_section( TEXT-064 ).
  cl_demo_output=>display( lt_book ) .

ENDFORM.
*&---------------------------------------------------------------------*
*& Form f_soru_65
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM f_soru_65 .

  SELECT COUNT(*)
  FROM zab_t_0011 INTO @DATA(lv_count).

ENDFORM.
*&---------------------------------------------------------------------*
*& Form f_soru_66
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM f_soru_66 .

  SELECT COUNT(*) AS ogrenci_sayısı
  FROM zab_t_0011 INTO @DATA(lv_count).

  cl_demo_output=>begin_section( TEXT-066 ).
  cl_demo_output=>display( lv_count ) .

ENDFORM.
*&---------------------------------------------------------------------*
*& Form f_soru_67
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM f_soru_67 .

  SELECT COUNT( DISTINCT stu_fname ) AS farklı_isim_sayısı
  FROM zab_t_0011
  INTO TABLE @DATA(lt_book).

  cl_demo_output=>begin_section( TEXT-067 ).
  cl_demo_output=>display( lt_book ) .

ENDFORM.
*&---------------------------------------------------------------------*
*& Form f_soru_68
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM f_soru_68 .

  SELECT MAX( page_no ) AS En_Fazla_Sayfa_Sayısı
  FROM zab_t_0008
  INTO TABLE @DATA(lt_book).

  cl_demo_output=>begin_section( TEXT-068 ).
  cl_demo_output=>display( lt_book ) .

ENDFORM.
*&---------------------------------------------------------------------*
*& Form f_soru_69
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM f_soru_69 .

  SELECT book_name,
         page_no AS En_Fazla_Sayfa_Sayısı
  FROM zab_t_0008
  WHERE page_no = ( SELECT MAX( page_no ) FROM zab_t_0008 )
  INTO TABLE @DATA(lt_book).

  cl_demo_output=>begin_section( TEXT-069 ).
  cl_demo_output=>display( lt_book ) .

ENDFORM.
*&---------------------------------------------------------------------*
*& Form f_soru_70
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM f_soru_70 .

  SELECT MIN( page_no ) AS En_Az_Sayfa_Sayısı
  FROM zab_t_0008
  INTO TABLE @DATA(lt_book).

  cl_demo_output=>begin_section( TEXT-070 ).
  cl_demo_output=>display( lt_book ) .

ENDFORM.
*&---------------------------------------------------------------------*
*& Form f_soru_71
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM f_soru_71 .

  SELECT book_name,
         page_no AS En_Az_Sayfa_Sayısı
  FROM zab_t_0008
  WHERE page_no = ( SELECT MIN( page_no ) FROM zab_t_0008 )
  INTO TABLE @DATA(lt_book).

  cl_demo_output=>begin_section( TEXT-071 ).
  cl_demo_output=>display( lt_book ) .

ENDFORM.
*&---------------------------------------------------------------------*
*& Form f_soru_72
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM f_soru_72 .

  SELECT MAX( page_no ) AS En_Fazla_Sayfa_Sayısı
  FROM zab_t_0008
  WHERE category_id =
  ( SELECT ( category_id ) FROM zab_t_0009 WHERE category = 'ROMAN' )
  INTO TABLE @DATA(lt_book).

  cl_demo_output=>begin_section( TEXT-072 ).
  cl_demo_output=>display( lt_book ) .

ENDFORM.
*&---------------------------------------------------------------------*
*& Form f_soru_73
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM f_soru_73 .

  SELECT SUM( page_no )
  FROM zab_t_0011 AS stu
  INNER JOIN zab_t_0012 AS pro ON stu~stu_no = pro~stu_no
  INNER JOIN zab_t_0008 AS boo ON pro~book_id = boo~book_id
  WHERE stu~stu_no = '2'
  INTO TABLE @DATA(lt_book).

  cl_demo_output=>begin_section( TEXT-073 ).
  cl_demo_output=>display( lt_book ).

ENDFORM.
*&---------------------------------------------------------------------*
*& Form f_soru_74
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM f_soru_74 .

  SELECT stu_fname,
         stu_lname,
         div( dats_days_between( stu_birth, @sy-datum ), 365 ) AS Yas
  FROM zab_t_0011
  INTO TABLE @DATA(lt_student).

  cl_demo_output=>begin_section( TEXT-074 ).
  cl_demo_output=>display( lt_student ).

ENDFORM.
*&---------------------------------------------------------------------*
*& Form f_soru_75
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM f_soru_75 .

  SELECT stu_fname,
         COUNT(*) AS Isme_Gore_Kisi_Sayısı
  FROM zab_t_0011
  GROUP BY stu_fname
  INTO TABLE @DATA(lt_student).

  cl_demo_output=>begin_section( TEXT-075 ).
  cl_demo_output=>display( lt_student ).

ENDFORM.
*&---------------------------------------------------------------------*
*& Form f_soru_76
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM f_soru_76 .

  SELECT stu_class,
         COUNT(*) AS Sınıfa_Gore_Ogrenci_Sayıları
  FROM zab_t_0011
  GROUP BY stu_class
  INTO TABLE @DATA(lt_student).

  cl_demo_output=>begin_section( TEXT-076 ).
  cl_demo_output=>display( lt_student ).

ENDFORM.
*&---------------------------------------------------------------------*
*& Form f_soru_77
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM f_soru_77 .

  SELECT stu_class,
         stu_gen,
         COUNT(*) AS Sınıfa_Gore_Kız_Erkek_Sayıları
  FROM zab_t_0011
  GROUP BY stu_gen, stu_class
  INTO TABLE @DATA(lt_student).

  cl_demo_output=>begin_section( TEXT-077 ).
  cl_demo_output=>display( lt_student ).

ENDFORM.
*&---------------------------------------------------------------------*
*& Form f_soru_78
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM f_soru_78 .

  SELECT stu_fname,
         stu_lname,
         SUM( page_no ) AS Sayfa_Sayısı
  FROM zab_t_0011 AS stu
  INNER JOIN zab_t_0012 AS pro ON stu~stu_no = pro~stu_no
  INNER JOIN zab_t_0008 AS boo ON pro~book_id = boo~book_id
  GROUP BY stu_fname, stu_lname, stu~stu_no
  ORDER BY Sayfa_Sayısı DESCENDING
  INTO TABLE @DATA(lt_student).

  cl_demo_output=>begin_section( TEXT-078 ).
  cl_demo_output=>display( lt_student ).

ENDFORM.
*&---------------------------------------------------------------------*
*& Form f_soru_79
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM f_soru_79 .

  SELECT stu_fname,
         stu_lname,
         COUNT(*) AS Kitap_Sayısı
  FROM zab_t_0011 AS stu
  INNER JOIN zab_t_0012 AS pro ON stu~stu_no = pro~stu_no
  INNER JOIN zab_t_0008 AS boo ON pro~book_id = boo~book_id
  GROUP BY stu_fname, stu_lname, stu~stu_no
  ORDER BY Kitap_Sayısı DESCENDING
  INTO TABLE @DATA(lt_student).

  cl_demo_output=>begin_section( TEXT-079 ).
  cl_demo_output=>display( lt_student ).

ENDFORM.
*&---------------------------------------------------------------------*
*& Form f_cases
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      <-- P_SORUNO
*&---------------------------------------------------------------------*
FORM f_cases  CHANGING p_p_soruno.

  CASE p_p_soruno.
    WHEN '01'.
      PERFORM f_soru_1.
    WHEN '02'.
      PERFORM f_soru_2.
    WHEN '03'.
      PERFORM f_soru_3.
    WHEN '04'.
      PERFORM f_soru_4.
    WHEN '05'.
      PERFORM f_soru_5.
    WHEN '06'.
      PERFORM f_soru_6.
    WHEN '07'.
      PERFORM f_soru_7.
    WHEN '08'.
      PERFORM f_soru_8.
    WHEN '09'.
      PERFORM f_soru_9.
    WHEN '10'.
      PERFORM f_soru_10.
    WHEN '11'.
      PERFORM f_soru_11.
    WHEN '12'.
      PERFORM f_soru_12.
    WHEN '13'.
      PERFORM f_soru_13.
    WHEN '14'.
      PERFORM f_soru_14.
    WHEN '15'.
      PERFORM f_soru_15.
    WHEN '16'.
      PERFORM f_soru_16.
    WHEN '17'.
      PERFORM f_soru_17.
    WHEN '18'.
      PERFORM f_soru_18.
    WHEN '19'.
      PERFORM f_soru_19.
    WHEN '20'.
      PERFORM f_soru_20.
    WHEN '21'.
      PERFORM f_soru_21.
    WHEN '22'.
      PERFORM f_soru_22.
    WHEN '23'.
      PERFORM f_soru_23.
    WHEN '24'.
      PERFORM f_soru_24.
    WHEN '25'.
      PERFORM f_soru_25.
    WHEN '26'.
      PERFORM f_soru_26.
    WHEN '27'.
      PERFORM f_soru_27.
    WHEN '28'.
      PERFORM f_soru_28.
    WHEN '29'.
      PERFORM f_soru_29.
    WHEN '30'.
      PERFORM f_soru_30.
    WHEN '31'.
      PERFORM f_soru_31.
    WHEN '32'.
      PERFORM f_soru_32.
    WHEN '33'.
      PERFORM f_soru_33.
    WHEN '34'.
      PERFORM f_soru_34.
    WHEN '35'.
      PERFORM f_soru_35.
    WHEN '36'.
      PERFORM f_soru_36.
    WHEN '37'.
      PERFORM f_soru_37.
    WHEN '38'.
      PERFORM f_soru_38.
    WHEN '39'.
      PERFORM f_soru_39.
    WHEN '40'.
      PERFORM f_soru_40.
    WHEN '41'.
      PERFORM f_soru_41.
    WHEN '42'.
      PERFORM f_soru_42.
    WHEN '43'.
      PERFORM f_soru_43.
    WHEN '44'.
      PERFORM f_soru_44.
    WHEN '45'.
      PERFORM f_soru_45.
    WHEN '46'.
      PERFORM f_soru_46.
    WHEN '47'.
      PERFORM f_soru_47.
    WHEN '48'.
      PERFORM f_soru_48.
    WHEN '49'.
      PERFORM f_soru_49.
    WHEN '50'.
      PERFORM f_soru_50.
    WHEN '51'.
      PERFORM f_soru_51.
    WHEN '52'.
      PERFORM f_soru_52.
    WHEN '53'.
      PERFORM f_soru_53.
    WHEN '54'.
      PERFORM f_soru_54.
    WHEN '55'.
      PERFORM f_soru_55.
    WHEN '56'.
      PERFORM f_soru_56.
    WHEN '57'.
      PERFORM f_soru_57.
    WHEN '58'.
      PERFORM f_soru_58.
    WHEN '59'.
      PERFORM f_soru_59.
    WHEN '60'.
      PERFORM f_soru_60.
    WHEN '61'.
      PERFORM f_soru_61.
    WHEN '62'.
      PERFORM f_soru_62.
    WHEN '63'.
      PERFORM f_soru_63.
    WHEN '64'.
      PERFORM f_soru_64.
    WHEN '65'.
      PERFORM f_soru_65.
    WHEN '66'.
      PERFORM f_soru_66.
    WHEN '67'.
      PERFORM f_soru_67.
    WHEN '68'.
      PERFORM f_soru_68.
    WHEN '69'.
      PERFORM f_soru_69.
    WHEN '70'.
      PERFORM f_soru_70.
    WHEN '71'.
      PERFORM f_soru_71.
    WHEN '72'.
      PERFORM f_soru_72.
    WHEN '73'.
      PERFORM f_soru_73.
    WHEN '74'.
      PERFORM f_soru_74.
    WHEN '75'.
      PERFORM f_soru_75.
    WHEN '76'.
      PERFORM f_soru_76.
    WHEN '77'.
      PERFORM f_soru_77.
    WHEN '78'.
      PERFORM f_soru_78.
    WHEN '79'.
      PERFORM f_soru_79.
  ENDCASE.

ENDFORM.
