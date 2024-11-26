import 'dart:convert';

import 'package:supabase_flutter/supabase_flutter.dart';

extension MapSession on Map<String, Object?>? {
  Session? toSession()=>Session.fromJson(this??{});
}

extension SessionStringify on Session {
  ///Converts the session to a json string
  ///that can be stored in a secure storage
  ///and readable by the Supabase client
  String stringify() {
    return jsonEncode(this.toJson());
  }
}

extension StringSession on String? {
  Session? toSession()=>Session.fromJson(jsonDecode(this??'{}'));
}