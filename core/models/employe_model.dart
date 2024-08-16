class Alerp_employes {
  final String id;
  final String matricul;
  final String noms;
  final String prenoms;
  final String sexe;
  final String date_naissance;
  final String lieu;
  final String cni;
  final String adresse;
  final String contacts;
  final String email;
  final String poste;
  final String profil;
  final String created_at;
  final String updated_at;

  static final columns = [
   "id",
    "matricul",
   "noms",
   "prenoms",
   "sexe",
   "date_naissance",
   "lieu",
   "cni",
   "adresse",
   "contacts",
   "email",
   "poste",
   "profil",
   "created_at",
   "updated_at",
  ];

  Alerp_employes(
      this.id,
      this.matricul,
      this.noms,
      this.prenoms,
      this.sexe,
      this.date_naissance,
      this.lieu,
      this.cni,
      this.adresse,
      this.contacts,
      this.email,
      this.poste,
      this.profil,
      this.created_at,
      this.updated_at,

      );

  factory Alerp_employes.fromMap(Map<String, dynamic> data) {
    return Alerp_employes(
      data['id'],
      data['matricul'],
      data['noms'],
      data['prenoms'],
      data['sexe'],
      data['date_naissance'],
      data['lieu_naissance'],
      data['cni'],
      data['adresse'],
      data['contacts'],
      data['email'],
      data['poste'],
      data['profil'],
      data['created_at'],
      data['updated_at'],
    );
  }

  Map<String, dynamic> toMap() => {
    "id":id,
    "matricul":matricul,
    "noms":noms,
    "prenoms":prenoms,
    "sexe":sexe,
    "date_naissance":date_naissance,
    "lieu_naissance":lieu,
    "cni":cni,
    "adresse":adresse,
    "contacts":contacts,
    "email":email,
    "poste":poste,
    "profil":profil,
    "created_at":created_at,
    "updated_at":updated_at,
  };
}