import 'package:cloud_firestore/cloud_firestore.dart';

class ReportModel {
  String title;
  String report;
  String auther;
  DateTime time;
  GeoPoint location;
  String reportId;
  bool? volunteer;
  String? volunteerId;
  ReportModel({
    required this.title,
    required this.report,
    required this.auther,
    required this.time,
    required this.location,
    required this.reportId,
    this.volunteerId,
    this.volunteer
  });

  // 🔹 Convert Firestore document snapshot to ReportModel
  static ReportModel fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> snapshot) {
    Timestamp timestamp = snapshot.get('time') as Timestamp;

    return ReportModel(
      reportId: snapshot.get('reportId')as String,
      auther: snapshot.get('auther') as String,
      title: snapshot.get('title') as String,
      report: snapshot.get('report') as String,
      location: snapshot.get('location') as GeoPoint,
        volunteerId: snapshot.data()?.containsKey('volunteerId') == true
        ? snapshot.get('volunteerId') as String?
        : null,
    volunteer: snapshot.data()?.containsKey('volunteer') == true
        ? snapshot.get('volunteer') as bool?
        : null,
      time: timestamp.toDate(),
    );
  }

  // 🔹 Convert ReportModel to JSON for Firestore
  Map<String, dynamic> toJson() {
    return {
      "reportId": reportId,
      'auther': auther,
      'volunteer':volunteer,
      'title': title,
      'report': report,
      'time': time,
      'volunteerId': volunteerId,
      'location': location,
    };
  }
}

