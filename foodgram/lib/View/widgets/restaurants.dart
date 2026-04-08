import 'package:flutter/material.dart';
import 'package:foodgram/Model/RestaurantEntity.dart';
import 'package:foodgram/View/pagesInsideStudent.dart';


class FeaturedCard extends StatelessWidget {
  final String image;
  final String name;
  final double rating;
  final Color primary;

  const FeaturedCard({
    required this.image,
    required this.name,
    required this.rating,
    required this.primary,
  });
  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
                          onTap: () {
                                final pagesState = context.findAncestorStateOfType<PagesState>();
                                pagesState?.setState(() {
                                print(name);
                                pagesState.setCurrentIndex2(1, name); // Cambia al índice de tu vista especial
                            } );
                            },
      
      
      child: Stack(
        children: [
          SizedBox(
            width: 200,
            height: 156,
            child: Image.network(image, fit: BoxFit.cover),
          ),
          Positioned(
            top: 8,
            left: 8,
            child: RatingPill(rating: rating, primary: primary),
          ),
          Positioned(
            left: 10,
            bottom: 10,
            child: Text(
              name,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
                fontSize: 20,
                shadows: [Shadow(blurRadius: 6, color: Colors.black54)],
              ),
            ),
          ),
        ],
      ),
    ));
  }
}

class RestaurantCard extends StatelessWidget {
  final Restaurant data;
  final Color primary;
  final bool isFavorite;
  final VoidCallback onFavoriteTap;

  const RestaurantCard({
    required this.data,
    required this.primary,
    required this.isFavorite,
    required this.onFavoriteTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(12, 10, 12, 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(26),
        boxShadow: const [
          BoxShadow(
            color: Color(0x14000000),
            blurRadius: 16,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(26)),
            child: Stack(
              children: [
                SizedBox(
                  height: 160,
                  width: double.infinity,
                  child: Image.network(data.image, fit: BoxFit.cover),
                ),
                Positioned(
                  top: 10,
                  left: 10,
                  child: RatingPill(
                    rating: data.rating,
                    primary: primary,
                    reviews: data.numberReviews,
                  ),
                ),
                Positioned(
                  top: 10,
                  right: 10,
                  child: GestureDetector(
                    onTap: onFavoriteTap,
                    child: Container(
                      width: 28,
                      height: 28,
                      decoration: BoxDecoration(
                        color: Colors.black38,
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Icon(
                        isFavorite ? Icons.favorite : Icons.favorite_border,
                        color: Colors.white,
                        size: 16,
                      ),
                    ),
                  ),
                ),
                if ((data.badge).isNotEmpty)
                  Positioned(
                    left: 10,
                    bottom: 10,
                    child: Row(
                      children: [
                        Badge(text: data.badge, primary: primary),
                        const SizedBox(width: 6),
                        if ((data.badge2).isNotEmpty)
                          Badge(text: data.badge2, primary: Colors.black54),
                      ],
                    ),
                  ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 10, 14, 14),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        data.name,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                    Text(
                      data.price,
                      style: const TextStyle(
                        color: Color(0xFFFF6933),
                        fontWeight: FontWeight.w800,
                        fontSize: 18,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  data.description,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 13,
                    color: Color(0xFF8A8A8A),
                    height: 1.25,
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Icon(Icons.schedule, size: 14, color: primary.withOpacity(.9)),
                    const SizedBox(width: 4),
                    Text(
                      data.time,
                      style: const TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                    const SizedBox(width: 12),
                    Icon(Icons.location_on_outlined,
                        size: 14, color: primary.withOpacity(.9)),
                    const SizedBox(width: 4),
                    Text(
                      data.distance,
                      style: const TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 9,
                      ),
                      decoration: BoxDecoration(
                        color: primary,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Text(
                        'View Menu',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
      
    );
    
  }

}

class RatingPill extends StatelessWidget {
  final double rating;
  final int? reviews;
  final Color primary;

  const RatingPill({
    required this.rating,
    required this.primary,
    this.reviews,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
      decoration: BoxDecoration(
        color: const Color(0xFFFCEFEA),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          const Icon(Icons.star_border, color:  Color(0xFFFF6933), size: 14),
          const SizedBox(width: 4),
          Text(
            reviews == null ? '$rating' : '$rating (${reviews!})',
            style: const TextStyle(
              color: Color.fromARGB(255, 0, 0, 0),
              fontWeight: FontWeight.w600,
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }
}

class Badge extends StatelessWidget {
  final String text;
  final Color primary;

  const Badge({required this.text, required this.primary});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
      decoration: BoxDecoration(
        color: primary,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w700,
          fontSize: 9,
        ),
      ),
    );
  }
}

class Recommended extends StatelessWidget{

  final Color primary;
  final List<Restaurant> featured;

  const Recommended({
    required this.primary,
    required this.featured,
  });
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(vertical: 10),
    

      child: Column(
        
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14),
            child: Row(
              children: [
                const Text(
                  'Recommended for You',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.w800),
                ),
                const Spacer(),
                Text(
                  'See All',
                  style: TextStyle(
                    color: primary,
                    fontWeight: FontWeight.w700,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          SizedBox(
            height: 156,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 14),
              itemBuilder: (_, index) => FeaturedCard(
                
                image: featured[index].image,
                name: featured[index].name,
                rating: featured[index].rating,
                primary: primary,
              ),
              separatorBuilder: (_, __) => const SizedBox(width: 10),
              itemCount: featured.length,
            ),
          ),
        ],
      ),
    );
  }
}
