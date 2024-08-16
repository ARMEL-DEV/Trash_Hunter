class News {
  final String idNew;
  final String idPersonne;
  final String libelle;
  final String description;
  final String time;
  final String image;
  final String statut;

  static final columns = [
    "idNew",
    "idPersonne",
    "libelle",
    "description",
    "time",
    "image",
    "statut"
  ];

  News(
      this.idNew,
      this.idPersonne,
      this.libelle,
      this.description,
      this.time,
      this.image,
      this.statut
      );

  factory News.fromMap(Map<String, dynamic> data) {
    return News(
        data['idNew'],
        data['idPersonne'],
        data['libelle'],
        data['description'],
        data['time'],
        data['image'],
        data['statut']
    );
  }

  Map<String, dynamic> toMap() => {
    "idNew": idNew,
    "idPersonne": idPersonne,
    "libelle": libelle,
    "description": description,
    "time": time,
    "image": image,
    "statut": statut
  };
}