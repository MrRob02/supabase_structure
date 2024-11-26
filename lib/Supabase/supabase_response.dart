import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseResponse {
  final String message;
  final Object? data;
  const SupabaseResponse({required this.message, required this.data});

  factory SupabaseResponse.fromResponse(FunctionResponse? response) {
    if (response == null || response.status == 500) {
      return SupabaseResponse.noResponse;
    }
    var data2 = response.data;
    final data = data2?['data'] as Object?;
    final message = data2?['message'] as String?;
    if (message == null) {
      return noResponse;
    }
    return SupabaseResponse(
      message: message,
      data: data,
    );
  }
  static SupabaseResponse get noResponse =>
      const SupabaseResponse(message: '', data: null);
  bool get isSuccess => message == 'success';
  bool get isServerError => message == 'server_error';
  bool get isDataInvalid => message == 'incorrect_data';
  bool get tokenInvalid => message == 'token_invalid';
  bool get isUnsuccessful => !isSuccess;
}
