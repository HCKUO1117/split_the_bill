import 'package:flutter/material.dart';
import 'package:split_the_bill/res/constants.dart';
import 'package:split_the_bill/screens/my_photo_view.dart';

class ProfilePhoto extends StatelessWidget {
  final String background;
  final String profile;

  const ProfilePhoto({
    Key? key,
    required this.background,
    required this.profile,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double profileSize = width / 3;
    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        Column(
          children: [
            GestureDetector(
              onTap: () {
                if (background.contains('http')) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MyPhotoView(url: background),
                    ),
                  );
                }
              },
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: background.isEmpty
                    ? Image.asset(Constants.background)
                    : Image.network(
                        background,
                        height: width / 16 * 9,
                        width: width,
                        fit: BoxFit.cover,
                      ),
              ),
            ),
            SizedBox(
              height: profileSize / 3,
            )
          ],
        ),
        GestureDetector(
          onTap: () {
            if (profile.contains('http')) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => MyPhotoView(url: profile),
                ),
              );
            }
          },
          child: Stack(
            alignment: Alignment.center,
            children: [
              Container(
                width: profileSize + 10,
                height: profileSize + 10,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(profileSize),
                ),
              ),
              ClipRRect(
                borderRadius: BorderRadius.circular(profileSize),
                child: SizedBox(
                  height: profileSize,
                  width: profileSize,
                  child: profile.isEmpty
                      ? Image.asset(
                          Constants.avatar,
                          color: Colors.grey,
                        )
                      : Image.network(
                          profile,
                          fit: BoxFit.cover,
                        ),
                ),
              )
            ],
          ),
        ),
      ],
    );
  }
}
