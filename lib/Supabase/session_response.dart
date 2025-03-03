import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:supabase_structure/Supabase/supabase_extensions.dart';
import '../supabase_helper.dart';
import 'supabase_response.dart';

class SessionResponse extends SupabaseResponse {
  late final Session? session;
  SessionResponse(
    SupabaseResponse response,
  ) : super(message: response.message, data: response.data) {
    if (response.isSuccess) {
      final map = response.data as Map<String, Object?>?;
      session = map?.toSession();
    }
  }
  bool get hasSession => session != null;

  static Future<SessionResponse> invoke(String s,
      {Map<String, Object?>? body, Map<String, String>? headers}) async {
    final res = await SupabaseHelper.invoke(s, body: body, headers: headers);
    return SessionResponse(res);
  }
}
