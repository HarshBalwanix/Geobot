import 'package:flutter/material.dart';
import 'package:geobot_flutter/query.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'query.dart';
import 'sahara.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    theme: ThemeData(
      primarySwatch: Colors.orange,
    ),
    home: ChatApp(),
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
    await launch(url, forceSafariVC: true, forceWebView: true, enableJavaScript: true);
  } else {
    throw "Could not launch $url";
  }
}
class _ChatAppState extends State<ChatApp> {
  final List<String> imageList = [
    "https://www.isro.gov.in/media_isro/image/index/Highlights/Achievements_Space.jpg.webp",
    "https://www.isro.gov.in/media_isro/image/index/Highlights/mahaquizbanner.jpg",
    "https://www.isro.gov.in/media_isro/image/akam-home-banner-eng_medium.jpg.webp",
    "https://www.isro.gov.in/media_isro/image/index/PSLVC56/PSLVC56_PostImg.jpg.webp",
  ];

  Widget _BScard(){
    return Card(
            child: Image.network("https://www.isro.gov.in/media_isro/image/index/GaganyaanTVD1/GaganyaanTVD1.jpg.webp",
              fit: BoxFit.fill,
              width: 150.0,
              height: 150.0,
            ),
            margin: EdgeInsets.only(left: 20, right: 20, top: 20),
          );
  }

  Widget _BSDetails(){
    return SizedBox(
            width: double.infinity,
            height: 100.0, // Adjust the height to decrease the distance
            child: Card(
              child: Padding(
                padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Center(
                      child: Text("ISRO", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
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
        title: Text("Geobot"),
        centerTitle: true,
      ),
      drawer: new Drawer(
       child: new ListView(
        children: [
                 UserAccountsDrawerHeader(
                   accountName: Text("Hi SAHARA!!", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 23),),
                   accountEmail: null,
                   currentAccountPicture: null,
           ),
             Divider(
                color: Colors.orange, // Change the color to your preferred color
                thickness: 2, // Adjust the thickness as needed
                // indent: 20, // Adjust the starting point from the left
                // endIndent: 20, // Adjust the ending point from the right
              ),
           new ListTile(
            title: new Text("ISRO Site!",style: TextStyle( fontSize: 17),),
            leading: new Image.asset('assets/logo.png', width: 35, height: 35), // Adjust width and height as needed
            onTap: (){
              _launchURL(1);
            },
           ),
           Divider(
                color: Colors.lightBlue, // Change the color to your preferred color
                thickness: 2, // Adjust the thickness as needed
                indent: 20, // Adjust the starting point from the left
                endIndent: 20, // Adjust the ending point from the right
              ),
           new ListTile(
            title: new Text("Locate on map",style: TextStyle( fontSize: 17),),
            leading: new Icon(Icons.maps_home_work_rounded),
            onTap: (){
              _launchURL(2);
            },
           ),
           Divider(
                color: Colors.lightBlue, // Change the color to your preferred color
                thickness: 2, // Adjust the thickness as needed
                indent: 20, // Adjust the starting point from the left
                endIndent: 20, // Adjust the ending point from the right
              ),
           new ListTile(
            title: new Text("About SAHARA",style: TextStyle( fontSize: 17),),
            leading: new Icon(Icons.question_mark),
            onTap: (){
              Navigator.push(context, MaterialPageRoute(builder: (context)=>saharapage()));
            },
           ),
           Divider(
                color: Colors.lightBlue, // Change the color to your preferred color
                thickness: 2, // Adjust the thickness as needed
                indent: 20, // Adjust the starting point from the left
                endIndent: 20, // Adjust the ending point from the right
              ),
        ],
       ), 
      ),
      body: ListView(
        padding: EdgeInsets.only(top: 40.0),
        children: [
          Center(
            child: CarouselSlider(
              options: CarouselOptions(
                enlargeCenterPage: true,
                enableInfiniteScroll: true,
                autoPlay: true,
              ),
              items: imageList.map((e) => ClipRRect(
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
              )).toList(),
            ),
          ),
         new Divider(height: 50.0),
         _BScard(),
         _BSDetails(),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
  onPressed: () {
    Navigator.push(context, MaterialPageRoute(builder: (context)=>querypage()));
  },
  icon: Icon(Icons.question_answer),
  label: Text("Enter Query!"),
  tooltip: 'Connect to Geobot',
  backgroundColor: Colors.lightBlue,
),
 
    );
  }
}
