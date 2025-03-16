import 'package:animated_icons/utils/rive_asset.dart';
import 'package:animated_icons/utils/rive_utils.dart';
import 'package:flutter/material.dart';
import 'package:rive/rive.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(child: Text("Home Screen", style: TextStyle(fontSize: 24)));
  }
}

class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(child: Text("Chat Screen", style: TextStyle(fontSize: 24)));
  }
}

class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(child: Text("Search Screen", style: TextStyle(fontSize: 24)));
  }
}

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(child: Text("Notification Screen", style: TextStyle(fontSize: 24)));
  }
}

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(child: Text("Profile Screen", style: TextStyle(fontSize: 24)));
  }
}

class BottomNavigationScreen extends StatefulWidget {
  const BottomNavigationScreen({super.key});

  @override
  State<BottomNavigationScreen> createState() => _BottomNavigationScreenState();
}

class _BottomNavigationScreenState extends State<BottomNavigationScreen> {
  List<RiveAsset> bottomNavs = [
    RiveAsset(
        src: "assets/animated_icon_set.riv",
        artboard: "HOME",
        stateMachineName: "HOME_interactivity",
        title: "Home"),
    RiveAsset(
        src: "assets/animated_icon_set.riv",
        artboard: "CHAT",
        stateMachineName: "CHAT_Interactivity",
        title: "Chat"),
    RiveAsset(
        src: "assets/animated_icon_set.riv",
        artboard: "SEARCH",
        stateMachineName: "SEARCH_Interactivity",
        title: "Search"),
    RiveAsset(
        src: "assets/animated_icon_set.riv",
        artboard: "BELL",
        stateMachineName: "BELL_Interactivity",
        title: "Notification"),
    RiveAsset(
        src: "assets/animated_icon_set.riv",
        artboard: "USER",
        stateMachineName: "USER_Interactivity",
        title: "Profile"),
  ];

  final List<Widget> screens = [
    const HomeScreen(),
    const ChatScreen(),
    const SearchScreen(),
    const NotificationScreen(),
    const ProfileScreen(),
  ];

  int currentIndex = 0; 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: currentIndex,
        children: screens,
      ),
      bottomNavigationBar: SafeArea(
        child: Container(
          padding: const EdgeInsets.all(12),
          margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          decoration: BoxDecoration(
            color: Colors.black45,
            borderRadius: BorderRadius.circular(24),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(
              bottomNavs.length,
              (index) => GestureDetector(
                onTap: () {
                  setState(() {
                    currentIndex = index;
                  });

                  if (bottomNavs[index].input != null) {
                    bottomNavs[index].input!.change(true);
                    Future.delayed(const Duration(seconds: 1), () {
                      bottomNavs[index].input!.change(false);
                    });
                  }
                },
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      height: 36,
                      width: 36,
                      child: Opacity(
                        opacity: currentIndex == index ? 1 : 0.5,
                        child: RiveAnimation.asset(
                          bottomNavs.first.src,
                          artboard: bottomNavs[index].artboard,
                          onInit: (artboard) {
                            StateMachineController controller =
                                RiveUtils.getRiveController(artboard,
                                    stateMachineName:
                                        bottomNavs[index].stateMachineName);
                            bottomNavs[index].input =
                                controller.findSMI("active") as SMIBool;
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      bottomNavs[index].title,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight:
                            currentIndex == index ? FontWeight.bold : FontWeight.normal,
                        color: currentIndex == index ? Colors.white : Colors.white70,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
