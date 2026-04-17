import 'package:flutter/material.dart';
import 'package:foodgram/Model/UserRepository.dart';

class FriendsScreen extends StatefulWidget {
  final String currentEmail;
  const FriendsScreen({super.key, required this.currentEmail});

  @override
  State<FriendsScreen> createState() => _FriendsScreenState();
}

class _FriendsScreenState extends State<FriendsScreen> {
  static const Color _primary = Color(0xFFFF6347);
  final TextEditingController _searchCtrl = TextEditingController();
  final UserRepository _repo = UserRepository();
  List<String> _friends = [];
  bool _loading = true;
  bool _adding = false;

  @override
  void initState() {
    super.initState();
    _loadFriends();
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  Future<void> _loadFriends() async {
    final user = await _repo.getUserByEmail(widget.currentEmail);
    if (mounted) {
      setState(() {
        _friends = user?.friends ?? [];
        _loading = false;
      });
    }
  }

  Future<void> _addFriend() async {
    final email = _searchCtrl.text.trim().toLowerCase();
    if (email.isEmpty || email == widget.currentEmail) return;
    setState(() => _adding = true);
    final name = await _repo.addFriend(widget.currentEmail, email);
    if (!mounted) return;
    setState(() => _adding = false);
    if (name != null) {
      _searchCtrl.clear();
      _loadFriends();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('$name added as a friend!')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('User not found.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F9F9),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF9F9F9),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: _primary, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Friends',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator(color: _primary))
          : Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _searchCtrl,
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(
                            hintText: 'Add friend by email',
                            prefixIcon: const Icon(
                                Icons.person_add_outlined, color: _primary),
                            filled: true,
                            fillColor: Colors.grey[100],
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(28),
                              borderSide: BorderSide.none,
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 14),
                          ),
                          onSubmitted: (_) => _addFriend(),
                        ),
                      ),
                      const SizedBox(width: 8),
                      _adding
                          ? const SizedBox(
                              width: 44,
                              height: 44,
                              child: Center(
                                child: CircularProgressIndicator(
                                    color: _primary, strokeWidth: 2),
                              ),
                            )
                          : ElevatedButton(
                              onPressed: _addFriend,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: _primary,
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(22),
                                ),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 12),
                                elevation: 0,
                              ),
                              child: const Text('Add'),
                            ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Expanded(
                    child: _friends.isEmpty
                        ? Center(
                            child: Text(
                              'No friends yet.\nAdd them with their email.',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: Colors.grey[500], fontSize: 15),
                            ),
                          )
                        : ListView.separated(
                            itemCount: _friends.length,
                            separatorBuilder: (_, _) =>
                                const Divider(height: 1),
                            itemBuilder: (context, i) => ListTile(
                              leading: CircleAvatar(
                                backgroundColor:
                                    _primary.withValues(alpha: 0.15),
                                child: const Icon(Icons.person, color: _primary),
                              ),
                              title: Text(
                                _friends[i],
                                style: const TextStyle(fontSize: 14),
                              ),
                            ),
                          ),
                  ),
                ],
              ),
            ),
    );
  }
}
