import 'package:flutter/material.dart';
import 'package:not_sepeti/utils/constant.dart';

class NotDetail extends StatefulWidget {
  NotDetail({Key? key, this.notDescription})
      : super(
          key: key,
        );
  String? notDescription;
  @override
  State<NotDetail> createState() => _NotDetailState();
}

class _NotDetailState extends State<NotDetail> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:const Text("Not"),
        backgroundColor: AppColor.primaryColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Container(
          child: Text(widget.notDescription!),
        ),
      ),
    );
  }
}
