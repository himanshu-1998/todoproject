import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';


import 'model/todo.dart';

class Utils {


  static DateTime? toDateTime(Timestamp value) {
    if (value == null) return null;

    return value.toDate();
  }

  static dynamic fromDateTimeToJson(DateTime date) {
    if (date == null) return null;

    return date.toUtc();
  }
  static StreamTransformer<QuerySnapshot<Map<String, dynamic>>, List<Todo>> transformer<T>(
      Todo fromJson(Map<String, dynamic> json),
      ) {
    return StreamTransformer<QuerySnapshot<Map<String, dynamic>>, List<Todo>>.fromHandlers(
      handleData: (QuerySnapshot<Map<String, dynamic>> data, EventSink<List<Todo>> sink) {
        final todos = data.docs.map((doc) => fromJson(doc.data())).toList();
        sink.add(todos);
      },
    );
  }

}
