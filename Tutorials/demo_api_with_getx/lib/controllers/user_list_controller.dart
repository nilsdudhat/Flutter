import 'package:get/get.dart';

import '../models/user_list_model.dart';
import '../providers/user_list_provider.dart';

class UserListController extends GetxController with StateMixin<UserListModel> {
  UserProvider userProvider = UserProvider();

  void getUserList({required int pageNumber}) {
    userProvider.getUserList(pageNumber: pageNumber).then(
      (value) {
        UserListModel userListModel = UserListModel.fromJson(value);
        change(userListModel, status: RxStatus.success());
      },
      onError: (error) {
        change(null, status: RxStatus.error(error.toString()));
      },
    );
  }
}
