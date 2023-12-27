*&---------------------------------------------------------------------*
*& Report ZAB_EDU_0023
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ZAB_EDU_0023.

data:   lwa_objpack type sopcklsti1,        "Contents of the Email
          li_objpack type standard table of sopcklsti1,
          lwa_reclist type somlreci1,         "Recievers List
          li_reclist type standard table of somlreci1,
          lwa_doc_chng type sodocchgi1,        "Mail Contents
          lv_line  like sy-tabix,     "Email Params
          objtxt  like solisti1   occurs 10 with header line.


  constants : lc_space type c value ' ',
              lc_1(15) type n value '1',         "Email Params
              lc_raw(3) type c value 'RAW',       "Email Params
              lc_u type c value 'U',              "Recipient Property
              lc_01 type c value '1',
              lc_x type c value 'X'.

*clear: p_subject, p_msg, p_mail.

*  Filling Mail Contents
  lwa_doc_chng-obj_name = 'E-Mail'.
  lwa_doc_chng-obj_descr = 'Your Appointment has been booked'.

  objtxt = 'Hello ABC ,'.
  append objtxt.

   objtxt = 'BOOKING ID: AND171008330BAN'.
  append objtxt.

  objtxt = 'Your appointment is being booked with Dr.Andrew at Memorial Hospital 17-10-2008 at 3:30PM. Please produce this booking ID at the time of consultation'.
  append objtxt.

  objtxt = '     '.
  append objtxt.

  objtxt = 'Thanks and Regards'.
  append objtxt.

  objtxt = 'Appointment booking team'.
  append objtxt.

  describe table objtxt lines lv_line.

   read table objtxt index lv_line transporting no fields.
  lwa_doc_chng-doc_size = ( lv_line - 1 ) * 255 + strlen( objtxt ).


*  Pack to main body
  lwa_objpack-body_start =  lc_1.
  lwa_objpack-head_start = lc_1.
  lwa_objpack-head_num   = '0'.
  lwa_objpack-body_num   =  lv_line.
  lwa_objpack-doc_type   =  lc_raw.
  append lwa_objpack to li_objpack.



*  translate p_mail to lower case.


*  Fill receiver list
  lwa_reclist-receiver     =  'abca@xyz.com'. "Email id
  lwa_reclist-rec_type     =  lc_u.
  append lwa_reclist to li_reclist.

call function 'SO_DOCUMENT_SEND_API1'
  exporting
    document_data                    = lwa_doc_chng
   put_in_outbox                    = lc_x
   commit_work                      = lc_x
  tables
    packing_list                     = li_objpack
   contents_txt                     = objtxt
    receivers                        = li_reclist
 exceptions
   too_many_receivers               = 1
   document_not_sent                = 2
   document_type_not_exist          = 3
   operation_no_authorization       = 4
   parameter_error                  = 5
   x_error                          = 6
   enqueue_error                    = 7
   others                           = 8
          .
if sy-subrc <> 0.
 message id sy-msgid type sy-msgty number sy-msgno
         with sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
endif.

if sy-subrc = 0.
    call function 'BAPI_TRANSACTION_COMMIT'.
  endif.
