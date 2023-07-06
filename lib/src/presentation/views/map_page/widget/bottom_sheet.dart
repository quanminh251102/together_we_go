// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../config/router/app_router.dart';
import '../../../../utils/constants/colors.dart';
import '../../../cubits/map/map/map_cubit.dart';
import '../../../models/booking.dart';
import '../../apply/create_apply_page.dart';

class BottomSheetDetail extends StatelessWidget {
  final Booking book;
  const BottomSheetDetail({
    Key? key,
    required this.book,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 0,
      child: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: Card(
          clipBehavior: Clip.antiAlias,
          child: Padding(
            padding: const EdgeInsets.only(bottom: 20, left: 10, right: 10),
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(
                      onPressed: () {
                        BlocProvider.of<MapCubit>(context).backtoInitial();
                      },
                      icon: const Icon(Icons.close_outlined)),
                ],
              ),
              Text(
                '${book.startPointMainText} - ${book.endPointMainText}',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                '${book.time}',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 10,
              ),
              InkWell(
                onTap: () {
                  appRouter.push(DetailPageRoute(booking: book));
                },
                child: Container(
                  height: MediaQuery.of(context).size.height * 0.1,
                  width: MediaQuery.of(context).size.width * 0.9,
                  decoration: BoxDecoration(
                    color: Colors.grey.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CircleAvatar(
                            radius: 25,
                            backgroundImage: NetworkImage(book.authorAvatar)),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              book.authorName,
                              style: const TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                SvgPicture.asset(
                                  "assets/svg/distance.svg",
                                  height: 30,
                                ),
                                Text(
                                  book.distance,
                                  style: const TextStyle(
                                    fontSize: 14,
                                  ),
                                ),
                                SvgPicture.asset(
                                  "assets/svg/clock.svg",
                                  height: 30,
                                ),
                                Text(
                                  book.duration,
                                  style: const TextStyle(
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            const SizedBox(
                              width: 5,
                            ),
                            Text(
                              '${book.price} VND',
                              style: const TextStyle(
                                  fontSize: 14, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Center(
                  child: GestureDetector(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => CreateApplyPage(booking: book),
                    ),
                  );
                },
                child: Container(
                  decoration: BoxDecoration(
                      color: AppColors.primaryColor,
                      borderRadius: BorderRadius.circular(10)),
                  height: MediaQuery.of(context).size.height * 0.06,
                  width: MediaQuery.of(context).size.width * 0.9,
                  child: const Center(
                    child: Text(
                      'Bắt đầu chuyến đi',
                      style: TextStyle(
                          color: Colors.black, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              )),
            ]),
          ),
        ),
      ),
    );
  }
}
