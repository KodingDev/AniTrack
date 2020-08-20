import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:oauth2_client/oauth2_helper.dart';
import 'package:wave/config.dart';
import 'package:wave/wave.dart';

class LoginPage extends StatelessWidget {
  final OAuth2Helper helper;
  final Function callback;

  const LoginPage({Key key, @required this.helper, @required this.callback})
      : assert(helper != null),
        assert(callback != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Container(
            decoration: BoxDecoration(
                image: DecorationImage(
                    colorFilter: ColorFilter.mode(
                        Color(0xFF232628).withOpacity(0.2), BlendMode.dstATop),
                    fit: BoxFit.cover,
                    image: AssetImage("lib/assets/background/login.jpg"))),
            child: Column(
              children: [
                Transform(
                    alignment: Alignment.center,
                    transform: Matrix4.rotationZ(pi),
                    child: WaveWidget(
                        config: CustomConfig(
                          colors: [Color(0xFF1a1c1e)],
                          durations: [20000],
                          heightPercentages: [0.3],
                        ),
                        waveAmplitude: -10,
                        backgroundColor: Color(0x00232628),
                        size: Size.fromHeight(100))),
                Spacer(),
                Image.asset("lib/assets/logo.png",
                    width: 100, height: 60, fit: BoxFit.cover),
                SizedBox(height: 10),
                Text(
                  "Welcome!",
                  style: Theme.of(context).textTheme.headline6,
                ),
                SizedBox(height: 5),
                Text(
                  "Please login to your AniList account.",
                  style: Theme.of(context).textTheme.bodyText2,
                ),
                SizedBox(height: 10),
                RaisedButton(
                  child: Text("Login"),
                  onPressed: () => helper.getToken().then((v) {
                    this.callback.call();
                  }),
                ),
                Spacer(),
                WaveWidget(
                    config: CustomConfig(
                      colors: [Color(0xFF1a1c1e)],
                      durations: [20000],
                      heightPercentages: [0.3],
                    ),
                    waveAmplitude: 10,
                    backgroundColor: Color(0x00232628),
                    size: Size.fromHeight(100))
              ],
            )));
  }
}
