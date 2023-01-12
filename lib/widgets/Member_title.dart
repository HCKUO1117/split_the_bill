import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:split_the_bill/models/group_model.dart';
import 'package:split_the_bill/res/constants.dart';

class MemberTitle extends StatelessWidget {
  final MemberModel memberModel;
  final Function()? onDelete;

  const MemberTitle({
    Key? key,
    required this.memberModel,
    this.onDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(100),
          child: memberModel.avatar.isEmpty
              ? Image.asset(
                  Constants.avatar,
                  height: 50,
                  width: 50,
                )
              : Image.network(
                  memberModel.avatar,
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
          child: Text(memberModel.name),
        ),
        if (onDelete != null)
          GestureDetector(
            onTap: onDelete,
            child: const Icon(
              Icons.highlight_remove,
              color: Colors.red,
            ),
          ),
      ],
    );
  }
}
