import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quotes/favourites/boxes.dart';
import 'package:quotes/favourites/model/favmodel.dart';
import 'package:quotes/quotes_model.dart';
import 'package:http/http.dart' as http;
import 'package:quotes/restart_app.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

List mylist = [];
bool myfav = false;
bool fav = false;
bool isInternetOn = true;

class QuotesPage extends StatefulWidget {
  const QuotesPage({super.key});

  @override
  State<QuotesPage> createState() => _QuotesPageState();
}

class _QuotesPageState extends State<QuotesPage> {
  Future<List<Quotes>> fetchQuotes(http.Client client) async {
    List<Quotes> list = [];
    final SharedPreferences sp = await SharedPreferences.getInstance();
    String link = "https://mocki.io/v1/728b41e5-3104-4a48-b721-994bd87bc9a8";
    try {
      var res = await http
          .get(Uri.parse(link), headers: {"Accept": "application/json"});
      if (res.statusCode == 200) {
        await sp.setString("quotesSpList", res.body.toString());
        final quotesString = sp.getString('quotesSpList');
        var data = json.decode(quotesString!);
        var rest = data["quotes"] as List;
        list = rest.map<Quotes>((json) => Quotes.fromJson(json)).toList();
      }
    } catch (e) {
      errorCatch();
    }
    return list;
  }

  Future<dynamic> errorCatch() {
    return Navigator.push(
      context,
      MaterialPageRoute(
        builder: ((context) => SafeArea(
              child: Scaffold(
                body: Stack(children: [
                  Align(
                    alignment: Alignment.topRight,
                    child: TextButton.icon(
                      label: const Text("Refresh"),
                      icon: const Icon(Icons.refresh_sharp),
                      onPressed: () {
                        RestartWidget.restartApp(context);
                      },
                    ),
                  ),
                  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Cant able to fetch data..!",
                          textAlign: TextAlign.center,
                          style: GoogleFonts.poppins(
                            color: Colors.red,
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          "Quotes can't be fetched ..\nMake Sure you have good Internet connection..\nOr try again later..!",
                          textAlign: TextAlign.center,
                          style: GoogleFonts.poppins(
                            color: const Color.fromARGB(255, 73, 0, 0),
                            fontSize: 18,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: TextButton.icon(
                      onPressed: () {
                        Navigator.pushNamed(context, "/fav");
                      },
                      icon: const Icon(Icons.favorite),
                      label: const Text('You can watch your favorites..!'),
                    ),
                  )
                ]),
              ),
            )),
      ),
    );
  }

  @override
  void initState() {
    // connection();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Quotes>>(
      future: fetchQuotes(http.Client()),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(
            child: Text(
              "An error has occured..!",
              style: GoogleFonts.poppins(
                color: Colors.red,
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),
          );
        } else if (snapshot.hasData) {
          return DisplayList(
            quotesList: snapshot.data!,
          );
        } else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}

class DisplayList extends StatefulWidget {
  final List<Quotes> quotesList;

  const DisplayList({required this.quotesList, super.key});

  @override
  State<DisplayList> createState() => _DisplayListState();
}

class _DisplayListState extends State<DisplayList> {
  @override
  Widget build(BuildContext context) {
    setState(() {
      mylist = widget.quotesList;
    });
    return ListView.builder(
      reverse: false,
      itemCount: widget.quotesList.length,
      itemBuilder: ((context, index) {
        return Card(
          margin: const EdgeInsets.all(2),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          elevation: 4,
          child: ListTile(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            tileColor: const Color.fromARGB(255, 216, 255, 251),
            title: Row(
              children: [
                Expanded(
                  child: Text(
                    widget.quotesList[index].quote,
                    style: GoogleFonts.poppins(
                      fontSize: 20,
                    ),
                  ),
                ),
                PopupMenuButton(
                    iconSize: 30,                    
                    itemBuilder: ((context) {
                      myfav = Boxes.getData().keys.contains(index);
                      return [
                        PopupMenuItem(
                          child: InkWell(
                            onTap: () {
                              if (myfav == false) {
                                addToFav(
                                  widget.quotesList[index].quote,
                                  widget.quotesList[index].author,
                                  index,
                                );
                                _snackbarMessage("Added to Favourites");
                                setState(() {});
                              } else {
                                _snackbarMessage("Already in Favourites");
                              }
                              Navigator.pop(context);
                            },
                            child: Row(
                              children: [
                                myfav
                                    ? const Icon(
                                        Icons.favorite,
                                        color: Colors.red,
                                      )
                                    : const Icon(
                                        Icons.favorite_border,
                                        color: Color.fromARGB(255, 0, 83, 75),
                                      ),
                                const SizedBox(
                                  width: 10,
                                ),
                                myfav
                                    ? Text(
                                        "Added to fav",
                                        style: GoogleFonts.poppins(
                                          color: const Color.fromARGB(
                                              255, 0, 83, 75),
                                        ),
                                      )
                                    : Text(
                                        "Add to fav",
                                        style: GoogleFonts.poppins(
                                          color: const Color.fromARGB(
                                              255, 0, 83, 75),
                                        ),
                                      ),
                              ],
                            ),
                          ),
                        ),
                        PopupMenuItem(
                          child: InkWell(
                            onTap: () {
                              Navigator.pop(context);
                              String quote =
                                  "'${widget.quotesList[index].quote}' - ${widget.quotesList[index].author}";
                              Share.share(quote);
                            },
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.share,
                                  color: Color.fromARGB(255, 0, 83, 75),
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  "Share",
                                  style: GoogleFonts.poppins(
                                    color: const Color.fromARGB(255, 0, 83, 75),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                        PopupMenuItem(
                          child: InkWell(
                            onTap: () {
                              Navigator.pop(context);

                              String quote =
                                  "'${widget.quotesList[index].quote}' - ${widget.quotesList[index].author}";
                              Clipboard.setData(ClipboardData(text: quote));
                              _snackbarMessage("Copied to clipboard...");
                            },
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.content_copy,
                                  color: Color.fromARGB(255, 0, 83, 75),
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  "Copy",
                                  style: GoogleFonts.poppins(
                                    color: const Color.fromARGB(255, 0, 83, 75),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ];
                    }))
              ],
            ),
            subtitle: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  "- ${widget.quotesList[index].author}",
                  style: GoogleFonts.poppins(
                    fontSize: 15,
                    color: Colors.black.withOpacity(0.5),
                  ),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }

  void addToFav(String quote, String author, int index) {
    final favquote = FavModel(quote: quote, author: author);

    var favquotes = Boxes.getData();
    favquotes.put(index, favquote);
  }

  void _snackbarMessage(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: const Duration(seconds: 2),
        content: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(msg),
            const Icon(
              Icons.done_outlined,
              color: Colors.white,
            )
          ],
        ),
      ),
    );
  }
}
