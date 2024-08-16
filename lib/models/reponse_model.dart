class Reponse {
  final int idReponse;
  final int idPersonne;
  final int idSuggestion;
  final String libelleReponse;
  final String dateReponse;

  static final columns = [
    "idReponse",
    "idPersonne",
    "idSuggestion",
    "libelleReponse",
    "dateReponse"
  ];

  Reponse(
      this.idReponse,
      this.idPersonne,
      this.idSuggestion,
      this.libelleReponse,
      this.dateReponse
      );

  factory Reponse.fromMap(Map<String, dynamic> data) {
    return Reponse(
        data['idReponse'],
        data['idPersonne'],
        data['idSuggestion'],
        data['libelleReponse'],
        data['dateReponse']
    );
  }

  Map<String, dynamic> toMap() => {
    "idReponse": idReponse,
    "idPersonne": idPersonne,
    "idSuggestion": idSuggestion,
    "libelleReponse": libelleReponse,
    "dateReponse": dateReponse
  };
}