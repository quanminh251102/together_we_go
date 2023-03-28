import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../utils/constants/colors.dart';
import '../cubits/chat/chat_rooms_cubit.dart';
import '../cubits/home_page/home_page_cubit.dart';
import 'chat/chat_rooms_page.dart';
import 'profile_and_settings/profile_page.dart';

class HomePageView extends StatefulWidget {
  const HomePageView({super.key, required this.email});
  final String email;
  @override
  State<HomePageView> createState() => _HomePageViewState();
}

class _HomePageViewState extends State<HomePageView> {
  int _currentIndex = 0;

  final tabs = [
    Container(
      child: Center(
          child: Text(
        'Home page',
        style: TextStyle(fontSize: 20),
      )),
    ),
    Container(
      child: Center(
          child: Text(
        'Bookings',
        style: TextStyle(fontSize: 20),
      )),
    ),
    const Center(child: ChatRoomsPage()),
    Container(
      child: Center(
          child: Text(
        'Wallet',
        style: TextStyle(fontSize: 20),
      )),
    ),
    Container(child: const ProfilePage()),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 48, 24, 0),
          child: tabs[_currentIndex],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: AppColors.primaryColor,
        unselectedItemColor: AppColors.borderColor,
        currentIndex: _currentIndex,
        onTap: (value) {
          if (value == 2) context.read<ChatRoomsCubit>().get_chatRoom();
          //BlocProvider.of<HomePageCubit>(context).set_current_index(value);
          setState(() {
            _currentIndex = value;
          });
        },
        items: [
          const BottomNavigationBarItem(
              backgroundColor: Colors.white,
              icon: Icon(Icons.home),
              label: 'Home'),
          const BottomNavigationBarItem(
              backgroundColor: Colors.white,
              icon: Icon(Icons.car_rental),
              label: 'Bookings'),
          const BottomNavigationBarItem(
              backgroundColor: Colors.white,
              icon: Icon(Icons.message),
              label: 'Inbox'),
          const BottomNavigationBarItem(
              backgroundColor: Colors.white,
              icon: Icon(Icons.wallet),
              label: 'Wallet'),
          const BottomNavigationBarItem(
              backgroundColor: Colors.white,
              icon: Icon(Icons.person),
              label: 'Profile'),
        ],
      ),
    );
  }
}
