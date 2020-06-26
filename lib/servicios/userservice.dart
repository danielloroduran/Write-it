import 'package:firebase_auth/firebase_auth.dart';

class UserService{

  final FirebaseAuth _fa = FirebaseAuth.instance;

  Future<FirebaseUser> signInEmail(String email, String password) async{
    return (await _fa.signInWithEmailAndPassword(email: email, password: password)).user;
  }

  Future<FirebaseUser> createUser(String email, String password) async{
    return (await _fa.createUserWithEmailAndPassword(email: email, password: password)).user;
  }

  Future<FirebaseUser> getCurrentUser() async{
    FirebaseUser user = await _fa.currentUser();
    return user;
  }

  void _changePassword(String password) async{
    FirebaseUser user = await getCurrentUser();
    user.updatePassword(password);
  }

  Future<void> updateUser(String email, String nombre) async{
    FirebaseUser user = await getCurrentUser();
    UserUpdateInfo userUpdate = new UserUpdateInfo();
    userUpdate.displayName = nombre;
    return await user.updateEmail(email);
    //user.reload();

  }

  void cerrarSesion(){
    _fa.signOut();
  }

} 