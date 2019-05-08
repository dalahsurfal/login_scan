import 'package:firebase_database/firebase_database.dart';

class WorkedHours{
  String _title;
  String _description;

  WorkedHours(this._title, this._description);

  WorkedHours.map(dynamic obj){
    this._title = obj['title'];
    this._description = obj['description'];
  }

  String get title => _title;
  String get description => _description;

  WorkedHours.fromSnapshot(DataSnapshot snapshot){
    _title = snapshot.value['title'];
    _description = snapshot.value['description'];
  }
}