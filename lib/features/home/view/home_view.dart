import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:twitter_clone/constants/constants.dart';
import 'package:twitter_clone/features/home/widgets/side_drawer.dart';
import 'package:twitter_clone/features/tweet/views/create_tweet_view.dart';
import 'package:twitter_clone/theme/pallete.dart';

import '../../../core/utils.dart';

class HomeView extends StatefulWidget {
  static route() => MaterialPageRoute(
        builder: (context) => const HomeView(),
      );
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  int _page = 0;
  final appBar = UIConstants.appBar();
  bool _buttonEnabled = true;
  void onPageChange(int index) {
    setState(() {
      _page = index;
    });
  }

  onCreateTweet() {
    if (_buttonEnabled) {
      // disable the button
      setState(() {
        _buttonEnabled = false;
      });
      // start a 24-hour countdown
      Timer(const Duration(hours: 24), () {
        // enable the button
        setState(() {
          _buttonEnabled = true;
        });
      });
      Navigator.push(context, CreateTweetScreen.route());

      // your button logic here
    } else {
      // String strDigits(int n) => n.toString().padLeft(2, '0');
      // final myDuration = Duration(hours: _lastPressedAt!.hour);
      // // final days = strDigits(myDuration.inDays);
      // final hours = strDigits(myDuration.inHours.remainder(24));
      // final minutes = strDigits(myDuration.inMinutes.remainder(60));
      // final seconds = strDigits(myDuration.inSeconds.remainder(60));
      // button is disabled
      // you can show a message to the user or just do nothing
      showSnackBar(
        context,
        'Your Next Post is 24 hours away',
        // '$hours:$minutes:$seconds remaining for next post!',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _page == 0 ? appBar : null,
      body: IndexedStack(
        index: _page,
        children: UIConstants.bottomTabBarPages,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: onCreateTweet,
        child: const Icon(
          Icons.add,
          color: Pallete.whiteColor,
          size: 28,
        ),
      ),
      drawer: const SideDrawer(),
      bottomNavigationBar: CupertinoTabBar(
        currentIndex: _page,
        onTap: onPageChange,
        backgroundColor: Pallete.darkPurpleColor,
        items: [
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              _page == 0
                  ? AssetsConstants.homeFilledIcon
                  : AssetsConstants.homeOutlinedIcon,
              color: Pallete.purpleAccentColor,
            ),
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              AssetsConstants.searchIcon,
              color: Pallete.purpleAccentColor,
            ),
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              _page == 2
                  ? AssetsConstants.notifFilledIcon
                  : AssetsConstants.notifOutlinedIcon,
              color: Pallete.purpleAccentColor,
            ),
          ),
        ],
      ),
    );
  }
}
