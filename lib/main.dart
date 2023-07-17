import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:path_provider/path_provider.dart';
import 'package:quotes/favourites/favmain.dart';
import 'package:quotes/favourites/model/favmodel.dart';
import 'package:quotes/quotes_page.dart';
import 'package:quotes/restart_app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  Directory directory = await getApplicationDocumentsDirectory();
  await Hive.initFlutter(directory.path);
  Hive.registerAdapter(FavModelAdapter());
  await Hive.openBox<FavModel>("favquotes");

  runApp(const RestartWidget(child:  MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    const appTitle = "Motiv Quotes";
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: appTitle,
      routes: {"/fav": (context) => const Favourites()},
      theme: ThemeData(
        primaryColor: Colors.teal,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.tealAccent),
      ),
      home: const MyHomePage(title: appTitle),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(
          widget.title,
          style: GoogleFonts.poppins(
            color: Colors.black,
            fontSize: 25,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          PopupMenuButton(
            iconSize: 30,
            splashRadius: 60,
            icon: const Icon(
              Icons.more_vert,
              color: Colors.black,
            ),
            itemBuilder: (context) => [
              PopupMenuItem(
                child: InkWell(
                  onTap: () {
                    Navigator.pop(context);
                    _gotofav();
                  },
                  child: Row(
                    children: [
                      const Icon(
                        Icons.favorite,
                        color: Color.fromARGB(255, 0, 83, 75),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Text(
                        "Favorites",
                        style: GoogleFonts.poppins(
                          color: const Color.fromARGB(255, 0, 83, 75),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ],
          )
        ],
      ),
      body: const QuotesPage(),
    );
  }

  void _gotofav() {
    Navigator.pushNamed(context, "/fav");
  }
}
