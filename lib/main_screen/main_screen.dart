import 'package:cool_clock/clock_screen/clock_screen.dart';
import 'package:cool_clock/alarm_screen/alarm_screen.dart';
import 'package:cool_clock/stopwatch_screen/stopwatch_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final _pageController = PageController();
  int _currentPage = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: NavigationBar(
        backgroundColor: Colors.blue.shade800,
        indicatorColor: Colors.blue.shade300,
        height: 60,
        destinations: const [
          NavigationDestination(
              label: '',
              icon: Icon(
                Icons.access_time,
                color: Colors.white,
              )),
          NavigationDestination(
              label: "", icon: Icon(Icons.alarm, color: Colors.white)),
          NavigationDestination(
              label: "", icon: Icon(Icons.timer_sharp, color: Colors.white)),
        ],
        selectedIndex: _currentPage,
        onDestinationSelected: (value) {
          _pageController.animateToPage(value,
              duration: const Duration(milliseconds: 100),
              curve: Curves.easeIn);
        },
      ),
      body: Container(
        color: Colors.blue.shade900,
        height: MediaQuery.of(context).size.height * 0.93,
        child: PageView(
          controller: _pageController,
          children: const [ClockScreen(), AlarmScreen(), StopwatchScreen()],
          onPageChanged: (value) {
            setState(() {
              _currentPage = value;
            });
          },
        ),
      ),
    );
  }
}
