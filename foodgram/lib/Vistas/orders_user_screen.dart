import 'package:flutter/material.dart';

class OrdersUserScreen extends StatelessWidget {
  const OrdersUserScreen({super.key});

  // ── Datos de ejemplo ────────────────────────────────────────────────────────
  static const List<Map<String, String>> _orders = [
    {
      'restaurant': 'The Golden Whisk',
      'date': 'Oct 24, 2023',
      'time': '12:30 PM',
      'items': 'Quinoa Salad Bowl, Fresh...',
      'price': r'$24.50',
    },
    {
      'restaurant': 'Burger & Co.',
      'date': 'Oct 18, 2023',
      'time': '7:45 PM',
      'items': 'Classic Cheeseburger, Sweet...',
      'price': r'$18.90',
    },
    {
      'restaurant': 'Sushi Master',
      'date': 'Oct 10, 2023',
      'time': '6:15 PM',
      'items': 'Salmon Sashimi Set, Miso Soup,...',
      'price': r'$42.00',
    },
    {
      'restaurant': 'Pizza Palace',
      'date': 'Sep 28, 2023',
      'time': '8:00 PM',
      'items': 'Pepperoni Pizza (Large), Garlic...',
      'price': r'$32.50',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(   
      backgroundColor: const Color(0xFFF2F2F2),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF2F2F2),
        elevation: 0,
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Container(
            margin: const EdgeInsets.all(8),
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.arrow_back_ios_new_rounded,
              color: Color(0xFFFF6347),
              size: 18,
            ),
          ),
        ),
        title: const Text(
          'Dining History',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        itemCount: _orders.length,
        itemBuilder: (context, index) {
          final order = _orders[index];
          return _OrderCard(order: order);
        },
      ),
    );
  }
}

// ── Tarjeta de pedido ──────────────────────────────────────────────────────────
class _OrderCard extends StatelessWidget {
  const _OrderCard({required this.order});

  final Map<String, String> order;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // ── Imagen del restaurante ──
          ClipRRect(
            borderRadius: BorderRadius.circular(14),
            child: Container(
              width: 64,
              height: 64,
              color: const Color(0xFFE8E0D5),
              child: Icon(
                Icons.restaurant,
                color: Colors.brown.shade200,
                size: 32,
              ),
            ),
          ),
          const SizedBox(width: 14),
          // ── Información ──
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      order['restaurant']!,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                        color: Colors.black87,
                      ),
                    ),
                    Text(
                      order['price']!,
                      style: const TextStyle(
                        color: Color(0xFFFF6347),
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 5),
                Row(
                  children: [
                    const Icon(
                      Icons.calendar_today_outlined,
                      size: 12,
                      color: Colors.grey,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '${order['date']} • ${order['time']}',
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 5),
                Text(
                  order['items']!,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}