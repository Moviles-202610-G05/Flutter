import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:foodgram/Model/MenuEntity.dart';
import 'package:foodgram/Model/RestaurantEntity.dart';
import 'package:foodgram/Model/UsuarioEntity.dart';
import 'package:foodgram/View/Notificaciones.dart';
import 'package:foodgram/View/login_screen.dart';
import 'package:foodgram/firebase_options.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:foodgram/Presenter/UserPresenter.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await Hive.initFlutter();
  Hive.registerAdapter(UsuarioAdapter());
  await Hive.openBox<Usuario>('usuarios');
  Hive.registerAdapter(RestaurantAdapter());
  await Hive.openBox<Restaurant>('restaurants');
  Hive.registerAdapter(MenuAdapter());
  await Hive.openBox<Menu>('menu');

  await NotificationService.init();
  runApp(const MyApp());
}




class MyApp extends StatefulWidget {
  const MyApp({super.key});
  
  @override
  State<MyApp> createState() => _MyAppState();
  



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
    if (result != ConnectivityResult.none && !(await presenter.pending())) {
      try {
        await presenter.registerPending();       // Tu lógica de registro
        await presenter.clearPending(); // Limpia el box local
        
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
  final GlobalKey<ScaffoldMessengerState> _scaffoldMessengerKey =
    GlobalKey<ScaffoldMessengerState>();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      scaffoldMessengerKey: _scaffoldMessengerKey,
      debugShowCheckedModeBanner: false,
      title: 'Food App',
      theme: ThemeData(
        primarySwatch: Colors.deepOrange,
      ),
      home: LoginScreen(),
    );
  }

  @override
  void mostrarError(String mensaje) {
    _scaffoldMessengerKey.currentState?.showSnackBar(
      SnackBar(
        content: Text(mensaje),
      ),
    );
  }

  @override
  void mostrarExito(String mensaje) {
         _scaffoldMessengerKey.currentState?.showSnackBar(
      SnackBar(
            content: Text(
      mensaje,
      textAlign: TextAlign.center, // centra el texto dentro del SnackBar
    ),
    backgroundColor: Color(0xFFFF6933),
    behavior: SnackBarBehavior.floating, // lo hace flotante
    margin: EdgeInsets.symmetric(
      horizontal: 50, // margen lateral para que no ocupe todo el ancho
    ),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12), // bordes redondeados
    ),
  ),
      );
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