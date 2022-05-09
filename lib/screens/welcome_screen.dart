import 'package:flutter/material.dart';
import 'package:hunch/constants.dart';
import 'package:hunch/main.dart';
import 'package:hunch/screens/SigninOrSignup/signInScreen.dart';

void main() {
  runApp(const WelcomeScreen());
}

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Spacer(
            flex: 1,
          ),
          Container(
            alignment: Alignment.centerRight,
            child: FittedBox(
              child: TextButton(
                onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => SigninOrSignupScreen())),
                child: Row(
                  children: [
                    Text(
                      'Skip',
                      style: Theme.of(context).textTheme.bodyText1!.copyWith(
                          color: Theme.of(context)
                              .textTheme
                              .bodyText1!
                              .color!
                              .withOpacity(0.8)),
                    ),
                    Icon(
                      Icons.arrow_forward_ios,
                      size: 16,
                      color: Theme.of(context)
                          .textTheme
                          .bodyText1!
                          .color!
                          .withOpacity(0.8),
                    )
                  ],
                ),
              ),
            ),
          ),
          const Spacer(
            flex: 16,
          ),
          Image.asset("assets/images/welcome-screen1.png"),
          const Spacer(
            flex: 8,
          ),
          Text(
            'Welcome to Hunch!',
            style: Theme.of(context)
                .textTheme
                .headline5!
                .copyWith(fontWeight: FontWeight.bold),
          ),
          const Spacer(
            flex: 1,
          ),
          Text(
            "You have just started to change your life better...",
            style: TextStyle(
              color: Theme.of(context)
                  .textTheme
                  .bodyText1!
                  .color!
                  .withOpacity(0.64),
            ),
          ),
          const Spacer(
            flex: 16,
          ),
        ],
      ),
    ));
  }
}
