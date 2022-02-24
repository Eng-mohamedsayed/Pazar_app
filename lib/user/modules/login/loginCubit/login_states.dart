
abstract class LoginStates{}


class LoginInitialStates extends LoginStates{}

class LoginLoadingStates extends LoginStates{}

class LoginSuccessStates extends LoginStates{
  final String uID;
  LoginSuccessStates(this.uID);
}

class LoginErrorStates extends LoginStates{
  final String error;
  LoginErrorStates(this.error);

}


class LoginChangeVisabilityStates extends LoginStates{}