class ServerResponse {
  final bool status;
  final List data;
  final Object msg;

  ServerResponse({required this.status, required this.data, required this.msg});

  factory ServerResponse.fromJson(Map<String, dynamic> json) {
    return ServerResponse(
        status: json["status"], data: json["data"], msg: json["message"]);
  }
}

class CustomResponse {
  final bool status;
  final Map<String, dynamic> data;
  final Object msg;

  CustomResponse({required this.status, required this.data, required this.msg});

  factory CustomResponse.fromJson(Map<String, dynamic> json) {
    return CustomResponse(
        status: json["status"], data: json["data"], msg: json["message"]);
  }
}

class ServerPrelim {
  final bool status;
  final Object msg;

  ServerPrelim({
    required this.status,
    required this.msg,
  });

  factory ServerPrelim.fromJson(Map<String, dynamic> json) {
    return ServerPrelim(status: json["status"], msg: json["message"]);
  }
}

class CBTData {
  final int qstno;
  final String qstn, optna, optnb, optnc, optnd, optne, ans, ansmt;

  CBTData(
      {required this.qstno,
      required this.qstn,
      required this.optna,
      required this.optnb,
      required this.optnc,
      required this.optnd,
      required this.optne,
      required this.ans,
      required this.ansmt});

  factory CBTData.fromJson(Map<String, dynamic> json) {
    return CBTData(
        qstno: json["question_no"],
        qstn: json["question"],
        optna: json["option_a"],
        optnb: json["option_b"],
        optnc: json["option_c"],
        optnd: json['option_d'],
        optne: json['option_e'],
        ans: json['answer'],
        ansmt: json['answer_meta']);
  }
}

class ContentData {
  final int qstno;

  final String qstn, ans, ansmt;
  final Map<String, String> optns;

  ContentData({
    required this.qstno,
    required this.qstn,
    required this.optns,
    required this.ans,
    required this.ansmt,
  });

  factory ContentData.fromJson(Map<String, dynamic> json) {
    Map<String, String> vrfo = {};
    json.forEach((key, value) {
      if (key.contains("option") && value.isNotEmpty) {
        vrfo.addEntries({key: value.toString()}.entries);
      }
    });

    return ContentData(
        qstno: json["question_no"],
        qstn: json["question"],
        optns: vrfo,
        ans: json['answer'],
        ansmt: json['answer_meta']);
  }
}
