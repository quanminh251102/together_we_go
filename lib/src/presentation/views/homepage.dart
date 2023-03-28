import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubits/chat/chat_rooms_cubit.dart';
import 'chat/chat_rooms_page.dart';

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
      child: Center(child: Text('home page')),
    ),
    Center(child: ChatRoomsPage()),
    Container(
      child: Center(child: Text('profile')),
    ),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: tabs[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (value) {
          context.read<ChatRoomsCubit>().get_chatRoom();
          setState(() {
            _currentIndex = value;
          });
        },
        iconSize: 40,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'home'),
          BottomNavigationBarItem(icon: Icon(Icons.message), label: 'message'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'profile'),
        ],
      ),
    );
  }
}
