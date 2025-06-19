import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../utils/util.dart';

class DateHeaderWidget extends StatelessWidget {
  const DateHeaderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    DateTime today = DateTime.now();

    return ListTile(
      tileColor: Colors.grey.shade200,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Wrap(
            children: [
              Column(
                children: [
                  Text(
                    today.month.toString(),
                    style: TextStyle(
                      fontWeight: FontWeight.normal,
                      color: Utils.weekDayColor(today.weekday),
                    ),
                  ),
                  Text(
                    "month".tr,
                    style: TextStyle(
                      fontWeight: FontWeight.normal,
                      color: Utils.weekDayColor(today.weekday),
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 10),
              Text(
                today.day.toString(),
                style: TextStyle(
                  fontSize: 35,
                  fontWeight: FontWeight.bold,
                  color: Utils.weekDayColor(today.weekday),
                ),
              ),
              const SizedBox(width: 10),
              SizedBox(
                height: 40,
                child: CircleAvatar(
                  radius: 15,
                  backgroundColor: Colors.white,
                  child: Text(
                    Utils.weekDayString(today.weekday),
                    style: TextStyle(color: Utils.weekDayColor(today.weekday)),
                  ),
                ),
              ),
            ],
          ),
          Text(
            "wish".tr,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
          ),
        ],
      ),
    );
  }
}
