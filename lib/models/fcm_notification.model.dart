class FCMNotification {
  Aps aps;

  FCMNotification({this.aps});

  FCMNotification.fromJson(Map<String, dynamic> json) {
    aps = json['aps'] != null ? new Aps.fromJson(json['aps']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.aps != null) {
      data['aps'] = this.aps.toJson();
    }
    return data;
  }
}

class Aps {
  Alert alert;

  Aps({this.alert});

  Aps.fromJson(Map<String, dynamic> json) {
    alert = json['alert'] != null ? new Alert.fromJson(json['alert']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.alert != null) {
      data['alert'] = this.alert.toJson();
    }
    return data;
  }
}

class Alert {
  String title;
  String body;

  Alert({this.title, this.body});

  Alert.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    body = json['body'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['title'] = this.title;
    data['body'] = this.body;
    return data;
  }
}
