import 'package:firebase_auth/firebase_auth.dart';
import 'package:foodgram/Model/PostEntity.dart';
import 'package:foodgram/Model/PostRespository.dart';

abstract class  PostView {
  void mostrarPosts(List<Post> posts);
  void mostrarError2(String mensaje);
  void mostrarExito(String mensaje);
}
class  PostPresenter {
  final PostRepository repository = PostRepository();
  final  PostView view;

  PostPresenter( this.view);

  Future<void> posts() async {
    print("entra");
    try {
      final firebaseUser = FirebaseAuth.instance.currentUser;
      view.mostrarPosts(await  repository.todosPost(firebaseUser!.email!)); 
    } catch (e) {
      view.mostrarError2("Error al mostrar posts: $e");
    }
  }

}