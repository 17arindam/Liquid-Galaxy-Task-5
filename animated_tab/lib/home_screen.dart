import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: Color(0xff03214A), // Background color
        appBarTheme: AppBarTheme(
          backgroundColor: Color(0xff021B3A), // Slightly darker for contrast
          titleTextStyle: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        tabBarTheme: TabBarTheme(
          labelColor: Colors.white, // Golden yellow for active tab
          unselectedLabelColor: Color(0xffB0BEC5), // Soft gray for inactive tab
          indicator: BoxDecoration(
            border: Border(
              bottom: BorderSide(color: Color(0xff1E88E5), width: 3), // Blue accent
            ),
          ),
        ),
      ),
      home: DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            title: Text("Animated Tab Effect"),
            centerTitle: true,
            bottom: TabBar(
              tabs: [
                Tab(
                  child: Icon(Icons.star, color: Color(0xffFFD700)), // Golden star
                ),
                Tab(text: "My Tasks"),
              ],
            ),
          ),
          body: TabBarView(
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
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        "Favorites Screen",
        style: TextStyle(fontSize: 20, color: Colors.white),
      ),
    );
  }
}

class MyTasksScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        "My Tasks Screen",
        style: TextStyle(fontSize: 20, color: Colors.white),
      ),
    );
  }
}