import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: const Color(0xff03214A), 
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xff021B3A), 
          titleTextStyle: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold
          ),
        ),
        tabBarTheme: const TabBarTheme(
          labelColor: Colors.white, 
          unselectedLabelColor: Color(0xffB0BEC5),
          indicator: BoxDecoration(
            border: Border(
              bottom: BorderSide(color: Color(0xff1E88E5), width: 3),
            ),
          ),
        ),
      ),
      home: DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            title: const Text("Animated Tab"),
            centerTitle: true,
            bottom: const TabBar(
              tabs: [
                Tab(
                  child: Icon(Icons.star, color: Color(0xffFFD700)), 
                ),
                Tab(text: "My Tasks"),
              ],
            ),
          ),
          body: const TabBarView(
            children: [
              FavoritesScreen(),
              MyTasksScreen(),
            ],
          ),
        ),
      ),
    );
  }
}

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        "Favorites Screen",
        style: TextStyle(fontSize: 20, color: Colors.white),
      ),
    );
  }
}

class MyTasksScreen extends StatelessWidget {
  const MyTasksScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        "My Tasks Screen",
        style: TextStyle(fontSize: 20, color: Colors.white),
      ),
    );
  }
}