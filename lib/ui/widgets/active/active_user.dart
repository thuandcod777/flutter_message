import 'package:chat/chat.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_message/states_management/home/home_cubit.dart';
import 'package:flutter_message/states_management/home/home_state.dart';
import 'package:flutter_message/ui/widgets/home/profile_image.dart';

class ActiveUser extends StatefulWidget {
  const ActiveUser({Key key}) : super(key: key);

  @override
  _ActiveUserState createState() => _ActiveUserState();
}

class _ActiveUserState extends State<ActiveUser> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeState>(
      builder: (_, state) {
        if (state is HomeLoading)
          return Center(child: CircularProgressIndicator());
        if (state is HomeSuccess) return _buildList(state.onlineUser);
        return Container();
      },
    );
  }

  _listItem(User user) => ListTile(
        leading: ProfileImage(
          imageUrl: user.photoUrl,
          online: true,
        ),
        title: Text(
          user.username,
          style: Theme.of(context)
              .textTheme
              .caption
              .copyWith(fontSize: 14.0, fontWeight: FontWeight.bold),
        ),
      );

  _buildList(List<User> users) => ListView.separated(
      padding: EdgeInsets.only(top: 30.0, right: 16.0),
      itemBuilder: (BuildContext context, indx) => _listItem(users[indx]),
      separatorBuilder: (_, __) => Divider(),
      itemCount: users.length);
}
