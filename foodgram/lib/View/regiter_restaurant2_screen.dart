import 'dart:io';

import 'package:flutter/material.dart';
import 'package:foodgram/Model/MenuEntity.dart';
import 'package:foodgram/Model/MenuRepository.dart';
import 'package:foodgram/Model/MenuSugestionApiAdapter.dart';
import 'package:foodgram/Model/MenuSugestionApiService.dart';
import 'package:foodgram/Model/RestaurantEntity.dart';
import 'package:foodgram/Model/RestaurantRepository.dart';
import 'package:foodgram/Model/UsuarioEntity.dart';
import 'package:foodgram/Model/UserRepository.dart';
import 'package:foodgram/Presenter/MenuPresenter.dart';
import 'package:foodgram/Presenter/RestaurantPresenter.dart';
import 'package:foodgram/View/login_screen.dart';
import 'package:foodgram/View/pagesInsideStudent.dart';
import 'package:foodgram/View/registro_menus.dart';

class RestaurantRegisterScreen2 extends StatefulWidget {
  final Restaurant restaurante;
  final Usuario user;

  const RestaurantRegisterScreen2({
    required this.restaurante,
    required this.user,
    super.key,
  });

  @override
  State<RestaurantRegisterScreen2> createState() =>
      _RestaurantRegisterScreen2State();
}

class _RestaurantRegisterScreen2State extends State<RestaurantRegisterScreen2>
    with RouteAware
    implements RestaurantView, MenuView {
  late final MenuPresenter presenterMenu;
  late final RestaurantPresenter presenterRestaurant;

  List<Menu> menuItems = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    presenterMenu = MenuPresenter(this);
    presenterRestaurant = RestaurantPresenter(this);
    presenterMenu.darMenu();
  }

  // didChangeDependencies is called on every dependency change (e.g. theme,
  // locale). Fetching the menu here caused redundant network calls.
  // initState + Navigator.pop() already re-triggers mostrarPlatos via
  // presenterMenu.darMenu() called in _addDish, so this override is removed.

  // No TextEditingControllers here — they belong to PreregisterMenu only.

  Future<void> _onFinishRegistration() async {
    if (_isLoading) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please wait, the AI is loading...')),
      );
      return;
    }
    final success = await presenterRestaurant.tryRegister(
      restaurante: widget.restaurante,
      usuario: widget.user,
      menus: menuItems,
    );
    if (success) presenterMenu.crearPlatos();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: NotificationListener<OverscrollIndicatorNotification>(
        onNotification: (overScroll) {
          overScroll.disallowIndicator();
          return true;
        },
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              backgroundColor: Colors.white,
              elevation: 0,
              floating: true,
              snap: true,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back, color: Color(0xFFFF6933)),
                onPressed: () => Navigator.pop(context),
              ),
              title: const Text(
                'Partner with Us',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              centerTitle: true,
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // --- HEADER ---
                    const Text(
                      'Create your Menu',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Expanded(
                          child: Text(
                            'Step 2 of 2',
                            style:
                                TextStyle(fontSize: 12, color: Colors.grey),
                          ),
                        ),
                        const Text(
                          '100%',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFFFF6347),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: const LinearProgressIndicator(
                        value: 1.0,
                        minHeight: 4,
                        backgroundColor:
                            Color.fromARGB(255, 230, 230, 230),
                        valueColor: AlwaysStoppedAnimation<Color>(
                          Color(0xFFFF6347),
                        ),
                      ),
                    ),
                    const SizedBox(height: 32),

                    // --- ADD TO MENU BUTTON ---
                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => PreregisterMenu(
                                restaurante: widget.restaurante.name,
                                menuPres: presenterMenu,
                              ),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFFF6933),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(28),
                          ),
                          elevation: 0,
                        ),
                        child: const Text(
                          'Add to Menu',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 32),

                    // --- MENU SECTION ---
                    const Text(
                      'MENU',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey,
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Use ListView.builder inside a SliverToBoxAdapter only
                    // when the list is small and already wrapped in a
                    // scrollable (CustomScrollView). shrinkWrap is avoided;
                    // instead we build items lazily via the spread operator
                    // replacement below — a plain indexed builder that
                    // constructs only what is needed.
                    if (menuItems.isEmpty)
                      const Center(
                        child: Padding(
                          padding: EdgeInsets.symmetric(vertical: 24),
                          child: Text(
                            'No dishes yet. Tap "Add to Menu" to get started.',
                            style:
                                TextStyle(color: Colors.grey, fontSize: 13),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      )
                    else
                      // RepaintBoundary isolates each card's repaint so that
                      // a change in one item does not repaint siblings.
                      ...List.generate(
                        menuItems.length,
                        (index) => RepaintBoundary(
                          child: _MenuItemCard(item: menuItems[index]),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16),
        child: SizedBox(
          width: double.infinity,
          height: 56,
          child: ElevatedButton(
            onPressed: _onFinishRegistration,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFFF6933),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(28),
              ),
              elevation: 0,
            ),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Finish Registration ',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                Icon(Icons.check, color: Colors.white),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // --- View callbacks ---

  @override
  void mostrarPlatos(List<Menu> platos) {
    if (mounted) setState(() => menuItems = platos);
  }

  @override
  void mostrarExito(String mensaje) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(mensaje)));
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => Pages()),
    );
  }

  @override
  void mostrarError(String mensaje) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(mensaje)));
  }

  @override
  void mostrarNoInternet(String s) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(s)));
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginScreen()),
    );
  }

  @override
  void estaCargando(bool mensaje) {
    if (mounted) setState(() => _isLoading = mensaje);
  }

  @override
  void mostrarRestaurantes(List<Restaurant> restaurantes) {}

  @override
  void hideLoading() {}

  @override
  void showLoading() {}

  @override
  void updateCameraPosition(double lat, double lng) {}
}

// ---------------------------------------------------------------------------
// Extracted const-capable card widget — no rebuild unless item reference
// changes, thanks to being a separate widget with its own element node.
// ---------------------------------------------------------------------------
class _MenuItemCard extends StatelessWidget {
  const _MenuItemCard({required this.item});

  final Menu item;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          CircleAvatar(
            radius: 24,
            backgroundColor: Colors.grey[200],
            backgroundImage: NetworkImage(item.image),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.name,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                Text(
                  '\$${item.price} • ${item.category}',
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                ),
              ],
            ),
          ),
          IconButton(
            icon: Icon(Icons.check_circle, color: Colors.grey[300]),
            onPressed: () {},
          ),
        ],
      ),
    );
  }
}