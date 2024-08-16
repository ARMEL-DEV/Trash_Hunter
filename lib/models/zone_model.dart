class Zones {
  final String id_zone;
  final String libelle;
  final String statut;

  static final columns = [
    "id_zone",
    "libelle",
    "statut"
  ];

  Zones(
      this.id_zone,
      this.libelle,
      this.statut
      );

  factory Zones.fromMap(Map<String, dynamic> data) {
    return Zones(
        data['id_zone'],
        data['libelle'],
        data['statut']
    );
  }

  Map<String, dynamic> toMap() => {
    "id_zone": id_zone,
    "libelle": libelle,
    "statut": statut
  };
}