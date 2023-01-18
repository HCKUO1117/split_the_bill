import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:split_the_bill/models/user_model.dart';
import 'package:split_the_bill/res/constants.dart';

class FriendTitle extends StatelessWidget {
  final UserModel model;

  const FriendTitle({Key? key, required this.model}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(100),
          child: model.avatar.isEmpty
              ? Image.asset(
                  Constants.avatar,
                  height: 50,
                  width: 50,
                )
              : Image.network(
                  model.avatar,
                  fit: BoxFit.cover,
                  height: 50,
                  width: 50,
                  loadingBuilder: (context, child, progress) {
                    if (progress == null) {
                      return child;
                    }
                    return Shimmer.fromColors(
                      baseColor: Colors.grey.shade300,
                      highlightColor: Colors.grey.shade100,
                      child: Container(
                        color: Colors.white,
                        height: 50,
                        width: 50,
                      ),
                    );
                  },
                ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                model.name,
                style: const TextStyle(fontWeight: FontWeight.bold),
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4),
              if (model.intro.isNotEmpty)
                Text(
                  model.intro,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(color: Colors.grey),
                ),
            ],
          ),
        ),
      ],
    );
  }
}
