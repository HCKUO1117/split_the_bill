import 'package:flutter/material.dart';

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
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image.network(
                background,
                height: width / 16 * 9,
                width: width,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(
              height: profileSize / 3,
            )
          ],
        ),
        Stack(
          alignment: Alignment.center,
          children: [
            Container(
              width: profileSize + 10,
              height: profileSize + 10,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(100),
              ),
            ),
            ClipRRect(
              borderRadius: BorderRadius.circular(60),
              child: SizedBox(
                height: profileSize,
                width: profileSize,
                child: Image.network(
                  profile,
                  fit: BoxFit.cover,
                ),
              ),
            )
          ],
        ),
      ],
    );
  }
}
