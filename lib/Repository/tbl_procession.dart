import 'package:farm_to_dish/global_objects.dart';

import '../global_string.dart';
import 'tbl_stack.dart';

Map<String, String> explicit() {
  Map<String, String> exp = {};
  return exp;
}

Map<String, List<String>> procession() {
  Map<String, List<String>> prc = {};
  prc.addEntries({ctg: defaultCln}.entries);
  prc.addEntries({dept: dptCln}.entries);
  prc.addEntries({hub: hubCln}.entries);
  prc.addEntries({lga: lgaCln}.entries);
  prc.addEntries({order: ordCln}.entries);
  prc.addEntries({orderItem: ordItmCln}.entries);
  prc.addEntries({orderType: defaultCln_}.entries);
  prc.addEntries({priceIndex: prcIdxCln}.entries);
  prc.addEntries({produce: prdCln}.entries);
  prc.addEntries({ptyp: prtypCln}.entries);
  prc.addEntries({sct: defaultCln}.entries);
  prc.addEntries({states: defaultCln}.entries);
  prc.addEntries({unit: untCln}.entries);
  prc.addEntries({untz: untzCln}.entries);
  prc.addEntries({users: usrCln}.entries);
  prc.addEntries({vendor: vndCln}.entries);
  prc.addEntries({sch: schCln}.entries);
  prc.addEntries({usrWlt: wltCln}.entries);
  return prc;
}
