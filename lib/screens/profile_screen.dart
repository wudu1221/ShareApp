import 'package:flutter/material.dart';
import '../models/user_profile.dart';

class ProfileScreen extends StatefulWidget {
  final UserProfile userProfile;
  final VoidCallback onLogout;

  const ProfileScreen({
    Key? key,
    required this.userProfile,
    required this.onLogout,
  }) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  // Mock data (replace with backend data later)
  final List<Map<String, String>> savedStories = [
    {"title": "The River's Whisper", "author": "Liya Alemu"},
    {"title": "Shadows of Gondar", "author": "Mulugeta Bekele"},
  ];

  final List<Map<String, String>> mySubmissions = [
    {"title": "The Desert Rose", "status": "Pending"},
    {"title": "The Hidden Village", "status": "Approved"},
    {"title": "Whispers in the Market", "status": "Rejected"},
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case "Approved":
        return Colors.green;
      case "Pending":
        return Colors.orange;
      case "Rejected":
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = widget.userProfile;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Profile"),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: "Logout",
            onPressed: () {
              _confirmLogout(context);
            },
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          tabs: const [
            Tab(text: "Saved Stories"),
            Tab(text: "My Submissions"),
          ],
        ),
      ),
      body: Column(
        children: [
          _buildProfileHeader(user),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [_buildSavedStoriesTab(), _buildMySubmissionsTab()],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileHeader(UserProfile user) {
    return Container(
      padding: const EdgeInsets.all(16),
      color: Theme.of(context).colorScheme.primaryContainer.withOpacity(0.2),
      child: Row(
        children: [
          CircleAvatar(
            radius: 40,
            backgroundImage:
                (user.avatarUrl != null && user.avatarUrl!.isNotEmpty)
                ? NetworkImage(user.avatarUrl!)
                : null,
            child: (user.avatarUrl == null || user.avatarUrl!.isEmpty)
                ? const Icon(Icons.person, size: 40)
                : null,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  user.name,
                  style: Theme.of(
                    context,
                  ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                ),
                Text(
                  user.email,
                  style: Theme.of(
                    context,
                  ).textTheme.bodyMedium?.copyWith(color: Colors.grey[700]),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSavedStoriesTab() {
    if (savedStories.isEmpty) {
      return _buildEmptyState("No saved stories yet.", Icons.bookmark_border);
    }
    return ListView.builder(
      itemCount: savedStories.length,
      itemBuilder: (context, index) {
        final story = savedStories[index];
        return ListTile(
          title: Text(story["title"]!),
          subtitle: Text("by ${story["author"]}"),
          leading: const Icon(Icons.bookmark, color: Colors.blue),
          onTap: () {
            // TODO: Open story
          },
        );
      },
    );
  }

  Widget _buildMySubmissionsTab() {
    if (mySubmissions.isEmpty) {
      return _buildEmptyState(
        "You haven't submitted any stories yet.",
        Icons.edit_note,
      );
    }
    return ListView.builder(
      itemCount: mySubmissions.length,
      itemBuilder: (context, index) {
        final submission = mySubmissions[index];
        return ListTile(
          title: Text(submission["title"]!),
          trailing: Text(
            submission["status"]!,
            style: TextStyle(
              color: _getStatusColor(submission["status"]!),
              fontWeight: FontWeight.bold,
            ),
          ),
        );
      },
    );
  }

  Widget _buildEmptyState(String message, IconData icon) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 48, color: Colors.grey),
          const SizedBox(height: 8),
          Text(message, style: TextStyle(color: Colors.grey[600])),
        ],
      ),
    );
  }

  void _confirmLogout(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Confirm Logout"),
        content: const Text("Are you sure you want to log out?"),
        actions: [
          TextButton(
            child: const Text("Cancel"),
            onPressed: () => Navigator.pop(context),
          ),
          TextButton(
            child: const Text("Logout"),
            onPressed: () {
              Navigator.pop(context);
              widget.onLogout();
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }
}
