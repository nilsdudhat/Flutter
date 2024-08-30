import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../constants/svg_constants.dart';
import '../database/hive_database.dart';
import '../database/student.dart';
import '../widgets/custom_text.dart';
import 'add_student_page.dart';

class StudentsPage extends StatefulWidget {
  const StudentsPage({super.key});

  @override
  State<StudentsPage> createState() => _StudentsPageState();
}

class _StudentsPageState extends State<StudentsPage> {
  final studentsNotifier = ValueNotifier<List<Student>>([]);

  @override
  void initState() {
    super.initState();

    HiveDatabase hive = HiveDatabase(context);
    hive.observe(
      boxName: "students",
      onUpdate: (values) {
        studentsNotifier.value = values;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const CustomText(
          text: "Students",
          customFontWeight: CustomFontWeight.semiBold,
          customFontSize: CustomFontSize.medium,
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.sp),
        child: ValueListenableBuilder(
          valueListenable: studentsNotifier,
          builder: (context, value, child) {
            return value.isEmpty
                ? const Center(
                    child: CustomText(
                      text: "No Students Available",
                    ),
                  )
                : ListView.builder(
                    itemCount: value.length,
                    itemBuilder: (context, index) {
                      Student student = value[index];

                      return Card(
                        child: InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) {
                                  return AddStudentPage(
                                    student: student,
                                  );
                                },
                              ),
                            );
                          },
                          child: Padding(
                            padding: EdgeInsets.all(16.sp),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                CustomText(
                                  text: student.name!,
                                  customFontWeight: CustomFontWeight.semiBold,
                                ),
                                CustomText(
                                  text: "Age: ${student.age!}",
                                  customFontWeight: CustomFontWeight.normal,
                                ),
                                CustomText(
                                  text: "Gender: ${student.gender!}",
                                  customFontWeight: CustomFontWeight.normal,
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) {
                return const AddStudentPage();
              },
            ),
          );
        },
        child: SvgPicture.asset(SvgConstants.plus),
      ),
    );
  }
}
