class Client {
  final int idPersonne;
  final int idGain;
  final int Cli_idPersonne;
  final String longitude;
  final String latitude;
  final String dateSubscription;
  final int nombreAppel;

  static final columns = [
    "idPersonne",
    "idGain",
    "Cli_idPersonne",
    "longitude",
    "latitude",
    "dateSubscription",
    "nombreAppel"
  ];

  Client(
      this.idPersonne,
      this.idGain,
      this.Cli_idPersonne,
      this.longitude,
      this.latitude,
      this.dateSubscription,
      this.nombreAppel
      );

  factory Client.fromMap(Map<String, dynamic> data) {
    return Client(
        data['idPersonne'],
        data['idGain'],
        data['Cli_idPersonne'],
        data['longitude'],
        data['latitude'],
        data['dateSubscription'],
        data['nombreAppel']
    );
  }

  Map<String, dynamic> toMap() => {
    "idPersonne": idPersonne,
    "idGain": idGain,
    "Cli_idPersonne": Cli_idPersonne,
    "longitude": longitude,
    "latitude": latitude,
    "dateSubscription": dateSubscription,
    "nombreAppel": nombreAppel
  };
}