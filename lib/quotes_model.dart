class Quotes {
  final String quote;
  final String author;

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
