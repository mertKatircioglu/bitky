class RoomSDataModel {
  String? roomId;
  String? createDate;
  String? roomName;

  RoomSDataModel(
      {this.roomId,
        this.createDate,
        this.roomName,
});

  RoomSDataModel.fromJson(Map<String, dynamic> json) {
    roomId = json['roomId'];
    createDate = json['createDate'];
    roomName = json['roomName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data =  <String, dynamic>{};
    data['roomId'] = roomId;
    data['createDate'] = createDate;
    data['roomName'] = roomName;

    return data;
  }
}