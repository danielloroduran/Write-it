import 'package:firebase_auth/firebase_auth.dart';

class UserService{

  final FirebaseAuth _fa = FirebaseAuth.instance;

  Future<User> signInEmail(String email, String password) async{
    return (await _fa.signInWithEmailAndPassword(email: email, password: password)).user;
  }

  Future<User> createUser(String email, String password) async{
    return (await _fa.createUserWithEmailAndPassword(email: email, password: password)).user;
  }

  Future<User> getCurrentUser() async{
    User user = _fa.currentUser;
    return user;
  }

  void _changePassword(String password) async{
    User user = await getCurrentUser();
    user.updatePassword(password);
  }

  Future<void> updateUser(String email, String nombre) async{
    User user = await getCurrentUser();
    await user.updateDisplayName(nombre);
    return await user.updateEmail(email);
    //user.reload();

  }

  void cerrarSesion(){
    _fa.signOut();
  }

} 