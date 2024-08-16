class Message {
  final int idMessage;
  final int idPersonne;
  final int idChat;
  final String corpsMessage;
  final String dateMessage;

  static final columns = [
    "idMessage",
    "idPersonne",
    "idChat",
    "corpsMessage",
    "dateMessage"
  ];

  Message(
      this.idMessage,
      this.idPersonne,
      this.idChat,
      this.corpsMessage,
      this.dateMessage
      );

  factory Message.fromMap(Map<String, dynamic> data) {
    return Message(
        data['idMessage'],
        data['idPersonne'],
        data['idChat'],
        data['corpsMessage'],
        data['dateMessage']
    );
  }

  Map<String, dynamic> toMap() => {
    "idMessage": idMessage,
    "idPersonne": idPersonne,
    "idChat": idChat,
    "corpsMessage": corpsMessage,
    "dateMessage": dateMessage
  };
}