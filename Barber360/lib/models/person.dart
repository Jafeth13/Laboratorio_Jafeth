class Person {
  final int id;
  final String name;
  final String email;
  final String identification;
  final String birthDate;

  Person({
    required this.id,
    required this.name,
    required this.email,
    required this.identification,
    required this.birthDate,
  });

  factory Person.fromJson(Map<String, dynamic> json) {
    return Person(
      id: json['Id'],
      name: json['Name'],
      email: json['Email'],
      identification: json['Identification'],
      birthDate: json['BirthDate'],
    );
  }
}
