import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'dart:async';

bool showSpinner = false;

class TestingPage extends StatefulWidget {
  const TestingPage({Key? key}) : super(key: key);

  @override
  State<TestingPage> createState() => _TestingPageState();
}

class _TestingPageState extends State<TestingPage> {
  String fileURL =
      'https://dugri.bcmschools.org/Upload/Download/e2ee2KYA_QUESTION_BANK.pdf';
  String fileName = 'test_booklet.pdf';

  // Define lists for each question type
  List<List<String>> questions = [
    List.generate(30, (index) => "LA Question ${index + 1}"),
    List.generate(30, (index) => "AR Question ${index + 1}"),
    List.generate(30, (index) => "VR Question ${index + 1}"),
    List.generate(30, (index) => "MR Question ${index + 1}"),
    List.generate(30, (index) => "NA Question ${index + 1}"),
    List.generate(30, (index) => "SA Question ${index + 1}"),
    List.generate(60, (index) => "PA Question ${index + 1}"),
  ];

  Map<String, String> selectedAnswers = {};

  int currentTestIndex = 0; // Keep track of the current test index
  bool testStarted = false;

  late Timer _timer;
  int _start = 600; // 10 minutes in seconds

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  Future<File?> downloadFile() async {
    var time = DateTime.now().millisecondsSinceEpoch;
    Directory directory = await getApplicationDocumentsDirectory();
    String path = "${directory.path}/$fileName";
    File file = File(path);

    try {
      final res = await Dio().get(fileURL,
          options: Options(
              responseType: ResponseType.bytes,
              followRedirects: false,
              receiveTimeout: Duration(milliseconds: 0)));
      final raf = file.openSync(mode: FileMode.write);
      raf.writeFromSync(res.data);
      await raf.close();
      setState(() {
        showSpinner = false;
      });
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              elevation: 10,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15)),
              title: Center(
                child: Text(
                  'Test Downloaded',
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 20),
                ),
              ),
            );
          });
      return file;
    } catch (e) {
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text(
                'Error Downloading File: $e',
                style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 20),
              ),
            );
          });
    }
  }

  Future<bool> checkAndRequestStoragePermission() async {
    var status = await Permission.storage.status;
    if (!status.isGranted) {
      status = await Permission.storage.request();
    }
    return status.isGranted;
  }

  Future<void> _startTestConfirmationDialog() async {
    bool startTest = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Confirmation"),
          content: Text(
              "Are you sure you want to start the test?\n(Please read the instructions on the manual before starting. Clicking on yes will start the test immediately)"),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text("No"),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(true);
                _startTimer();
              },
              child: Text("Yes"),
            ),
          ],
        );
      },
    );
    if (startTest != null && startTest) {
      setState(() {
        testStarted = true;
      });
    }
  }

  void _startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (Timer timer) {
      if (_start == 0) {
        _timer.cancel();
        _submitTest();
      } else {
        setState(() {
          _start--;
        });
      }
    });
  }

  void _submitTest() {
    print("Selected Answers:");
    print(selectedAnswers);

    // Print part answers separately
    print('Test ${currentTestIndex + 1} Answers:');
    print(selectedAnswers);

    // Increment current test index to switch to the next test
    if (currentTestIndex < questions.length - 1) {
      currentTestIndex++;
    } else {
      // Reset current test index if all tests are completed
      currentTestIndex = 0;
    }

    // Reset timer for the next test
    _start = 600;
    _timer.cancel();

    // Reset selected answers for the next test
    selectedAnswers.clear();

    // Start the next test automatically
    _startTestConfirmationDialog();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        floatingActionButton: FloatingActionButton.large(
          elevation: 2,
          backgroundColor: Colors.blue.shade900,
          onPressed: () {
            _submitTest();
          },
          child: Text(
            'SUBMIT',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, fontFamily: 'SansitaOne'),
          ),
        ),
        floatingActionButtonAnimator: FloatingActionButtonAnimator.scaling,
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
        body: ModalProgressHUD(
          inAsyncCall: showSpinner,
          child: Container(
            child: Column(
              children: [
                Expanded(
                  flex: 1,
                  child: Container(
                    color: Colors.blue.shade900,
                    child: Center(
                      child: Text(
                        testStarted
                            ? '${_start ~/ 60}:${(_start % 60).toString().padLeft(2, '0')}'
                            : 'APTO',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 100,
                            fontFamily: 'SansitaOne',
                            fontWeight: FontWeight.w900),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  flex: 5,
                  child: Container(
                    padding: EdgeInsets.all(15),
                    color: Colors.white,
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            ElevatedButton(
                              onPressed: () async {
                                setState(() {
                                  showSpinner = true;
                                });
                                await downloadFile();
                              },
                              style: ButtonStyle(
                                  backgroundColor: MaterialStatePropertyAll(Colors.blue.shade900)),
                              child: Text(
                                'Download Test',
                                style: TextStyle(fontSize: 25),
                              ),
                            ),
                            ElevatedButton(
                              style: ButtonStyle(
                                  backgroundColor: MaterialStatePropertyAll(Colors.white)),
                              onPressed: () {
                                _startTestConfirmationDialog();
                              },
                              child: Text(
                                'Start Test',
                                style: TextStyle(fontSize: 25, color: Colors.black),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 20),
                        if (testStarted)
                          Expanded(
                            child: SingleChildScrollView(
                              child: Column(
                                children: [
                                  _buildQuestionPart(questions[currentTestIndex], "Test ${currentTestIndex + 1}"),
                                ],
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildQuestionPart(List<String> questions, String partTitle) {
    return Column(
      children: [
        SizedBox(height: 20),
        Text(
          partTitle,
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 10),
        ...List.generate(
          questions.length,
              (index) {
            final question = questions[index];
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  question,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 10),
                Row(
                  children: [
                    Radio<String>(
                      value: 'A',
                      groupValue: selectedAnswers[question],
                      onChanged: (value) {
                        setState(() {
                          selectedAnswers[question] = value!;
                        });
                      },
                    ),
                    Text(
                      'A',
                      style: TextStyle(fontSize: 20),
                    ),
                    SizedBox(width: 10),
                    Radio<String>(
                      value: 'B',
                      groupValue: selectedAnswers[question],
                      onChanged: (value) {
                        setState(() {
                          selectedAnswers[question] = value!;
                        });
                      },
                    ),
                    Text(
                      'B',
                      style: TextStyle(fontSize: 20),
                    ),
                    SizedBox(width: 10),
                    Radio<String>(
                      value: 'C',
                      groupValue: selectedAnswers[question],
                      onChanged: (value) {
                        setState(() {
                          selectedAnswers[question] = value!;
                        });
                      },
                    ),
                    Text(
                      'C',
                      style: TextStyle(fontSize: 20),
                    ),
                    SizedBox(width: 10),
                    Radio<String>(
                      value: 'D',
                      groupValue: selectedAnswers[question],
                      onChanged: (value) {
                        setState(() {
                          selectedAnswers[question] = value!;
                        });
                      },
                    ),
                    Text(
                      'D',
                      style: TextStyle(fontSize: 20),
                    ),
                  ],
                ),
                SizedBox(height: 20),
              ],
            );
          },
        ),
      ],
    );
  }
}
