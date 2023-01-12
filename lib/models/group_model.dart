enum MemberRole {
  admin,
  editor,
  viewer,
}

class GroupModel {
  String id;
  String name;
  String intro;
  String photo;
  MemberModel host;
  DateTime createAt;
  List<MemberModel> members;

  GroupModel({
    required this.id,
    required this.name,
    required this.intro,
    required this.photo,
    required this.host,
    required this.createAt,
    required this.members,
  });
}

class MemberModel {
  String id;
  String name;
  String avatar;
  MemberRole role;
  bool joined;
  bool connected;

  MemberModel({
    required this.id,
    required this.name,
    required this.avatar,
    required this.role,
    required this.joined,
    required this.connected,
  });
}
