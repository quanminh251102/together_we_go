import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:dropdown_textfield/dropdown_textfield.dart';

import '../../../../utils/constants/colors.dart';
import '../../../../utils/showSnackbar.dart';
import '../../../cubits/update_profile/update_profile_cubit.dart';

class UpdateProfilePage extends StatefulWidget {
  final Map<String, dynamic> user;

  const UpdateProfilePage({Key? key, required this.user}) : super(key: key);

  @override
  State<UpdateProfilePage> createState() => _UpdateProfilePageState();
}

class _UpdateProfilePageState extends State<UpdateProfilePage> {
  late FocusNode nameFocus;
  late FocusNode birthdayFocus;
  late FocusNode genderFocus;
  late TextEditingController name;
  late TextEditingController birthday;

  late GlobalKey<FormState> _formKey;
  late SingleValueDropDownController gender;

  String? _gender;
  DateTime? _birthday;
  bool _isLoadingUpdate = false;
  // Function to show a date picker dialog when the birthday field is tapped
  Future<void> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: _birthday ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: ColorScheme.light(
              primary: AppColors.primaryColor,
              onPrimary: Colors.black,
              surface: AppColors.primaryColor,
              onSurface: Colors.black,
              onBackground: Colors.black,
            ),
            dialogBackgroundColor: Colors.white,
          ),
          child: child!,
        );
      },
    ) as DateTime;
    if (picked != null && picked != _birthday) {
      setState(() {
        _birthday = picked;
        if (this._birthday == null) {
          this.birthday.text = 'Chọn ngày';
        } else {
          this.birthday.text =
              '${_birthday?.day}/${_birthday?.month}/${_birthday?.year}';
        }
      });
    }
  }

  @override
  void initState() {
    gender = SingleValueDropDownController();
    super.initState();
    print('update page');
    print(this.widget.user["name"]);
    print(this.widget.user["gender"]);

    nameFocus = FocusNode();
    birthdayFocus = FocusNode();
    genderFocus = FocusNode();

    nameFocus.addListener(() {
      setState(() {});
    });
    birthdayFocus.addListener(() {
      setState(() {});
    });
    genderFocus.addListener(() {
      setState(() {});
    });

    _formKey = GlobalKey<FormState>();
    name = TextEditingController();
    birthday = TextEditingController();

    this.name.text = widget.user["name"];

    if (widget.user["gender"] == "male") {
      this.gender.dropDownValue =
          DropDownValueModel(name: 'Nam', value: "male");
    } else {
      this.gender.dropDownValue =
          DropDownValueModel(name: 'Nữ', value: "female");
    }

    if (widget.user["birth_date"] == "") {
      this._birthday = DateTime.now();
    } else {
      this._birthday = DateTime.parse(widget.user["birth_date"]);
    }
    if (this._birthday == null) {
      this.birthday.text = 'Chọn ngày';
    } else {
      this.birthday.text =
          '${_birthday?.day}/${_birthday?.month}/${_birthday?.year}';
    }
  }

  @override
  void dispose() {
    name.dispose();
    birthday.dispose();
    gender.dispose();
    super.dispose();
  }

  void update_profile_click_event_button() {
    if (_formKey.currentState!.validate() && this._isLoadingUpdate == false) {
      Map<String, dynamic> data = {
        "name": this.name.text.trim(),
        "gender": this.gender.dropDownValue!.value,
        "birth_date": this._birthday.toString(),
      };
      print(this.name.text.trim());
      print(this.gender.dropDownValue!.value);
      print(this._birthday.toString());

      setState(() {
        this._isLoadingUpdate = true;
      });
      BlocProvider.of<UpdateProfileCubit>(context)
          .update_user(data, function_pass, function_error);
    }
  }

  void function_pass() {
    setState(() {
      this._isLoadingUpdate = false;
    });
    showSnackBar(context, 'Cập nhật thành công');
  }

  void function_error() {
    setState(() {
      this._isLoadingUpdate = false;
    });
    showSnackBar(context, 'Đã xảy ra lổi');
  }

  @override
  Widget build(BuildContext context) {
    _formUpdateProfile() => Form(
          key: _formKey,
          child: Column(children: [
            TextFormField(
              style: const TextStyle(fontWeight: FontWeight.w600),
              focusNode: nameFocus,
              controller: name,
              validator: (value) {
                if (value!.isEmpty) {
                  return "Vui lòng nhập tên";
                }
                return null;
              },
              decoration: InputDecoration(
                labelText: 'Tên',
                filled: true, //<-- SEE HERE
                fillColor: nameFocus.hasFocus
                    ? AppColors.primaryColor.withOpacity(0.1)
                    : Colors.grey.withOpacity(0.1),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: AppColors.primaryColor),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(
                    color: Colors.grey.withOpacity(0.1),
                    width: 2.0,
                  ),
                ),
                hintText: 'Vui lòng nhập tên',
                // prefixIcon: Icon(
                //   Icons.ac_unit_rounded,
                //   color: nameFocus.hasFocus
                //       ? AppColors.primaryColor
                //       : Colors.black,
                // ),
              ),
            ),
            SizedBox(
              height: 24,
            ),
            DropDownTextField(
              clearOption: false,
              controller: this.gender,
              textFieldFocusNode: genderFocus,
              textFieldDecoration: InputDecoration(
                labelText: 'Giới tính',
                hintText: 'Giới tính',
                filled: true, //<-- SEE HERE
                fillColor: Colors.grey.withOpacity(0.1),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: AppColors.primaryColor),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(
                    color: Colors.grey.withOpacity(0.1),
                    width: 2.0,
                  ),
                ),
              ),
              // searchFocusNode: searchFocusNode,
              // searchAutofocus: true,
              dropDownItemCount: 8,
              searchShowCursor: false,
              // enableSearch: true,
              // searchKeyboardType: TextInputType.number,
              dropDownList: const [
                DropDownValueModel(name: 'Nam', value: "male"),
                DropDownValueModel(name: 'Nữ', value: "female"),
              ],
              onChanged: (val) {
                print(val);
                print(this.gender.dropDownValue);
              },
            ),
            SizedBox(
              height: 24,
            ),
            TextFormField(
              readOnly: true,
              focusNode: birthdayFocus,
              controller: birthday,
              maxLines: 1,
              onTap: () {
                _selectDate(context);
              },
              validator: (value) {
                if (value!.isEmpty || value.length < 1) {
                  return 'Chọn ngày';
                }
              },
              decoration: InputDecoration(
                labelText: 'Ngày sinh', hintText: 'Chọn ngày',
                labelStyle: TextStyle(fontSize: 15),
                filled: true, //<-- SEE HERE
                fillColor: Colors.grey.withOpacity(0.1),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: AppColors.primaryColor),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(
                    color: Colors.grey.withOpacity(0.1),
                    width: 2.0,
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 24,
            ),
            (this._isLoadingUpdate)
                ? CircularProgressIndicator()
                : Center(
                    child: NeumorphicButton(
                      onPressed: () {
                        this.update_profile_click_event_button();
                      },
                      style: NeumorphicStyle(
                          shape: NeumorphicShape.concave,
                          boxShape: NeumorphicBoxShape.roundRect(
                              BorderRadius.circular(15)),
                          depth: 4,
                          color: AppColors.primaryColor),
                      padding: const EdgeInsets.all(12.0),
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width * 0.8,
                        child: Center(
                          child: Text(
                            'Cập nhật',
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ),
                  ),
          ]),
        );

    return Scaffold(
      appBar: AppBar(
        title: Text('Cập nhật thông tin cá nhân'),
        centerTitle: false,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 12, 24, 0),
          child: _formUpdateProfile(),
        ),
      ),
    );
  }
}