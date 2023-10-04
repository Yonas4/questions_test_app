import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:onesignal_flutter/onesignal_flutter.dart';

class Notifications {
  final kAppId = "07fefa70-86ed-468e-b520-7af815520a42";

//  داله لتضمين او حقن oneSignal عند فتح التطبيقد
  init() {
    //Remove this method to stop OneSignal Debugging
    OneSignal.Debug.setLogLevel(OSLogLevel.verbose);

    OneSignal.initialize(kAppId);

// The promptForPushNotificationsWithUserResponse function will show the iOS or Android push notification prompt. We recommend removing the following code and instead using an In-App Message to prompt for notification permission
    OneSignal.Notifications.requestPermission(true);
  }

  //دداله لارسال الاشعارات
  Future<http.Response> sendNotification(
      String tokenIdList, String contents, String heading) async {
    return await http.post(
      Uri.parse('https://onesignal.com/api/v1/notifications'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        "app_id": kAppId,
        //kAppId is the App Id that one get from the OneSignal When the application is registered.

        "include_player_ids": [tokenIdList],
        //tokenIdList Is the List of All the Token Id to to Whom notification must be sent.

        // android_accent_color reprsent the color of the heading text in the notifiction
        "android_accent_color": "FF9976D2",

        "small_icon": "ic_stat_onesignal_default",

        "headings": {"en": heading},

        "contents": {"en": contents},
      }),
    );
  }
}
