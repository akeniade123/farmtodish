//

import '../global_string.dart';

List<String> usrCln = [
  nmm_,
  unq,
  phn_,
  cph,
  slt,
  //prfPx,
  gnd,
  dvc,
  ctg_,
  sct,
  eml,
  fb_uid,
  indx,
  phs,
  elg,
  crt_,
  upd
];

List<String> wltCln = [id, usrId, amt, lstTrnz];
List<String> cptCln = [cpt];

// List<String> mnfCln = [id,];

/*

            // "essence": "order",
            // "products": "tomato*2kg*2000@4000#pepper*3kg*2000@6000",
            // "order_id": "234090",
            // "user":"211678",
            // "total":"10,000"
            */

List<String> vndCln = [id, hub, opr, latlong, ctt];
List<String> untzCln = [id, nmm, sct.toLowerCase()];
List<String> untCln = [id, tag, abbrv];
List<String> defaultCln = [id, nmm];
List<String> defaultCln_ = [id, tag];
List<String> prtypCln = [id, typ, img];
List<String> prdCln = [id, itm, typ, crt, img];
List<String> prcIdxCln = [id, cdr, produce, unit, amt, crr, avl, qnt];
List<String> ordItmCln = [id, itm, qnt, rate, amt, crr, order];
List<String> ordCln = [id, usr, prDtl, dlvAr, stt];
List<String> lgaCln = [id, stId, nmm];
List<String> hubCln = [id, nmm, latlong, lga, ctt];
List<String> dptCln = [id, core];
List<String> schCln = [id, div, tsk, dtme, dur];


/*
static void raiseCalendarTapCallback(
      SfCalendar calendar,
      DateTime? date,
      List<dynamic>? appointments,
      CalendarElement element,
      CalendarResource? resource) {
    if (appointments != null && appointments.isNotEmpty) {
      for (final dynamic appointment in appointments) {
        String? notes = appointment.notes;
        if (notes != null && notes.isNotEmpty) {
          notes = notes.replaceAll('isOccurrenceAppointment', '');
          appointment.notes = notes;
        }
      }
    }
    calendar.onTap!(CalendarTapDetails(appointments, date, element, resource));
  }
*/