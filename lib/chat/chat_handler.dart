import 'package:cloud_firestore/cloud_firestore.dart';

import '../constants/keys.dart';
import 'model/chat_room_model.dart';

class chatHandler{

  static ChatRoomModel? chatRoom;

  static Future<ChatRoomModel?> getChatRoom(targetID, userID) async {
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
}