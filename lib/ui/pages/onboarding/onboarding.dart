import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_message/states_management/onboarding/onboarding_state.dart';
import 'package:provider/provider.dart';
import 'package:flutter_message/colors.dart';
import 'package:flutter_message/states_management/onboarding/onboarding_cubit.dart';
import 'package:flutter_message/states_management/onboarding/profile_image_cubit.dart';
import 'package:flutter_message/ui/widgets/onboarding/logo.dart';
import 'package:flutter_message/ui/widgets/onboarding/profile_upload.dart';
import 'package:flutter_message/ui/widgets/shared/custom_text_field.dart';

class OnBoarding extends StatefulWidget {
  const OnBoarding({Key key}) : super(key: key);

  @override
  _OnBoardingState createState() => _OnBoardingState();
}

class _OnBoardingState extends State<OnBoarding> {
  String _username = '';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
      ),
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _logo(context),
              Spacer(),
              ProfileUpload(),
              Spacer(flex: 1),
              Padding(
                padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                child: CustomTextField(
                  hint: 'input name?',
                  height: 45.0,
                  onchanged: (val) {
                    _username = val;
                  },
                  inputAction: TextInputAction.done,
                ),
              ),
              SizedBox(
                height: 30.0,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 50.0, right: 50.0),
                child: ElevatedButton(
                  onPressed: () async {
                    final error = _checkInput();
                    if (error.isNotEmpty) {
                      final snackBar = SnackBar(
                        content: Text(
                          error,
                          style: TextStyle(
                              fontSize: 14.0, fontWeight: FontWeight.bold),
                        ),
                      );
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      return;
                    }

                    await _connectSession();
                  },
                  child: Container(
                    height: 45.0,
                    alignment: Alignment.center,
                    child: Text(
                      'Ok',
                      style: Theme.of(context)
                          .textTheme
                          .button
                          .copyWith(fontSize: 18.0, color: Colors.white),
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                      primary: kPrimary,
                      elevation: 5.0,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0))),
                ),
              ),
              Spacer(flex: 2),
              BlocBuilder<OnboardingCubit, OnBoardingState>(
                  builder: (context, state) => state is Loading
                      ? Center(child: CircularProgressIndicator())
                      : Container()),
              Spacer(flex: 1),
            ],
          ),
        ),
      ),
    );
  }

  _logo(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Laba',
          style: Theme.of(context)
              .textTheme
              .headline4
              .copyWith(fontWeight: FontWeight.bold),
        ),
        SizedBox(
          width: 8.0,
        ),
        Logo(),
        Text(
          'Laba',
          style: Theme.of(context)
              .textTheme
              .headline4
              .copyWith(fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  _connectSession() async {
    final profileImage = context.read<ProfileImageCubit>().state;
    await context.read<OnboardingCubit>().connect(_username, profileImage);
  }

  String _checkInput() {
    var error = '';
    if (_username.isEmpty) error = 'Enter display name';

    if (context.read<ProfileImageCubit>().state == null)
      error = error + '\n' + 'Upload profile image';

    return error;
  }
}
