class Chat {
  final int idChat;
  final String sujet;
  final String time;

  static final columns = [
    "idChat",
    "sujet",
    "time"
  ];

  Chat(this.idChat, this.sujet, this.time);

  factory Chat.fromMap(Map<String, dynamic> data) {
    return Chat(
        data['idChat'],
        data['sujet'],
        data['time']
    );
  }

  Map<String, dynamic> toMap() => {
    "idChat": idChat,
    "sujet": sujet,
    "time": time
  };
}