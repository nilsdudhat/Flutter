import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import '../controllers/user_list_controller.dart';
import '../models/user_list_model.dart';

class ListingPage extends StatefulWidget {
  const ListingPage({super.key});

  @override
  State<ListingPage> createState() => _ListingPageState();
}

class _ListingPageState extends State<ListingPage> {
  final _userList = <User>[];

  final _scrollController = ScrollController();

  var controller = Get.put(UserListController());

  int _pageNumber = 0;
  int _totalPages = -1;

  @override
  void initState() {
    super.initState();

    _scrollController.addListener(() {
      if (_scrollController.position.maxScrollExtent ==
          _scrollController.position.pixels) {
        if (!controller.status.isLoading) {
          if (_pageNumber < _totalPages) {
            _pageNumber++;
            controller.getUserList(pageNumber: _pageNumber);
          }
        }
      }
    });

    _pageNumber++;
    controller.getUserList(pageNumber: _pageNumber);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: Text(
          "User List",
          style: Theme.of(context).textTheme.titleLarge!.copyWith(
                color: Theme.of(context).colorScheme.onPrimary,
                fontWeight: FontWeight.w600,
              ),
        ),
      ),
      body: controller.obx(
        (userListModel) {
          if (userListModel != null) {
            _totalPages = userListModel.totalPages!;
            _userList.addAll(userListModel.data!);
          }

          return ListView.builder(
            controller: _scrollController,
            itemCount: _userList.length,
            itemBuilder: (context, index) {
              return Column(
                children: [
                  Container(
                    margin: EdgeInsets.all(8.sp),
                    padding:
                        EdgeInsets.symmetric(vertical: 8.sp, horizontal: 16.sp),
                    child: Row(
                      children: [
                        SizedBox(
                          width: 25.w,
                          height: 25.w,
                          child: CircleAvatar(
                            backgroundImage:
                                NetworkImage(_userList[index].avatar!),
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                                vertical: 8.sp, horizontal: 16.sp),
                            child: Text(
                              "${_userList[index].firstName} ${_userList[index].lastName}",
                              style: Theme.of(context)
                                  .textTheme
                                  .titleLarge!
                                  .copyWith(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onBackground,
                                    fontWeight: FontWeight.w600,
                                  ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    height: 0.1.h,
                    color: Colors.black.withOpacity(0.25),
                  ),
                ],
              );
            },
          );
        },
        onError: (error) {
          return Center(
            child: Text(error!),
          );
        },
      ),
    );
  }
}
