import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:supabase_structure/Supabase/supabase_shared_data.dart';
import 'supabase_response.dart';

enum SupabaseTable {
  usuarios;

  String get name {
    switch (this) {
      case usuarios:
        return 'Usuarios';
    }
  }
}

//? A como esta configurado, la sesion nunca va a expirar, ya que se necesita ser usuario premium
//?de supabase para activar Time-box user sessions y asi obligar a los usuarios a iniciar sesion cada cierto tiempo
//link: https://supabase.com/dashboard/project/[the-project-id]/settings/auth

class SupabaseHelper {
  static SupabaseClient? instance;

  static GoTrueClient? get auth => instance?.auth;
  //?Se inicializa en MainApp initState
  static Future<void> initialize(
      {required String productionUrl,
      required String productionAnonKey,
      required String testUrl,
      required String testAnonKey}) async {
    try {
      await SupabaseSharedData.initShared();
      await Supabase.initialize(
        url: kDebugMode ? testUrl : productionUrl,
        anonKey: kDebugMode ? testAnonKey : productionAnonKey,
        realtimeClientOptions: const RealtimeClientOptions(
          eventsPerSecond: 2,
        ),
      );

      instance = Supabase.instance.client;
    } catch (e) {
      debugPrint('Error initializing Supabase: $e');
    }
  }

  static Future<SupabaseResponse> invoke(String s,
      {Map<String, Object?>? body, Map<String, String>? headers}) async {
    try {
      final newBody = {
        ...?body,
        'local_db_version': SupabaseSharedData.getLocalDbVersion,
      };
      final res = await instance?.functions
          .invoke(s, headers: headers, body: newBody)
          .timeout(
            const Duration(seconds: 10),
            onTimeout: () => FunctionResponse(status: 500, data: 'Timeout'),
          );
      final sup = SupabaseResponse.fromResponse(res);
      return sup;
    } catch (e) {
      return SupabaseResponse.noResponse;
    }
  }

  static Future<Session?> setSession({required String refreshToken}) async {
    final ses = await instance?.auth.setSession(refreshToken);
    return ses?.session;
  }

  static Future<Session?> signIn(String token) async =>
      await setSession(refreshToken: token);

  static Future signOut() async {
    await auth?.signOut();
  }
}
