class TypeTrash {
  final String idType;
  final String libelle;
  final String description;

  static final columns = [
    "idType",
    "libelle",
    "description"
  ];

  TypeTrash(
      this.idType,
      this.libelle,
      this.description
      );

  factory TypeTrash.fromMap(Map<String, dynamic> data) {
    return TypeTrash(
        data['idType'],
        data['libelle'],
        data['description']
    );
  }

  Map<String, dynamic> toMap() => {
    "idType": idType,
    "libelle": libelle,
    "description": description
  };
}