import 'package:flutter/material.dart';
import 'package:photo_gallery/route/navigator.dart';

class CreatePopup extends StatelessWidget {
  final String? title;
  final String? content;

  const CreatePopup({
    Key? key,
    this.title,
    this.content,
  }) : super(key: key);

  static Future<String?> show({String? title, String? content}) => showDialog(
      context: navigatorKey.currentContext!,
      builder: (BuildContext context) {
        return CreatePopup(
          title: title,
          content: content,
        );
      });

  @override
  Widget build(BuildContext context) {
    TextEditingController controller =
        TextEditingController(text: content ?? '');
    return AlertDialog(
        scrollable: true,
        title: Text(title ?? 'Create'),
        content: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Form(
            child: Column(
              children: <Widget>[
                TextFormField(
                  controller: controller,
                  decoration: const InputDecoration(
                    labelText: 'Name',
                  ),
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
              child: const Text("Submit"),
              onPressed: () {
                if (controller.text.isEmpty) return;
                pop(controller.text);
              })
        ]);
  }
}
