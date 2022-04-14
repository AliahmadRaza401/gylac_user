// ignore_for_file: avoid_unnecessary_containers, prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gyalcuser_project/chat/model/chat_room_model.dart';
import 'package:gyalcuser_project/chat/model/message_model.dart';
import 'package:gyalcuser_project/chat/model/user_model.dart';
import 'package:gyalcuser_project/constants/keys.dart';

class ChatRoom extends StatefulWidget {
  final UserModel targetUser;
  final ChatRoomModel chatRoom;
  final UserModel userModel;

  const ChatRoom(
      {Key? key,
      required this.targetUser,
      required this.chatRoom,
      required this.userModel})
      : super(key: key);

  @override
  State<ChatRoom> createState() => _ChatRoomState();
}

class _ChatRoomState extends State<ChatRoom> {
  TextEditingController masgContrl = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  sendMsg() async {
    MessageModel newMessage = MessageModel(
      messageid: uuid.v1(),
      sender: widget.userModel.uid.toString(),
      text: masgContrl.text.trim().toString(),
      seen: false,
      createdon: DateTime.now(),
    );

    FirebaseFirestore.instance
        .collection('chatrooms')
        .doc(widget.chatRoom.chatroomid)
        .collection('messages')
        .doc(newMessage.messageid)
        .set(newMessage.toMap());

    widget.chatRoom.lastMessage = masgContrl.text;
    FirebaseFirestore.instance
        .collection('chatrooms')
        .doc(widget.chatRoom.chatroomid)
        .set(widget.chatRoom.toMap());

    masgContrl.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.white, //change your color here
        ),
        backgroundColor: Color(0xffFBB03B),
        title: Row(
          children: [
            CircleAvatar(
              backgroundColor: Colors.grey[200],
              backgroundImage:
                  NetworkImage(widget.targetUser.profilepic.toString()),
            ),
            SizedBox(
              width: 10,
            ),
            Text(
              widget.targetUser.fullname.toString(),
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ],
        ),
        centerTitle: true,
      ),
      body: Container(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Expanded(
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection("chatrooms")
                        .doc(widget.chatRoom.chatroomid)
                        .collection("messages")
                        .orderBy("createdon", descending: true)
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.active) {
                        if (snapshot.hasData) {
                          QuerySnapshot dataSnapshot =
                              snapshot.data as QuerySnapshot;

                          return ListView.builder(
                            reverse: true,
                            itemCount: dataSnapshot.docs.length,
                            itemBuilder: (context, index) {
                              MessageModel currentMessage =
                                  MessageModel.fromMap(dataSnapshot.docs[index]
                                      .data() as Map<String, dynamic>);

                              return Row(
                                mainAxisAlignment: (currentMessage.sender ==
                                        widget.userModel.uid)
                                    ? MainAxisAlignment.end
                                    : MainAxisAlignment.start,
                                children: [
                                  Container(
                                      margin: EdgeInsets.symmetric(
                                        vertical: 2,
                                      ),
                                      padding: EdgeInsets.symmetric(
                                        vertical: 10,
                                        horizontal: 30.w,
                                      ),
                                      decoration: currentMessage.sender ==
                                              widget.userModel.uid
                                          ? BoxDecoration(
                                              color: Color(0xffFBB03B),
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                            )
                                          : BoxDecoration(
                                              color: Colors.white,
                                              border: Border.all(
                                                  width: 2,
                                                  color: Color(0xffFBB03B)),
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                            ),
                                      child: Text(
                                        currentMessage.text.toString(),
                                        style: TextStyle(
                                          color: Colors.black,
                                        ),
                                      )),
                                ],
                              );
                            },
                          );
                        } else if (snapshot.hasError) {
                          return Center(
                            child: Text(
                                "An error occured! Please check your internet connection."),
                          );
                        } else {
                          return Center(
                            child: Text("Say hi to your new friend"),
                          );
                        }
                      } else {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                    },
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(
                  vertical: 10,
                  horizontal: 15,
                ),
                child: Row(
                  children: [
                    Flexible(
                        child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 15,
                        vertical: 5,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: TextFormField(
                        validator: (value) {
                          if (value!.isEmpty || value == null) {
                            return "Message Required!";
                          }
                        },
                        controller: masgContrl,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: "Type your Message...",
                        ),
                      ),
                    )),
                    IconButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            sendMsg();
                          }
                        },
                        icon: Icon(
                          Icons.send,
                          color: Color(0xffFBB03B),
                          size: 90.h,
                        )),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
