import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';

import '../../../config/router/app_router.dart';
import '../../../utils/constants/colors.dart';
import '../../cubits/booking/booking_cubit.dart';
import '../../cubits/map/map/map_cubit.dart';

enum BookingType { findDriver, findPassenger }

class NewBookingView extends StatefulWidget {
  const NewBookingView({super.key});

  @override
  State<NewBookingView> createState() => _NewBookingViewState();
}

String formatString(String input) {
  if (input.length > 30) {
    return input.substring(0, 27) + "...";
  } else {
    return input;
  }
}

class _NewBookingViewState extends State<NewBookingView> {
  TextEditingController textEditingController = TextEditingController();
  late FocusNode startPlaceFocus;
  late FocusNode endPlaceFocus;
  late TextEditingController time;
  late TextEditingController startPlace;
  late TextEditingController endPlace;
  late GlobalKey<FormState> _formKey;
  DateTime _selectedDateTime = DateTime.now();
  BookingType _bookingType = BookingType.findDriver;
  bool searching = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    startPlaceFocus = FocusNode();
    endPlaceFocus = FocusNode();
    startPlaceFocus.addListener(() {
      setState(() {});
    });
    endPlaceFocus.addListener(() {
      setState(() {});
    });
    _formKey = GlobalKey<FormState>();
    startPlace = TextEditingController();
    endPlace = TextEditingController();
    time = TextEditingController();
  }

  Future<void> selectDateTime(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      initialEntryMode: DatePickerEntryMode.inputOnly,
      context: context,
      initialDate: _selectedDateTime,
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
      builder: (context, child) {
        return Theme(
          data: ThemeData.dark().copyWith(
              colorScheme: const ColorScheme.dark(
                primary: Colors.black,
                surface: Colors.white,
                onSurface: Colors.black,
              ),
              dialogBackgroundColor: AppColors.primaryColor,
              dialogTheme: const DialogTheme(
                  backgroundColor: AppColors.primaryColor,
                  titleTextStyle: TextStyle(color: Colors.white),
                  contentTextStyle: TextStyle(color: Colors.black))),
          child: child!,
        );
      },
    );
    if (picked != null) {
      final TimeOfDay? timePicked = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(_selectedDateTime),
      );
      if (timePicked != null) {
        setState(() {
          _selectedDateTime = DateTime(
            picked.year,
            picked.month,
            picked.day,
            timePicked.hour,
            timePicked.minute,
          );
          final DateFormat formatter = DateFormat('HH:mm | dd/MM/yyyy');
          time.text = formatter.format(_selectedDateTime).toString();
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        leading: GestureDetector(
          onTap: () => appRouter.pop(),
          child: const Icon(
            Icons.arrow_back_ios_rounded,
            color: AppColors.textPrimaryColor,
          ),
        ),
        title: const Text(
          'ĐĂNG BÀI',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Container(
          decoration: BoxDecoration(color: Colors.grey.withOpacity(0.05)),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: screenSize.width * 0.05),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Địa điểm',
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.w600),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 10.0),
                          child: TextFormField(
                            onChanged: (value) {
                              setState(() {
                                BlocProvider.of<MapCubit>(context)
                                    .getSearchPlace(value);
                              });
                            },
                            style: const TextStyle(fontWeight: FontWeight.w600),
                            focusNode: startPlaceFocus,
                            controller: startPlace,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "Vui lòng nhập điểm đi";
                              }
                              setState(() {
                                searching = false;
                              });
                            },
                            decoration: InputDecoration(
                              filled: true, //<-- SEE HERE
                              fillColor: startPlaceFocus.hasFocus
                                  ? AppColors.primaryColor.withOpacity(0.1)
                                  : Colors.white,
                              focusedBorder: const OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: AppColors.primaryColor, width: 2)),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.grey.withOpacity(0.1),
                                  width: 2.0,
                                ),
                              ),
                              hintText: 'Điểm đi',
                              prefixIcon: Icon(
                                Icons.start_outlined,
                                color: startPlaceFocus.hasFocus
                                    ? AppColors.primaryColor
                                    : Colors.grey,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        TextFormField(
                          onChanged: (value) {
                            setState(() {
                              BlocProvider.of<MapCubit>(context)
                                  .getSearchPlace(value);
                            });
                          },
                          style: const TextStyle(fontWeight: FontWeight.bold),
                          focusNode: endPlaceFocus,
                          controller: endPlace,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "Vui lòng nhập điểm đến";
                            }
                            setState(() {
                              searching = false;
                            });
                          },
                          decoration: InputDecoration(
                            labelStyle:
                                const TextStyle(fontWeight: FontWeight.w600),
                            focusColor: Colors.black,
                            filled: true, //<-- SEE HERE
                            fillColor: endPlaceFocus.hasFocus
                                ? AppColors.primaryColor.withOpacity(0.1)
                                : Colors.white,
                            focusedBorder: const OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: AppColors.primaryColor, width: 2)),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.grey.withOpacity(0.1),
                                width: 2.0,
                              ),
                            ),
                            hintText: 'Điểm đến',
                            prefixIcon: Icon(Icons.place_outlined,
                                color: endPlaceFocus.hasFocus
                                    ? AppColors.primaryColor
                                    : Colors.grey),
                          ),
                        ),
                        Container(
                          height: screenSize.height * 0.8,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Thời gian',
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.w600),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                    top: 10.0, bottom: 10),
                                child: TextFormField(
                                  readOnly: true,
                                  onChanged: (value) {
                                    BlocProvider.of<MapCubit>(context)
                                        .getSearchPlace(value);
                                  },
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w600),
                                  controller: time,
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return "Vui lòng chọn thời gian";
                                    }
                                    return null;
                                  },
                                  decoration: InputDecoration(
                                      filled: true, //<-- SEE HERE
                                      fillColor: Colors.white,
                                      focusedBorder: const OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: AppColors.primaryColor,
                                              width: 2)),
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Colors.grey.withOpacity(0.1),
                                          width: 2.0,
                                        ),
                                      ),
                                      hintText: 'Thời gian',
                                      prefixIcon: IconButton(
                                        onPressed: () =>
                                            selectDateTime(context),
                                        icon: const Icon(
                                          Icons.calendar_month_outlined,
                                          color: Colors.grey,
                                        ),
                                      )),
                                ),
                              ),
                              const Text(
                                'Loại bài đăng',
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.w600),
                              ),
                              Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: Colors.white),
                                width: screenSize.width * 0.9,
                                height: screenSize.height * 0.08,
                                child: Center(
                                  child: RadioListTile(
                                    controlAffinity:
                                        ListTileControlAffinity.trailing,
                                    title: Row(
                                      children: [
                                        SvgPicture.asset(
                                          "assets/svg/driver.svg",
                                          height: 40,
                                        ),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        const Text(
                                          'Tìm tài xế',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    ),
                                    value: BookingType.findDriver,
                                    groupValue: _bookingType,
                                    onChanged: (value) {
                                      setState(() {
                                        _bookingType = value!;
                                      });
                                    },
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 10.0),
                                child: Container(
                                  width: screenSize.width * 0.9,
                                  height: screenSize.height * 0.08,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: Colors.white),
                                  child: Center(
                                    child: RadioListTile(
                                      controlAffinity:
                                          ListTileControlAffinity.trailing,
                                      title: Row(
                                        children: [
                                          SvgPicture.asset(
                                            "assets/svg/passenger.svg",
                                            height: 40,
                                          ),
                                          const SizedBox(
                                            width: 10,
                                          ),
                                          const Text(
                                            'Tìm hành khách',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ],
                                      ),
                                      value: BookingType.findPassenger,
                                      groupValue: _bookingType,
                                      onChanged: (value) {
                                        setState(() {
                                          _bookingType = value!;
                                        });
                                      },
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              const Text(
                                'Nội dung',
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.w600),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 10),
                                child: TextField(
                                  controller: textEditingController,
                                  keyboardType: TextInputType.multiline,
                                  decoration: InputDecoration(
                                    contentPadding: const EdgeInsets.symmetric(
                                        vertical: 20.0, horizontal: 20.0),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: const BorderSide(
                                          color: Color(0xffF2F2F3)),
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: const BorderSide(
                                          color: AppColors.borderColor),
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    hintText:
                                        "Mình cần tìm người đi cùng chiều nay...",
                                    hintStyle: const TextStyle(
                                        color: Color(0xff616161),
                                        fontFamily: "AvertaStdCY-Regular"),
                                    filled: true,
                                    fillColor: const Color(0xffF2F2F3),
                                  ),
                                  style: const TextStyle(
                                      fontSize: 14, color: Colors.black),
                                  maxLines: 100,
                                  minLines: 1,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          color: Colors.white,
                          height: screenSize.height * 0.8,
                          child: ListView.builder(
                              shrinkWrap: true,
                              itemCount: BlocProvider.of<MapCubit>(context)
                                  .placeSearchList
                                  .length,
                              itemBuilder: (context, index) {
                                return Card(
                                  child: ListTile(
                                    contentPadding: const EdgeInsets.symmetric(
                                        horizontal: 20),
                                    leading: SvgPicture.asset(
                                      'assets/svg/location.svg',
                                      height: 30,
                                    ),
                                    title: Text(
                                      BlocProvider.of<MapCubit>(context)
                                          .placeSearchList[index]
                                          .mainText,
                                      style: const TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16),
                                    ),
                                    subtitle: Text(
                                      formatString(
                                          BlocProvider.of<MapCubit>(context)
                                              .placeSearchList[index]
                                              .secondaryText),
                                      style: const TextStyle(
                                          color: Colors.black, fontSize: 14),
                                    ),
                                  ),
                                );
                              }),
                        ),
                      ],
                    )),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
