// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

import 'package:tt9_betweener_challenge/controllers/link_controller.dart';
import 'package:tt9_betweener_challenge/views/widgets/secondary_button_widget.dart';

import 'widgets/custom_text_form_field.dart';

class EditLinkView extends StatefulWidget {
  static String id = '/editLinkView';
  late int linkId;
  late String defaultTitle;
  late String defaultLink;

  EditLinkView({
    Key? key,
    required this.linkId,
    required this.defaultTitle,
    required this.defaultLink,
  }) : super(key: key);

  @override
  State<EditLinkView> createState() => _EditLinkViewState();
}

class _EditLinkViewState extends State<EditLinkView> {
  String get defaultTitle => widget.defaultTitle;
  String get defaultLink => widget.defaultLink;

  int get linkId => widget.linkId;

  late TextEditingController titleController;
  late TextEditingController linkController;
  final _formKey = GlobalKey<FormState>();

  void submitEditLink() async {
    if (_formKey.currentState!.validate()) {
      final body = {
        'title': titleController.text,
        'link': linkController.text,
      };

      editLink(body, linkId).then((user) async {
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
  void initState() {
    titleController = TextEditingController(text: defaultTitle);
    linkController = TextEditingController(text: defaultLink);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 197, 193, 193),
        title: const Text('Edit Link'),
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
                    height: 24,
                  ),
                  SecondaryButtonWidget(
                    onTap: submitEditLink,
                    text: 'Edit',
                    width: 100,
                  ),
                ],
              )),
        ),
      ),
    );
  }
}
