class Quotes {
  late String quote;
  late String author;
  bool isFav = false;

  Quotes({
    required this.quote,
    required this.author,
  });

  factory Quotes.fromJson(Map<String, dynamic> json) {
    return Quotes(
      quote: json['quote'] as String,
      author: json['author'] as String,
    );
  }
}
