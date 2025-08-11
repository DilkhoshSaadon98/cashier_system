class CustomSelectedListItems {
  String name;
  String? value; // This could be ID or any other string value
  String? price;
  String? desc;
  String? type;

  CustomSelectedListItems({
    required this.name,
    this.value,
    this.price,
    this.desc,
    this.type,
  });
}
