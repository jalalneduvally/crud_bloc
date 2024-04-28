
import 'package:flutter_bloc/flutter_bloc.dart';

abstract class SearchEvent{}

// class SearchChanged extends SearchEvent{
//   String? selectedValue;
//   SearchChanged(this.selectedValue);
// }

class SearchBloc extends Bloc<SearchEvent,String?> {
  SearchBloc() :super(null) {
    // on<SearchChanged>((event, emit) async {
    //   SearchChanged(event.selectedValue);
    //   emit(event.selectedValue);
    // });
  }
}