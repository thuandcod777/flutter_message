import 'package:flutter/material.dart';
import 'package:flutter_message/states_management/home/home_cubit.dart';
import 'package:flutter_message/states_management/home/home_state.dart';
import 'package:flutter_message/ui/widgets/active/active_user.dart';
import 'package:flutter_message/ui/widgets/chats/chats.dart';
import 'package:flutter_message/ui/widgets/home/profile_image.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Home extends StatefulWidget {
  const Home();

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  void initState() {
    super.initState();
    context.read<HomeCubit>().activeUsers();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Container(
            width: double.maxFinite,
            child: Row(
              children: [
                ProfileImage(
                  imageUrl: "https://picsum.photos/seed/picsum/200/300",
                  online: true,
                ),
                Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 10.0),
                      child: Text(
                        'Messi',
                        style: Theme.of(context).textTheme.caption.copyWith(
                            fontSize: 14.0, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 10.0),
                      child: Text(
                        'Online',
                        style: Theme.of(context).textTheme.caption,
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
          bottom: TabBar(
            indicatorPadding: EdgeInsets.only(top: 10.0, bottom: 10.0),
            tabs: [
              Tab(
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50.0),
                  ),
                  child: Align(
                    alignment: Alignment.center,
                    child: Text(
                      'Messages',
                    ),
                  ),
                ),
              ),
              Tab(
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50.0),
                  ),
                  child: Align(
                    alignment: Alignment.center,
                    child: BlocBuilder<HomeCubit, HomeState>(
                        builder: (_, state) => state is HomeSuccess
                            ? Text('Active(${state.onlineUser.length})')
                            : Text('Active(0)')),
                  ),
                ),
              )
            ],
          ),
        ),
        body: TabBarView(
          children: [
            Container(
              child: Chats(),
            ),
            Container(
              child: ActiveUser(),
            )
          ],
        ),
      ),
    );
  }
}
