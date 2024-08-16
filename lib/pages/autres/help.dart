import 'package:flutter/material.dart';

class AidePage extends StatelessWidget {

  @override
  Widget build(BuildContext context){
    String image = 'assets/images/carousel/g2.jpg';
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey.shade300,
        elevation: 8,
        titleSpacing: 110,
        title: Text('Aide',style: TextStyle(color: Colors.black,fontSize: 30.0)),
        actions: <Widget>[
          IconButton(icon: Icon(Icons.share), onPressed: (){},)
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          child: Stack(
            children: <Widget>[
              Container(
                margin: EdgeInsets.fromLTRB(16.0, 16.0,16.0,16.0),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(5.0)
                ),
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text("E-Learning", style: Theme.of(context).textTheme.headline6?.apply(color: Colors.black),),
                    SizedBox(height: 10.0),
                    Text("Septembre 23, 2021",style: TextStyle(color: Colors.black ),),
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
                    Text("Avec le préfixe « e » pour web, numérique, ou cyber et « learning » pour apprentissage, le e-learning, signifie littéralement : formation sur internet.Nouvelle forme d’apprentissage, le e-learning tire son attrait du fait de pouvoir apprendre à son rythme, sur son ordinateur, des contenus pédagogiques sur des sujets variés. Organisée en sessions ou modules, avec tests d’évaluations, la formation peut-être totalement autogérée et suivie via un tableau de bord qui répertorie chacune des avancées du participant.Pour se former les plateformes se structurent autour de vidéos, d’animations, de textes, et de tests en tout genre.Le but : obtenir pour certaines formations, un certificat d’aptitudes ou de connaissances, mais surtout améliorer son capital connaissance dans un domaine précis.Point positif, les évaluations peuvent être refaites jusqu’à ce que l’exercice soit réussi ou totalement maîtrisé.",style: TextStyle(color: Colors.black ), textAlign: TextAlign.justify,),
                    SizedBox(height: 10.0,),
                    Text("C'EST QUOI EXACTEMENT?", style: Theme.of(context).textTheme.headline6?.apply(color: Colors.black),),
                    SizedBox(height: 10.0),
                    Text("Simplement à l’aide d’un téléphone portable ou d’une tablette il est maintenant possible de permettre aux enfants de suivre des cours au programme et de s\'auto évalué.",style: TextStyle(color: Colors.black ), textAlign: TextAlign.justify,),
                    SizedBox(height: 10.0,),
                    Text("QUELS SONT LES ATOUTS?", style: Theme.of(context).textTheme.headline6?.apply(color: Colors.black),),
                    SizedBox(height: 10.0),
                    Text("Facilité l'apprentissage des jeunnes .",style: TextStyle(color: Colors.black ), textAlign: TextAlign.justify,),
                    SizedBox(height: 10.0),
                    Text("On assosie a chaque leçon des images et ou des videos illustratifs",style: TextStyle(color: Colors.black ), textAlign: TextAlign.justify,),
                    SizedBox(height: 10.0),
                    Text("Assurer la bonne aquisition des connaissance en leurs donnant un test d'abtitude à la fin.",style: TextStyle(color: Colors.black ), textAlign: TextAlign.justify,)
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