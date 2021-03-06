import 'package:bubble/bubble.dart';
import 'package:chattychat/styles.dart';
import 'package:chattychat/util.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';

final firestore = Firestore.instance;
FirebaseUser loggedInUser;

class ChattyScreen extends StatefulWidget {
  static const String id = 'chatty_screen';

  @override
  _ChattyScreenState createState() => _ChattyScreenState();
}

class _ChattyScreenState extends State<ChattyScreen> {
  final mTextController = TextEditingController();
  final _auth = FirebaseAuth.instance;

  String mText;

  @override
  void initState() {
    super.initState();
    getCurrentUser();
  }

  void getCurrentUser() async {
    try {
      final user = await _auth.currentUser();
      if (user != null) {
        loggedInUser = user;
      }
    } catch (e) {
      if (e is PlatformException) {
        showDialog(
          context: context,
          builder: (BuildContext context) =>
              Util.showDialog(context, e.message),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: null,
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.close),
              onPressed: () {
                _auth.signOut();
                Navigator.pop(context);
              }),
        ],
        title: Text('Chatty Chat'),
        backgroundColor: Colors.blue,
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            MessagesStream(),
            Container(
              decoration: style_message_container,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      controller: mTextController,
                      onChanged: (value) {
                        mText = value;
                      },
                      decoration: style_message,
                    ),
                  ),
                  FlatButton(
                    onPressed: () {
                      mTextController.clear();
                      if (mText != null && mText.isNotEmpty) {
                        firestore.collection('messages').add({
                          'text': mText,
                          'sender': loggedInUser.email,
                        });
                      }
                    },
                    child: Text(
                      'Send',
                      style: style_action_button,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MessagesStream extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: firestore.collection('messages').snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center();
        }
        final messages = snapshot.data.documents.reversed;
        List<MessageBubble> messageBubbles = [];
        for (var message in messages) {
          final mText = message.data['text'];
          final messageSender = message.data['sender'];

          final currentUser = loggedInUser.email;

          final messageBubble = MessageBubble(
            sender: messageSender,
            text: mText,
            isWriter: currentUser == messageSender,
          );

          messageBubbles.add(messageBubble);
        }
        return Expanded(
          child: ListView(
            reverse: true,
            padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
            children: messageBubbles,
          ),
        );
      },
    );
  }
}

class MessageBubble extends StatelessWidget {
  MessageBubble({this.sender, this.text, this.isWriter});

  final String sender;
  final String text;
  final bool isWriter;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment:
            isWriter ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: <Widget>[
          Material(
            elevation: 0.0,
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
              child: isWriter
                  ? Bubble(
                      margin: BubbleEdges.only(top: 10),
                      nip: BubbleNip.rightBottom,
                      color: Color.fromRGBO(225, 255, 199, 1.0),
                      child: Text(text, textAlign: TextAlign.right),
                    )
                  : Bubble(
                      margin: BubbleEdges.only(top: 10),
                      nip: BubbleNip.leftBottom,
                      color: Color.fromRGBO(225, 255, 199, 1.0),
                      child: Text(text, textAlign: TextAlign.right),
                    ),
            ),
          ),
          Text(
            sender,
            style: TextStyle(
              fontSize: 12.0,
              color: Colors.black54,
            ),
          ),
        ],
      ),
    );
  }
}
