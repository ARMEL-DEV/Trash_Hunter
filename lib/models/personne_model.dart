class Personne {
  final String idPersonne;
  final String nom;
  final String prenom;
  final String sexe;
  final String email;
  final String contact;
  final String adresse;
  final String profil;
  final String statut;

  static final columns = [
    "idPersonne",
    "nom",
    "prenom",
    "sexe",
    "email",
    "contact",
    "adresse",
    "profil",
    "statut"
  ];

  Personne(
      this.idPersonne,
      this.nom,
      this.prenom,
      this.sexe,
      this.email,
      this.contact,
      this.adresse,
      this.profil,
      this.statut
      );

  factory Personne.fromMap(Map<String, dynamic> data) {
    return Personne(
        data['idPersonne'],
        data['nom'],
        data['prenom'],
        data['sexe'],
        data['email'],
        data['contact'],
        data['adresse'],
        data['profil'],
        data['statut']
    );
  }

  Map<String, dynamic> toMap() => {
    "idPersonne": idPersonne,
    "nom": nom,
    "prenom": prenom,
    "sexe": sexe,
    "email": email,
    "contact": contact,
    "adresse": adresse,
    "profil": profil,
    "statut": statut
  };
}