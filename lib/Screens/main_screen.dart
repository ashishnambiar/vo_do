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
  final ScrollController scroll = ScrollController();

  List<TileItem> todos = [];

  addItem() {
    setState(() {
      todos.add(TileItem(text.text));
      text.clear();
      textFocus.requestFocus();
    });
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      scroll.animateTo(
        scroll.position.maxScrollExtent,
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeOut,
      );
    });
  }

  @override
  void initState() {
    super.initState();
    FocusManager.instance.addListener(
      () {
        WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
          setState(() {});
        });
      },
    );
  }

  erasePreviousWord() {
    List<String> words =
        text.text.substring(0, text.selection.baseOffset).split(" ");
    if (words.length < 2) {
      text.text = text.text.substring(text.selection.baseOffset);
      text.selection = const TextSelection.collapsed(offset: 0);
      return;
    }
    final w = words.sublist(0, words.length - 1).join(" ");
    text.text = w + text.text.substring(text.selection.baseOffset);
    text.selection = TextSelection.collapsed(offset: w.length);
  }

  eraseBeforeCursor() => text
    ..text = text.text.substring(text.selection.baseOffset)
    ..selection = const TextSelection.collapsed(
        offset: 0, affinity: TextAffinity.downstream);

  eraseAfterCursor() =>
      text.text = text.text.substring(0, text.selection.baseOffset);

  @override
  Widget build(BuildContext context) {
    return Shortcuts(
      shortcuts: {
        const SingleActivator(
          LogicalKeyboardKey.tab,
        ): VoidCallbackIntent(
          () {
            if (listFocus.hasFocus) {
              textFocus.requestFocus();
            }
            if (textFocus.hasFocus) {
              listFocus.requestFocus();
            }
          },
        ),
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text("Vo-Do"),
        ),
        body: Center(
          child: Column(
            children: [
              Expanded(
                child: Shortcuts(
                  shortcuts: {
                    const SingleActivator(
                      LogicalKeyboardKey.keyJ,
                    ): VoidCallbackIntent(
                      () {
                        if (todos.isNotEmpty) {
                          todos.first.focus.requestFocus();
                        }
                      },
                    ),
                    const SingleActivator(
                      LogicalKeyboardKey.keyK,
                    ): VoidCallbackIntent(
                      () {
                        if (todos.isNotEmpty) {
                          todos.last.focus.requestFocus();
                        }
                      },
                    ),
                  },
                  child: Focus(
                    focusNode: listFocus,
                    child: ListView.builder(
                      controller: scroll,
                      itemCount: todos.length,
                      itemBuilder: (context, index) {
                        return Shortcuts(
                          shortcuts: {
                            const SingleActivator(
                              LogicalKeyboardKey.keyJ,
                            ): VoidCallbackIntent(
                              () {
                                if (index < (todos.length - 1)) {
                                  todos[index + 1].focus.requestFocus();
                                } else {
                                  textFocus.requestFocus();
                                }
                              },
                            ),
                            const SingleActivator(
                              LogicalKeyboardKey.keyK,
                            ): VoidCallbackIntent(
                              () {
                                if (index > 0) {
                                  todos[index - 1].focus.requestFocus();
                                } else {
                                  textFocus.requestFocus();
                                }
                              },
                            ),
                          },
                          child: Focus(
                            focusNode: todos[index].focus,
                            child: ListTile(
                              selectedTileColor: Colors.amber[100],
                              selected: todos[index].focus.hasFocus,
                              title: Text("$index) ${todos[index].item}"),
                            ),
                          ),
                        );
                      },
                    ),
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
                    ): VoidCallbackIntent(addItem),
                    const SingleActivator(
                      LogicalKeyboardKey.keyU,
                      control: true,
                    ): VoidCallbackIntent(eraseBeforeCursor),
                    const SingleActivator(
                      LogicalKeyboardKey.keyH,
                      control: true,
                    ): VoidCallbackIntent(
                      () => text.selection = TextSelection.collapsed(
                          offset: text.selection.baseOffset - 1),
                    ),
                    const SingleActivator(
                      LogicalKeyboardKey.keyL,
                      control: true,
                    ): VoidCallbackIntent(
                      () => text.selection = TextSelection.collapsed(
                          offset: text.selection.baseOffset + 1),
                    ),
                    const SingleActivator(
                      LogicalKeyboardKey.keyK,
                      control: true,
                    ): VoidCallbackIntent(eraseAfterCursor),
                    const SingleActivator(
                      LogicalKeyboardKey.keyW,
                      control: true,
                    ): VoidCallbackIntent(erasePreviousWord),
                  },
                  child: TextField(
                    controller: text,
                    focusNode: textFocus,
                    onSubmitted: (value) {
                      addItem();
                    },
                    decoration: InputDecoration(
                      filled: textFocus.hasFocus,
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

class TileItem {
  TileItem(this.item);
  String item;
  FocusNode focus = FocusNode();
}
