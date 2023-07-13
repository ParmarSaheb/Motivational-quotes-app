// ignore_for_file: must_be_immutable

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quotes/quotes_model.dart';
import 'package:http/http.dart' as http;

class QuotesPage extends StatefulWidget {
  const QuotesPage({super.key});

  @override
  State<QuotesPage> createState() => _QuotesPageState();
}

class _QuotesPageState extends State<QuotesPage> {
  Future<List<Quotes>> fetchQuotes(http.Client client) async {
    List<Quotes> list = [];
    String link = "https://mocki.io/v1/e2eb7856-907e-4fd9-b574-4e8bff5c2585";
    try {
      var res = await http
          .get(Uri.parse(link), headers: {"Accept": "application/json"});
      if (res.statusCode == 200) {
        var data = json.decode(res.body);
        var rest = data["quotes"] as List;
        list = rest.map<Quotes>((json) => Quotes.fromJson(json)).toList();
      }
    } catch (e) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: ((context) => SafeArea(
                child: Scaffold(
                  body: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Cant able to fetch data..!",
                          style: GoogleFonts.poppins(
                            color: Colors.red,
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          e.toString(),
                          style: GoogleFonts.poppins(
                            color: const Color.fromARGB(255, 0, 0, 0),
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              )),
        ),
      );
    }

    return list;
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
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}

class DisplayList extends StatelessWidget {
  List<Quotes> quotesList;
  DisplayList({required this.quotesList, super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      reverse: false,
      itemCount: quotesList.length,
      itemBuilder: ((context, index) {
        return Card(
          margin: EdgeInsets.only(right: 0),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          elevation: 4,
          child: ListTile(
            tileColor: const Color.fromARGB(255, 216, 255, 251),
            title: Row(
              children: [
                Expanded(
                  child: Text(
                    quotesList[index].quote,
                    style: GoogleFonts.poppins(
                      fontSize: 20,
                    ),
                  ),
                ),
                PopupMenuButton(itemBuilder: ((context) {
                  return [
                    const PopupMenuItem(
                        child: ListTile(
                      title: Text("Copy"),
                      leading: Icon(Icons.content_copy),
                    ))
                  ];
                }))
              ],
            ),
            subtitle: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  "- ${quotesList[index].author}",
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
}
