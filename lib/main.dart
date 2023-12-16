import 'package:flutter/material.dart';
import 'package:Geobot/query.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'sahara.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    theme: ThemeData(
      primarySwatch: Colors.orange,
    ),
    home: const ChatApp(),
  ));
}

class ChatApp extends StatefulWidget {
  const ChatApp({Key? key}) : super(key: key);

  @override
  State<ChatApp> createState() => _ChatAppState();
}

void _launchURL(int value) async {
  String url = "";
  if (value == 1) {
    url = "https://www.isro.gov.in/";
  } else if (value == 2) {
    url = "https://www.google.com/maps";
  } else if (value == 3) {
    url =
        "https://play.google.com/store/apps/details?id=com.mitf.SaharaMobile&hl=en_IN&gl=US&pli=1";
  }
  if (await canLaunch(url)) {
    await launch(url,
        forceSafariVC: true, forceWebView: true, enableJavaScript: true);
  } else {
    throw "Could not launch $url";
  }
}

class _ChatAppState extends State<ChatApp> {
  final List<String> imageList = [
    "https://pbs.twimg.com/profile_images/1171839413879365632/NaEa4KKY_400x400.jpg",
    "https://pbs.twimg.com/media/EKW29PSUwAA6-T_?format=jpg&name=4096x4096",
    "https://pbs.twimg.com/media/EAAPXZ9UYAIgZCh?format=jpg&name=900x900",
    "https://pbs.twimg.com/profile_banners/1533051649681305603/1654343880/1500x500",
  ];

  Widget _BScard() {
    return Card(
      margin: const EdgeInsets.only(left: 20, right: 20, top: 20),
      child: Image.asset(
        "assets/isromain.jpeg",
        fit: BoxFit.fill,
        width: 150.0,
        height: 150.0,
      ),
    );
  }

  Widget _BSDetails() {
    return const SizedBox(
      width: double.infinity,
      height: 100.0, // Adjust the height to decrease the distance
      child: Card(
        child: Padding(
          padding: EdgeInsets.only(left: 20, right: 20, top: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Center(
                child: Text("ISRO",
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
              ),
              SizedBox(
                width: 135,
                child: Divider(),
              ),
              Center(
                child: Text("Proud of India ❤️"),
              ),
              SizedBox(
                width: 170,
                child: Divider(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Geobot"),
        centerTitle: true,
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            const UserAccountsDrawerHeader(
              accountName: Text(
                "Hi SAHARA!!",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 23),
              ),
              accountEmail: null,
              currentAccountPicture: null,
            ),
            const Divider(
              color: Colors.orange, // Change the color to your preferred color
              thickness: 2, // Adjust the thickness as needed
              // indent: 20, // Adjust the starting point from the left
              // endIndent: 20, // Adjust the ending point from the right
            ),
            ListTile(
              title: const Text(
                "ISRO Site!",
                style: TextStyle(fontSize: 17),
              ),
              leading: Image.asset('assets/logo.png',
                  width: 35, height: 35), // Adjust width and height as needed
              onTap: () {
                _launchURL(1);
              },
            ),
            const Divider(
              color:
                  Colors.lightBlue, // Change the color to your preferred color
              thickness: 2, // Adjust the thickness as needed
              indent: 20, // Adjust the starting point from the left
              endIndent: 20, // Adjust the ending point from the right
            ),
            ListTile(
              title: const Text(
                "Locate on map",
                style: TextStyle(fontSize: 17),
              ),
              leading: const Icon(Icons.maps_home_work_rounded),
              onTap: () {
                _launchURL(2);
              },
            ),
            const Divider(
              color:
                  Colors.lightBlue, // Change the color to your preferred color
              thickness: 2, // Adjust the thickness as needed
              indent: 20, // Adjust the starting point from the left
              endIndent: 20, // Adjust the ending point from the right
            ),
            ListTile(
              title: const Text(
                "About SAHARA",
                style: TextStyle(fontSize: 17),
              ),
              leading: const Icon(Icons.question_mark),
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => saharapage()));
              },
            ),
            const Divider(
              color:
                  Colors.lightBlue, // Change the color to your preferred color
              thickness: 2, // Adjust the thickness as needed
              indent: 20, // Adjust the starting point from the left
              endIndent: 20, // Adjust the ending point from the right
            ),
          ],
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.only(top: 40.0),
        children: [
          Center(
            child: CarouselSlider(
              options: CarouselOptions(
                enlargeCenterPage: true,
                enableInfiniteScroll: true,
                autoPlay: true,
              ),
              items: imageList
                  .map((e) => ClipRRect(
                        borderRadius: BorderRadius.circular(10.0),
                        child: Stack(
                          fit: StackFit.expand,
                          children: [
                            Image.network(
                              e,
                              width: 1050.0,
                              height: 350.0,
                              fit: BoxFit.cover,
                            ),
                          ],
                        ),
                      ))
                  .toList(),
            ),
          ),
          const Divider(height: 50.0),
          _BScard(),
          _BSDetails(),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => QueryPage()));
        },
        icon: const Icon(Icons.question_answer),
        label: const Text("Enter Query!"),
        tooltip: 'Connect to Geobot',
        backgroundColor: Colors.lightBlue,
      ),
    );
  }
}
