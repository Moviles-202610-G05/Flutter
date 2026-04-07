import 'package:firebase_auth/firebase_auth.dart';
import 'package:foodgram/Model/RestaurantEntity.dart';
import 'package:foodgram/Model/RestaurantRepository.dart';
import 'package:foodgram/Model/UserEntity.dart';
import 'package:foodgram/Model/UserRepository.dart';
import 'package:foodgram/Model/UtilitysFierbase.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

abstract class RestaurantView {
  void showLoading();
  void hideLoading();
  void mostrarRestaurantes(List<Restaurant> restaurants);
  void updateCameraPosition(double lat, double lng);
  void mostrarError(String message);
  void mostrarExito(String message);
  
  void mostrarRuta(List<LatLng> polylineCoordinates) {}

}

class RestaurantPresenter {
  final RestaurantRepository repository;
  final UserRepository repositoryUsuario;
  final RestaurantView view;

  RestaurantPresenter(this.repository, this.repositoryUsuario, this.view);

  Future<void> calcularRuta(double destLat, double destLng) async {
  PolylinePoints polylinePoints = PolylinePoints(apiKey: 'AIzaSyDxzMLWUCmAQqm2dpmpDzkC3L8r09rEri4');
  Position position = await _getCurrentLocation();
  // 1. Pedir la ruta a Google
  PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
    request: PolylineRequest(
      origin: PointLatLng(position.latitude, position.longitude),
      destination: PointLatLng(destLat, destLng),
      mode: TravelMode.driving, // Puede ser walking para estudiantes en Uniandes
    ),
  );

  if (result.points.isNotEmpty) {
    List<LatLng> polylineCoordinates = [];
    
    // 2. Convertir los puntos de la respuesta en LatLng de Flutter
    for (var point in result.points) {
      polylineCoordinates.add(LatLng(point.latitude, point.longitude));
    }
    print("STATUS DE LA RUTA: ${result.status}");
    // 3. Enviarlo a la vista para que lo pinte
    view.mostrarRuta(polylineCoordinates);
  }
}

  Future<void> cargarRestaurantes() async {
    try {
      final restaurantes = await repository.todosRestaurantes();
      view.mostrarRestaurantes(restaurantes);
    } catch (e) {
      view.mostrarError("Error al cargar restaurantes: $e");
    }
  }
  UtilitisFirebase utilitisFirebase = UtilitisFirebase();
  Future<void> agregarRestaurante(Restaurant restaurante, Usuario usuario) async {
    try {
      
      view.mostrarExito("Restaurante agregado correctamente");
      usuario.setRol("RESTAURANTE") ;
      bool disponible = await repositoryUsuario.isUsernameAvailable(usuario.username);
      if (!disponible) {
        view.mostrarError("El nombre de usuario ya está en uso.");
        return;
      }

      await FirebaseAuth.instance.createUserWithEmailAndPassword(email: usuario.email, password: usuario.password, );

      
      utilitisFirebase.subirImagen(restaurante.imagenFiel!);
      await repositoryUsuario.crearUser(usuario); 
      await repository.crearRestaurante(restaurante);

      view.mostrarExito("Usuario creado correctamente."); 
    } on FirebaseAuthException catch (e) {
      view.mostrarError("Error de autenticación: ${e.message}");
    } catch (e) {
      view.mostrarError("Error al crear usuario: $e");
    }
    
  }

Future<void> fetchNearbyRestaurants() async {
  try {
    view.showLoading();

    // 1. Obtener ubicación actual
    Position position = await _getCurrentLocation();
    
    // 2. Mover la cámara
    view.updateCameraPosition(position.latitude, position.longitude);

    // 3. ESCUCHAR el Stream del repositorio
    // Nota: Aquí quitamos el 'await' porque un Stream no se espera, se escucha.
    repository.getRestaurantsByProximity(
      position.latitude, 
      position.longitude, 10
    ).listen((restaurants) {
      
      // 4. Entregar los datos a la vista cada vez que el Stream emita algo
      if (restaurants.isEmpty) {
        view.mostrarError("No se encontraron restaurantes cerca.");
      } else {
        print(restaurants);
        view.mostrarRestaurantes(restaurants);
      }
      
      view.hideLoading(); // Ocultamos el loader cuando llega el primer paquete de datos
      
    }, onError: (e) {
      print("------ERROR-----");
      view.mostrarError("Error en el stream: ${e.toString()}");
      print("${e.toString()}");
      view.hideLoading();
    });

  } catch (e) {
    view.mostrarError("Error al obtener ubicación: ${e.toString()}");
    view.hideLoading();
  }
}

  /// Lógica privada para manejar el GPS
  Future<Position> _getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) return Future.error('El GPS está desactivado.');

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Permisos de ubicación denegados.');
      }
    }
    
    return await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high
    );
  }


  
}