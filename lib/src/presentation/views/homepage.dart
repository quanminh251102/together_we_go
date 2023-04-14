import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

import '../../utils/constants/colors.dart';
import '../cubits/chat/chat_rooms_cubit.dart';
import 'booking/booking_page.dart';
import '../cubits/home_page/home_page_cubit.dart';
import 'chat/chat_rooms_page.dart';
import 'profile_and_settings/profile_page.dart';

class HomePageView extends StatefulWidget {
  const HomePageView({super.key, required this.email});
  final String email;
  @override
  State<HomePageView> createState() => _HomePageViewState();
}

class _HomePageViewState extends State<HomePageView>
    with TickerProviderStateMixin {
  int _currentIndex = 0;
  late TabController _tabController;
  bool isBookingPage = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _tabController = TabController(
      length: 3,
      vsync: this,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _currentIndex == 1
          ? AppBar(
              leading: const Icon(Icons.book_outlined),
              title: const Text(
                'Bài đăng',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              bottom: TabBar(
                controller: _tabController,
                indicatorSize: TabBarIndicatorSize.label,
                indicatorColor: AppColors.primaryColor,
                tabs: [
                  const Tab(
                      child: Text(
                    'Đang hoạt động',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 14),
                  )),
                  const Tab(
                      child: Text(
                    'Hoàn thành',
                    style: TextStyle(fontSize: 14),
                  )),
                  const Tab(
                      child: Text(
                    'Đã hủy',
                    style: TextStyle(fontSize: 14),
                  )),
                ],
              ),
            )
          : _currentIndex == 0
              ? AppBar()
              : _currentIndex == 2
                  ? AppBar()
                  : _currentIndex == 3
                      ? AppBar()
                      : AppBar(),
      body: SizedBox(
        child: _currentIndex == 0
            ? Container(
                child: const Center(
                    child: Text(
                  'Home page',
                  style: TextStyle(fontSize: 20),
                )),
              )
            : _currentIndex == 1
                ? BookingPage(tabController: _tabController)
                : _currentIndex == 2
                    ? const Center(child: ChatRoomsPage())
                    : _currentIndex == 3
                        ? Container(
                            child: const Center(
                                child: Text(
                              'Wallet',
                              style: TextStyle(fontSize: 20),
                            )),
                          )
                        : Container(child: const ProfilePage()),
      ),
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: AppColors.primaryColor,
        unselectedItemColor: AppColors.borderColor,
        currentIndex: _currentIndex,
        onTap: (value) {
          if (value == 2) context.read<ChatRoomsCubit>().get_chatRoom();
          if (value == 1)
            setState(() {
              isBookingPage == true;
            });
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
