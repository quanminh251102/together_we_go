import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../cubits/booking/booking_cubit.dart';

class SearchBookingPage extends StatefulWidget {
  const SearchBookingPage({super.key});

  @override
  State<SearchBookingPage> createState() => _SearchBookingPageState();
}

class _SearchBookingPageState extends State<SearchBookingPage> {
  TextEditingController _startPoint = TextEditingController();
  TextEditingController _endPoint = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tìm kiếm booking'),
        centerTitle: true,
        // leading: IconButton(
        //   icon: Icon(Icons.arrow_back, color: Colors.black),
        //   onPressed: () => Navigator.of(context).pop(),
        // ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.fromLTRB(24, 24, 24, 0),
          child: Column(children: [
            Text('Điểm đi : '),
            TextField(
              controller: _startPoint,
              decoration: InputDecoration(
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                      width: 3, color: Colors.greenAccent), //<-- SEE HERE
                ),
                disabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                      width: 3, color: Colors.greenAccent), //<-- SEE HERE
                ),
              ),
            ),
            Text('Điểm đến : '),
            TextField(
              controller: _endPoint,
              decoration: InputDecoration(
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                      width: 3, color: Colors.greenAccent), //<-- SEE HERE
                ),
                disabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                      width: 3, color: Colors.greenAccent), //<-- SEE HERE
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Text('t'),
            ElevatedButton(
              onPressed: () {
                BlocProvider.of<BookingCubit>(context).do_filter(
                    _startPoint.text.trim().toLowerCase(),
                    _endPoint.text.trim().toLowerCase());
              },
              child: Text('Tiếp'),
            ),
          ]),
        ),
      ),
    );
  }
}
