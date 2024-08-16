class Employes {
  final String matricul;
  final String nom;
  final String prenom;
  final String sexe;
  final String date_naissance;
  final String lieu;
  final String cni;
  final String adresse;
  final String contacts;
  final String email;
  final DateTime poste;
  final String profil;
  final String accreditation;
  final String created_at;
  final String updated_at;

  static final columns = [
   "matricul",
   "nom",
   "prenom",
   "sexe",
   "date_naissance",
   "lieu",
   "cni",
   "adresse",
   "contacts",
   "email",
   "poste",
   "profil",
   "accreditation",
   "created_at",
   "updated_at",
  ];

  Employes(
      this.matricul,
      this.nom,
      this.prenom,
      this.sexe,
      this.date_naissance,
      this.lieu,
      this.cni,
      this.adresse,
      this.contacts,
      this.email,
      this.poste,
      this.profil,
      this.accreditation,
      this.created_at,
      this.updated_at,

      );

  factory Employes.fromMap(Map<String, dynamic> data) {
    return Employes(
      data['matricul'],
      data['nom'],
      data['prenom'],
      data['sexe'],
      data['date_naissance'],
      data['lieu_naissance'],
      data['cni'],
      data['adresse'],
      data['contacts'],
      data['email'],
      data['poste'],
      data['profil'],
      data['accreditation'],
      data['created_at'],
      data['updated_at'],
    );
  }

  Map<String, dynamic> toMap() => {
    "matricul":matricul,
    "nom":nom,
    "prenom":prenom,
    "sexe":sexe,
    "date_naissance":date_naissance,
    "lieu_naissance":lieu,
    "cni":cni,
    "adresse":adresse,
    "contacts":contacts,
    "email":email,
    "poste":poste,
    "profil":profil,
    "accreditation":accreditation,
    "created_at":created_at,
    "updated_at":updated_at,
  };
}