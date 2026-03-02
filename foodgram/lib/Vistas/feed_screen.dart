import 'package:flutter/material.dart';

class FeedScreen extends StatefulWidget {
  const FeedScreen({super.key});

  @override
  State<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  int _selectedIndex = 0;

  final List<Map<String, dynamic>> posts = [
    {
      'userName': 'ChefMario',
      'userInitial': 'CM',
      'userColor': Colors.teal,
      'location': 'La Traviata Ristorante',
      'likes': 1234,
      'comments': 86,
      'description':
          'The best truffle pasta I\'ve had in the city. The aroma is just incredible. #Foodie #Truffle',
      'postImage':
          'https://images.unsplash.com/photo-1473093295203-cad00df16e50?w=500',
      'comments_data': [
        {
          'name': 'SushiLover',
          'comment': 'Fresh catch from this morning. You can easily taste the difference !'
        },
        {'name': 'User123', 'comment': '👌❤️ looks amazing'},
      ],
    },
    {
      'userName': 'SushiLover',
      'userInitial': 'SL',
      'userColor': Colors.deepPurple,
      'location': 'Otaku Sushi Bar',
      'likes': 856,
      'comments': 42,
      'description':
          'Fresh catch from this morning. You can easily taste the difference!',
      'postImage':
          'https://images.unsplash.com/photo-1579584425555-c3ce17fd4351?w=500',
      'comments_data': [
        {'name': 'ChefMario', 'comment': 'Looking delicious! 🍜'},
        {'name': 'FoodBlogger', 'comment': 'Where is this from?'},
      ],
    },
    {
      'userName': 'BurgerKing',
      'userInitial': 'BK',
      'userColor': Colors.orange,
      'location': 'The Burger Joint',
      'likes': 2145,
      'comments': 156,
      'description':
          'Homemade beef burger with special sauce and fresh ingredients. Worth every bite! #BurgerLife',
      'postImage':
          'https://images.unsplash.com/photo-1568901346375-23c9450c58cd?w=500',
      'comments_data': [
        {'name': 'SushiLover', 'comment': 'That looks juicy! 🍔'},
        {
          'name': 'ChefMario',
          'comment': 'Mind sharing the recipe for that sauce?'
        },
      ],
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        leadingWidth: 173,
        leading: Padding(
          padding: const EdgeInsets.only(left: 16),
          child: Row(
            children: [
              const Icon(Icons.restaurant_menu, color: Color(0xFFFF6347), size: 28),
              const SizedBox(width: 4),
              const Text(
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
        actions: [
          IconButton(
            icon: const Icon(Icons.favorite_border, color: Colors.red, size: 24),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.notifications_none, color: Colors.black, size: 24),
            onPressed: () {},
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: NotificationListener<OverscrollIndicatorNotification>(
        onNotification: (overScroll) {
          overScroll.disallowIndicator();
          return true;
        },
        child: ListView.separated(
          padding: const EdgeInsets.symmetric(vertical: 8),
          itemCount: posts.length,
          separatorBuilder: (context, index) => const SizedBox(height: 8),
          itemBuilder: (context, index) {
            final post = posts[index];
            return FoodPostCard(
              userName: post['userName'],
              userInitial: post['userInitial'],
              userColor: post['userColor'],
              location: post['location'],
              likes: post['likes'],
              comments: post['comments'],
              description: post['description'],
              postImage: post['postImage'],
              commentsData: post['comments_data'],
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Create new post')),
          );
        },
        backgroundColor: const Color(0xFFFF6347),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        child: const Icon(Icons.add, color: Colors.white, size: 28),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        selectedItemColor: const Color(0xFFFF6347),
        unselectedItemColor: Colors.grey[600],
        backgroundColor: Colors.white,
        type: BottomNavigationBarType.fixed,
        elevation: 8,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Search'),
          BottomNavigationBarItem(icon: Icon(Icons.bookmark), label: 'Saves'),
          BottomNavigationBarItem(icon: Icon(Icons.favorite), label: 'Likes'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}

// ============================================
// COMPONENTES REUTILIZABLES PARA TODA LA APP
// ============================================

/// Componente reutilizable para mostrar tarjetas de posts
class FoodPostCard extends StatefulWidget {
  final String userName;
  final String userInitial;
  final Color userColor;
  final String location;
  final int likes;
  final int comments;
  final String description;
  final String postImage;
  final List<Map<String, String>> commentsData;

  const FoodPostCard({
    super.key,
    required this.userName,
    required this.userInitial,
    required this.userColor,
    required this.location,
    required this.likes,
    required this.comments,
    required this.description,
    required this.postImage,
    required this.commentsData,
  });

  @override
  State<FoodPostCard> createState() => _FoodPostCardState();
}

class _FoodPostCardState extends State<FoodPostCard> {
  late bool _isLiked;
  late int _currentLikes;

  @override
  void initState() {
    super.initState();
    _isLiked = false;
    _currentLikes = widget.likes;
  }

  void _toggleLike() {
    setState(() {
      _isLiked = !_isLiked;
      _currentLikes += _isLiked ? 1 : -1;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      margin: const EdgeInsets.only(bottom: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // --- USER HEADER ---
          UserHeader(
            userName: widget.userName,
            userInitial: widget.userInitial,
            userColor: widget.userColor,
            location: widget.location,
          ),

          // --- POST IMAGE ---
          FoodImage(imageUrl: widget.postImage),

          // --- INTERACTION ROW ---
          InteractionButtons(
            likes: _currentLikes,
            comments: widget.comments,
            isLiked: _isLiked,
            onLikeTap: _toggleLike,
          ),

          // --- DESCRIPTION ---
          PostDescription(
            userName: widget.userName,
            description: widget.description,
          ),

          // --- VIEW COMMENTS ---
          ViewCommentsButton(
            commentCount: widget.comments,
            onTap: () {
              // Navegar a pantalla de detalles
            },
          ),

          // --- COMMENTS PREVIEW ---
          CommentsPreview(
            comments: widget.commentsData,
          ),

          // --- TIMESTAMP ---
          Container(
            color: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: const Text(
              '2 hours ago',
              style: TextStyle(
                color: Colors.grey,
                fontSize: 10,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Header con información del usuario
class UserHeader extends StatelessWidget {
  final String userName;
  final String userInitial;
  final Color userColor;
  final String location;

  const UserHeader({
    super.key,
    required this.userName,
    required this.userInitial,
    required this.userColor,
    required this.location,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      child: Row(
        children: [
          CircleAvatar(
            radius: 20,
            backgroundColor: userColor,
            child: Text(
              userInitial,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  userName,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                    color: Colors.black,
                  ),
                ),
                Text(
                  location,
                  style: const TextStyle(
                    fontSize: 11,
                    color: Colors.grey,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.more_vert, size: 20),
            onPressed: () {},
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(maxHeight: 40, maxWidth: 40),
          ),
        ],
      ),
    );
  }
}

/// Imagen del post
class FoodImage extends StatelessWidget {
  final String imageUrl;

  const FoodImage({super.key, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 320,
      color: Colors.grey[800],
      child: Image.network(
        imageUrl,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return Container(
            color: Colors.grey[300],
            child: const Icon(Icons.image_not_supported, size: 48),
          );
        },
      ),
    );
  }
}

/// Botones de interacción (likes, comentarios, compartir)
class InteractionButtons extends StatelessWidget {
  final int likes;
  final int comments;
  final bool isLiked;
  final VoidCallback onLikeTap;

  const InteractionButtons({
    super.key,
    required this.likes,
    required this.comments,
    required this.isLiked,
    required this.onLikeTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      child: Row(
        children: [
          GestureDetector(
            onTap: onLikeTap,
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.red, width: 1.5),
                borderRadius: BorderRadius.circular(6),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    isLiked ? Icons.favorite : Icons.favorite_outline,
                    color: Colors.red,
                    size: 18,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    likes.toString(),
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 10),
          Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey[300]!, width: 1.5),
              borderRadius: BorderRadius.circular(6),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.chat_bubble_outline,
                  color: Colors.grey[600],
                  size: 18,
                ),
                const SizedBox(width: 6),
                Text(
                  comments.toString(),
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          Icon(Icons.share, color: Colors.grey[600], size: 20),
          const Spacer(),
          Icon(Icons.bookmark_outline, color: Colors.grey[600], size: 20),
        ],
      ),
    );
  }
}

/// Descripción del post
class PostDescription extends StatelessWidget {
  final String userName;
  final String description;

  const PostDescription({
    super.key,
    required this.userName,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: RichText(
        text: TextSpan(
          children: [
            TextSpan(
              text: '$userName ',
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                color: Colors.black,
                fontSize: 13,
              ),
            ),
            TextSpan(
              text: description,
              style: const TextStyle(
                color: Colors.black,
                fontSize: 13,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Botón para ver todos los comentarios
class ViewCommentsButton extends StatelessWidget {
  final int commentCount;
  final VoidCallback onTap;

  const ViewCommentsButton({
    super.key,
    required this.commentCount,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      child: GestureDetector(
        onTap: onTap,
        child: Text(
          'View all $commentCount comments',
          style: const TextStyle(
            color: Colors.grey,
            fontSize: 11,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}

/// Vista previa de comentarios
class CommentsPreview extends StatelessWidget {
  final List<Map<String, String>> comments;

  const CommentsPreview({super.key, required this.comments});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: comments
            .take(2)
            .map(
              (comment) => Padding(
                padding: const EdgeInsets.only(bottom: 6.0),
                child: RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: '${comment['name']} ',
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                          fontSize: 12,
                        ),
                      ),
                      TextSpan(
                        text: comment['comment'],
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            )
            .toList(),
      ),
    );
  }
}