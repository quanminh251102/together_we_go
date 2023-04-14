import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../../config/router/app_router.dart';
import '../../cubits/app_user.dart';
import '../../services/image.dart';
import '../../services/user.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool _isLoadingImage = false;

  void uploadImage(XFile file) {
    setState(() {
      _isLoadingImage = true;
    });

    ImageService.uploadFile(file).then((value) async {
      if (value != "error") {
        // context
        //     .read<MessageCubit>()
        //     .send_message_to_chat_room(value, "isImage");
        await UserService.editAvatar(value);
        appUser.edit_avatar(value);
        //appRouter.push(HomePageViewRoute(email: appUser.gmail));
      }
      setState(() {
        _isLoadingImage = false;
      });
    });
  }

  void openMediaDialog() {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            backgroundColor: Colors.white,
            title: const Text(
              'Chọn nguồn',
              style: TextStyle(fontSize: 14),
            ),
            content: Container(
              margin: const EdgeInsets.fromLTRB(16, 0, 16, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  InkWell(
                    onTap: () async {
                      final ImagePicker _picker = ImagePicker();
                      final XFile? image =
                          await _picker.pickImage(source: ImageSource.camera);
                      if (image != null) {
                        print("get successfully");
                        uploadImage(image);
                        Future.delayed(Duration.zero, () {
                          Navigator.pop(context);
                        });
                      }
                    },
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.camera_alt,
                          size: 30,
                        ),
                        const Text('Máy ảnh')
                      ],
                    ),
                  ),
                  const SizedBox(
                    width: 100,
                  ),
                  InkWell(
                    onTap: () async {
                      final ImagePicker _picker = ImagePicker();
                      final XFile? image =
                          await _picker.pickImage(source: ImageSource.gallery);
                      if (image != null) {
                        uploadImage(image);
                        Future.delayed(Duration.zero, () {
                          Navigator.pop(context);
                        });
                        // image.path
                      }
                    },
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.image,
                          size: 30,
                        ),
                        const Text('Thư viện')
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }

  final settings = [
    const ListTile(
        leading: Icon(Icons.account_box),
        title: Text('Edit Profile'),
        trailing: Icon(
          Icons.keyboard_arrow_right,
        )),
    const ListTile(
      leading: Icon(Icons.location_on),
      title: Text('Address'),
      trailing: Icon(Icons.keyboard_arrow_right),
    ),
    const ListTile(
      leading: Icon(Icons.notifications),
      title: Text('Notification'),
      trailing: Icon(Icons.keyboard_arrow_right),
    ),
    ListTile(
      leading: const Icon(Icons.logout),
      title: const Text('Logout'),
      onTap: () {
        appRouter.push(const SignInViewRoute());
      },
    ),
  ];
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
          horizontal: MediaQuery.of(context).size.width * 0.05,
          vertical: MediaQuery.of(context).size.height * 0.05),
      child: Column(children: [
        const Align(
          child: Text(
            'Thông tin tài khoản',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          alignment: Alignment.topLeft,
        ),
        const SizedBox(height: 8),
        CircleAvatar(
          radius: 60.0,
          backgroundImage: NetworkImage(appUser.avatar),
          backgroundColor: Colors.transparent,
        ),
        Visibility(
            visible: _isLoadingImage, child: const CircularProgressIndicator()),
        ElevatedButton(
          onPressed: () {
            openMediaDialog();
          },
          child: const Text('Edit avatar'),
        ),
        const SizedBox(height: 8),
        Text(appUser.name),
        const SizedBox(height: 8),
        Text(appUser.gmail),
        const SizedBox(height: 24),
        ...settings,
      ]),
    );
  }
}
