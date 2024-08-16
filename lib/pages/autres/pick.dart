import 'package:flutter/material.dart';

class Pick extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return PickList();
  }
}
class PickList extends StatefulWidget {
  PickList({Key? key}) : super(key: key);

  _PickListState createState() => _PickListState();
}

class _PickListState extends State<PickList> {
  final TextStyle dropdownMenuItem =
  TextStyle(color: Colors.black, fontSize: 18);

  final primary = Color(0xff696b9e);
  final secondary = Color(0xfff29a94);

  final List<Map> schoolLists = [
    {
      "name": "Sixte KOUAWA",
      "location": "Entree lycee Makepe",
      "type": "Organique et plastique",
      "logoText":
      "https://cdn.pixabay.com/photo/2017/03/16/21/18/logo-2150297_960_720.png"
    },
    {
      "name": "Kevin DJIDJOU",
      "location": "Bepanda One to One",
      "type": "Plastique et metalique",
      "logoText":
      "https://cdn.pixabay.com/photo/2017/01/31/13/14/animal-2023924_960_720.png"
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xfff0f0f0),
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Stack(
            children: <Widget>[
              Container(
                padding: EdgeInsets.only(top: 145),
                height: MediaQuery.of(context).size.height,
                width: double.infinity,
                child: ListView.builder(
                    itemCount: schoolLists.length,
                    itemBuilder: (BuildContext context, int index) {
                      return buildList(context, index);
                    }),
              ),
              Container(
                height: 140,
                width: double.infinity,
                decoration: BoxDecoration(
                    color: primary,
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(30),
                        bottomRight: Radius.circular(30))),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: Icon(
                          Icons.arrow_back,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        "Liste des Tâches à faire",
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      ),
                      IconButton(
                        onPressed: () {
                          // Navigator.push(context,MaterialPageRoute(
                          //     builder: (BuildContext context) => AddAccountPage()));
                        },
                        icon: Icon(
                          Icons.person_add_alt,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                child: Column(
                  children: <Widget>[
                    SizedBox(
                      height: 110,
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Material(
                        elevation: 5.0,
                        borderRadius: BorderRadius.all(Radius.circular(30)),
                        child: TextField(
                          // controller: TextEditingController(text: locations[0]),
                          cursorColor: Theme.of(context).primaryColor,
                          style: dropdownMenuItem,
                          decoration: InputDecoration(
                              hintText: "Recherche d'une commande",
                              hintStyle: TextStyle(
                                  color: Colors.black38, fontSize: 16),
                              prefixIcon: Material(
                                elevation: 0.0,
                                borderRadius:
                                BorderRadius.all(Radius.circular(30)),
                                child: Icon(Icons.search),
                              ),
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.symmetric(
                                  horizontal: 25, vertical: 13)),
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget buildList(BuildContext context, int index) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25),
        color: Colors.white,
      ),
      width: double.infinity,
      height: 110,
      margin: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 50,
                    height: 50,
                    margin: EdgeInsets.only(right: 15),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      border: Border.all(width: 3, color: secondary),
                      image: DecorationImage(
                          image: NetworkImage(schoolLists[index]['logoText']),
                          fit: BoxFit.fill),
                    ),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          schoolLists[index]['name'],
                          style: TextStyle(
                              color: primary,
                              fontWeight: FontWeight.bold,
                              fontSize: 18),
                        ),
                        SizedBox(
                          height: 6,
                        ),
                        Row(
                          children: <Widget>[
                            Icon(
                              Icons.location_on,
                              color: secondary,
                              size: 20,
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Text(schoolLists[index]['location'],
                                style: TextStyle(
                                    color: primary, fontSize: 13, letterSpacing: .3)),
                          ],
                        ),
                        SizedBox(
                          height: 6,
                        ),
                        Row(
                          children: <Widget>[
                            Icon(
                              Icons.restore_from_trash_outlined,
                              color: secondary,
                              size: 20,
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Text(schoolLists[index]['type'],
                                style: TextStyle(
                                    color: primary, fontSize: 13, letterSpacing: .3)),
                          ],
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
          Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
            IconButton(
              onPressed: onPressed, icon: Icon(Icons.start),
              iconSize:20,
              alignment: Alignment.topRight,
            ),
            IconButton(
              onPressed: onPressed, icon: Icon(Icons.start),
              iconSize:20,alignment: Alignment.bottomRight,
            ),
          ]),
        ],
      ),
    );
  }

  void onPressed() {
  }
}
