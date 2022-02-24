import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pazar/shared/components/components.dart';
import 'package:pazar/shared/network/local/cashe_helper.dart';
import 'package:pazar/shared/styles/colors.dart';
import 'package:pazar/user/models/onBoarding_model.dart';
import 'package:pazar/user/modules/login/login_screen.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

// ignore: must_be_immutable
class OnBoardingScreen extends StatefulWidget {
  @override
  _OnBoardingScreenState createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
  var pageController = PageController();

  bool isLast = false;

  List<OnBoardingModel> onBoardingList = [
    OnBoardingModel(
        'assets/images/splash_1.png', 'Pazar', 'Welcome to Pazar Let\'s Shop'),
    OnBoardingModel('assets/images/splash_2.png', 'Pazar',
        'We help people connect with store from the whole world'),
    OnBoardingModel('assets/images/splash_3.png', 'Pazar',
        'We show the easy way to shop just stay at home with us'),
  ];

  void submit() {
    CasheHelper.saveData(key: 'onboarding', value: true).then((value) {
      navigateTo(context, LoginScreen());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          actions: [
            TextButton(
                onPressed: () {
                  submit();
                },
                child: Text('SKIP',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: defaultColor,
                    )))
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              Expanded(
                child: PageView.builder(
                  controller: pageController,
                  itemBuilder: (context, index) =>
                      buildBoardingItem(onBoardingList[index]),
                  itemCount: onBoardingList.length,
                  onPageChanged: (index) {
                    if (index == onBoardingList.length - 1) {
                      setState(() {
                        isLast = true;
                      });
                    } else {
                      isLast = false;
                    }
                  },
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                children: [
                  SmoothPageIndicator(
                    effect: ExpandingDotsEffect(
                        dotColor: Colors.grey,
                        dotHeight: 10,
                        expansionFactor: 4,
                        dotWidth: 10,
                        spacing: 5,
                        activeDotColor: defaultColor),
                    controller: pageController,
                    count: onBoardingList.length,
                  ),
                  Spacer(),
                  FloatingActionButton(
                    backgroundColor: defaultColor,
                    onPressed: () {
                      if (isLast == false) {
                        pageController.nextPage(
                            duration: Duration(microseconds: 750),
                            curve: Curves.fastLinearToSlowEaseIn);
                      } else {
                        submit();
                      }
                    },
                    child: Icon(Icons.arrow_forward_ios_rounded),
                  ),
                ],
              ),
            ],
          ),
        ));
  }

  Widget buildBoardingItem(OnBoardingModel model) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Image(
            image: AssetImage(model.image.toString()),
          ),
        ),
        SizedBox(
          height: 40,
        ),
        Text('${model.title}',
            style: GoogleFonts.lobsterTwo(
                fontSize: 40, fontWeight: FontWeight.bold, color: defaultColor)

            // style: TextStyle(
            //     fontSize: 24, Gog, color: defaultColor),
            ),
        SizedBox(
          height: 10,
        ),
        Text('${model.body}', style: TextStyle(fontSize: 16)),
      ],
    );
  }
}
