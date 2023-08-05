import 'package:flutter/material.dart';
import 'package:tt9_betweener_challenge/controllers/link_controller.dart';
import 'package:tt9_betweener_challenge/views/widgets/secondary_button_widget.dart';

import 'widgets/custom_text_form_field.dart';

class AddLinkView extends StatefulWidget {
  static String id = '/addLinkView';
  const AddLinkView({super.key});

  @override
  State<AddLinkView> createState() => _AddLinkViewState();
}

class _AddLinkViewState extends State<AddLinkView> {
  TextEditingController titleController = TextEditingController();
  TextEditingController linkController = TextEditingController();
  TextEditingController userNameController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  void submitAddLink() {
    if (_formKey.currentState!.validate()) {
      final body = {
        'title': titleController.text,
        'link': linkController.text,
        'username': userNameController.text,
      };

      addLink(body).then((user) async {
        if (mounted) {
          Navigator.pop(context, true);
        }
      }).catchError((err) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(err.toString()),
          backgroundColor: Colors.red,
        ));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 197, 193, 193),
        title: const Text('Add Link'),
      ),
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        child: Padding(
          padding: const EdgeInsets.all(40.0),
          child: Form(
              key: _formKey,
              child: Column(
                children: [
                  CustomTextFormField(
                    controller: titleController,
                    hint: 'snapchat',
                    label: 'Title',
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'please enter the email';
                      } else if (value.isEmpty) {
                        return 'please enter a valid email';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(
                    height: 14,
                  ),
                  CustomTextFormField(
                    controller: linkController,
                    hint: 'http:\\\\example.com',
                    label: 'Link',
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'please enter the password';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(
                    height: 14,
                  ),
                  CustomTextFormField(
                    controller: userNameController,
                    hint: '@example',
                    label: 'UserName',
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'please enter the user name';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(
                    height: 24,
                  ),
                  SecondaryButtonWidget(
                    onTap: submitAddLink,
                    text: 'Add',
                    width: 100,
                  ),
                ],
              )),
        ),
      ),
    );
  }
}
