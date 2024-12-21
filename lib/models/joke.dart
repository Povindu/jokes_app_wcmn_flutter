class Joke {
  final String type;
  final String? joke;
  final String? setup;
  final String? delivery;

  Joke({
    required this.type,
    this.joke,
    this.setup,
    this.delivery,
  });

  factory Joke.fromJson(Map<String, dynamic> json) {
    return Joke(
      type: json['type'],
      joke: json['joke'],
      setup: json['setup'],
      delivery: json['delivery'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'joke': joke,
      'setup': setup,
      'delivery': delivery,
    };
  }

  String get fullJoke {
    if (type == 'single') {
      return joke ?? '';
    } else {
      return '${setup ?? ''}\n${delivery ?? ''}';
    }
  }
}