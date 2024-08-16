import 'package:flutter/material.dart';
final List<String> images= [
  'assets/images/abouts.jpg',
  'assets/images/abouts.jpg',
  'assets/images/abouts.jpg',
  'assets/images/abouts.jpg',
  'assets/images/abouts.jpg',
  'assets/images/abouts.jpg',
  'assets/images/profil.jpeg',
];
class PostPage extends StatelessWidget {
  static const String path = "lib/src/pages/blog/article1.dart";

  const PostPage({super.key});
  @override
  Widget build(BuildContext context) {
    final String image = images[1];
    return Scaffold(
      appBar: AppBar(
        title: const Text('Post'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Stack(
              children: <Widget>[
                SizedBox(
                    height: 300,
                    width: double.infinity,
                    child: Image.asset(
                      image,
                      fit: BoxFit.cover,
                    )),
                Positioned(
                  bottom: 20.0,
                  left: 20.0,
                  right: 20.0,
                  child: Row(
                    children: const <Widget>[
                      Icon(
                        Icons.slideshow,
                        color: Colors.white,
                      ),
                      SizedBox(width: 10.0),
                      Text(
                        "Sante",
                        style: TextStyle(color: Colors.white),
                      )
                    ],
                  ),
                )
              ],
            ),
            Padding(
              padding:
              const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      const Expanded(
                        child: Text("aout 21, 2023"),
                      ),
                      IconButton(
                        icon: const Icon(Icons.share),
                        onPressed: () {},
                      )
                    ],
                  ),
                  Text(
                    "Cerémonie du lancement du ramassage des ordures dans la ville de Dschang",
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const Divider(),
                  const SizedBox(
                    height: 10.0,
                  ),
                  Row(
                    children: const <Widget>[
                      Icon(Icons.favorite_border),
                      SizedBox(
                        width: 5.0,
                      ),
                      Text("20.2k"),
                      SizedBox(
                        width: 16.0,
                      ),
                      Icon(Icons.comment),
                      SizedBox(
                        width: 5.0,
                      ),
                      Text("2.2k"),
                    ],
                  ),
                  const SizedBox(
                    height: 10.0,
                  ),
                  const Text(
                    "Lorem ipsum dolor, sit amet consectetur adipisicing elit. Aperiam, ullam? Fuga doloremque repellendus aut sequi officiis dignissimos, enim assumenda tenetur reprehenderit quam error, accusamus ipsa? Officiis voluptatum sequi voluptas omnis. Lorem ipsum dolor, sit amet consectetur adipisicing elit. Aperiam, ullam? Fuga doloremque repellendus aut sequi officiis dignissimos, enim assumenda tenetur reprehenderit quam error, accusamus ipsa? Officiis voluptatum sequi voluptas omnis.",
                    textAlign: TextAlign.justify,
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}