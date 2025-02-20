import 'package:cloud_firestore/cloud_firestore.dart';

class ReportModel {
  String title;
  String report;
  String auther;
  DateTime time;
  GeoPoint location;

  ReportModel({
    required this.title,
    required this.report,
    required this.auther,
    required this.time,
    required this.location,
  });

  // 🔹 Convert Firestore document snapshot to ReportModel
  static ReportModel fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> snapshot) {
    Timestamp timestamp = snapshot.get('time') as Timestamp;

    return ReportModel(
      auther: snapshot.get('auther') as String,
      title: snapshot.get('title') as String,
      report: snapshot.get('report') as String,
      location: snapshot.get('location') as GeoPoint,
      time: timestamp.toDate(),
    );
  }

  // 🔹 Convert ReportModel to JSON for Firestore
  Map<String, dynamic> toJson() {
    return {
      'auther': auther,
      'title': title,
      'report': report,
      'time': time,
      'location': location,
    };
  }
}

