

class UsersModel{
 String? username;
 String? email;
 String? phone;
 String? userID;

UsersModel(
  this.username,
  this.email,
  this.phone,
  this.userID
); 

UsersModel.fromJson(Map<String , dynamic>json){
    username=json['username'];

  email=json['email'];
  phone=json['phone'];
  userID=json['userID'];

}

Map<String ,dynamic>toMap(){
  return {
     'username':username,
     'email':email,
     'phone':phone,
     'userID' : userID
  };
}


}