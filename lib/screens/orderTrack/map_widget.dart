
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'distanceTime_box.dart';

Widget bottomDistanceCancelBtn(BuildContext context, rideTime, ridedistance,id) {
  return Positioned(
    bottom: 0,
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        DistanceTimeEstimateBox(
            etaInMinutes: rideTime, distanceInKM: ridedistance),
        // cancelButton(context),
      ],
    ),
  );
}

Widget requestCard(BuildContext context, Function onTap) {
  final width = MediaQuery.of(context).size.width;
  final height = MediaQuery.of(context).size.height;
  return Positioned(
    bottom: 0,
    child: Container(
      height: 200,
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 20,
      ),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(40),
          topRight:  Radius.circular(40),
        ),
      ),
      child: SingleChildScrollView(
        child: Column(
          children: [
            const Text("All Request"),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.35,
              child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('drivers')
                      .doc(FirebaseAuth.instance.currentUser!.uid)
                      .collection("requests")
                      .where("status", isEqualTo: "confirmed")
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return const Center(child: const CircularProgressIndicator());
                    } else if (snapshot.hasData) {
                      return SizedBox(
                        height: MediaQuery.of(context).size.height * 0.7,
                        child: snapshot.data!.docs.isNotEmpty
                            ? ListView.builder(
                                shrinkWrap: true,
                                itemCount: snapshot.data!.docs.length,
                                itemBuilder: (context, index) {
                                  DocumentSnapshot data =
                                      snapshot.data!.docs[index];
                                  return Container(
                                    margin: const EdgeInsets.symmetric(
                                      vertical: 10,
                                    ),
                                    child: Card(
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(15.0),
                                        ),
                                        color: Colors.white,
                                        elevation: 5,
                                        child: Container(
                                          padding: const EdgeInsets.all(5),
                                          child: Column(
                                            children: [
                                              Container(
                                                height: height * 0.07,
                                                width: MediaQuery.of(context)
                                                    .size
                                                    .width,
                                                child: Row(
                                                  //crossAxisAlignment: CrossAxisAlignment.start,
                                                  //mainAxisAlignment: MainAxisAlignment.start,
                                                  children: <Widget>[
                                                    Container(
                                                      height: height * 0.06,
                                                      width: height * 0.06,
                                                      child: Image.network(
                                                          data['serviceImage'],
                                                          fit: BoxFit.fill),
                                                      alignment:
                                                          Alignment.centerRight,
                                                      decoration: BoxDecoration(
                                                          color:
                                                              const Color(0xFF222222),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      10)),
                                                    ),
                                                    Container(
                                                      padding: EdgeInsets.only(
                                                          left: width * 0.02,
                                                          top: width * 0.02),
                                                      child: Column(
                                                        //mainAxisAlignment: MainAxisAlignment.start,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,

                                                        children: <Widget>[
                                                          Row(
                                                            //crossAxisAlignment: CrossAxisAlignment.start,
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Text(
                                                                data[
                                                                    'serviceTitle'],
                                                                overflow:
                                                                    TextOverflow
                                                                        .ellipsis,
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .black,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    fontSize: MediaQuery.of(context)
                                                                            .size
                                                                            .width *
                                                                        0.03),
                                                              ),
                                                              const SizedBox(
                                                                width: 5,
                                                              ),
                                                              Text(
                                                                '\$${data['maxPrice']}' +
                                                                    '-' +
                                                                    '\$${data['minPrice']}',
                                                                overflow:
                                                                    TextOverflow
                                                                        .ellipsis,
                                                                style:
                                                                    TextStyle(
                                                                  color: Colors
                                                                      .black,
                                                                  //fontFamily: "Poppins-Medium",
                                                                  //fontWeight: FontWeight.bold,
                                                                  fontSize: MediaQuery.of(
                                                                              context)
                                                                          .size
                                                                          .width *
                                                                      0.025,
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                          const SizedBox(
                                                            height: 10,
                                                          ),
                                                          Text(
                                                            data['description'],
                                                            style: TextStyle(
                                                              color:
                                                                  Colors.black,
                                                              //fontWeight: FontWeight.bold,
                                                              //fontFamily: "Poppins-Semibold",
                                                              fontSize: MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .width *
                                                                  0.025,
                                                            ),
                                                            maxLines: 1,
                                                            overflow:
                                                                TextOverflow
                                                                    .fade,
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    Container(
                                                      // color: Colors.amber,
                                                      padding: EdgeInsets.only(
                                                          left: width * 0.1,
                                                          top: width * 0.02,
                                                          right: 5),
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: <Widget>[
                                                          Text(
                                                            data['date'],
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .black,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                fontSize: MediaQuery.of(
                                                                            context)
                                                                        .size
                                                                        .width *
                                                                    0.03),
                                                          ),
                                                          const SizedBox(
                                                            height: 10,
                                                          ),
                                                          Text(
                                                            data['time'],
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .black,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                fontSize: MediaQuery.of(
                                                                            context)
                                                                        .size
                                                                        .width *
                                                                    0.03),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              SizedBox(
                                                height: width * 0.008,
                                              ),
                                              InkWell(
                                                onTap: onTap(),
                                                child: Card(
                                                  child: Container(
                                                    width: width * 0.65,
                                                    // height: height * 0.06,
                                                    decoration: BoxDecoration(
                                                      //boxShadow: Colors.grey,
                                                      color: Colors.white,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10),
                                                    ),
                                                    child: Row(
                                                      children: [
                                                        SizedBox(
                                                          width: width * 0.12,
                                                          //height: height*0.04,

                                                          child: const Icon(
                                                            Icons
                                                                .location_on_sharp,
                                                            color: Colors.red,
                                                            size: 40,
                                                          ),
                                                        ),
                                                        const SizedBox(
                                                          width: 3,
                                                        ),
                                                        Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: [
                                                            const Padding(
                                                              padding:  EdgeInsets
                                                                  .only(
                                                                      top: 10),
                                                              child: Text(
                                                                'Appointment Location',
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        15,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    color: Colors
                                                                        .black),
                                                                overflow:
                                                                    TextOverflow
                                                                        .ellipsis,
                                                                textAlign:
                                                                    TextAlign
                                                                        .start,
                                                                maxLines: 1,
                                                              ),
                                                            ),
                                                            const SizedBox(
                                                              height: 4,
                                                            ),
                                                            Padding(
                                                              padding: const EdgeInsets
                                                                  .only(
                                                                      bottom:
                                                                          10),
                                                              child: Text(
                                                                data['address'],
                                                                style: const TextStyle(
                                                                    fontSize:
                                                                        10,
                                                                    color: Colors
                                                                        .black),
                                                                overflow:
                                                                    TextOverflow
                                                                        .ellipsis,
                                                                textAlign:
                                                                    TextAlign
                                                                        .start,
                                                                maxLines: 1,
                                                              ),
                                                            )
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        )),
                                  );
                                },
                              )
                            : Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Image.asset(
                                      'assets/images/orderSuccess.png',
                                      height: 100,
                                      width: 100,
                                    ),
                                    const Text("No Record")
                                  ],
                                ),
                              ),
                      );
                    } else {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Image.asset(
                              'assets/images/orderSuccess.png',
                              height: 100,
                              width: 100,
                            ),
                            const Text("No Record")
                          ],
                        ),
                      );
                    }
                  }),
            )
          ],
        ),
      ),
    ),
  );
}
