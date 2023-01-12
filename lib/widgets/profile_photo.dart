import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:split_the_bill/res/constants.dart';
import 'package:split_the_bill/screens/my_photo_view.dart';

class ProfilePhoto extends StatefulWidget {
  final String background;
  final String profile;

  const ProfilePhoto({
    Key? key,
    required this.background,
    required this.profile,
  }) : super(key: key);

  @override
  State<ProfilePhoto> createState() => _ProfilePhotoState();
}

class _ProfilePhotoState extends State<ProfilePhoto> {
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
                if (widget.background.contains('http')) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MyPhotoView(url: widget.background),
                    ),
                  );
                }
              },
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: widget.background.isEmpty
                    ? Image.asset(
                        Constants.background,
                        height: width / 16 * 9,
                        width: width,
                        fit: BoxFit.cover,
                      )
                    : Image.network(
                        widget.background,
                        height: width / 16 * 9,
                        width: width,
                        fit: BoxFit.cover,
                        loadingBuilder: (context, child, progress) {
                          if (progress == null) {
                            return child;
                          }
                          return Shimmer.fromColors(
                            baseColor: Colors.grey.shade300,
                            highlightColor: Colors.grey.shade100,
                            child: Container(
                              color: Colors.white,
                              width: width,
                              height: width / 16 * 9,
                            ),
                          );
                        },
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
            if (widget.profile.contains('http')) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => MyPhotoView(url: widget.profile),
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
                  child: widget.profile.isEmpty
                      ? Image.asset(
                          Constants.avatar,
                          color: Colors.grey,
                        )
                      : Image.network(
                          widget.profile,
                          fit: BoxFit.cover,
                          loadingBuilder: (context, child, progress) {
                            if (progress == null) {
                              return child;
                            }
                            return Shimmer.fromColors(
                              baseColor: Colors.grey.shade300,
                              highlightColor: Colors.grey.shade100,
                              child: Container(
                                color: Colors.white,
                                height: profileSize,
                                width: profileSize,
                              ),
                            );
                          },
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
