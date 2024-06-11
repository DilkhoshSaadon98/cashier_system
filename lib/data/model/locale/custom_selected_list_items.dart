class CustomSelectedListItems {
  String name;
  String? value; // This could be ID or any other string value
  String? price;
  String? desc;

  CustomSelectedListItems({
    required this.name,
    this.value,
    this.price,
    this.desc,
  });
}
