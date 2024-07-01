import 'package:flutter/material.dart';
//import 'package:google_fonts/google_fonts.dart';

class PastTestsPage extends StatefulWidget {
  const PastTestsPage({super.key});

  @override
  State<PastTestsPage> createState() => _PastTestsPageState();
}

class _PastTestsPageState extends State<PastTestsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Column(
          children: [
            Expanded(
              flex: 1,
              child: Container(
                decoration: BoxDecoration(
                    gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                      Color(0xFF0038FF),
                      Color(0xFF096CD4),
                      Color(0xFF12A5A5)
                    ])),
                child: Center(
                  child: Text(
                    'APTO',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 80,
                        fontFamily: 'SansitaOne',
                        fontWeight: FontWeight.w900),

                  ),
                ),
              ),
            ),
            Expanded(
                flex: 3,
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 15),
                  color: Colors.white,
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 15.0),
                            child: IconButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                icon: Icon(
                                  Icons.arrow_back_ios,
                                  size: 25,
                                  color: Colors.black,
                                )),
                          ),
                          Center(
                            child: Text(
                              'Past Tests',
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15.0),
                        child: Divider(
                          height: 1,
                          color: Colors.grey.shade400,
                        ),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      SingleChildScrollView(
                        child: Column(
                          children: [
                            Container(
                              height: 50,
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: () {},
                                child: Text(
                                  'Example Test',
                                  style: TextStyle(
                                      fontSize: 18, color: Colors.black),
                                ),
                                style: ButtonStyle(
                                    elevation: MaterialStatePropertyAll(2),
                                    backgroundColor:
                                        MaterialStatePropertyAll(Colors.white)),
                              ),
                            ),
                            Container(
                              height: 50,
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: () {},
                                child: Text(
                                  'Example Test',
                                  style: TextStyle(
                                      fontSize: 18, color: Colors.black),
                                ),
                                style: ButtonStyle(
                                    elevation: MaterialStatePropertyAll(2),
                                    backgroundColor:
                                        MaterialStatePropertyAll(Colors.white)),
                              ),
                            ),
                            Container(
                              height: 50,
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: () {},
                                child: Text(
                                  'Example Test',
                                  style: TextStyle(
                                      fontSize: 18, color: Colors.black),
                                ),
                                style: ButtonStyle(
                                    elevation: MaterialStatePropertyAll(2),
                                    backgroundColor:
                                        MaterialStatePropertyAll(Colors.white)),
                              ),
                            ),
                            Container(
                              height: 50,
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: () {},
                                child: Text(
                                  'Example Test',
                                  style: TextStyle(
                                      fontSize: 18, color: Colors.black),
                                ),
                                style: ButtonStyle(
                                    elevation: MaterialStatePropertyAll(2),
                                    backgroundColor:
                                        MaterialStatePropertyAll(Colors.white)),
                              ),
                            ),
                            Container(
                              height: 50,
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: () {},
                                child: Text(
                                  'Example Test',
                                  style: TextStyle(
                                      fontSize: 18, color: Colors.black),
                                ),
                                style: ButtonStyle(
                                    elevation: MaterialStatePropertyAll(2),
                                    backgroundColor:
                                        MaterialStatePropertyAll(Colors.white)),
                              ),
                            ),
                            Container(
                              height: 50,
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: () {},
                                child: Text(
                                  'Example Test',
                                  style: TextStyle(
                                      fontSize: 18, color: Colors.black),
                                ),
                                style: ButtonStyle(
                                    elevation: MaterialStatePropertyAll(2),
                                    backgroundColor:
                                        MaterialStatePropertyAll(Colors.white)),
                              ),
                            ),
                            Container(
                              height: 50,
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: () {},
                                child: Text(
                                  'Example Test',
                                  style: TextStyle(
                                      fontSize: 18, color: Colors.black),
                                ),
                                style: ButtonStyle(
                                    elevation: MaterialStatePropertyAll(2),
                                    backgroundColor:
                                        MaterialStatePropertyAll(Colors.white)),
                              ),
                            ),
                            Container(
                              height: 50,
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: () {},
                                child: Text(
                                  'Example Test',
                                  style: TextStyle(
                                      fontSize: 18, color: Colors.black),
                                ),
                                style: ButtonStyle(
                                    elevation: MaterialStatePropertyAll(2),
                                    backgroundColor:
                                        MaterialStatePropertyAll(Colors.white)),
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ))
          ],
        ),
      ),
    );
  }
}
