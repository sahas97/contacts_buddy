class Contact {
  int? id;
  String name;
  String phoneNumber;
  String? eMail;
  String imagePath;

  Contact({
    this.id,
    required this.name,
    required this.phoneNumber,
    this.eMail,
    required this.imagePath,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'phoneNumber': phoneNumber,
      'email': eMail,
      'imagePath': imagePath,
    };
  }

  factory Contact.fromMap(Map<String, dynamic> map) {
    return Contact(
      id: map['id'],
      name: map['name'],
      phoneNumber: map['phoneNumber'],
      eMail: map['email'] ?? '',
      imagePath: map['imagePath'] ?? '',
    );
  }
}
