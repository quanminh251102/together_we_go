import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

import '../../../config/router/app_router.dart';
import '../../../utils/constants/colors.dart';
import '../../cubits/chat/chat_rooms_cubit.dart';
import '../booking/add_booking.dart';
import '../booking/booking_page.dart';
import '../../cubits/home_page/home_page_cubit.dart';
import '../chat/chat_rooms_page.dart';
import '../map_page/map_page.dart';
import '../map_page/search_place_screen.dart';
import 'widget/blurred_dialog.dart';
import '../profile_and_settings/profile_page.dart';

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
    _appBar(index) {
      var _appBar;
      switch (index) {
        case 1:
          _appBar = AppBar(
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
          );
          break;
        case 2:
          _appBar = AppBar(
            toolbarHeight: 0,
          );
          break;
        default:
          _appBar = AppBar(
            toolbarHeight: 0,
          );
          break;
      }
      return _appBar;
    }

    _body(index) {
      var _body;
      switch (index) {
        case 0:
          _body = SearchPlaceScreen();
          break;
        case 1:
          _body = BookingPage(tabController: _tabController);
          break;
        case 2:
          _body = ChatRoomsPage();
          break;
        case 3:
          _body = Container(
            child: const Center(
                child: Text(
              'Wallet',
              style: TextStyle(fontSize: 20),
            )),
          );
          break;
        case 4:
          _body = Container(child: const ProfilePage());
          break;
        default:
          break;
      }
      return _body;
    }

    _bottomNavigationBar() {
      return BottomNavigationBar(
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
      );
    }

    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
        appBar: _appBar(_currentIndex),
        body: _body(_currentIndex),
        bottomNavigationBar: _bottomNavigationBar(),
      ),
    );
  }
}
