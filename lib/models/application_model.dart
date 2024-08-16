class Application {
  final String idApp;
  final String name;
  final String description;
  final String contactOrange;
  final String contactMtn;
  final String logo;
  final String version;

  static final columns = [
    "idApp",
    "name",
    "description",
    "contactOrange",
    "contactMtn",
    "logo",
    "version"
  ];
  
  Application(this.idApp, this.name, this.description, this.contactOrange, this.contactMtn, this.logo, this.version);

  factory Application.fromMap(Map<String, dynamic> data) {
    return Application(
        data['idApp'],
        data['name'],
        data['description'],
        data['contactOrange'],
        data['contactMtn'],
        data['logo'],
        data['version']
    );
  }

  Map<String, dynamic> toMap() => {
    "idApp": idApp,
    "name": name,
    "description": description,
    "contactOrange": contactOrange,
    "contactMtn": contactMtn,
    "logo": logo,
    "version": version
  };
}