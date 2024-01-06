class Contact {
  int? id;
  String name;
  String contact;
  String email;

  Contact({this.id, required this.name, required this.contact, required this.email});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'contact': contact,
      'email': email,
    };
  }
}

