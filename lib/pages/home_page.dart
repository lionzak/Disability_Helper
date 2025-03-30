import 'package:disability_helper/components/emergency_popup.dart';
import 'package:disability_helper/pages/settings_page.dart';
import 'package:disability_helper/services/boxes.dart';
import 'package:disability_helper/services/data_checker.dart';
import 'package:disability_helper/services/health.dart';
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

  void showHealthCard() async {
    if (await isDataExists("Health", boxHealth)) {
      Health health = boxHealth.get("Health");
      String gender = health.isMale ? "Male" : "Female";
      showDialog(
          context: context,
          builder: (context) => AlertDialog(
                title: const Center(
                    child: Text(
                  "Health Card",
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                )),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          "Gender: $gender",
                          style: const TextStyle(
                              fontSize: 25, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text("Age: ${health.age}",
                            style: const TextStyle(
                                fontSize: 25, fontWeight: FontWeight.bold)),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          "Diseases: ",
                          style: TextStyle(
                              fontSize: 25, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    health.diseases!.isNotEmpty
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Column(
                                  children: health.diseases!
                                      .where((e) => e != '')
                                      .map((e) => Container(
                                          margin: const EdgeInsets.all(6),
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width /
                                              2.2,
                                          decoration: BoxDecoration(
                                              color: Colors.grey,
                                              borderRadius:
                                                  BorderRadius.circular(6)),
                                          child: Center(
                                            child: Text(e,
                                                style: const TextStyle(
                                                    fontSize: 25,
                                                    fontWeight:
                                                        FontWeight.bold)),
                                          )))
                                      .toList()),
                            ],
                          )
                        : const Text(
                            "No Diseases",
                            style: TextStyle(
                                fontSize: 25, fontWeight: FontWeight.bold),
                          ),
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          "Allergies: ",
                          style: TextStyle(
                              fontSize: 25, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    health.allergies!.isNotEmpty
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Column(
                                children: health.allergies!
                                    .where((e) => e != '')
                                    .map((e) => Container(
                                        margin: const EdgeInsets.all(6),
                                        width:
                                            MediaQuery.of(context).size.width /
                                                2.2,
                                        decoration: BoxDecoration(
                                            color: Colors.grey,
                                            borderRadius:
                                                BorderRadius.circular(6)),
                                        child: Center(
                                          child: Text(e,
                                              style: const TextStyle(
                                                  fontSize: 25,
                                                  fontWeight: FontWeight.bold)),
                                        )))
                                    .toList(),
                              ),
                            ],
                          )
                        : const Text(
                            "No Allergies",
                            style: TextStyle(
                                fontSize: 25, fontWeight: FontWeight.bold),
                          ),
                  ],
                ),
              ));
    } else {
      showDialog(
          context: context,
          builder: (context) => const AlertDialog(
                  title: Text(
                "Please Add Health Details In Settings!",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              )));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            icon: const Icon(
              Icons.document_scanner_outlined,
              color: Colors.black,
            ),
            onPressed: showHealthCard,
          )
        ],
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
          decoration: const BoxDecoration(color: Color(0XFFb3dfff)),
        ),
        pages[currentIndex]
      ]),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await emergencyPopup(context);
        },
        child: const Icon(
          Icons.sos_sharp,
          size: 30,
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
          backgroundColor: const Color(0XFF0181ff),
          selectedLabelStyle:
              const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          unselectedLabelStyle:
              const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          selectedItemColor: Colors.black,
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
