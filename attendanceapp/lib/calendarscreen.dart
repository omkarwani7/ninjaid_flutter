import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:intl/intl.dart';
import 'package:month_year_picker/month_year_picker.dart';

import 'model/user.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({Key? key}) : super(key: key);

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  double screenHeight = 0;
  double screenWidth = 0;

  Color primary = const Color(0xffeeff444c);

  String _month = DateFormat('MMMM').format(DateTime.now());

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            Container(
              alignment: Alignment.centerLeft,
              margin: EdgeInsets.only(top: 32),
              child: Text(
                "My Attendance",
                style: TextStyle(
                  color: Colors.black,
                  fontFamily: "NexaBold",
                  fontSize: screenWidth / 18,
                ),
              ),
            ),
            Stack(
              children: [
                Container(
                  alignment: Alignment.centerLeft,
                  margin: EdgeInsets.only(top: 32),
                  child: Text(
                    //DateFormat('MMMM').format(DateTime.now()),
                    _month,
                    style: TextStyle(
                      color: Colors.black,
                      fontFamily: "NexaBold",
                      fontSize: screenWidth / 18,
                    ),
                  ),
                ),
                Container(
                  alignment: Alignment.centerRight,
                  margin: EdgeInsets.only(top: 32),
                  child: GestureDetector(
                    onTap: () async {
                      final month = await showMonthYearPicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(2022),
                          lastDate: DateTime(2099),
                          builder: (context, child) {
                            return Theme(
                              data: Theme.of(context).copyWith(
                                colorScheme: ColorScheme.light(
                                  primary: primary,
                                  secondary: primary,
                                  onSecondary: Colors.white,
                                ),
                                textButtonTheme: TextButtonThemeData(
                                  style: TextButton.styleFrom(
                                    primary: primary,
                                  ),
                                ),
                                textTheme: TextTheme(
                                  headline4: TextStyle(
                                    fontFamily: "NexaBold",
                                  ),
                                  overline: TextStyle(
                                    fontFamily: "NexaBold",
                                  ),
                                  button: TextStyle(
                                    fontFamily: "NexaBold",
                                  ),
                                ),
                              ),
                              child: child!,
                            );
                          });

                      if (month != null) {
                        setState(() {
                          _month = DateFormat('MMMM').format(month);
                        });
                      }
                    },
                    child: Text(
                      "Pick a Month",
                      style: TextStyle(
                        color: Colors.black,
                        fontFamily: "NexaBold",
                        fontSize: screenWidth / 18,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: screenHeight / 1.45,
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection("Employee")
                    .doc(User.id)
                    .collection("Record")
                    .snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasData) {
                    final snap = snapshot.data!.docs;
                    return ListView.builder(
                        itemCount: snap.length,
                        itemBuilder: (context, index) {
                          return DateFormat('MMMM')
                                      .format(snap[index]['date'].toDate()) ==
                                  _month
                              ? Container(
                                  margin: EdgeInsets.only(
                                    top: index > 0 ? 12 : 0,
                                    left: 6,
                                    right: 6,
                                  ),
                                  height: 150,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black26,
                                        blurRadius: 10,
                                        offset: Offset(2, 2),
                                      ),
                                    ],
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(20)),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Expanded(
                                        child: Container(
                                          margin: EdgeInsets.only(),
                                          decoration: BoxDecoration(
                                            color: primary,
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(20)),
                                          ),
                                          child: Center(
                                            child: Text(
                                              //snap[index]['date'].toString(),
                                              DateFormat('EE\ndd').format(
                                                  snap[index]['date'].toDate()),
                                              style: TextStyle(
                                                fontFamily: "NexaBold",
                                                fontSize: screenWidth / 18,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Text(
                                              "Check In",
                                              style: TextStyle(
                                                fontFamily: "NexaRegular",
                                                fontSize: screenWidth / 20,
                                                color: Colors.black54,
                                              ),
                                            ),
                                            Text(
                                              snap[index]['checkIn'],
                                              style: TextStyle(
                                                fontFamily: "NexaBold",
                                                fontSize: screenWidth / 18,
                                                color: Colors.black,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Expanded(
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Text(
                                              "CheckOut",
                                              style: TextStyle(
                                                fontFamily: "NexaRegular",
                                                fontSize: screenWidth / 20,
                                                color: Colors.black54,
                                              ),
                                            ),
                                            Text(
                                              snap[index]['checkOut'],
                                              style: TextStyle(
                                                fontFamily: "NexaBold",
                                                fontSize: screenWidth / 18,
                                                color: Colors.black,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              : const SizedBox();
                        });
                  } else {
                    return const SizedBox();
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
