

REPORT zab_edu_0041.

TABLES : spfli,  sflight, mara.

SELECT-OPTIONS :
  s_cityto FOR spfli-cityto,
  s_fldate FOR sflight-fldate,
  s_matnr FOR mara-matnr.

START-OF-SELECTION.



  PERFORM internal_tablo.

*  PERFORM join.

*    PERFORM left_join.


*  PERFORM right_join.

*  PERFORM select_in_cond.


*    PERFORM select_expressions.

*  PERFORM group_by.

*  PERFORM inner_select.


*  PERFORM for_all_entries.

*  PERFORM db_islem.
*
*  CALL FUNCTION 'ZTEST1'.
*
*  PERFORM db_islem2.
  .

*  PERFORM dynamic_select.

FORM internal_tablo.

**  DATA
*
*
*
*  TYPES : tt_sflight TYPE STANDARD TABLE OF sflight WITH DEFAULT KEY.
*
*  TYPES tt_sflight_sorted
*    TYPE SORTED TABLE OF sflight WITH NON-UNIQUE KEY carrid connid planetype.
*
**  TYPES tt_sflight_hashed
**    TYPE HASHED TABLE OF sflight WITH NON-UNIQUE SORTED KEY carrid
*
*  DATA : lt_sflight        TYPE tt_sflight,
*         lt_sflight_sorted TYPE tt_sflight_sorted.
*
*  DATA : ls_sflight LIKE LINE OF lt_sflight .
*
*  DATA : lt_sflight_collect TYPE tt_sflight,
*         ls_sflight_collect LIKE LINE OF lt_sflight_collect.
*
*  SELECT *
*      FROM sflight
*      INTO TABLE lt_sflight.
*
**  SORT lt_sflight BY carrid connid fldate.
*
**  READ TABLE lt_sflight INTO ls_sflight
**    WITH KEY carrid = 'AA' connid = '1000' fldate = '20230304' BINARY SEARCH.
**  IF sy-subrc EQ 0.
*
*
*  LOOP AT lt_sflight INTO ls_sflight.
*
*    ls_sflight_collect-carrid      = ls_sflight-carrid     . "char
*    ls_sflight_collect-connid      = ls_sflight-connid     . "char
**    ls_sflight_collect-fldate      = ls_sflight-fldate     . "tarih
*    ls_sflight_collect-price       = ls_sflight-price      .
*    ls_sflight_collect-currency    = ls_sflight-currency   .
*    ls_sflight_collect-planetype   = ls_sflight-planetype  .
*    ls_sflight_collect-seatsmax    = ls_sflight-seatsmax   .
*    ls_sflight_collect-seatsocc    = ls_sflight-seatsocc   .
*    ls_sflight_collect-paymentsum  = ls_sflight-paymentsum .
*
*    COLLECT ls_sflight_collect INTO lt_sflight_collect.
*
*  ENDLOOP.
*
*  DELETE lt_sflight_collect WHERE carrid = 'AA'.
*
*  DELETE lt_sflight_collect INDEX 10.



  SELECT *
      FROM bkpf
      INTO TABLE @DATA(lt_bkpf)
      WHERE bldat BETWEEN '20230101' AND '20230201'.

  IF lt_bkpf IS NOT INITIAL.

    SELECT *
      FROM bseg
      INTO TABLE @DATA(lt_bseg)
      FOR ALL ENTRIES IN @lt_bkpf
      WHERE bukrs EQ @lt_bkpf-bukrs
        AND belnr EQ @lt_bkpf-belnr
        AND gjahr EQ @lt_bkpf-gjahr
        AND koart EQ 'K'.

  ENDIF.

  BREAK-POINT.

  LOOP AT lt_bkpf INTO DATA(ls_bkpf).
    DATA(lndx) = sy-tabix.

*    IF ls_bkpf-price EQ '1000'.
*      EXIT.
*
*    ENDIF.

  ENDLOOP.

  DATA(lv_bkpf_cnt) = lines( lt_bkpf ).

  DESCRIBE TABLE lt_bkpf LINES DATA(lv_bkpf_cnt2).


  DO 2 TIMES.




  ENDDO.

*let i = 0;
*while (i < 3) { // önce 0, sonra 1, sonra 2
*  alert( i );
*  i++;
*}

  DATA : lv_index TYPE i VALUE 0.

  WHILE lv_index < lv_bkpf_cnt.
    READ TABLE lt_bkpf INTO ls_bkpf INDEX lv_index + 1 .

    TRY.
        DATA(ls_bpkf) =  lt_bkpf[ bukrs = '1000' belnr = lt_bseg[ 5 ]-belnr ]  .
      CATCH cx_sy_itab_line_not_found.
    ENDTRY.

    lv_index += 1.
  ENDWHILE.


DATA : lv_str1 TYPE char10 VALUE 'Abc',
       lv_str2 TYPE char10 VALUE 'deF'.

*CONCATENATE lv_str1 lv_str2 INTO DATA(lv_str3)
*  SEPARATED BY space.

DATA(lv_str3)  = |{ lv_str1 }{ lv_str2  }|.

*  DELETE lt_bkpf WHERE matnr NOT IN s_matnr.


*  LOOP AT lt_bkpf INTO DATA(ls_bkpf) GROUP BY


ENDFORM.

FORM join.
*
*  DATA : lr_carrid  TYPE RANGE OF sflight-carrid,
*         lrs_carrid LIKE LINE OF lr_carrid.
*
*  TYPES : BEGIN OF ty_flight,
*    carrid    TYPE sflight-carrid   ,
*    connid    TYPE sflight-connid   ,
*    fldate    TYPE sflight-fldate   ,
*    planetype TYPE sflight-planetype,
*    seatsmax  TYPE sflight-seatsmax ,
*    cityfrom  TYPE spfli-cityfrom,
*    cityto    TYPE spfli-cityto ,
*    fltime    TYPE spfli-fltime  ,
*
*END  OF ty_flight.
*
**  lrs_carrid-sign = 'I' .
**  lrs_carrid-option = 'CP' .
**  lrs_carrid-low = 'A*'.
**  APPEND lrs_carrid TO lr_carrid.
**
**  lrs_carrid-sign = 'I' .
**  lrs_carrid-option = 'CP' .
**  lrs_carrid-low = '*A'.
**  APPEND lrs_carrid TO lr_carrid.
*
*  lr_carrid = VALUE #( ( sign = 'I' option = 'CP' low = 'A*' )
*                       ( sign = 'I' option = 'CP' low = '*A' )  ).
*
*  SELECT sf~carrid ,
*         sf~connid,
*         sf~fldate,
*         sf~planetype,
*         sf~seatsmax,
*         sp~cityfrom,
*         sp~cityto,
*         sp~fltime
*   FROM sflight AS sf
*   INNER JOIN spfli AS sp ON sp~carrid = sf~carrid AND
*                             sp~connid = sf~connid
*   INTO TABLE @DATA(lt_sflight2)
*    WHERE fldate IN s_fldate
*      AND sp~carrid IN lr_carrid.
*
*
*
*
*  lr_carrid = VALUE #( BASE lr_carrid ( sign = 'I' option = 'CP' low = 'B*' )
*                                      ( sign = 'I' option = 'CP' low = '*B' )  ).
*
*
*
*  lt_sflight2 = VALUE #( BASE lt_sflight2
*              ( carrid = 'AA' fldate = '20221010' cityfrom = 'IST' )
*              ( carrid = 'AA' fldate = '20221010' cityfrom = ' ank' ) ).
*
*
*  BREAK-POINT.

ENDFORM.



FORM left_join.

*  SELECT DISTINCT sp~planetype as ucak_tipi,
*                  sf~carrid as havayolu_sirketi,
*                  sf~fldate as ucus_tarihi
*      FROM saplane AS sp
*      LEFT OUTER JOIN sflight AS sf ON sp~planetype EQ sf~planetype
*      ORDER BY sp~planetype ASCENDING, sf~fldate DESCENDING
*  INTO TABLE @DATA(lt_plane).
**

*  SELECT mara~matnr, makt~maktx, makt~spras
*    FROM mara
*    LEFT OUTER JOIN makt ON makt~matnr EQ mara~matnr AND
*                            makt~spras EQ 'T'
*    INTO TABLE @DATA(lt_mara)
*    WHERE mara~matnr IN @s_matnr.
*      .
*
*
*
*  cl_demo_output=>display( lt_mara ).
ENDFORM.


FORM right_join.

  SELECT sp~planetype,
         sf~carrid
    FROM sflight AS sf
    RIGHT OUTER JOIN saplane AS sp ON sp~planetype EQ sf~planetype
    INTO TABLE @DATA(lt_plane).

  SORT lt_plane BY planetype.

  cl_demo_output=>display( lt_plane ).

ENDFORM.


FORM select_in_cond.

  DATA : lv_sayi TYPE i.

  SELECT sp~planetype,
         sp~seatsmax,
        sf~price,
        CASE WHEN sp~seatsmax GT 300 THEN 'Büyük Uçak'
              WHEN sp~seatsmax LE 300 AND sp~seatsmax GT 100 THEN 'Orta Uçak'
              WHEN sp~seatsmax LE 100 AND sp~seatsmax GT 15 THEN 'Küçük Uçak'
              ELSE 'Özel Uçak' END AS ucak_tipi,

         CASE WHEN sp~seatsmax GT 300 THEN sf~price * 2
              WHEN sp~seatsmax LE 300 AND sp~seatsmax GT 100  THEN sf~price * 5
              WHEN sp~seatsmax LE 100 AND sp~seatsmax GT 15 THEN sf~price * 10
              ELSE sf~price * 30 END AS ucak_fyati



      FROM saplane AS sp
      LEFT OUTER JOIN sflight AS sf ON sf~planetype = sp~planetype
      INTO TABLE @DATA(lt_plane)
      ORDER BY sp~planetype.



*
*  READ TABLE lt_plane INTO DATA(ls_plane)
*   WITH KEY seatsmax = '189' BINARY SEARCH.

*  WRITE : sy-subrc, '-', ls_plane-planetype.

  cl_demo_output=>display( lt_plane ).

ENDFORM.


FORM select_expressions.

  DELETE FROM demo_expressions.
  INSERT demo_expressions FROM TABLE @( VALUE #( (
      id = 'X'
      char1 = '01234'
      char2 = 'aAaA' ) ) ).

  SELECT SINGLE
      char1 AS text1,
      char2 AS text2,
      concat( char1,char2 ) AS concat,"01234aAaA
      concat_with_space( char1,char2, 2 )  AS concat_with_space,"01234  aAaA
      instr( char1, '3' ) AS instr,"4
      left( char1, 4 ) AS left, "0123
      length( char1 ) AS length,"5
      lower( char2 ) AS lower, "aaaa
      lpad( char1,10,'x' ) AS lpad, "xxxxx012344
      ltrim( char1,'0' ) AS ltrim, "1234
      replace( char1,'12','__' ) AS replace,"0__34
      right( char1,3 ) AS right,  "234
      rpad( char1,10,'a' ) AS rpad, "01234aaaaa
      rtrim( char1,'3' ) AS rtrim, "0124
      substring( char1,3,2 ) AS substring,"23
      upper( char2 ) AS upper "AAAA
  FROM demo_expressions
  INTO @DATA(result).

  cl_demo_output=>display( result ).


ENDFORM.


FORM group_by.

  SELECT  sp~planetype,
      AVG( sf~price  ) AS ucus_fiyati_usd
      FROM saplane AS sp
      INNER JOIN sflight AS sf ON sp~planetype EQ sf~planetype

      WHERE sf~currency EQ 'USD'

      GROUP BY sp~planetype
      HAVING COUNT( * ) GT 30
      ORDER BY sp~planetype
  INTO TABLE @DATA(lt_plane).


  cl_demo_output=>display( lt_plane ).

ENDFORM.


FORM inner_select.

  SELECT sp~planetype,
          sp~seatsmax,
         CASE WHEN sp~seatsmax GT 300 THEN 'Büyük Uçak'
              WHEN sp~seatsmax LE 300 AND sp~seatsmax GT 100 THEN 'Orta Uçak'
              WHEN sp~seatsmax LE 100 AND sp~seatsmax GT 15 THEN 'Küçük Uçak'
              ELSE 'Özel Uçak' END AS ucak_tipi
      FROM saplane AS sp
      INTO TABLE @DATA(lt_plane)

      WHERE sp~planetype IN ( SELECT planetype
                                FROM sflight
                                WHERE fldate BETWEEN '20230101' AND '20231231' )
      ORDER BY sp~planetype.


*  SELECT  sp~planetype,
*          sp~seatsmax,
*         CASE WHEN sp~seatsmax GT 300 THEN 'Büyük Uçak'
*              WHEN sp~seatsmax LE 300 AND sp~seatsmax GT 100 THEN 'Orta Uçak'
*              WHEN sp~seatsmax LE 100 AND sp~seatsmax GT 15 THEN 'Küçük Uçak'
*              ELSE 'Özel Uçak' END AS ucak_tipi,
*         sf~price
*        FROM saplane AS sp
*        INNER JOIN sflight AS sf ON sp~planetype EQ sf~planetype
*        WHERE sf~fldate BETWEEN '20230101' AND '20231231'
*        ORDER BY sp~planetype
*        INTO TABLE @DATA(lt_sflight2).

*    DATA : lt_sflight_ydk LIKE lt_sflight2.

*    DATA(lt_sflight_ydk) = lt_sflight2.
*
*    SORT lt_sflight_ydk BY planetype seatsmax ucak_tipi.
*    DELETE ADJACENT DUPLICATES FROM lt_sflight_ydk COMPARING planetype seatsmax ucak_tipi.



*  cl_demo_output=>display( lt_sflight2 ).

  cl_demo_output=>display( lt_plane ).

ENDFORM.


FORM db_islem.

  DATA : ls_test TYPE zegt_test01,
         lt_test TYPE TABLE OF zegt_test01.
*
  ls_test-carrid = 'AF'.
  ls_test-connid = '12345'.
  ls_test-cityfrom = 'BOLU'.
  ls_test-countryto = 'EN'.
*  ls_test-countryfr = ''
  APPEND ls_test TO lt_test.

  INSERT zegt_test01 FROM ls_test.
  IF sy-subrc EQ 0.

*    MESSAGE 'Başarılı' TYPE 'I'.
  ELSE.
*    MESSAGE 'Başarısız' TYPE 'I'.
  ENDIF.

  ls_test-carrid = 'AG'.
  ls_test-connid = '12345'.
  ls_test-cityfrom = 'ANKARA'.
  ls_test-countryto = 'TR'.
  ls_test-countryfr = 'EB'.
  APPEND ls_test TO lt_test.

  MODIFY zegt_test01 FROM ls_test.
  IF sy-subrc EQ 0.
*    MESSAGE 'Başarılı' TYPE 'I'.
  ELSE.
*    MESSAGE 'Başarısız' TYPE 'I'.
  ENDIF.


  UPDATE zegt_test01
    SET cityfrom = 'SAMSUN'
    WHERE carrid = 'AF'.
  IF sy-subrc EQ 0.
*    MESSAGE 'Başarılı' TYPE 'I'.
  ELSE.
*    MESSAGE 'Başarısız' TYPE 'I'.
  ENDIF.

  ROLLBACK WORK. " COMMIT WORK AND WAIT.


  ls_test-carrid = 'AF'.
  ls_test-connid = '12345'.
  ls_test-cityfrom = 'BOLU'.
  ls_test-countryto = 'EN'.
*  ls_test-countryfr = ''
  APPEND ls_test TO lt_test.

  INSERT zegt_test01 FROM ls_test.
  IF sy-subrc EQ 0.

*    MESSAGE 'Başarılı' TYPE 'I'.
  ELSE.
*    MESSAGE 'Başarısız' TYPE 'I'.
  ENDIF.

  ls_test-carrid = 'AH'.
  ls_test-connid = '12345'.
  ls_test-cityfrom = 'ANKARA'.
  ls_test-countryto = 'TR'.
  ls_test-countryfr = 'EB'.
  APPEND ls_test TO lt_test.

  MODIFY zegt_test01 FROM ls_test.
  IF sy-subrc EQ 0.
*    MESSAGE 'Başarılı' TYPE 'I'.
  ELSE.
*    MESSAGE 'Başarısız' TYPE 'I'.
  ENDIF.


  UPDATE zegt_test01
    SET cityfrom = 'SAMSUN'
    WHERE carrid = 'AF'.
  IF sy-subrc EQ 0.
*    MESSAGE 'Başarılı' TYPE 'I'.
  ELSE.
*    MESSAGE 'Başarısız' TYPE 'I'.
  ENDIF.

  COMMIT WORK AND WAIT.


*  ls_test-carrid = 'AE'.
*  ls_test-connid = '12345'.
*  ls_test-cityfrom = 'ANKARA'.
*  ls_test-countryto = 'TR'.
*  APPEND ls_test TO lt_test .
*
*
*  ls_test-carrid = 'AB'.
*  ls_test-connid = '12347'.
*  ls_test-cityfrom = 'BOLU'.
*  ls_test-countryto = 'TR'.
*  APPEND ls_test TO lt_test .
*
**  TRY.
**      INSERT zegt_test01 FROM TABLE lt_test.
**      IF sy-subrc EQ 0.
**        MESSAGE 'başarılı' TYPE 'I'.
**      ENDIF.
**    CATCH cx_sy_open_sql_db.
**      WRITE 'Başarısız'.
**  ENDTRY.
*
*
**  DELETE FROM zegt_test01 WHERE carrid LIKE 'A%'.
**  IF sy-subrc EQ 0.
**    MESSAGE 'başarılı' TYPE 'I'.
**  else.
**    MESSAGE 'başarısız' TYPE 'I'.
**
**  ENDIF.
*
*
*
**  UPDATE zegt_test01
**    SET cityfrom = 'ISTANBUL'
**        AIRPFROM = 'AT'
**    WHERE carrid = 'AD'.
**
**  IF sy-subrc EQ 0.
**    MESSAGE 'başarılı' TYPE 'I'.
**  else.
**    MESSAGE 'başarısız' TYPE 'I'.
**  ENDIF.
*
*
*  MODIFY zegt_test01 FROM TABLE lt_test.
*  IF sy-subrc EQ 0.
*    MESSAGE 'başarılı' TYPE 'I'.
*  else.
*    MESSAGE 'başarısız' TYPE 'I'.
*  ENDIF.
**
**  MODIFY zegt_test01 FROM ls_test.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form for_all_entries
*&---------------------------------------------------------------------*
FORM for_all_entries .

*  TYPES : BEGIN OF ty_malzeme,
*            matnr TYPE matnr,
*            maktx TYPE maktx,
*            mtart TYPE mtart,
*            meins TYPE meins,
*          END OF ty_malzeme.
*
*  DATA : lt_alv TYPE TABLE OF ty_malzeme.
*
*  SELECT *
*    FROM mara
*    INTO CORRESPONDING FIELDS OF TABLE @lt_alv
*    WHERE mara~matnr IN @s_matnr.
*
**  CHECK lt_alv IS NOT INITIAL.
*
*
**  SELECT *
**   FROM makt
**   FOR ALL ENTRIES IN @lt_alv
**   WHERE matnr EQ @lt_alv-matnr
**  INTO TABLE @DATA(lt_makt).
*
*  IF lt_alv IS INITIAL.
*
*    SELECT DISTINCT makt~*
*      FROM @lt_alv AS lsf
*      INNER JOIN makt ON lsf~matnr = makt~matnr AND
*                         makt~spras = @sy-langu
*      INTO TABLE @DATA(lt_makt).
*
*  ENDIF.
*
*
*
*  LOOP AT lt_alv ASSIGNING FIELD-SYMBOL(<lfs_alv>).
*
**    READ TABLE lt_makt INTO DATA(ls_makt)
**      WITH KEY matnr = <lfs_alv>-matnr .
**    IF sy-subrc EQ 0.
**      <lfs_alv>-maktx = ls_makt-maktx.
**    ENDIF.
*
*    TRY.
*        DATA(ls_makt) = lt_makt[ matnr = <lfs_alv>-matnr ].
*      CATCH cx_sy_itab_line_not_found.
*    ENDTRY.
*
*    <lfs_alv>-maktx = ls_makt-maktx.
*
*
**    DATA(ls_makt2) = VALUE #( lt_makt[ matnr = <lfs_alv>-matnr ] OPTIONAL ).
*
*
**    MODIFY lt_alv FROM ls_alv.
*
*    CLEAR : ls_makt.
*
*  ENDLOOP.
*
*  cl_demo_output=>display( lt_alv ).

ENDFORM.
*&---------------------------------------------------------------------*
*& Form db_islem2
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM db_islem2 .

*  Commit work.
*
*  ROLLBACK WORK.
*
ENDFORM.
*&---------------------------------------------------------------------*
*& Form dynamic_select
*&---------------------------------------------------------------------*
FORM dynamic_select .

  DATA : lv_tabname TYPE string VALUE 'MARA',
         lv_where   TYPE string.

  lv_where = 'matnr IN @s_matnr'.

  DATA :  lt_mara TYPE TABLE OF mara.



  SELECT *
    FROM (lv_tabname)
    WHERE (lv_where)
    INTO CORRESPONDING FIELDS OF TABLE @lt_mara.

  BREAK-POINT.
ENDFORM.
