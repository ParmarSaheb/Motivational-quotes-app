import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:quotes/favourites/boxes.dart';
import 'package:quotes/favourites/delete_quote.dart';
import 'package:quotes/favourites/model/favmodel.dart';

class Favourites extends StatefulWidget {
  const Favourites({super.key});

  @override
  State<Favourites> createState() => _FavouritesState();
}

class _FavouritesState extends State<Favourites> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 22, 0, 61),
      appBar: AppBar(
        backgroundColor: Colors.deepPurpleAccent.shade400,
        title: Text(
          "Favourites",
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontSize: 25,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: ValueListenableBuilder(
        valueListenable: Boxes.getData().listenable(),
        builder: (context, box, _) {
          final quotes = box.values.toList().cast<FavModel>();
          return buildContent(quotes);
        },
      ),
    );
  }

  Widget buildContent(List<FavModel> quotes) {
    if (quotes.isEmpty) {
      return Center(
        child: Text(
          "No Favourites added yet..!",
          style: GoogleFonts.poppins(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
      );
    } else {
      return ListView.builder(
        itemCount: quotes.length,
        itemBuilder: (context, index) {
          return Card(
            margin: const EdgeInsets.all(2),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            elevation: 4,
            child: ListTile(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              tileColor: const Color.fromARGB(255, 216, 255, 251),
              title: Row(
                children: [
                  Expanded(
                    child: Text(
                      quotes[index].quote,
                      style: GoogleFonts.poppins(
                        fontSize: 20,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      _snackbarMessage("Removed from favourotes..!");
                      deleteQuote(quotes[index]);
                    },
                    icon: const Icon(
                      Icons.remove_circle_outlined,
                      color: Colors.red,
                    ),
                    tooltip: "Remove favourite",
                  ),
                ],
              ),
              subtitle: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    "- ${quotes[index].author}",
                    style: GoogleFonts.poppins(
                      fontSize: 15,
                      color: Colors.black.withOpacity(0.5),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      );
    }
  }

  void _snackbarMessage(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.black,
        duration: const Duration(seconds: 2),
        content: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              msg,
              style: const TextStyle(
                  color: Colors.red, fontWeight: FontWeight.bold),
            ),
            const Icon(
              Icons.delete_sweep_outlined,
              color: Colors.red,
            )
          ],
        ),
      ),
    );
  }
}
