class Gain {
  final String idGain;
  final String idPersonne;
  final String libelle;
  final String description;
  final String total;
  final String dateAjout;
  final String statut;

  static final columns = [
    "idGain",
    "idPersonne",
    "libelle",
    "description",
    "total",
    "dateAjout",
    "statut"
  ];

  Gain(
      this.idGain,
      this.idPersonne,
      this.libelle,
      this.description,
      this.total,
      this.dateAjout,
      this.statut
      );

  factory Gain.fromMap(Map<String, dynamic> data) {
    return Gain(
        data['idGain'],
        data['idPersonne'],
        data['libelle'],
        data['description'],
        data['total'],
        data['dateAjout'],
        data['statut']
    );
  }

  Map<String, dynamic> toMap() => {
    "idGain": idGain,
    "idPersonne": idPersonne,
    "libelle": libelle,
    "description": description,
    "total": total,
    "dateAjout": dateAjout,
    "statut": statut
  };
}