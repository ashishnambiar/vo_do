import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final TextEditingController text = TextEditingController();
  final FocusNode listFocus = FocusNode();
  final FocusNode textFocus = FocusNode();

  List<String> todos = [];

  addItem() {
    setState(() {
      todos.add(text.text);
      text.clear();
      textFocus.requestFocus();
    });
  }

  @override
  void initState() {
    super.initState();
    FocusManager.instance.addListener(
      () {
        print("FOCUS list ${listFocus.hasFocus}");
        print("FOCUS text ${textFocus.hasFocus}");
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Shortcuts(
      shortcuts: {
        const SingleActivator(
          LogicalKeyboardKey.enter,
          shift: true,
        ): VoidCallbackIntent(
          () {
            print("hello");
          },
        ),
      },
      child: Scaffold(
        appBar: AppBar(title: Text("Vo-Do")),
        body: Center(
          child: Column(
            children: [
              Expanded(
                child: Focus(
                  focusNode: listFocus,
                  child: ListView.builder(
                    itemCount: todos.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text("$index) ${todos[index]}"),
                      );
                    },
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Shortcuts(
                  shortcuts: {
                    const SingleActivator(
                      LogicalKeyboardKey.enter,
                      shift: true,
                    ): VoidCallbackIntent(
                      () {
                        addItem();
                      },
                    ),
                  },
                  child: TextField(
                    controller: text,
                    focusNode: textFocus,
                    onSubmitted: (value) {
                      addItem();
                    },
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.amber.withOpacity(.5),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
