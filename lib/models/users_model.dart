class Users {
  final int idPersonne;
  final int trashCash;
  final String fonction;

  static final columns = [
    "idPersonne",
    "trashCash",
    "fonction"
  ];

  Users(
      this.idPersonne,
      this.trashCash,
      this.fonction
      );

  factory Users.fromMap(Map<String, dynamic> data) {
    return Users(
        data['idPersonne'],
        data['trashCash'],
        data['fonction']
    );
  }

  Map<String, dynamic> toMap() => {
    "idPersonne": idPersonne,
    "trashCash": trashCash,
    "fonction": fonction
  };
}