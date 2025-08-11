class AccountMenuModel {
  final int id;
  final String name;
  final int? parentId;
  final List<AccountMenuModel> children;

  AccountMenuModel({
    required this.id,
    required this.name,
    this.parentId,
    this.children = const [],
  });
}