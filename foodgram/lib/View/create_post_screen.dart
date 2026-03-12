import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class CreatePostScreen extends StatefulWidget {
  const CreatePostScreen({super.key});

  @override
  State<CreatePostScreen> createState() => _CreatePostScreenState();
}

class _CreatePostScreenState extends State<CreatePostScreen> {
  File? _imagenSeleccionada;
  final TextEditingController _captionController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final List<String> _taggedFriends = ['@sarah_j', '@mike_eats'];
  final List<String> _selectedHashtags = [];
  
  final List<String> _availableHashtags = [
    '#Vegan',
    '#GlutenFree',
    '#DinnerDate',
    '#GourmetFood',
    '#Foodie',
    '#Delicious',
  ];


  void _toggleHashtag(String hashtag) {
    setState(() {
      if (_selectedHashtags.contains(hashtag)) {
        _selectedHashtags.remove(hashtag);
      } else {
        _selectedHashtags.add(hashtag);
      }
    });
  }

  void _removeTaggedFriend(String friend) {
    setState(() {
      _taggedFriends.remove(friend);
    });
  }

  void _showAddFriendDialog() {
    final TextEditingController friendController = TextEditingController();
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Tag a Friend'),
        content: TextField(
          controller: friendController,
          decoration: const InputDecoration(
            hintText: 'Enter username',
            prefixText: '@',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              if (friendController.text.isNotEmpty) {
                setState(() {
                  _taggedFriends.add('@${friendController.text}');
                });
                Navigator.pop(context);
              }
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  void _handlePost() {
    // Aquí iría la lógica para publicar el post
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Post created successfully!'),
        backgroundColor: Colors.deepOrange,
      ),
    );
    Navigator.pop(context);
  }

  @override
  void dispose() {
    _captionController.dispose();
    _locationController.dispose();
    super.dispose();
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
          slivers: [SliverAppBar(backgroundColor: Colors.white,
              elevation: 0,
              floating: true,
              snap: true,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back, color: Color(0xFFFF6933)),
                onPressed: () => Navigator.pop(context),
              ),
              title: const Text(
                'Post',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 28,
                  fontWeight: FontWeight.bold
                ),
              ),
              centerTitle: true,),
          SliverToBoxAdapter(
          child : Padding (padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Upload Photo Section
InkWell(
                      onTap: () async {
                        // Mostrar un diálogo para elegir cámara o galería
                        showModalBottomSheet(
                          context: context,
                          builder: (context) => Wrap(
                            children: [
                              ListTile(
                                leading: const Icon(Icons.camera_alt),
                                title: const Text("Abrir cámara"),
                                onTap: () {
                                  Navigator.pop(context);
                                  _pickImage(ImageSource.camera);
                                },
                              ),
                              ListTile(
                                leading: const Icon(Icons.photo_library),
                                title: const Text("Abrir galería"),
                                onTap: () {
                                  Navigator.pop(context);
                                  _pickImage(ImageSource.gallery);
                                },
                              ),
                            ],
                          ),
                        );
                      },
                    child: Container(

                    width: double.infinity,
                    height: 150,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: const Color(0xFFFF6933),
                        width: 2,
                        style: BorderStyle.solid,

                      ),
                      image: _imagenSeleccionada != null
                        ? DecorationImage(
                            image: FileImage(_imagenSeleccionada!),
                            fit: BoxFit.cover,
                        )
                      : null,
                      borderRadius: BorderRadius.circular(8),
                      color: const Color(0xFFFFEAE6),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: _imagenSeleccionada != null
                      ?[Positioned(
                            child: Container(
                              decoration: BoxDecoration(
                                color: const Color.fromARGB(118, 255, 99, 71),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              padding: const EdgeInsets.all(8),
                              child: const Icon(
                                Icons.edit,
                                color: Colors.white,
                                size: 20,
                              ),
                            ),
                          ),]
                      : [
                        Icon(
                          Icons.camera_alt_outlined,
                          size: 48,
                          color: const Color(0xFFFF6933),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Upload Photo',
                          style: TextStyle(
                            color: Color(0xFFFF6933),
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),),
              const SizedBox(height: 24),

              // Where did you eat?
              const Text(
                'Where did you eat?',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: Colors.grey[50],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.location_on,
                      color: Colors.deepOrange.shade400,
                      size: 24,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: TextField(
                        controller: _locationController,
                        decoration: const InputDecoration(
                          hintText: 'The Golden Truffle Bistro',
                          border: InputBorder.none,
                          hintStyle: TextStyle(
                            color: Colors.black87,
                            fontSize: 15,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Who were you with?
              const Text(
                'Who were you with?',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.grey[50],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.people,
                          color: Colors.deepOrange.shade400,
                          size: 24,
                        ),
                        const SizedBox(width: 12),
                        const Text(
                          'Tag friends',
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 15,
                          ),
                        ),const SizedBox(width: 12),GestureDetector(
                            onTap: _showAddFriendDialog,
                            child: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                                border: Border.all(color: Colors.grey[300]!),
                              ),
                              child: const Icon(
                                Icons.add,
                                size: 20,
                                color: Colors.grey,
                              ),
                            ),
                          ),
                      ],
                    ),
                    if (_taggedFriends.isNotEmpty) ...[
                      const SizedBox(height: 12),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          ..._taggedFriends.map((friend) => Chip(
                                avatar: CircleAvatar(
                                  backgroundColor: Colors.grey[300],
                                  child: const Icon(
                                    Icons.person,
                                    size: 16,
                                    color: Colors.white,
                                  ),
                                ),
                                
                                label: Text(friend),
                                deleteIcon: const Icon(Icons.close, size: 16),
                                onDeleted: () => _removeTaggedFriend(friend),
                                backgroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                  side: BorderSide(color: Colors.grey[300]!),
                                ),
                              )),
                          
                        ],
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Caption
              const Text(
                'Caption',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: Colors.grey[50],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: TextField(
                  controller: _captionController,
                  maxLines: 4,
                  decoration: const InputDecoration(
                    hintText: 'Write a caption... share your food journey',
                    border: InputBorder.none,
                    hintStyle: TextStyle(
                      color: Colors.grey,
                      fontSize: 15,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Hashtags
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: _availableHashtags.map((hashtag) {
                  final isSelected = _selectedHashtags.contains(hashtag);
                  return GestureDetector(
                    onTap: () => _toggleHashtag(hashtag),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        color: isSelected ? Colors.deepOrange : Colors.grey[100],
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        hashtag,
                        style: TextStyle(
                          color: isSelected ? Colors.white : Colors.black87,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 32),

              // Post Button
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: _handlePost,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepOrange,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    elevation: 0,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Text(
                        'Post',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(width: 8),
                      Icon(
                        Icons.send,
                        color: Colors.white,
                        size: 20,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
       )] ),
    ));
    
    
  }
  Future<void> _pickImage(ImageSource source) async {
  final ImagePicker picker = ImagePicker();
  final XFile? image = await picker.pickImage(source: source);

  if (image != null) {
      setState(() {
        _imagenSeleccionada = File(image.path);
      });

  }
}
}