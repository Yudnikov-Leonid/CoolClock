import 'package:cool_clock/clock_screen/clock_screen.dart';
import 'package:cool_clock/timer_screen/timer_screen.dart';
import 'package:flutter/material.dart';

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
        backgroundColor: Colors.blue.shade100,
        indicatorColor: Colors.blue.shade300,
        height: 60,
        destinations: const [
          NavigationDestination(label: "Clock", icon: Icon(Icons.access_time)),
          NavigationDestination(label: "Timer", icon: Icon(Icons.timer)),
        ],
        selectedIndex: _currentPage,
        onDestinationSelected: (value) {
          _pageController.animateToPage(value,
              duration: const Duration(milliseconds: 100), curve: Curves.easeIn);
        },
      ),
      body: Container(
        color: Colors.blue.shade200,
        height: MediaQuery.of(context).size.height * 0.93,
        child: PageView(
          controller: _pageController,
          children: const [ClockScreen(), TimerScreen()],
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
