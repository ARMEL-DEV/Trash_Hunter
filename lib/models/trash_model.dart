class Trash_Model {
  final String idTrash;
  final String idType;
  final String idPersonne;
  final String gender;
  final String image;
  final String dateEnregistrement;
  final String statut;

  static final columns = [
    "idTrash",
    "idType",
    "idPersonne",
    "gender",
    "image",
    "dateEnregistrement",
    "statut"
  ];

  Trash_Model(
      this.idTrash,
      this.idType,
      this.idPersonne,
      this.gender,
      this.image,
      this.dateEnregistrement,
      this.statut
      );

  factory Trash_Model.fromMap(Map<String, dynamic> data) {
    return Trash_Model(
        data['idTrash'],
        data['idType'],
        data['idPersonne'],
        data['gender'],
        data['image'],
        data['dateEnregistrement'],
        data['statut']
    );
  }

  Map<String, dynamic> toMap() => {
    "idTrash": idTrash,
    "idType": idType,
    "idPersonne": idPersonne,
    "gender": gender,
    "image": image,
    "dateEnregistrement": dateEnregistrement,
    "statut": statut
  };
}