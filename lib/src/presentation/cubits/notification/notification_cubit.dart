import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../service/notifi_service.dart';

part 'notification_state.dart';

class NotificationCubit extends Cubit<NotificationState> {
  NotificationCubit() : super(NotificationInitial());

  void init_socket_notifications() {
    // NotificationService()
    //     .showNotification(title: 'Sample title', body: 'It works!');
  }
}
