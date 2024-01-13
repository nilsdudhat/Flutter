import 'package:get/get.dart';

class UserProvider extends GetConnect {
  Future<Map<String, dynamic>> getUserList({required int pageNumber}) async {
    final response = await get("https://reqres.in/api/users?page=$pageNumber");

    if (response.status.hasError) {
      return Future.error(response.statusText!);
    } else {
      return response.body;
    }
  }
}
