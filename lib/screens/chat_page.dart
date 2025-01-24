import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;


class ChatScreen extends StatefulWidget {
  final String? userId;  // Current user's ID
  final String recipientId;  // The recipient's ID

  ChatScreen({required this.userId, required this.recipientId, required String userName});

  @override
  _ChatScreenState createState() => _ChatScreenState();

  
}
// chatpage
class _ChatScreenState extends State<ChatScreen> {
  late IO.Socket socket;
  final TextEditingController _controller = TextEditingController();
  List<String> messages = [];

  @override
  void initState() {
    super.initState();
    connectToServer();
  }

  void connectToServer() {
    socket = IO.io('https://hillffair-backend-2k24.onrender.com/', <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': false,
    });
    socket.connect();

    // Listening for messages from the server
    socket.on('receiveMessage', (data) {
      setState(() {
        messages.add('${data['from']}: ${data['message']}');
      });
    });
  }

  void sendMessage(String message) {
    // Emitting the message along with user IDs to the backend
    socket.emit('sendMessage', {
      'from': widget.userId,  // Dynamic user ID of the sender
      'to': widget.recipientId,  // Dynamic user ID of the recipient
      'message': message
    });
    setState(() {
      messages.add('Me: $message');
    });
    _controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Chat with ${widget.recipientId}')),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: messages.length,
              itemBuilder: (context, index) {
                return ListTile(
                  
                  
                  title: Text(messages[index]));
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(controller: _controller),
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: () => sendMessage(_controller.text),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}