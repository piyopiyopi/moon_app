class MoonList {
  Null message;
  late List<Results> results;
  late int status;

  MoonList({this.message, required this.results, required this.status});

  MoonList.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    if (json['results'] != null) {
      results = <Results>[];
      json['results'].forEach((v) {
        results.add(new Results.fromJson(v));
      });
    }
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = this.message;
    data['results'] = this.results.map((v) => v.toJson()).toList();
    data['status'] = this.status;
    return data;
  }
}

class Results {
  String? date;
  int? status;

  Results(
    {
      required this.date,
      required this.status,
    }
  );

  Results.fromJson(Map<String, dynamic> json) {
    date = json['date'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['date'] = this.date;
    data['status'] = this.status;
    return data;
  }
}