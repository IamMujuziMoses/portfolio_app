/*
* Created by Mujuzi Moses
*/

class Event{
  String title;
  String doctorsName;
  String name;
  String hospital;
  String type;
  String chatRoomId;
  String status;
  DateTime startTime;
  String time;
  bool isAllDay;
  List<String> users;

  Event({
    this.doctorsName, this.name, this.hospital, this.type, this.title, this.status,
    this.startTime, this.isAllDay, this.users, this.chatRoomId, this.time,
  });

  Map<String, dynamic> toMap(Event event) {
    Map<String, dynamic> eventsMap = Map();
    eventsMap["title"] = event.title;
    eventsMap["doctors_name"] = event.doctorsName;
    eventsMap["name"] = event.name;
    eventsMap["hospital"] = event.hospital;
    eventsMap["type"] = event.type;
    eventsMap["status"] = event.status;
    eventsMap["start_time"] = event.startTime;
    eventsMap["is_all_day"] = event.isAllDay;
    eventsMap["users"] = event.users;
    eventsMap["chatroomId"] = event.chatRoomId;
    eventsMap["time"] = event.time;

    return eventsMap;
  }

  Event.fromMap(Map eventsMap) {
    this.title = eventsMap["title"];
    this.doctorsName = eventsMap["doctors_name"];
    this.name = eventsMap["name"];
    this.hospital = eventsMap["hospital"];
    this.type = eventsMap["type"];
    this.status = eventsMap["status"];
    this.startTime= eventsMap["start_time"];
    this.isAllDay = eventsMap["is_all_day"];
    this.users = eventsMap["users"];
    this.chatRoomId = eventsMap["chatroomId"];
    this.time = eventsMap["time"];
  }

}