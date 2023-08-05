// ignore_for_file: public_member_api_docs, sort_constructors_first, must_be_immutable
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import '../../constants.dart';

class CustomSlidableProfileLink extends StatelessWidget {
  String? linkTitle;
  String? link;
  Color backgroundColor;
  Color titleColor;
  Color linkColor;
  Function(BuildContext) onEditPressed;
  Function(BuildContext) onDeletePressed;

  CustomSlidableProfileLink(
      {Key? key,
      required this.linkTitle,
      required this.link,
      required this.backgroundColor,
      required this.titleColor,
      required this.linkColor,
      required this.onEditPressed,
      required this.onDeletePressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Slidable(
        endActionPane: ActionPane(motion: const ScrollMotion(), children: [
          SlidableAction(
            onPressed: onEditPressed,
            backgroundColor: kSecondaryColor,
            foregroundColor: Colors.white,
            icon: Icons.edit,
            borderRadius: BorderRadius.circular(15),
          ),
          const SizedBox(
            width: 8,
          ),
          SlidableAction(
            onPressed: onDeletePressed,
            backgroundColor: Colors.red,
            foregroundColor: Colors.white,
            icon: Icons.delete,
            borderRadius: BorderRadius.circular(15),
          )
        ]),
        child: Center(
          child: Container(
            decoration: BoxDecoration(
                color: backgroundColor,
                borderRadius: BorderRadius.circular(12)),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              width: MediaQuery.of(context).size.width * 0.85,
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '$linkTitle',
                      style: TextStyle(
                          letterSpacing: 3,
                          fontSize: 16,
                          color: titleColor,
                          fontWeight: FontWeight.w400),
                    ),
                    AutoSizeText(
                      '$link',
                      style: TextStyle(
                          color: linkColor, fontWeight: FontWeight.w400),
                      maxLines: 1,
                    )
                  ]),
            ),
          ),
        ));
  }
}
