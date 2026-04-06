import 'package:flutter/material.dart';

class ReviewsUserScreen extends StatelessWidget {
  const ReviewsUserScreen({super.key});

  static const List<Map<String, dynamic>> _reviews = [
    {
      'restaurant': 'The Green Garden',
      'date': '12 Oct 2023',
      'meal': 'Lunch',
      'review':
          'Absolutely loved the avocado toast here! The sourdough was perfectly crispy, and the poached eggs were runny just how I like them. Highly recommend for a healthy brunch spot.',
      'likes': 124,
      'comments': 8,
    },
    {
      'restaurant': 'Burger & Co.',
      'date': '05 Oct 2023',
      'meal': 'Dinner',
      'review':
          'Great atmosphere and the truffle fries are to die for. The burger was juicy, though a bit too much sauce for my taste. Service was impeccable!',
      'likes': 89,
      'comments': 12,
    },
    {
      'restaurant': 'Sushi Master',
      'date': '28 Sep 2023',
      'meal': 'Dinner',
      'review':
          'Best omakase experience in the city. Every piece was a work of art. The chef explained the origin of every fish. Pricey but worth it for special occasions.',
      'likes': 245,
      'comments': 34,
    },
    {
      'restaurant': 'Pasta Palace',
      'date': '15 Sep 2023',
      'meal': 'Lunch',
      'review':
          'The pasta was decent, but the service was incredibly slow. We waited 40 minutes for our main courses. Might give it another try on a less busy day.',
      'likes': 15,
      'comments': 3,
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
          'My Reviews',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
      ),
      body: NotificationListener<OverscrollIndicatorNotification>(
        onNotification: (overScroll) {
          overScroll.disallowIndicator();
          return true;
        },
        child: ListView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 8),
          itemCount: _reviews.length,
          itemBuilder: (context, index) {
            return _ReviewCard(review: _reviews[index]);
          },
        ),
      ),
    );
  }
}

class _ReviewCard extends StatelessWidget {
  const _ReviewCard({required this.review});

  final Map<String, dynamic> review;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Texto superior ──
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  review['restaurant'],
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${review['date']} • ${review['meal']}',
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
                const SizedBox(height: 10),
                Text(
                  review['review'],
                  style: const TextStyle(
                    fontSize: 13,
                    color: Colors.black54,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
          // ── Imagen pegada al borde inferior ──
          ClipRRect(
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(20),
              bottomRight: Radius.circular(20),
            ),
            child: Container(
              height: 180,
              width: double.infinity,
              color: const Color(0xFFDDC9B4),
            ),
          ),
          // ── Likes y comentarios ──
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                _buildAction(Icons.favorite_border_rounded, '${review['likes']}'),
                const SizedBox(width: 20),
                _buildAction(Icons.chat_bubble_outline_rounded, '${review['comments']}'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAction(IconData icon, String count) {
    return Row(
      children: [
        Icon(icon, size: 20, color: Colors.grey),
        const SizedBox(width: 5),
        Text(count, style: const TextStyle(fontSize: 13, color: Colors.grey)),
      ],
    );
  }
}