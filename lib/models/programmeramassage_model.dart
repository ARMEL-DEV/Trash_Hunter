class ProgrammeRamassage {
  final String idProgramme;
  final String idPersonne;
  final String zone;
  final String dateProgrammation;
  final String statut;

  static final columns = [
    "idProgramme",
    "idPersonne",
    "zone",
    "dateProgrammation",
    "statut"
  ];

  ProgrammeRamassage(
      this.idProgramme,
      this.idPersonne,
      this.zone,
      this.dateProgrammation,
      this.statut
      );

  factory ProgrammeRamassage.fromMap(Map<String, dynamic> data) {
    return ProgrammeRamassage(
        data['idProgramme'],
        data['idPersonne'],
        data['zone'],
        data['dateProgrammation'],
        data['statut']
    );
  }

  Map<String, dynamic> toMap() => {
    "idProgramme": idProgramme,
    "idPersonne": idPersonne,
    "zone": zone,
    "dateProgrammation": dateProgrammation,
    "statut": statut
  };
}