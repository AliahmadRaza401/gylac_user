// ignore_for_file: unnecessary_brace_in_string_interps

import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gyalcuser_project/chat/chat_room.dart';
import 'package:gyalcuser_project/chat/model/chat_room_model.dart';
import 'package:gyalcuser_project/chat/model/user_model.dart';
import 'package:gyalcuser_project/constants/keys.dart';
import 'package:gyalcuser_project/screens/delivery_form/create_delivery_form.dart';
import 'package:gyalcuser_project/screens/orderTrack/go_map.dart';
import 'package:gyalcuser_project/utils/app_route.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import '../../constants/colors.dart';
import '../../providers/create_delivery_provider.dart';
import '../../providers/userProvider.dart';
import '../../utils/image.dart';
import '../../widgets/App_Menu.dart';
import '../../widgets/custom_btn.dart';
import '../../widgets/gradient_text.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  late UserProvider _userProvider;
  late CreateDeliveryProvider deliveryProvider;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _userProvider = Provider.of<UserProvider>(context, listen: false);
    deliveryProvider =
        Provider.of<CreateDeliveryProvider>(context, listen: false);
    getData();
  }

  getData() async {
    String uid = _auth.currentUser!.uid;
    await _firestore.collection('users').doc(uid).get().then((value) {
      setState(() {
        _userProvider.email = value.data()!["email"].toString();
        _userProvider.fullName = value.data()!["fullName"].toString();
        _userProvider.phoneNumber = '0${value.data()!["mobileNumber"]}';
        _userProvider.image = value.data()!["image"].toString();
        _userProvider.address = value.data()!["address"].toString();
      });
    });
    getCount();
  }

  getCount() async {
    int count = await FirebaseFirestore.instance
        .collection('drivers')
        .get()
        .then((value) => value.size);
    setState(() {
      deliveryProvider.driverLength = count;
    });
  }

  ChatRoomModel? chatRoom;

  Future<ChatRoomModel?> getChatRoom(targetID, userID) async {
    print('userID: $userID');
    print('targetID: $targetID');
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection("chatrooms")
        .where("participants.${userID}", isEqualTo: true)
        .where("participants.${targetID}", isEqualTo: true)
        .get();

    if (snapshot.docs.length > 0) {
      print("ChatRoom Available");

      var docData = snapshot.docs[0].data();
      ChatRoomModel existingChatRoom =
          ChatRoomModel.fromMap(docData as Map<String, dynamic>);

      chatRoom = existingChatRoom;
    } else {
      print("ChatRoom Not Available");

      ChatRoomModel newChatRoom = ChatRoomModel(
        chatroomid: uuid.v1(),
        lastMessage: "",
        participants: {
          userID.toString(): true,
          targetID.toString(): true,
        },
      );

      await FirebaseFirestore.instance
          .collection('chatrooms')
          .doc(newChatRoom.chatroomid)
          .set(newChatRoom.toMap());
      chatRoom = newChatRoom;
    }

    return chatRoom;
  }

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        elevation: 0,
        toolbarHeight: 210,
        backgroundColor: Colors.transparent,
        flexibleSpace: SafeArea(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 5),
            width: media.width,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/bg.png'),
                fit: BoxFit.fill,
              ),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    Builder(
                      builder: (context) => IconButton(
                        icon: Image.asset(
                          menuimage,
                          width: 30,
                          height: 30,
                        ),
                        onPressed: () => Scaffold.of(context).openDrawer(),
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    GestureDetector(
                      onTap: () {
                        AppRoutes.push(context, const CreateDeliveryForm());
                      },
                      child: Container(
                        width: media.width * 0.55,
                        padding: const EdgeInsets.symmetric(
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          border: Border.all(color: orange, width: 1),
                          boxShadow: const [
                            BoxShadow(
                                color: stroke,
                                offset: Offset(2, 6),
                                blurRadius: 8)
                          ],
                          color: white,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Container(
                              alignment: Alignment.center,
                              child: const GradientText(
                                'SCHEDULE A NEW \n DELIVERY',
                                style: TextStyle(
                                    fontSize: 15,
                                    fontFamily: 'Poppins',
                                    fontWeight: FontWeight.bold),
                                gradient: LinearGradient(
                                  colors: [
                                    orangeDark,
                                    redOrange,
                                  ],
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                ),
                              ),
                            ),
                            Image.asset(
                              'assets/images/clock.png',
                              height: 50,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
      backgroundColor: Colors.white,
      drawer: AppMenu(),
      body: SafeArea(
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          height: media.height,
          child: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  height: media.height * 0.68,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        GestureDetector(
                          onTap: () {},
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Image.asset(
                                "assets/images/food.png",
                                height: media.height * 0.12,
                              ),
                              Image.asset(
                                "assets/images/bags.png",
                                height: media.height * 0.12,
                              ),
                              Image.asset(
                                "assets/images/people.png",
                                height: media.height * 0.12,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Row(
                          children: [
                            SizedBox(
                                width: media.width * 0.5,
                                child: CustomBtn(
                                  text: "POPULAR DELIVERIES",
                                  onTap: () async {
                                    ChatRoomModel? chatRoomModel =
                                        await getChatRoom(
                                            '9PAK0ofdCfSR6A6K8PQcjniYEzv2',
                                            FirebaseAuth
                                                .instance.currentUser!.uid);

                                    if (chatRoomModel != null) {
                                      AppRoutes.push(
                                          context,
                                          ChatRoom(
                                            targetUser: UserModel(
                                              uid:
                                                  '9PAK0ofdCfSR6A6K8PQcjniYEzv2',
                                              fullname: 'Driver',
                                              email: 'aaa@gmail.com',
                                              profilepic: 'asdf',
                                            ),
                                            userModel: UserModel(
                                              uid: _userProvider.uid,
                                              fullname: _userProvider.fullName,
                                              email: _userProvider.email,
                                              profilepic: _userProvider.image,
                                            ),
                                            chatRoom: chatRoomModel,
                                          ));
                                    }
                                  },
                                  bgColor: orange,
                                  size: 15,
                                )),
                          ],
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        GridView.builder(
                            shrinkWrap: true,
                            physics: const BouncingScrollPhysics(),
                            gridDelegate:
                                const SliverGridDelegateWithMaxCrossAxisExtent(
                                    maxCrossAxisExtent: 200,
                                    childAspectRatio: 3 / 2,
                                    crossAxisSpacing: 20,
                                    mainAxisSpacing: 20),
                            itemCount: 8,
                            itemBuilder: (BuildContext ctx, index) {
                              return Container(
                                height: media.height * 0.15,
                                width: media.width * 0.43,
                                decoration: BoxDecoration(
                                  border: Border.all(color: stroke, width: 1),
                                  boxShadow: [
                                    BoxShadow(
                                        offset: const Offset(2, 3),
                                        blurRadius: 5,
                                        color: black.withOpacity(0.25))
                                  ],
                                  borderRadius: BorderRadius.circular(10),
                                  color: white,
                                ),
                              );
                            }),
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
}
