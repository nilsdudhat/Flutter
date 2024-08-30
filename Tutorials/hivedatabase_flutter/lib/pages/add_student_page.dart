import 'package:flutter/material.dart';
import 'package:hivedatabase_flutter/database/student.dart';
import 'package:hivedatabase_flutter/database/hive_database.dart';
import 'package:hivedatabase_flutter/widgets/custom_filled_button.dart';
import 'package:hivedatabase_flutter/widgets/custom_text.dart';
import 'package:hivedatabase_flutter/widgets/custom_text_field.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class AddStudentPage extends StatefulWidget {
  const AddStudentPage({
    super.key,
    this.student,
  });

  final Student? student;

  @override
  State<AddStudentPage> createState() => _AddStudentPageState();
}

class _AddStudentPageState extends State<AddStudentPage> {
  final nameController = TextEditingController();
  final ageController = TextEditingController();
  final genderController = TextEditingController();

  final globalKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();

    nameController.text = widget.student?.name ?? "";
    ageController.text = widget.student?.age.toString() ?? "";
    genderController.text = widget.student?.gender ?? "";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Student"),
      ),
      body: SafeArea(
        child: Form(
          key: globalKey,
          child: Column(
            children: [
              SizedBox(
                height: 16.sp,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.sp),
                child: CustomTextField.field(
                  validator: (value) {
                    if (nameController.text.isEmpty) {
                      return "Please enter name";
                    }
                    return null;
                  },
                  controller: nameController,
                  borderRadius: 12.sp,
                  textInputType: TextInputType.text,
                  labelText: "Name",
                  labelWeight: CustomFontWeight.semiBold,
                  labelSize: CustomFontSize.small,
                  textSize: CustomFontSize.medium,
                  textWeight: CustomFontWeight.normal,
                ),
              ),
              SizedBox(
                height: 16.sp,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.sp),
                child: CustomTextField.field(
                  validator: (value) {
                    if (ageController.text.isEmpty) {
                      return "Please enter age";
                    }
                    return null;
                  },
                  controller: ageController,
                  borderRadius: 12.sp,
                  textInputType: TextInputType.number,
                  labelText: "Age",
                  labelWeight: CustomFontWeight.semiBold,
                  labelSize: CustomFontSize.small,
                  textSize: CustomFontSize.medium,
                  textWeight: CustomFontWeight.normal,
                ),
              ),
              SizedBox(
                height: 16.sp,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.sp),
                child: CustomTextField.field(
                  validator: (value) {
                    if (genderController.text.isEmpty) {
                      return "Please enter gender";
                    }
                    return null;
                  },
                  controller: genderController,
                  borderRadius: 12.sp,
                  textInputType: TextInputType.number,
                  labelText: "Gender",
                  labelWeight: CustomFontWeight.semiBold,
                  labelSize: CustomFontSize.small,
                  textSize: CustomFontSize.medium,
                  textWeight: CustomFontWeight.normal,
                ),
              ),
              const Spacer(),
              Padding(
                padding: EdgeInsets.all(16.sp),
                child: CustomFilledButton(
                  isFullWidth: true,
                  onPressed: () async {
                    if (globalKey.currentState!.validate()) {
                      HiveDatabase hive = HiveDatabase(context);

                      if (widget.student != null) {
                        widget.student!.name = nameController.text;
                        widget.student!.gender = genderController.text;
                        widget.student!.age = int.parse(ageController.text);

                        await hive.update(
                          boxName: "students",
                          key: widget.student!.key,
                          value: widget.student,
                        );
                      } else {
                        Student student = Student(
                          name: nameController.text,
                          age: int.parse(ageController.text),
                          gender: genderController.text,
                        );

                        await hive.add(
                          boxName: "students",
                          value: student,
                        );
                      }

                      if (context.mounted) {
                        Navigator.pop(context);
                      }
                    }
                  },
                  text: "Add Student",
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
