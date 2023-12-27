*&---------------------------------------------------------------------*
*& Include          ZAB_EDU_0034_FRM
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*& Form internal_table
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM internal_table .

*  TYPES : BEGIN OF lty_line,
*            material TYPE matnr,
*            mat_des  TYPE maktx,
*            mat_typ  TYPE mtart,
*            mat_unit TYPE meins,
*          END OF lty_line.
*
*  DATA : ls_material TYPE lty_line,
*         lt_material TYPE TABLE OF lty_line.

*DATA : gt_scarr TYPE TABLE Of scarr,
*       gs_scarr TYPE scarr.

  SELECT * FROM scarr INTO TABLE @DATA(lt_scarr).

  BREAK-POINT.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form appending_table
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM appending_table .

  "mevcut verisi olan bir internal tablenin üzerine veri ekler.
  " var olan veriyi değiştirmez tablonun sonuna ekler.

  SELECT * FROM sflight INTO TABLE @DATA(lt_flight)
    WHERE carrid EQ 'AA'.

  SELECT * FROM sflight APPENDING TABLE lt_flight
    WHERE carrid EQ 'JL'.

  BREAK-POINT.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form where_condition
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM where_condition .

*  DATA : lr_carrid TYPE RANGE OF sflight-carrid.
*  lr_cityto = so_citto[].
*
*  lr_carrid = VALUE #( ( sign = 'I' option = 'CP' low = 'A*')
*                       ( sign = 'I' option = 'CP' low = '*L')
*                       ( sign = 'E' option = 'CP' low = '*Z*')
*                        ).

*  SELECT * FROM spfli INTO TABLE @DATA(lt_spfli)
*    WHERE cityfrom in ('TOKYO', 'NEW YORK').

*  SELECT * FROM spfli INTO TABLE @DATA(lt_spfli)
*    WHERE cityfrom LIKE '%N'.

*  SELECT * FROM sflight INTO TABLE @DATA(lt_carrid)
*    WHERE carrid IN @lr_carrid.

  SELECT * FROM sflight INTO TABLE @DATA(lt_sflight)
    WHERE fldate IN @so_fldat.

  BREAK-POINT.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form inner_join
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM inner_join .

  DATA : lr_carrid  TYPE RANGE OF sflight-carrid,
         lrs_carrid LIKE LINE OF lr_carrid.

  "  ---------Eski Syntax-----------------
*  lrs_carrid-sign = 'I'.
*  lrs_carrid-low = '*A'.
*  lrs_carrid-option = 'CP'.
*  APPEND lrs_carrid TO lr_carrid.
  "  --------------------------------------

  "  ---------Yeni Syntax-----------------
  lr_carrid = VALUE #( ( sign = 'I' low = '*A' option = 'CP' )
                       ( sign = 'E' low = 'U*' option = 'CP' ) ).
  "  --------------------------------------


  SELECT sf~carrid,
         sf~connid,
         sf~fldate,
         sp~cityfrom,
         sp~cityto FROM sflight AS sf
    JOIN spfli AS sp ON sp~carrid EQ sf~carrid
                    AND sp~connid EQ sf~connid
    INTO TABLE @DATA(lt_sflight)
    WHERE sf~carrid IN @lr_carrid.

  BREAK-POINT.

  "--------üstüne eklemeye devam edecek. herhangi bir tablo tipi için kullanılabilir--------------
  lr_carrid = VALUE #( BASE lr_carrid ( sign = 'I' low = '*A' option = 'CP' ) ).
  "-----------------------------------------------------------------------------------------------


ENDFORM.
*&---------------------------------------------------------------------*
*& Form left_join
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM left_join .

  "--------------------------->        <--------------------------------
  " distinct = tekrarlı satırlardan kurtarır.
  "----------------------------------------------------------------------

  SELECT DISTINCT
         sp~planetype AS ucak_tipi,
         sf~carrid AS havayolu_sirketi,
         sf~fldate AS ucus_tarihi
    FROM saplane AS sp
    LEFT JOIN sflight AS sf ON sf~planetype EQ sp~planetype
    WHERE carrid IS NOT INITIAL
    ORDER BY sp~planetype ASCENDING, fldate DESCENDING
    INTO TABLE @DATA(lt_plane).

*  SORT lt_plane BY fldate.

  "--------------------------->        <--------------------------------
  " orderby ile sort aynı işlevi görüyor.
  "----------------------------------------------------------------------

  "--------------------------->        <--------------------------------
  " as= tabloya başlık ekliyor.
  "----------------------------------------------------------------------

  cl_demo_output=>display( lt_plane ).

  "--------------------------->        <---------------------------------
  "  carrid uçuş bilgilerini tutuyor. carrid boşsa uçak uçuş yapmamıştır.
  "----------------------------------------------------------------------

ENDFORM.
*&---------------------------------------------------------------------*
*& Form select_in_condition
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM select_in_condition .

  SELECT sp~planetype,
         sp~seatsmax,
         sf~price,

    CASE WHEN sp~seatsmax GT 300 THEN 'Büyük Uçak'
         WHEN sp~seatsmax LE 300 AND sp~seatsmax GT 250 THEN 'Orta Uçak'
         WHEN sp~seatsmax LE 250 AND sp~seatsmax GT 100 THEN 'Küçük Uçak'
    ELSE 'Özel Uçak' END AS ucak_tipi,

    CASE WHEN sp~seatsmax GT 300 THEN sf~price * 5
         WHEN sp~seatsmax LE 300 AND sp~seatsmax GT 250 THEN sf~price * 4
         WHEN sp~seatsmax LE 250 AND sp~seatsmax GT 100 THEN sf~price * 3
    ELSE sf~price * 10 END AS ucak_fiyati

  FROM sflight AS sf
    JOIN saplane AS sp ON sp~planetype EQ sf~planetype
    INTO TABLE @DATA(lt_plane)
    ORDER BY sp~planetype.

  cl_demo_output=>display( lt_plane ).

ENDFORM.
*&---------------------------------------------------------------------*
*& Form select_expressions
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM select_expressions .

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
      instr( char1, '3' ) AS instr,"4         3'ün indexini veriyor.
      left( char1, 4 ) AS left, "0123       soldan 4 karakter yazacak.
      length( char1 ) AS length,"5
      lower( char2 ) AS lower, "aaaa
      lpad( char1,10,'x' ) AS lpad, "xxxxx012344
      ltrim( char1,'0' ) AS ltrim, "1234              dizinin başındaki boşlukları siliyor.
      replace( char1,'12','__' ) AS replace,"0__34    12 yerine __ getirecek.
      right( char1,3 ) AS right,  "234                sağdan 3 karakter
      rpad( char1,10,'a' ) AS rpad, "01234aaaaa
      rtrim( char1,'3' ) AS rtrim, "01234              dizinin sonundaki boşlukları siliyor.
      substring( char1,3,2 ) AS substring,"23         3. karakterden itibaren 2 karakter yaz.
      upper( char2 ) AS upper "AAAA
  FROM demo_expressions
  INTO @DATA(result).

  cl_demo_output=>display( result ).

ENDFORM.
*&---------------------------------------------------------------------*
*& Form left_join1
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM left_join1 .

  SELECT mara~matnr,
         makt~maktx,
         makt~spras
    FROM mara
    LEFT JOIN makt ON makt~matnr EQ mara~matnr
                  AND makt~spras EQ 'T' "-----> ilk tabloda olanları spras'ı boş olsada getirir.
    INTO TABLE @DATA(lt_mara)
    WHERE mara~matnr IN @so_matnr.
  "    AND makt~spras eq 'T'.       "----->  içinde T olmayanları filtreleyeceği için left joinde anlamsız.

*  BREAK-POINT.
  cl_demo_output=>display( lt_mara ).

ENDFORM.
*&---------------------------------------------------------------------*
*& Form group_by
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM group_by .

  "--------------------------->        <--------------------------------
  "   Uçak tipleri ve yaptıkları son uçuş tarihi
  "----------------------------------------------------------------------

*  SELECT sp~planetype, max( sf~fldate ) as fldate " min de alınabilir.
*    FROM saplane as sp
*    LEFT OUTER JOIN sflight as sf ON sf~planetype eq sp~planetype
*    GROUP BY sp~planetype
*    HAVING MAX( sf~fldate ) gt '20230101' "having verdiğimizde left in anlamı kalmaz inner gibi davranır.
*    ORDER BY sp~planetype
*    INTO TABLE @DATA(lt_plane).

*  SELECT sp~planetype, COUNT( * ) AS ucus_sayısı
*    FROM saplane AS sp
*    LEFT OUTER JOIN sflight AS sf ON sf~planetype EQ sp~planetype
*    GROUP BY sp~planetype
*    HAVING COUNT( * ) GT '15' "having verdiğimizde left in anlamı kalmaz inner gibi davranır.
*    ORDER BY sp~planetype
*    INTO TABLE @DATA(lt_plane).

  SELECT sp~planetype,
    SUM( CASE WHEN sf~currency EQ 'USD' THEN sf~price END ) AS ucus_fiyati_usd,
    SUM( CASE WHEN sf~currency EQ 'EUR' THEN sf~price END ) AS ucus_fiyati_eur,
    SUM( CASE WHEN sf~currency EQ 'JPL' THEN sf~price END ) AS ucus_fiyati_jpl
    FROM saplane AS sp
    INNER JOIN sflight AS sf ON sf~planetype EQ sp~planetype
    GROUP BY sp~planetype
    HAVING COUNT( * ) GT '15' "having verdiğimizde left in anlamı kalmaz inner gibi davranır.
    ORDER BY sp~planetype
    INTO TABLE @DATA(lt_plane).

  "--------------------------->        <--------------------------------
  "   sum yerine avg kullanıp ortalama hesaplanabilir.
  "----------------------------------------------------------------------

  cl_demo_output=>display( lt_plane ).

ENDFORM.
*&---------------------------------------------------------------------*
*& Form duplicates
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM duplicates .

  SELECT sp~planetype,
         sp~seatsmax,
    CASE WHEN sp~seatsmax GT 300 THEN 'Büyük Uçak'
         WHEN sp~seatsmax LE 300 AND sp~seatsmax GT 250 THEN 'Orta Uçak'
         WHEN sp~seatsmax LE 250 AND sp~seatsmax GT 100 THEN 'Küçük Uçak'
    ELSE 'Özel Uçak' END AS ucak_tipi,
    sf~price
    FROM saplane AS sp
    INNER JOIN sflight AS sf ON sp~planetype EQ sf~planetype
    WHERE sf~fldate BETWEEN '20230101' AND '20231231'
    ORDER BY sp~planetype
    INTO TABLE @DATA(lt_sflight).

  DATA(lt_sflight_ydk) = lt_sflight.
  SORT lt_sflight_ydk BY planetype seatsmax ucak_tipi.
  DELETE ADJACENT DUPLICATES FROM lt_sflight_ydk COMPARING planetype seatsmax ucak_tipi.

  cl_demo_output=>display( lt_sflight_ydk ).

ENDFORM.
*&---------------------------------------------------------------------*
*& Form for_all_entries
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM for_all_entries .

  TYPES : BEGIN OF lty_material,
            matnr TYPE matnr,
            maktx TYPE maktx,
            mtart TYPE mtart,
            meins TYPE meins,
          END OF lty_material.

  DATA : lt_alv TYPE TABLE OF lty_material,
         ls_alv TYPE lty_material.

  SELECT *
    FROM mara
    INTO CORRESPONDING FIELDS OF TABLE @lt_alv
    WHERE matnr IN @so_matnr.

  SELECT * FROM makt
    FOR ALL ENTRIES IN @lt_alv
    WHERE matnr EQ @lt_alv-matnr
                AND spras EQ 'T'
    INTO TABLE @DATA(lt_makt).

  LOOP AT lt_alv ASSIGNING FIELD-SYMBOL(<lfs_alv>).

    READ TABLE lt_makt INTO DATA(ls_makt) WITH KEY matnr = <lfs_alv>-matnr.
    IF sy-subrc EQ 0.
      <lfs_alv>-maktx = ls_makt-maktx.
    ENDIF.

    "--------------------------->New Syntax <--------------------------------
*      TRY.
*        DATA(ls_makt) = lt_makt[ matnr = <lfs_alv>-matnr ].
*      CATCH cx_sy_itab_line_not_found.
*
*      ENDTRY.
    "------------------------------------------------------------------------

  ENDLOOP.

  cl_demo_output=>display( lt_alv ).

ENDFORM.
*&---------------------------------------------------------------------*
*& Form db_islem
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM db_islem .

  DATA : lt_test TYPE TABLE OF zegt_test01,
         ls_test TYPE zegt_test01.

  ls_test-carrid = 'AL'.
  ls_test-connid = '345'.
  ls_test-cityfrom = 'KOCAELİ'.
  ls_test-countryfr = 'TR'.
  ls_test-countryto = 'FR'.
  INSERT zegt_test01 FROM ls_test.
  "  INSERT zegt_test01 FROM TABLE lt_test.

*  DELETE FROM zegt_test01 WHERE carrid in ( select carrid FROM sflight
*                                            WHERE fldate BETWEEN '20230101' AND '202301201' ).

*  UPDATE zegt_test01
*  SET cityfrom = 'ISTANBUL'
*      airpfrom = 'KO'
*      WHERE carrid = 'AL'.

*  MODIFY zegt_test01 FROM lt_test.
*  MODIFY zegt_test01 FROM ls_test.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form dynamic_select
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM dynamic_select .

  DATA : lv_tabname TYPE string VALUE 'MARA',
         lv_where   TYPE string.

  lv_where = 'matnr in @so_matnr'.

  DATA : lt_mara TYPE TABLE OF mara.

  SELECT * FROM (lv_tabname)
    WHERE (lv_where)
    INTO CORRESPONDING FIELDS OF TABLE @lt_mara.

  cl_demo_output=>display( lt_mara ).

ENDFORM.
*&---------------------------------------------------------------------*
*& Form internal_table1
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM internal_table1 .

  TYPES tt_sflight TYPE STANDARD TABLE OF sflight WITH DEFAULT KEY.

  TYPES tt_sorted TYPE SORTED TABLE OF sflight WITH NON-UNIQUE KEY carrid connid planetype.

  TYPES tt_hashed TYPE HASHED TABLE OF sflight WITH UNIQUE DEFAULT KEY.

  DATA : lt_sorted  TYPE tt_sorted,
         lt_hashed  TYPE tt_hashed,
         lt_sflight TYPE tt_sflight,
         ls_sflight LIKE LINE OF lt_sflight.

  SELECT * FROM sflight
    INTO TABLE @lt_sorted.

  SELECT * FROM sflight
    INTO TABLE @DATA(lt_sorted1).

  INSERT LINES OF lt_sorted INTO TABLE lt_sorted1.

  "--------------------------->        <--------------------------------
  " sorted table da append deil insert ile ekliyoruz.
  "----------------------------------------------------------------------

  cl_demo_output=>display( lt_sorted1 ).

ENDFORM.
*&---------------------------------------------------------------------*
*& Form modify_sorted
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM modify_sorted .

  TYPES tt_sflight TYPE STANDARD TABLE OF sflight WITH DEFAULT KEY.

  TYPES tt_sorted TYPE SORTED TABLE OF sflight WITH NON-UNIQUE KEY carrid connid planetype.

  DATA : lt_sorted  TYPE tt_sorted,
         lt_sflight TYPE tt_sflight,
         ls_sflight LIKE LINE OF lt_sflight.

  SELECT * FROM sflight INTO TABLE lt_sflight.
  SELECT * UP TO 1 ROWS FROM sflight INTO TABLE lt_sorted.

  SORT lt_sflight by carrid connid.

  LOOP AT lt_sflight INTO ls_sflight.
    ls_sflight-currency = 'TRY'.

    READ TABLE lt_sorted TRANSPORTING NO FIELDS
    WITH KEY carrid = ls_sflight-carrid
             connid = ls_sflight-connid
             fldate = ls_sflight-fldate.
    IF sy-subrc eq 0.
      MODIFY lt_sorted FROM ls_sflight INDEX sy-tabix.
    ENDIF.

  ENDLOOP.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form do_times
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM do_times .

  SELECT * FROM bkpf INTO TABLE @DATA(lt_bkpf).

  DATA(lv_bkpf_cnt) = lines( lt_bkpf ).

  DESCRIBE TABLE lt_bkpf LINES DATA(lv_bkpf_cnt2).

ENDFORM.
