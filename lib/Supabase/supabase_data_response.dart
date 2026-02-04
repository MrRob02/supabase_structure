//?Se tienen configuradas que solamente se puedan regresar 200 filas por query
//?Esta configuracion se cambia en: Project Settings -> API
import '../supabase_helper.dart';
import 'supabase_response.dart';

class SupabaseDataResponse<T> extends SupabaseResponse {
  List<T> resData = [];
  SupabaseDataResponse(
      SupabaseResponse response, T Function(Map<String, Object?>) fromMap)
      : super(message: response.message, data: response.data) {
    var data = response.data;
    if (data is List) {
      resData =
          data.map((item) => fromMap(item as Map<String, Object?>)).toList();
    } else {
      resData = [];
    }
  }
  bool get hasData => resData.isNotEmpty;

  static Future<SupabaseDataResponse<T>> invoke<T>(String s,
      {required T Function(Map<String, Object?>) fromMap,
      Map<String, Object?>? body,
      Map<String, String>? headers}) async {
    final res = await SupabaseHelper.invoke(s, body: body, headers: headers);
    return SupabaseDataResponse<T>(res, fromMap);
  }
}
