import 'package:flutter/material.dart';

class AproposPage extends StatelessWidget {
  const AproposPage({super.key});

  @override
  Widget build(BuildContext context){
    String image = 'assets/images/abouts.jpg';
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey.shade300,
        elevation: 8,
        titleSpacing: 80,
        title: Text('A Propos',style: TextStyle(color: Colors.black,fontSize: 30.0)),
        actions: <Widget>[
          IconButton(icon: Icon(Icons.share),color: Colors.black87, onPressed: (){},)
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          child: Stack(
            children: <Widget>[
              Container(
                height: 300,
                width: double.infinity,
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage(image),
                        fit: BoxFit.cover
                    )
                ),
              ),
              Container(
                margin: EdgeInsets.fromLTRB(16.0, 250.0,16.0,16.0),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(5.0)
                ),
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text("Trash Hunter", style: Theme.of(context).textTheme.headline6?.apply(color: Colors.black),),
                    SizedBox(height: 10.0),
                    Text("Juillet 03, 2023",style: TextStyle(color: Colors.black ),),
                    SizedBox(height: 10.0),
                    Divider(),
                    SizedBox(height: 10.0,),
                    Row(children: <Widget>[
                      Icon(Icons.favorite_border, color: Colors.black),
                      SizedBox(width: 5.0,),
                      Text("20.2k",style: TextStyle(color: Colors.black),),
                      SizedBox(width: 16.0,),
                      Icon(Icons.comment, color: Colors.black),
                      SizedBox(width: 5.0,),
                      Text("2.2k",style: TextStyle(color: Colors.black),),
                    ],),
                    SizedBox(height: 10.0,),
                    Text("QU'EST CE QUE C'EST?", style: Theme.of(context).textTheme.headline6?.apply(color: Colors.black),),
                    SizedBox(height: 10.0,),
                    Text("Trash de son vrai nom « poubelle », hunter « chasseur », trash hunter et une application avec pour mission la chasse au déchet, conçu dans un contexte où l’insalubrité fait partie intégrante de notre quotidien cette application s’inscrira dans le futur en ce sens où elle permettra à tout citoyen désireux de faire partir de la locomotive « chasse au déchet » de contribuer au développement durable et propre de notre environnement en, téléchargeant juste l’application de s’inscrire et en un seul clic vous viendrons le débarrasser de ses déchets.",style: TextStyle(color: Colors.black ), textAlign: TextAlign.justify,),
                    SizedBox(height: 10.0,),
                    Text("C'EST QUOI EXACTEMENT?", style: Theme.of(context).textTheme.headline6?.apply(color: Colors.black),),
                    SizedBox(height: 10.0),
                    Text("A cette époque on ne devrait plus souffrir pour faire quoi se soit avec un téléphone Android et une petite connexion on télécharge juste l’application et c’est fini tous vos problèmes de déchet et de poubelle partout dans le quartier et même à la maison en un seul clic les chasseurs de poubelle seront déjà à votre porte.",style: TextStyle(color: Colors.black ), textAlign: TextAlign.justify,),
                    SizedBox(height: 10.0,),
                    Text("QUELS SONT LES ATOUTS?", style: Theme.of(context).textTheme.headline6?.apply(color: Colors.black),),
                    SizedBox(height: 10.0),
                    Text("Facilite le drainage des déchets.",style: TextStyle(color: Colors.black ), textAlign: TextAlign.justify,),
                    SizedBox(height: 10.0),
                    Text("Crée un environnement saint.",style: TextStyle(color: Colors.black ), textAlign: TextAlign.justify,),
                    SizedBox(height: 10.0),
                    Text("Améliore la vie des populations.",style: TextStyle(color: Colors.black ), textAlign: TextAlign.justify,),
                    SizedBox(height: 10.0),
                    Text("Diminue le taux de déchet dans la Ville.",style: TextStyle(color: Colors.black ), textAlign: TextAlign.justify,),
                    SizedBox(height: 10.0),
                    Text("Améliore la circulation.",style: TextStyle(color: Colors.black ), textAlign: TextAlign.justify,)
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}