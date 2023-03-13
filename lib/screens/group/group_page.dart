import 'package:flutter/material.dart';
import 'package:split_the_bill/generated/l10n.dart';
import 'package:split_the_bill/models/group_model.dart';
import 'package:split_the_bill/res/constants.dart';

class GroupPage extends StatefulWidget {
  final GroupModel model;

  const GroupPage({Key? key, required this.model}) : super(key: key);

  @override
  State<GroupPage> createState() => _GroupPageState();
}

class _GroupPageState extends State<GroupPage> with TickerProviderStateMixin {
  late TabController tabController;

  @override
  void initState() {
    tabController = TabController(length: 3, vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.model.name),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.people_alt_outlined),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.messenger_outline),
          ),
        ],
      ),
      body: NestedScrollView(
        headerSliverBuilder: (context, _) {
          return [
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(50),
                          child: widget.model.photo.isEmpty
                              ? Image.asset(
                                  Constants.background,
                                  width: 50,
                                  height: 50,
                                  fit: BoxFit.cover,
                                )
                              : Image.network(
                                  widget.model.photo,
                                  width: 50,
                                  height: 50,
                                  fit: BoxFit.cover,
                                ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Text(
                            widget.model.name,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
                childCount: 1,
              ),
            ),
            SliverPersistentHeader(
              pinned: true,
              delegate: _SliverAppBarDelegate(
                TabBar(
                  controller: tabController,
                  labelColor: Colors.black,
                  tabs: [
                    Tab(
                      text: S.of(context).news,
                    ),
                    Tab(
                      text: S.of(context).accounting,
                    ),
                    Tab(
                      text: S.of(context).events,
                    ),
                  ],
                ),
              ),
            )
          ];
        },
        body: const SizedBox(),
      ),
    );
  }
}

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  final TabBar tabBar;

  _SliverAppBarDelegate(this.tabBar);

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return tabBar;
  }

  @override
  double get maxExtent => 44;

  @override
  double get minExtent => 44;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return true;
  }
}
