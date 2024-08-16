class Ramassage {
  final int idRamassage;
  final int idTrash;
  final int idProgramme;
  final String poids;
  final String dateRamassage;
  final String statut;

  static final columns = [
    "idRamassage",
    "idTrash",
    "poids",
    "idProgramme",
    "dateRamassage",
    "statut"
  ];

  Ramassage(
      this.idRamassage,
      this.idTrash,
      this.idProgramme,
      this.poids,
      this.dateRamassage,
      this.statut
      );

  factory Ramassage.fromMap(Map<String, dynamic> data) {
    return Ramassage(
        data['idRamassage'],
        data['idTrash'],
        data['idProgramme'],
        data['poids'],
        data['dateRamassage'],
        data['statut']
    );
  }

  Map<String, dynamic> toMap() => {
    "idRamassage": idRamassage,
    "idTrash": idTrash,
    "idProgramme": idProgramme,
    "poids": poids,
    "dateRamassage": dateRamassage,
    "statut": statut
  };
}