import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'home_page_state.dart';

class HomePageCubit extends Cubit<HomePageState> {
  HomePageCubit() : super(HomePageInitial());

  int current_index = 0;

  void set_current_index(int value) {
    current_index = value;
  }
}
