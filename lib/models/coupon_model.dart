class Coupon {
  final String idCoupon;
  final String idPersonne;
  final String Use_idPersonne;
  final String idGain;
  final String dateCoupon;
  final String preuve;
  final String reste;
  final String statut;

  static final columns = [
    "idCoupon",
    "idPersonne",
    "Use_idPersonne",
    "idGain",
    "dateCoupon",
    "preuve",
    "reste",
    "statut"
  ];

  Coupon(
      this.idCoupon,
      this.idPersonne,
      this.Use_idPersonne,
      this.idGain,
      this.dateCoupon,
      this.preuve,
      this.reste,
      this.statut
      );

  factory Coupon.fromMap(Map<String, dynamic> data) {
    return Coupon(
        data['idCoupon'],
        data['idPersonne'],
        data['Use_idPersonne'],
        data['idGain'],
        data['dateCoupon'],
        data['preuve'],
        data['reste'],
        data['statut']
    );
  }

  Map<String, dynamic> toMap() => {
    "idCoupon": idCoupon,
    "idPersonne": idPersonne,
    "Use_idPersonne": Use_idPersonne,
    "idGain": idGain,
    "dateCoupon": dateCoupon,
    "preuve": preuve,
    "reste": reste,
    "statut": statut
  };
}