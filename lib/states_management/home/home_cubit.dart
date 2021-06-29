import 'package:bloc/bloc.dart';
import 'package:chat/chat.dart';
import 'package:flutter_message/states_management/home/home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  IUserService _userService;
  HomeCubit(this._userService) : super(HomeInitial());

  Future<void> activeUsers() async {
    emit(HomeLoading());
    final users = await _userService.online();
    emit(HomeSuccess(users));
  }
}
