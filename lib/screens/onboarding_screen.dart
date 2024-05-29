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
      "image": "assets/images/applogo.png",
    },
    {
      "title": "Stay Connected",
      "description": "Stay connected with your loved ones",
      "image": "assets/images/applogo.png",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                    child: Text("SKIP", style: TextStyle(color: Colors.deepPurpleAccent),),
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
                    child: Text("Sign In",style:TextStyle(color: Colors.deepPurpleAccent),),
                  )
                else
                  TextButton(
                    onPressed: () {
                      _pageController.nextPage(
                        duration: Duration(milliseconds: 300),
                        curve: Curves.ease,
                      );
                    },
                    child: Text("NEXT", style:TextStyle(color: Colors.deepPurpleAccent),),
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
}
