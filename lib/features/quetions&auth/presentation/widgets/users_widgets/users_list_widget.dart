import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:questions/features/quetions&auth/domain/entities/auth/user.dart';

class UsersListWidget extends StatelessWidget {
  final List<UserData> userData;

  const UsersListWidget({
    Key? key,
    required this.userData,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // list.sort((a, b) => a["price"].compareTo(b["price"]));
    userData.sort((a, b) => b.rate.compareTo(a.rate));
    return ListView.separated(
      itemCount: userData.length,
      itemBuilder: (context, index) {
        return Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15), color: Colors.blue),
          child: Row(
            children: [
              SizedBox(
                width: 10.w,
              ),
              Text(
                '${index + 1}',
                style: TextStyle(color: Colors.white, fontSize: 18.sp),
              ),
              Expanded(
                child: ListTile(
                  leading: ClipRRect(
                      borderRadius: BorderRadius.circular(50),
                      child:
                          Image.network(userData[index].photourl.toString())),
                  title: Text(
                    'Name: ' + userData[index].name,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: Text(
                    'Scour: ' + userData[index].rate,
                    maxLines: 1,
                    style: TextStyle(
                      fontSize: 16.sp,
                    ),
                  ),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 10),
                  onTap: () {
                    var id = OneSignal.User.pushSubscription.id;
                    var token = OneSignal.User.pushSubscription.token;
                    var optedIn = OneSignal.User.pushSubscription.optedIn;

                    print(id );
                  },
                ),
              ),
            ],
          ),
        );
      },
      separatorBuilder: (context, index) => const Divider(thickness: 1),
    );
  }
}
