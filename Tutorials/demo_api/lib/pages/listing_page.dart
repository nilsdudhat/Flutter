import 'dart:convert';

import 'package:demo_api/models/user_list_model.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class ListingPage extends StatefulWidget {
  const ListingPage({super.key});

  @override
  State<ListingPage> createState() => _ListingPageState();
}

class _ListingPageState extends State<ListingPage> {
  final _userList = <User>[];

  bool _isLoadingData = false;

  final ScrollController _scrollController = ScrollController();

  int pageNumber = 0;
  int totalPages = -1;

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    _scrollController.addListener(() {
      if (_scrollController.position.maxScrollExtent ==
          _scrollController.position.pixels) {
        if (!_isLoadingData) {
          if (pageNumber < totalPages) {
            pageNumber++;
            getUserListFromServer(pageNumber: pageNumber);
          }
        }
      }
    });

    pageNumber++;
    getUserListFromServer(pageNumber: pageNumber);
  }

  void getUserListFromServer({required int pageNumber}) async {
    setState(() {
      _isLoadingData = true;
    });

    var url = Uri.parse("https://reqres.in/api/users?page=$pageNumber");
    var response = await get(url);

    if (response.statusCode != 200) {
      setState(() {
        _isLoadingData = false;
      });
      return;
    }

    UserListModel userListModel =
        UserListModel.fromJson(json.decode(response.body));

    totalPages = userListModel.totalPages!;

    if (userListModel.data == null) {
      setState(() {
        _isLoadingData = false;
      });
      return;
    }

    List<User> tempList = userListModel.data!;

    _userList.addAll(tempList);

    setState(() {
      _isLoadingData = false;
    });
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
      body: Stack(
        children: [
          _userList.isEmpty
              ? _isLoadingData
                  ? const Center(
                      child: CircularProgressIndicator(),
                    )
                  : Center(
                      child: Text(
                        "No Data found",
                        style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                              color: Theme.of(context).colorScheme.onBackground,
                            ),
                      ),
                    )
              : ListView.builder(
                  padding: EdgeInsets.symmetric(vertical: 8.sp),
                  itemCount: _userList.length,
                  controller: _scrollController,
                  itemBuilder: (context, index) {
                    return Column(
                      children: [
                        Container(
                          margin: EdgeInsets.all(8.sp),
                          padding: EdgeInsets.symmetric(
                              vertical: 8.sp, horizontal: 16.sp),
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
                ),
          if (_isLoadingData && _userList.isNotEmpty)
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                width: double.infinity,
                height: 25.h,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [
                      Colors.white,
                      Colors.transparent,
                    ],
                  ),
                ),
                padding: EdgeInsets.symmetric(vertical: 8.sp),
                child: const Center(
                  child: CircularProgressIndicator(),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
