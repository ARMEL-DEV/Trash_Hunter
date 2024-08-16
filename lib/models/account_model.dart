class Account {
  final String idAccount;
  final String idApp;
  final String idPersonne;
  final String login;
  final String password;
  final String niveauAcces;
  final String statut;

  static final columns = [
    "idAccount",
    "idApp",
    "idPersonne",
    "login",
    "password",
    "niveauAcces",
    "statut"
  ];

  Account(
      this.idAccount,
      this.idApp,
      this.idPersonne,
      this.login,
      this.password,
      this.niveauAcces,
      this.statut
  );

  factory Account.fromMap(Map<String, dynamic> data) {
    return Account(
      data['idAccount'],
      data['idApp'],
      data['idPersonne'],
      data['login'],
      data['password'],
      data['niveauAcces'],
      data['statut']
    );
  }

  Map<String, dynamic> toMap() => {
    "idAccount": idAccount,
    "idApp": idApp,
    "idPersonne": idPersonne,
    "login": login,
    "password": password,
    "niveauAcces": niveauAcces,
    "statut": statut
  };
}