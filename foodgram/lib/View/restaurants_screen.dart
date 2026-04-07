import 'package:flutter/material.dart';
import 'package:foodgram/Model/RestaurantEntity.dart';
import 'package:foodgram/Model/RestaurantRepository.dart';
import 'package:foodgram/Model/UserRepository.dart';
import 'package:foodgram/Presenter/RestaurantPresenter.dart';
import 'package:foodgram/View/pagesInsideStudent.dart' show Pages, PagesState;
import 'package:foodgram/View/restaurant_detalle_screen.dart';
import 'package:foodgram/View/widgets/restaurants.dart';
import 'package:google_maps_flutter_platform_interface/src/types/location.dart';

class RestaurantFeed extends StatefulWidget {
  @override
  _RestaurantFeed createState() => _RestaurantFeed();
}

class _RestaurantFeed extends State<RestaurantFeed> 
  implements RestaurantView {
  late RestaurantPresenter presenter;
  List<Restaurant> restaurantes = [];
  static const Color primary = Color(0xFFFF6933);
  final Set<int> favorites = {};
  int selectedCategory = 0;
  final categories = const ['Italian', 'Mexican', 'Fast Food'];

  final List<Map<String, dynamic>> featured = const [
    {
      'name': 'Oasis Garden',
      'rating': 4.9,
      'image':
          'https://images.unsplash.com/photo-1513104890138-7c749659a591?w=1200',
    },
    {
      'name': 'Steakhouse',
      'rating': 4.7,
      'image':
          'https://images.unsplash.com/photo-1544025162-d76694265947?w=1200',
    },
  ];

  @override
  void initState() {
    super.initState();
    presenter = RestaurantPresenter(RestaurantRepository(), UserRepository() ,this);
    presenter.cargarRestaurantes();
  }

  @override
  void mostrarRestaurantes(List<Restaurant> restaurantes) {
    setState(() {
      this.restaurantes = restaurantes;
    });
  }

  @override
  void mostrarError(String mensaje) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(mensaje)));
  }

  @override
  void mostrarExito(String mensaje) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(mensaje)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      body: NotificationListener<OverscrollIndicatorNotification>(
        onNotification: (overScroll) {
          overScroll.disallowIndicator();
          return true;
        },
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              leadingWidth: 173,

              leading: Padding(
                padding: const EdgeInsets.only(left: 16),
                child: Row(
                  children: const [
                    Icon(
                      Icons.restaurant_menu,
                      color: Color(0xFFFF6347),
                      size: 28,
                    ),
                    SizedBox(width: 4),
                    Text(
                      'FoodGram',
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFFFF6347),
                      ),
                    ),
                  ],
                ),
              ),
              expandedHeight: 148, // altura máxima cuando está expandido
              actions: [
                Padding(
                  padding: const EdgeInsets.only(left: 10.0, right: 10),
                  child: Container(
                    width: 30,
                    height: 30,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                    ),
                    child: const Icon(Icons.tune, color: primary, size: 18),
                  ),
                ),
              ],
              floating: true,
              backgroundColor: Colors.white,
              flexibleSpace: FlexibleSpaceBar(
                background: Padding(
                  padding: const EdgeInsets.only(
                    left: 10.0,
                    right: 10,
                    bottom: 10,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Spacer(),
                      const SizedBox(height: 10),
                      Container(
                        height: 44,
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(28, 255, 105, 51),
                          borderRadius: BorderRadius.circular(24),
                        ),
                        child: const TextField(
                          decoration: InputDecoration(
                            hintText: 'Search restaurants, cuisines...',
                            hintStyle: TextStyle(
                              fontSize: 13,
                              color: Colors.grey,
                            ),
                            border: InputBorder.none,
                            prefixIcon: Icon(
                              Icons.search,
                              color: primary,
                              size: 20,
                            ),
                            contentPadding: EdgeInsets.only(top: 11),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: List.generate(categories.length, (index) {
                          final selected = selectedCategory == index;
                          return Padding(
                            padding: EdgeInsets.only(right: index == 2 ? 0 : 8),
                            child: GestureDetector(
                              onTap: () =>
                                  setState(() => selectedCategory = index),
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 14,
                                  vertical: 8,
                                ),
                                decoration: BoxDecoration(
                                  color: selected ? primary : Colors.white,
                                  borderRadius: BorderRadius.circular(22),
                                ),
                                child: Text(
                                  categories[index],
                                  style: TextStyle(
                                    color: selected
                                        ? Colors.white
                                        : Colors.black87,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                            ),
                          );
                        }),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            SliverToBoxAdapter(
              child: Column(
                children: [
                  const SizedBox(height: 8),
                  Recommended(primary: primary, featured: featured,),
                  const SizedBox(height: 8),
                  ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: restaurantes.length,
                  itemBuilder: (context, index) {
              
                  final r = restaurantes[index];
                  return (InkWell(
                          onTap: () {
                                final pagesState = context.findAncestorStateOfType<PagesState>();
                                pagesState?.setState(() {
                                print(r.name);
                                pagesState.setCurrentIndex2(1, r.name); // Cambia al índice de tu vista especial
                            } );
                            },
                          child: (RestaurantCard(
                                  data: r,
                                  primary: primary,
                                  isFavorite: favorites.contains(index),
                                  onFavoriteTap: () {
                                    setState(() {
                                      if (favorites.contains(index)) {
                                        favorites.remove(index);
                                      } else {
                                        favorites.add(index);
                                      }
                                    });
                                  },
                                ))));
                              },
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  @override
  void hideLoading() {
    // TODO: implement hideLoading
  }
  
  @override
  void showLoading() {
    // TODO: implement showLoading
  }
  
  @override
  void updateCameraPosition(double lat, double lng) {
    // TODO: implement updateCameraPosition
  }

  @override
  void mostrarRuta(List<LatLng> polylineCoordinates) {
    // TODO: implement mostrarRuta
  }
}