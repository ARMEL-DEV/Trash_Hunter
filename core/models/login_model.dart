class Login {
final String id;
final String id_employe;
final String password;
final String username;
final String accreditation;
final String created_at;
final String updated_at;

static final columns = [
  "id",
  "id_employe",
  "password",
  "username",
  "accreditation",
  "created_at",
  "updated_at",
];

Login(
    this.id,
    this.id_employe,
    this.password,
    this.username,
    this.accreditation,
    this.created_at,
    this.updated_at,
);

factory Login.fromMap(Map<String, dynamic> data) {
return Login(
  data['id'],
  data['id_employe'],
  data['password'],
  data['username'],
  data['accreditation'],
  data['created_at'],
  data['updated_at'],
);
}

Map<String, dynamic> toMap() => {
  "id":id,
  "id_employe":id_employe,
  "password":password,
  "username":username,
  "accreditation":accreditation,
  "created_at":created_at,
  "updated_at":updated_at,
};
}