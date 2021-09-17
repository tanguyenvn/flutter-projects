import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

void main() {
  runApp(const FriendlyChatApp());
}

final String _name = 'Gabriel'; //global variable
//theme
final ThemeData iosTheme = ThemeData(
  primarySwatch: Colors.orange,
  primaryColor: Colors.grey[100],
  primaryColorBrightness: Brightness.light,
);
final ThemeData defaultTheme = ThemeData(
  colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.green)
      .copyWith(secondary: Colors.orangeAccent[400]),
);

//App
class FriendlyChatApp extends StatelessWidget {
  const FriendlyChatApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme:
          defaultTargetPlatform == TargetPlatform.iOS ? iosTheme : defaultTheme,
      home: ChatScreen(),
    );
  }
}

//Screen widget: stateful
class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

//Screen state
//TickerProviderStateMixin: ticker (heartbeat for animation)
class _ChatScreenState extends State<ChatScreen> with TickerProviderStateMixin {
  final _textController = TextEditingController(); //control text editing
  final List<ChatMessage> _messages = []; //list of chat messages
  final FocusNode _focusNode = FocusNode(); //manage keyboard focus, ~ stack
  bool _isComposing = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Friendly Chat'),
        elevation: //size of shadow
            Theme.of(context).platform == TargetPlatform.iOS ? 0.0 : 4.0,
      ),
      body: Column(
        children: [
          _buildChatList(), //chat message list
          const Divider(height: 1.0), //separator
          Container(
            decoration: BoxDecoration(color: Theme.of(context).cardColor),
            child: _buildTextComposer(), //chat input field
          ),
        ],
      ),
    );
  }

  //ChatList widget
  Widget _buildChatList() {
    return Flexible(
      child: ListView.builder(
        padding: const EdgeInsets.all(8.0),
        reverse: true,
        itemBuilder: (_, index) => _messages[index],
        itemCount: _messages.length, //improve list view scroll
      ),
    );
  }

  //TextField Widget
  Widget _buildTextComposer() {
    return IconTheme(
      data: IconThemeData(color: Theme.of(context).colorScheme.secondary),
      child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Row(
            children: [
              Flexible(
                //text field
                child: TextField(
                  controller: _textController,
                  //onchange event
                  onChanged: (String text) {
                    setState(() {
                      _isComposing = text.isNotEmpty;
                    });
                  },
                  //on submit event
                  onSubmitted: _isComposing ? _handleSubmitted : null,
                  decoration: const InputDecoration.collapsed(
                      hintText: 'Send a message'),
                  focusNode: _focusNode,
                ),
              ),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 4.0),
                //command button
                child: IconButton(
                  onPressed: _isComposing
                      ? () => _handleSubmitted(_textController.text)
                      : null,
                  icon: const Icon(Icons.send),
                ),
              )
            ],
          )),
    );
  }

  void _handleSubmitted(String text) {
    _textController.clear(); //clear text field
    ChatMessage message = ChatMessage(
      text: text,
      animationController: AnimationController(
        duration: const Duration(milliseconds: 200), //animation time
        vsync: this, //source of hearbeat (ticker)
      ),
    );
    setState(() {
      //re-render the ChatScreen (stateful widget)
      _messages.insert(0, message);
      _isComposing = false;
    });
    _focusNode.requestFocus(); //return focus to previous element
    message.animationController.forward(); //trigger animate
  }

  @override
  void dispose() {
    //free up resource
    for (var message in _messages) {
      message.animationController.dispose();
    }
    super.dispose();
  }
}

//Chat message widget
class ChatMessage extends StatelessWidget {
  //constructor
  ChatMessage({required this.text, required this.animationController});
  final String text;
  final AnimationController animationController; //control animation

  @override
  Widget build(BuildContext context) {
    //transition type: size/fade
    return SizeTransition(
      //animation type: curve
      sizeFactor: CurvedAnimation(
        parent: animationController,
        curve: Curves.slowMiddle,
      ),
      axisAlignment: 0.0,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start, //vertical align
        children: [
          Container(
            margin: const EdgeInsets.only(right: 16.0),
            child: CircleAvatar(child: Text(_name[0])), //avatar
          ),
          //wrap long line
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(_name, style: Theme.of(context).textTheme.headline4),
                Container(
                  margin: const EdgeInsets.only(top: 5.0),
                  child: Text(text),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
