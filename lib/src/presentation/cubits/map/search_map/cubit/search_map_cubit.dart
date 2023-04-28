import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'search_map_state.dart';

class SearchMapCubit extends Cubit<SearchMapState> {
  SearchMapCubit() : super(SearchMapInitial());
}
