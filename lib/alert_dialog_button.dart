import 'package:flutter/material.dart';

class AlertDialogButtons extends StatefulWidget {

  final String buttonName;
  Function() onPressed;
  IconData? buttonIcon;

  AlertDialogButtons({
    Key? key,
    required this.buttonName,
    required this.onPressed,
    this.buttonIcon,
  }): super(key: key);

  @override
  State<AlertDialogButtons> createState() => _AlertDialogButtonsState();
}

class _AlertDialogButtonsState extends State<AlertDialogButtons> {
  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      onPressed: widget.onPressed,
      color: Colors.grey.shade800,
      child: Row (
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          widget.buttonIcon != null
              ? Icon(widget.buttonIcon, color: Colors.white)
              : const Text(""),
          Text(
            widget.buttonName,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 15.0,
            ),
          ),
        ],
      )
    );
  }
}
