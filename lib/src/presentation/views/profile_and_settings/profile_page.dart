import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../../config/router/app_router.dart';
import '../../../utils/constants/colors.dart';
import '../../cubits/app_user.dart';
import '../../cubits/signin/signin_cubit.dart';
import '../../cubits/update_profile/update_profile_cubit.dart';
import '../../services/image.dart';
import '../../services/user.dart';
import '../homepage/signin/widget/app_icon_button.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool _isLoadingForUpdateProfilePage = false;
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
                      children: const [
                        Icon(
                          Icons.camera_alt,
                          size: 30,
                        ),
                        Text('Máy ảnh')
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
                        Icon(
                          Icons.image,
                          size: 30,
                        ),
                        Text('Thư viện')
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }

  void _modalBottomSheetLogout(context) {
    showModalBottomSheet(
        context: context,
        builder: (builder) {
          return new Container(
            height: 200.0,
            color: Colors.transparent, //could change this to Color(0xFF737373),
            //so you don't have to change MaterialApp canvasColor
            child: new Container(
                padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
                decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: const BorderRadius.only(
                        topLeft: const Radius.circular(30.0),
                        topRight: const Radius.circular(30.0))),
                child: Column(
                  children: [
                    const Text(
                      "Đăng xuất",
                      style: TextStyle(
                          color: Colors.red,
                          fontSize: 20,
                          fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      "Bạn chắc chắn muốn đăng xuất?",
                      style:
                          TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Container(
                            decoration: BoxDecoration(
                                color: AppColors.primaryColor,
                                borderRadius: BorderRadius.circular(25)),
                            height: MediaQuery.of(context).size.height * 0.06,
                            width: MediaQuery.of(context).size.width * 0.8,
                            child: const Center(
                              child: Text(
                                'Hủy',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        ),
                        IconBtn(
                          onPressed: () {
                            BlocProvider.of<SigninCubit>(context).Logout();
                            appRouter.push(const SignInViewRoute());
                          },
                          children: SizedBox(
                            width: MediaQuery.of(context).size.width * 0.35,
                            child: const Center(
                              child: Text(
                                'Vâng, Đăng xuất',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                )),
          );
        });
  }

  void cancel_loading() {
    setState(() {
      this._isLoadingForUpdateProfilePage = false;
    });
  }

  settings(context) => [
        ListTile(
          leading: const Icon(Icons.account_box),
          title: const Text('Cập nhật thông tin cá nhân'),
          trailing: this._isLoadingForUpdateProfilePage
              ? const CircularProgressIndicator()
              : const Icon(
                  Icons.keyboard_arrow_right,
                ),
          onTap: () {
            if (this._isLoadingForUpdateProfilePage == false) {
              setState(() {
                _isLoadingForUpdateProfilePage = true;
              });
              BlocProvider.of<UpdateProfileCubit>(context)
                  .navigateToUpdateProfileScreen(cancel_loading);
            }
          },
        ),
        // const ListTile(
        //   leading: Icon(Icons.location_on),
        //   title: Text('Địa chỉ'),
        //   trailing: Icon(Icons.keyboard_arrow_right),
        // ),
        // const ListTile(
        //   leading: Icon(Icons.notifications),
        //   title: Text('Thông báo'),
        //   trailing: Icon(Icons.keyboard_arrow_right),
        // ),
        ListTile(
          leading: const Icon(Icons.lock_clock),
          title: const Text('Chính sách quyền riêng tư'),
          trailing: const Icon(Icons.keyboard_arrow_right),
          onTap: () {
            appRouter.push(const PrivacyPolicyPageRoute());
          },
        ),
        ListTile(
          leading: const Icon(
            Icons.logout,
            color: Colors.red,
          ),
          title: const Text(
            'Đăng xuất',
            style: TextStyle(
              color: Colors.red,
            ),
          ),
          onTap: () {
            _modalBottomSheetLogout(context);
          },
        ),
      ];
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
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
          CachedNetworkImage(
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
          Visibility(
              visible: _isLoadingImage,
              child: const CircularProgressIndicator()),
          ElevatedButton(
            onPressed: () {
              openMediaDialog();
            },
            child: const Text('Đổi ảnh đại diện'),
          ),
          const SizedBox(height: 8),
          Text(appUser.name),
          const SizedBox(height: 8),
          Text(appUser.gmail),
          const SizedBox(height: 24),
          ...settings(context),
        ]),
      ),
    );
  }
}
