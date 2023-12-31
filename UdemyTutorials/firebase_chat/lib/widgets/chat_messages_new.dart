import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ChatMessagesNew extends StatelessWidget {
  const ChatMessagesNew({super.key});

  @override
  Widget build(BuildContext context) {
    final currentUser = FirebaseAuth.instance.currentUser!;
    final width = MediaQuery.of(context).size.width;

    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection("chat")
          .orderBy("createdAt", descending: true)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Center(
            child: Text("No messages found"),
          );
        }

        if (snapshot.hasError) {
          return const Center(
            child: Text("Something went wrong...!"),
          );
        }

        final loadedMessages = snapshot.data!.docs;
        return ListView.builder(
          padding: const EdgeInsets.all(16),
          reverse: true,
          itemCount: loadedMessages.length,
          itemBuilder: (context, index) {
            final currentData = loadedMessages[index].data();
            final currentDateTime = DateTime.fromMillisecondsSinceEpoch(
                (currentData["createdAt"] as Timestamp).millisecondsSinceEpoch);
            final currentDate = getDate(currentDateTime);
            final currentUserName = currentData["userName"];
            print(currentUserName);

            final nextData;
            final nextDateTime;
            final nextDate;
            final nextUserName;

            var displayUser = false;
            var displayDate = false;

            if ((index + 1) == loadedMessages.length) {
              displayDate = true;
              displayUser = true;
            } else {
              nextData = loadedMessages[index + 1].data();
              nextDateTime = DateTime.fromMillisecondsSinceEpoch(
                  (nextData["createdAt"] as Timestamp).millisecondsSinceEpoch);
              nextDate = getDate(nextDateTime);
              nextUserName = nextData["userName"];

              if (currentDate == nextDate) {
                displayDate = false;
              } else {
                displayDate = true;
              }
              if (currentUserName == nextUserName) {
                if (displayDate) {
                  displayUser = true;
                } else {
                  displayUser = false;
                }
              } else {
                displayUser = true;
              }
            }

            if (currentData["userId"] != currentUser.uid) {
              return Column(
                children: [
                  if (displayDate)
                    Container(
                      margin: const EdgeInsets.only(
                        top: 16,
                        bottom: 8,
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: Theme.of(context)
                            .colorScheme
                            .primary
                            .withOpacity(0.25),
                        borderRadius: BorderRadius.circular(45),
                      ),
                      child: Text(
                        getDate(currentDateTime),
                      ),
                    ),
                  if (displayUser)
                    Row(
                      children: [
                        SizedBox(
                          height: 36,
                          width: 36,
                          child: CircleAvatar(
                            backgroundColor:
                                Theme.of(context).colorScheme.primary,
                            foregroundImage:
                                NetworkImage(currentData["userProfile"]),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            currentUserName,
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium!
                                .copyWith(
                                  fontWeight: FontWeight.w500,
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onBackground,
                                ),
                          ),
                        )
                      ],
                    ),
                  Container(
                    margin: EdgeInsets.only(
                      top: 1,
                      bottom: 1,
                      right: (width / 5),
                      left: 36,
                    ),
                    alignment: Alignment.topLeft,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primary,
                        borderRadius: const BorderRadius.only(
                          bottomRight: Radius.circular(5),
                          topRight: Radius.circular(5),
                          bottomLeft: Radius.circular(5),
                        ),
                      ),
                      padding: const EdgeInsets.symmetric(
                        vertical: 5,
                        horizontal: 5,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(right: 16.0),
                            child: Text(
                              currentData["message"],
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium!
                                  .copyWith(
                                    color:
                                        Theme.of(context).colorScheme.onPrimary,
                                  ),
                            ),
                          ),
                          const SizedBox(
                            height: 4,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 12.0),
                            child: Text(
                              getTime(currentDateTime),
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall!
                                  .copyWith(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onPrimary
                                        .withOpacity(0.5),
                                  ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              );
            } else {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  if (displayDate)
                    Align(
                      alignment: Alignment.center,
                      child: Container(
                        margin: const EdgeInsets.only(
                          bottom: 8,
                          top: 16,
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: Theme.of(context)
                              .colorScheme
                              .primary
                              .withOpacity(0.25),
                          borderRadius: BorderRadius.circular(45),
                        ),
                        child: Text(
                          getDate(currentDateTime),
                        ),
                      ),
                    ),
                  Container(
                    margin: EdgeInsets.only(
                      top: 1,
                      bottom: 1,
                      left: (width / 3),
                    ),
                    padding: const EdgeInsets.symmetric(
                      vertical: 5,
                      horizontal: 5,
                    ),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primary,
                      borderRadius: const BorderRadius.only(
                        bottomRight: Radius.circular(5),
                        topLeft: Radius.circular(5),
                        bottomLeft: Radius.circular(5),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(right: 16.0),
                          child: Text(
                            currentData["message"],
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium!
                                .copyWith(
                                  color: Theme.of(context).colorScheme.onPrimary,
                                ),
                          ),
                        ),
                        const SizedBox(
                          height: 4,
                        ),
                        Text(
                          getTime(currentDateTime),
                          style:
                              Theme.of(context).textTheme.bodySmall!.copyWith(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onPrimary
                                        .withOpacity(0.5),
                                  ),
                        )
                      ],
                    ),
                  ),
                ],
              );
            }
          },
        );
      },
    );
  }

  bool isToday(DateTime createdDate) {
    int day = createdDate.day;
    int month = createdDate.month;
    int year = createdDate.year;

    DateTime today = DateTime.now();

    if ((today.day == day) && (today.month == month) && (today.year == year)) {
      return true;
    }
    return false;
  }

  String getDate(DateTime createdDate) {
    int day = createdDate.day;
    int month = createdDate.month;
    int year = createdDate.year;

    String strDay;
    String strMonth;
    String strYear;

    if (day.toString().length == 1) {
      strDay = "0$day";
    } else {
      strDay = day.toString();
    }

    List months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December'
    ];

    strMonth = months[month - 1];

    strYear = year.toString();

    return "$strDay, $strMonth $strYear";
  }

  String getTime(DateTime createdAtDate) {
    int hour = createdAtDate.hour;
    int minute = createdAtDate.minute;

    String strHour;
    String strMin;

    if (hour.toString().length == 1) {
      strHour = "0$hour";
    } else {
      strHour = hour.toString();
    }
    if (minute.toString().length == 1) {
      strMin = "0$minute";
    } else {
      strMin = minute.toString();
    }

    return "$strHour:$strMin";
  }
}
