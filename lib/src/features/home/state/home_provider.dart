
import 'package:hooks_riverpod/hooks_riverpod.dart';

class UserData{
  String? name;
  String? lastName;
  String? email;
  String? phoneNumber;

  UserData({this.name, this.lastName, this.email, this.phoneNumber});
}
final localUserDataProvider = StateProvider<UserData?>((ref) => UserData(
  name: "Halima",
  lastName: "Moussa",
  email: "hal@gmail.com",
  phoneNumber: "0227 600000000",
));