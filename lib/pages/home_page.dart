import 'package:disability_helper/components/emergency_popup.dart';
import 'package:disability_helper/pages/settings_page.dart';
import 'package:disability_helper/widgets/grid_view.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int currentIndex = 0;
  String appBarTitle = 'Home';

  final List<String> pageTitles = [
    'Home',
    'Settings',
  ];

  List<Widget> pages = [
    const GridViewPage(),
    const SettingsPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(appBarTitle),
        titleTextStyle: const TextStyle(
            color: Colors.black, fontSize: 30, fontWeight: FontWeight.bold),
        centerTitle: true,
        backgroundColor: Colors.lightBlue,
      ),
      body: Stack(children: [
        Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          decoration: const BoxDecoration(color: Color(0XFF98B9AB)),
        ),
        pages[currentIndex]
      ]),
      floatingActionButton: FloatingActionButton(
        onPressed: () async{
          await emergencyPopup(context);
        },
        child: const Icon(
          Icons.sos_sharp,
          size: 30,
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
          backgroundColor: const Color(0XFF9BC995),
          onTap: (index) {
            setState(() {
              currentIndex = index;
              appBarTitle = pageTitles[index];
            });
          },
          currentIndex: currentIndex,
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
            BottomNavigationBarItem(
                icon: Icon(Icons.settings), label: "Settings"),
          ]),
    );
  }
}
