import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// class DropdownEvent extends Equatable{
// var  value;
//  DropdownEvent(this.value);
//
// @override
//   List<Object?> get props =>[value];
// }
// class DropBloc extends Bloc{
//   DropBloc():super(null);
//
//
// }

abstract class DropDownEvent{}

class DropDownChanged extends DropDownEvent{
   String? selectedValue;
  DropDownChanged(this.selectedValue);
}
//
// abstract class DropDownState{}
// class DropDownUpdated extends DropDownState{
//   final String selectedValue;
//   DropDownUpdated(this.selectedValue);
// }

 class DropDownBloc extends Bloc<DropDownEvent,String?>{
  DropDownBloc():super(null){
    on<DropDownChanged>((event, emit)async {
      // DropDownChanged(event.selectedValue);
      emit(event.selectedValue);
    });
  }

  // @override
  // Stream _mapEventToState(DropDownChanged event)async*{
  //   yield DropDownUpdated(event.selectedValue);
  // }
}

abstract class RadioButtonEvent{}

class ChangeValue extends RadioButtonEvent{
  bool value;
  ChangeValue(this.value);
}

class RadioBloc extends Bloc<RadioButtonEvent,bool>{
  RadioBloc():super(true){
    on<ChangeValue>((event, emit){
      emit(event.value =! event.value);
    });
  }
}