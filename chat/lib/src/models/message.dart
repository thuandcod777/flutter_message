class Message {
  String get id => _id;
  final String from;
  final String to;
  final DateTime timestamp;
  final String container;
  String _id;

  Message({this.from, this.to, this.timestamp, this.container});

  toJson() => {
        'from': this.from,
        'to': this.to,
        'timestamp': this.timestamp,
        'container': this.container,
      };

  factory Message.fromJson(Map<String, dynamic> json) {
    var message = Message(
        from: json['from'],
        to: json['to'],
        container: json['container'],
        timestamp: json['timestamp']);

    message._id = json['id'];

    return message;
  }
}
