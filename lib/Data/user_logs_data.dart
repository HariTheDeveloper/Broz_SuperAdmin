class UsersLogs {
  final int userId;
  final String userName;
  final String createdDate;
  final String deviceModel;
  final int deviceStatus;
  final String userPhone;
  final String deviceVolume;
  final String deviceBattery;

  UsersLogs(
      {this.userId,
      this.userName,
      this.createdDate,
      this.deviceStatus,
      this.deviceModel,
      this.userPhone,
      this.deviceVolume,
      this.deviceBattery});

  factory UsersLogs.fromJson(Map<String, dynamic> jsonData) {
    return UsersLogs(
        userId: jsonData['userId'],
        userName: jsonData['userName'],
        createdDate: jsonData['createdDate'].toString(),
        deviceStatus: jsonData['deviceStatus'],
        deviceModel: jsonData['deviceModel'],
        userPhone: jsonData['userPhone'],
        deviceVolume: jsonData['deviceVolume'].toString(),
        deviceBattery: jsonData['deviceBattery'].toString());
  }
}
