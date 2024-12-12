import '../../global_string.dart';

class User {
  final String Name,
      Unique_ID,
      Phone,
      Cipher,
      Salt,
      Gender,
      Device_ID,
      Category,
      Section,
      Email,
      Fb_UID,
      indexed,
      Phase,
      Eligible,
      created_at,
      Updated_at;

  User(
      {required this.Name,
      required this.Unique_ID,
      required this.Phone,
      required this.Cipher,
      required this.Salt,
      required this.Gender,
      required this.Device_ID,
      required this.Category,
      required this.Section,
      required this.Email,
      required this.Fb_UID,
      required this.indexed,
      required this.Phase,
      required this.Eligible,
      required this.created_at,
      required this.Updated_at});

  factory User.fromData(Map<String, dynamic> data) {
    return User(
        Name: data[nmm],
        Unique_ID: data[unq],
        Phone: data[phn],
        Cipher: data[cph],
        Salt: data[slt],
        Gender: data[gnd],
        Device_ID: data[dvd],
        Category: data[ctg],
        Section: data["Section"],
        Email: data[eml],
        Fb_UID: data[fbd],
        indexed: data[ind],
        Phase: data["Phase"],
        Eligible: data[elg],
        created_at: data[crt],
        Updated_at: data[upd]);
  }

  // ignore: empty_constructor_bodies
  static Map<String, dynamic> toMap(User data) {
    return {
      nmm: data.Name,
      unq: data.Unique_ID,
      phn: data.Phone,
      cph: data.Cipher,
      slt: data.Salt,
      gnd: data.Gender,
      dvd: data.Device_ID,
      ctg: data.Category,
      sct: data.Section,
      eml: data.Email,
      fbd: data.Fb_UID,
      ind: data.indexed,
      phs: data.Phase,
      elg: data.Eligible,
      crt: data.created_at,
      upd: data.Updated_at
    };
  }
}


/*
class UserDomain {
  final String domain,
      name,
      bank,
      currency,
      playstore,
      contact,
      fb_sect,
      session,
      term;
  UserDomain(
      {required this.domain,
      required this.name,
      required this.bank,
      required this.currency,
      required this.playstore,
      required this.contact,
      required this.fb_sect,
      required this.session,
      required this.term});

  factory UserDomain.fromData(Map<String, dynamic> data) {
    return UserDomain(
        domain: data[dmn_],
        name: data[nm],
        bank: data[bnk],
        currency: data[crrTbl],
        playstore: data[pls],
        contact: data[ctc],
        fb_sect: data[fbs],
        session: data[ssn_],
        term: data[trm]);
  }
}

*/

/*
class UserProfile {
  final name, class_, wallet, email, gender, phone, access, balance;

  UserProfile({
    this.balance,
    this.name,
    this.class_,
    this.wallet,
    this.email,
    this.gender,
    this.phone,
    this.access,
  });

  factory UserProfile.fromData(Map<String, dynamic> data) {
    return UserProfile(
        balance: data['balance'],
        name: data[nmm],
        class_: data[cls],
        wallet: data[wltTbl],
        email: data[eml],
        gender: data[gnd],
        phone: data[phn],
        access: data[ass_tbl]);
  }
}
*/