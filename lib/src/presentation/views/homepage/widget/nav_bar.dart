import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../../cubits/app_user.dart';
import '../../apply/my_apply_page.dart';
import '../../booking/my_booking_page.dart';

class NavBar extends StatefulWidget {
  const NavBar({super.key});

  @override
  State<NavBar> createState() => _NavBarState();
}

class _NavBarState extends State<NavBar> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.white,
      child: ListView(padding: EdgeInsets.zero, children: <Widget>[
        UserAccountsDrawerHeader(
          accountName: Text(
            appUser.name,
            style: TextStyle(color: Colors.white),
          ),
          accountEmail: Text(
            appUser.gmail,
            style: TextStyle(color: Colors.white),
          ),
          currentAccountPicture: CachedNetworkImage(
            imageUrl: appUser.avatar,
            imageBuilder: (context, imageProvider) => Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(Radius.circular(
                        60.0) //                 <--- border radius here
                    ),
                image: DecorationImage(
                  image: imageProvider,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            placeholder: (context, url) => const CircularProgressIndicator(),
            errorWidget: (context, url, error) => const Icon(Icons.error),
          ),
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: NetworkImage(
                  'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRt5KENnAJ_Vfx8W3gzM_U79r3zNwppNXCknA&usqp=CAU'),
              fit: BoxFit.cover,
            ),
          ),
        ),
        ListTile(
          leading: Icon(Icons.book_sharp),
          title: Text('Danh sách booking của tôi'),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => MyBookPage()),
            );
          },
        ),
        ListTile(
          leading: const Icon(Icons.list),
          title: const Text('Danh sách apply của tôi'),
          onTap: () async {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => MyApplyPage()),
            );
          },
        )
      ]),
    );
  }
}
