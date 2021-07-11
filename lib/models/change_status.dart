class ChangeStatusModal {
  String data;
  bool success;

  ChangeStatusModal({this.data, this.success});

  ChangeStatusModal.fromJson(Map<String, dynamic> json) {
    data = json['data'];
    success = json['success'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['data'] = this.data;
    data['success'] = this.success;
    return data;
  }
}
