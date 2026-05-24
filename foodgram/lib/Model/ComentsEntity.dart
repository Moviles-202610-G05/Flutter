
class Coments {
  final String userName;
  final String description;

  Coments({ required this.userName, required this.description});
  

  factory Coments.fromMap(Map<String, dynamic> map,) {

    return Coments(
      userName: map['userName'] ?? '',
      description: map['description'] ?? '', 
    
    );
  }


  Map<String, dynamic> toMap() {
    return {
      'description': description,
      'userName': userName,
    };
  }


}
