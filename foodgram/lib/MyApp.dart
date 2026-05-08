// my_app.dart
import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:foodgram/Model/UsuarioEntity.dart';
import 'package:foodgram/Presenter/UserPresenter.dart';
import 'package:foodgram/View/login_screen.dart';

class MyApp extends StatefulWidget {
  const MyApp({super.key});
  
  @override
  State<MyApp> createState() => _MyAppState();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Food App',
      theme: ThemeData(
        primarySwatch: Colors.deepOrange,
      ),
      home: LoginScreen(),
    );
  }



}


class _MyAppState extends State<MyApp> implements UserView {
  late final StreamSubscription<ConnectivityResult> _connectivitySub;
  late final UserPresenter presenter;
  

  @override
  void initState() {
    super.initState();
    presenter = UserPresenter(this);
    // Escucha cambios de red en tiempo real
    _connectivitySub = Connectivity()
        .onConnectivityChanged
        .listen(_onConnectivityChanged);
  }

  Future<void> _onConnectivityChanged(ConnectivityResult result) async {
    if (result != ConnectivityResult.none && presenter.hasPending) {
      try {
        await presenter.registerPending();       // Tu lógica de registro
        presenter.clearPending(); // Limpia el box local
        
      } catch (e) {
        debugPrint('Error al sincronizar registro pendiente: $e');
      }
    }
  }

 

  @override
  void dispose() {
    _connectivitySub.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // tu configuración...
    );
  }
  
  @override
  void mostrarError(String mensaje) {
    // TODO: implement mostrarError
  }
  
  @override
  void mostrarExito(String mensaje) {
    // TODO: implement mostrarExito
  }
  
  @override
  void mostrarPerfil(Usuario usuario) {
    // TODO: implement mostrarPerfil
  }
  
  @override
  void mostrarUsuarios(List<Usuario> usuarios) {
    // TODO: implement mostrarUsuarios
  }
  
  @override
  void onLoginSuccess() {
    // TODO: implement onLoginSuccess
  }
  
  @override
  void mostrarNoInternet(String mensaje) {
    // TODO: implement mostrarNoInternet
  }
}