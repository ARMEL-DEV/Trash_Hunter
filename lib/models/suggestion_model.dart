class Suggestion {
  final int idSuggestion;
  final int idPersonne;
  final String libelle;
  final String description;
  final String dateSuggestion;

  static final columns = [
    "idSuggestion",
    "idPersonne",
    "idSuggestion",
    "libelle",
    "description",
    "dateSuggestion"
  ];

  Suggestion(
      this.idSuggestion,
      this.idPersonne,
      this.libelle,
      this.description,
      this.dateSuggestion
      );

  factory Suggestion.fromMap(Map<String, dynamic> data) {
    return Suggestion(
        data['idSuggestion'],
        data['idPersonne'],
        data['libelle'],
        data['description'],
        data['dateSuggestion']
    );
  }

  Map<String, dynamic> toMap() => {
    "idSuggestion": idSuggestion,
    "idPersonne": idPersonne,
    "libelle": libelle,
    "description": description,
    "dateSuggestion": dateSuggestion
  };
}