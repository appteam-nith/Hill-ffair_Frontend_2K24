import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
// ignore: library_prefixes
import 'package:socket_io_client/socket_io_client.dart' as IO;

class ChatPage extends StatefulWidget {
  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _messageController = TextEditingController();
  final List<String> _messages = [];
  final ImagePicker _picker = ImagePicker();
  late IO.Socket socket;

  @override
  void initState() {
    super.initState();
    _connectToSocket();
  }

  void _connectToSocket() {
    socket = IO.io('http://YOUR_SERVER_IP:PORT', <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': false,
    });
    
    socket.connect();
    
    // Listen for new messages from the server
    socket.on('message', (data) {
      setState(() {
        _messages.add(data);
      });
    });
  }

  void _sendMessage() {
    if (_messageController.text.isNotEmpty) {
      socket.emit('message', _messageController.text);  // Send message to the server
      setState(() {
        _messages.add(_messageController.text);  // Add message to the list locally
        _messageController.clear();
      });
    }
  }

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      // Send image as a message (could be a file or URL in a real-world app)
      socket.emit('image', 'Image sent from gallery');  // Emit an image message
      setState(() {
        _messages.add('Sent an image');
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chat with Virendra'),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: ListView.builder(
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(_messages[index]),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: <Widget>[
                IconButton(
                  icon: Icon(Icons.photo),
                  onPressed: _pickImage,
                ),
                Expanded(
                  child: TextFormField(
                    controller: _messageController,
                    decoration: InputDecoration(
                      hintText: 'Type a message',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: _sendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    socket.dispose();  // Dispose the socket when the widget is removed
    super.dispose();
  }
}
