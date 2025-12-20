import 'package:get_storage/get_storage.dart';

const String baseUrl = "http://10.0.2.2:8000/api/v1";

Future<GetStorage> setup() async {
  await GetStorage.init();
  final box = GetStorage();
  return box;
}
