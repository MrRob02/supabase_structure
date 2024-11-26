import 'package:shared_preferences/shared_preferences.dart';

class SupabaseSharedData {
  static late SharedPreferences _instance;
  static Future<void> initShared() async =>
      _instance = await SharedPreferences.getInstance();

  static Future<void> setLocalDbVersion(int p0) async {
    await _instance.setInt('dbVersion', p0);
  }

  //todo: realmente está mal porque al momento de subir una funcion de supabase invoke lanzará la versión 1 primero y luego la correcta
  //pero se cambiará en un futuro, ambas funciones se ejecutan juntas asi que a menos de que una falle no debe haber problemas
  static int get getLocalDbVersion => _instance.getInt('dbVersion') ?? 1;
}
