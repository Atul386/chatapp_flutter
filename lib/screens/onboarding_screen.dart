/*
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'home_screen.dart';
import 'login_screen.dart';

class OnboardingScreen extends StatefulWidget {
  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  List<Map<String, String>> onboardingData = [
    {
      "title": "Welcome to Aviary Chat",
      "description": "Connect with your friends and family",
      "image": "assets/images/applogo.png",
    },
    {
      "title": "Chat Anytime",
      "description": "Enjoy seamless chat experience",
      "image": "assets/images/loginimage.1.png",
    },
    {
      "title": "Stay Connected",
      "description": "Stay connected with your loved ones",
      "image": "assets/images/chatpic.jpeg",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepPurple[50],
      body: Stack(
        children: [
          PageView.builder(
            controller: _pageController,
            onPageChanged: (index) {
              setState(() {
                _currentPage = index;
              });
            },
            itemCount: onboardingData.length,
            itemBuilder: (context, index) => OnboardingContent(
              image: onboardingData[index]["image"]!,
              title: onboardingData[index]["title"]!,
              description: onboardingData[index]["description"]!,
            ),
          ),
          Positioned(
            bottom: 20,
            left: 20,
            right: 20,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (_currentPage != onboardingData.length - 1)
                  TextButton(
                    onPressed: () {
                      _pageController.jumpToPage(onboardingData.length - 1);
                    },
                    child: Text("SKIP", style: TextStyle(color: Colors.deepPurpleAccent,fontSize: 20.0),),
                  ),
                Row(
                  children: List.generate(
                    onboardingData.length,
                        (index) => buildDot(index, context),
                  ),
                ),
                if (_currentPage == onboardingData.length - 1)
                  TextButton(
                    onPressed: () async {
                      SharedPreferences prefs = await SharedPreferences.getInstance();
                      await prefs.setBool('seenOnboarding', true);
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) {
                          if (FirebaseAuth.instance.currentUser != null) {
                            return HomeScreen();
                          } else {
                            return LoginScreen();
                          }
                        }),
                      );
                    },
                    child: Text("SIGN IN",style:TextStyle(color: Colors.deepPurpleAccent,fontSize: 20.0),),
                  )
                else
                  TextButton(
                    onPressed: () {
                      _pageController.nextPage(
                        duration: Duration(milliseconds: 300),
                        curve: Curves.ease,
                      );
                    },
                    child: Text("NEXT", style:TextStyle(color: Colors.deepPurpleAccent,fontSize: 20.0),),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  AnimatedContainer buildDot(int index, BuildContext context) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 300),
      margin: EdgeInsets.only(right: 5),
      height: 10,
      width: _currentPage == index ? 20 : 10,
      decoration: BoxDecoration(
        color: _currentPage == index ? Colors.deepPurpleAccent : Colors.grey,
        borderRadius: BorderRadius.circular(5),
      ),
    );
  }
}

class OnboardingContent extends StatelessWidget {
  final String image, title, description;

  const OnboardingContent({
    required this.image,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(
          image,
          height: 300,
          width: double.infinity,
        ),
        SizedBox(height: 20),
        Text(
          title,
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 10),
        Text(
          description,
          style: TextStyle(fontSize: 16),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
} */


import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wave/wave.dart';
import 'package:wave/config.dart';

import 'home_screen.dart';
import 'login_screen.dart';

class OnboardingScreen extends StatefulWidget {
  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  List<Map<String, String>> onboardingData = [
    {
      "title": "Welcome to Aviary Chat",
      "description": "Connect with your friends and family",
      "image": "assets/images/applogo.png",
    },
    {
      "title": "Chat Anytime",
      "description": "Enjoy seamless chat experience",
      "image": "assets/images/loginimage.1.png",
    },
    {
      "title": "Stay Connected",
      "description": "Stay connected with your loved ones",
      "image": "assets/images/chatpic.jpeg",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: WaveWidget(
              config: CustomConfig(
                gradients: [
                  [Colors.deepPurple, Colors.deepPurpleAccent],
                  [Colors.deepPurpleAccent, Colors.deepPurple],
                ],
                durations: [35000, 19440],
                heightPercentages: [0.20, 0.23],
                blur: MaskFilter.blur(BlurStyle.solid, 5),
                gradientBegin: Alignment.bottomLeft,
                gradientEnd: Alignment.topRight,
              ),
              waveAmplitude: 0,
              backgroundColor: Colors.deepPurple[50],
              size: Size(double.infinity, double.infinity),
            ),
          ),
          PageView.builder(
            controller: _pageController,
            onPageChanged: (index) {
              setState(() {
                _currentPage = index;
              });
            },
            itemCount: onboardingData.length,
            itemBuilder: (context, index) => OnboardingContent(
              image: onboardingData[index]["image"]!,
              title: onboardingData[index]["title"]!,
              description: onboardingData[index]["description"]!,
              index: index,
            ),
          ),
          Positioned(
            bottom: 20,
            left: 20,
            right: 20,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (_currentPage != onboardingData.length - 1)
                  TextButton(
                    onPressed: () {
                      _pageController.jumpToPage(onboardingData.length - 1);
                    },
                    child: Text(
                      "SKIP",
                      style: TextStyle(color: Colors.deepPurpleAccent, fontSize: 20.0),
                    ),
                  ),
                Row(
                  children: List.generate(
                    onboardingData.length,
                        (index) => buildDot(index, context),
                  ),
                ),
                if (_currentPage == onboardingData.length - 1)
                  TextButton(
                    onPressed: () async {
                      SharedPreferences prefs = await SharedPreferences.getInstance();
                      await prefs.setBool('seenOnboarding', true);
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) {
                          if (FirebaseAuth.instance.currentUser != null) {
                            return HomeScreen();
                          } else {
                            return LoginScreen();
                          }
                        }),
                      );
                    },
                    child: Text(
                      "SIGN IN",
                      style: TextStyle(color: Colors.white, fontSize: 20.0),
                    ),
                  )
                else
                  TextButton(
                    onPressed: () {
                      _pageController.nextPage(
                        duration: Duration(milliseconds: 300),
                        curve: Curves.ease,
                      );
                    },
                    child: Text(
                      "NEXT",
                      style: TextStyle(color: Colors.white, fontSize: 20.0),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  AnimatedContainer buildDot(int index, BuildContext context) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 300),
      margin: EdgeInsets.only(right: 5),
      height: 10,
      width: _currentPage == index ? 20 : 10,
      decoration: BoxDecoration(
        color: _currentPage == index ? Colors.deepPurpleAccent : Colors.grey,
        borderRadius: BorderRadius.circular(5),
      ),
    );
  }
}

class OnboardingContent extends StatelessWidget {
  final String image, title, description;
  final int index;

  const OnboardingContent({
    required this.image,
    required this.title,
    required this.description,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        FadeInUp(
          duration: Duration(milliseconds: 1000 + index * 200),
          child: Image.asset(
            image,
            height: 300,
            width: double.infinity,
          ),
        ),
        SizedBox(height: 20),
        FadeInUp(
          duration: Duration(milliseconds: 1200 + index * 200),
          child: Text(
            title,
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
            textAlign: TextAlign.center,
          ),
        ),
        SizedBox(height: 10),
        FadeInUp(
          duration: Duration(milliseconds: 1400 + index * 200),
          child: Text(
            description,
            style: TextStyle(fontSize: 16, color: Colors.white70),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }
}
