import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dog_catcher/data/models/message_model.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ChatServices {
  final String userId = FirebaseAuth.instance.currentUser!.uid;

  Future<void> sendMessage(String recieverId, String message) async {
    //get current user info

    final String userEmailId = FirebaseAuth.instance.currentUser!.email!;
    final Timestamp timestamp = Timestamp.now();

    //create a new message
    MessageModel newMessage = MessageModel(
      senderId: userId,
      senderEmail: userEmailId,
      recieverId: recieverId,
      message: message,
      timestamp: timestamp,
    );
    //  construct chat room id for 2 users(sorted to ensure uniqueness)
    List<String> ids = [userId, recieverId];
    ids.sort(); //sort the ids (to ensure chatroomid is the same for any 2 people)
    String chatroomId = ids.join('_');
    await FirebaseFirestore.instance
        .collection("chat_rooms")
        .doc(chatroomId)
        .set(
            {
          'participants': ids, // Ensure both participants are listed
          'lastMessageTimestamp':
              timestamp, // Optionally, track when the last message was sent
          'lastMessage': message
        },
            SetOptions(
                merge:
                    true)); // Merge to prevent overwriting any existing fields

    // Add the new message to the messages sub-collection
    await FirebaseFirestore.instance
        .collection("chat_rooms")
        .doc(chatroomId)
        .collection("messages")
        .add(newMessage.toMap());
  }

  // add new message to database
  Stream<QuerySnapshot> getMessages(String userId, String otherUserId) {
    //construct a chatroom id for the two users
    List<String> ids = [userId, otherUserId];
    ids.sort();
    String chatroomId = ids.join('_');
    return FirebaseFirestore.instance
        .collection('chat_rooms')
        .doc(chatroomId)
        .collection('messages')
        .orderBy('timestamp', descending: false)
        .snapshots();
  }

  // Fetch chat rooms for the current user
  Future<List<String>> getMessagedUsers(String currentUserId) async {
    List<String> messagedUserIds = [];

    // Query chat_rooms collection where the current user is a participant
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('chat_rooms')
        .where('participants', arrayContains: currentUserId)
        .get();

    // Iterate through the chat rooms and extract the other user IDs
    for (var doc in querySnapshot.docs) {
      List<String> participants = List<String>.from(doc['participants']);

      // Remove the current user from the participants list to get the other user
      participants.remove(currentUserId);

      if (participants.isNotEmpty) {
        messagedUserIds.add(participants.first); // Add the other user ID
      }
    }
    // print(messagedUserIds);

    return messagedUserIds;
  }

  Future<List<Timestamp>> lastMessaged(String currentUserId) async {
    List<Timestamp> messagedTime = [];

    // Query chat_rooms collection where the current user is a participant
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('chat_rooms')
        .where('participants', arrayContains: currentUserId)
        .get();

    // Iterate through the chat rooms and extract the last message timestamp
    for (var doc in querySnapshot.docs) {
      var data = doc.data() as Map<String, dynamic>?; // Safely cast to a Map
      if (data != null && data.containsKey('lastMessageTimestamp')) {
        Timestamp time = data['lastMessageTimestamp'];
        messagedTime.add(time);
      }
    }

    // Return the list of message timestamps sorted in descending order (latest first)
    messagedTime.sort((a, b) => b.compareTo(a));

    return messagedTime;
  }
}
