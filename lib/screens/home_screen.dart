import 'package:flutter/material.dart';
import '../data/sample_stories.dart';
import '../models/story.dart';
import '../models/user_profile.dart';
import 'profile_screen.dart';
import 'story_screen.dart';

class HomeScreen extends StatefulWidget {
  final Function(bool)? onThemeToggle;
  final bool isDarkMode;
  final UserProfile currentUser;
  final VoidCallback onLogout;

  HomeScreen({
    this.onThemeToggle,
    this.isDarkMode = false,
    required this.currentUser,
    required this.onLogout,
  });

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String searchQuery = "";
  String selectedCategory = "All";
  List<String> categories = ["All"];
  bool showScrollToTop = false;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    final uniqueCategories =
        stories.map((story) => story.category).toSet().toList();
    categories.addAll(uniqueCategories);

    _scrollController.addListener(() {
      if (_scrollController.offset > 200 && !showScrollToTop) {
        setState(() => showScrollToTop = true);
      } else if (_scrollController.offset <= 200 && showScrollToTop) {
        setState(() => showScrollToTop = false);
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List<Story> filteredStories = stories.where((story) {
      final matchesSearch = story.title
              .toLowerCase()
              .contains(searchQuery.toLowerCase()) ||
          story.author.toLowerCase().contains(searchQuery.toLowerCase());
      final matchesCategory =
          selectedCategory == "All" || story.category == selectedCategory;
      return matchesSearch && matchesCategory;
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text("Story App"),
        centerTitle: true,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(Icons.person),
            tooltip: "Profile",
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => ProfileScreen(
                    userProfile: widget.currentUser,
                    onLogout: widget.onLogout,
                  ),
                ),
              );
            },
          ),
          Row(
            children: [
              Icon(
                widget.isDarkMode ? Icons.dark_mode : Icons.light_mode,
                color: Colors.white,
              ),
              Switch(
                value: widget.isDarkMode,
                onChanged: (val) {
                  if (widget.onThemeToggle != null) {
                    widget.onThemeToggle!(val);
                  }
                },
                activeColor: Colors.white,
              ),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: EdgeInsets.all(10),
            child: TextField(
              onChanged: (value) {
                setState(() {
                  searchQuery = value;
                });
              },
              decoration: InputDecoration(
                hintText: "Search by title or author...",
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),

          // Category Filter
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: DropdownButtonFormField<String>(
              value: selectedCategory,
              items: categories.map((cat) {
                return DropdownMenuItem(
                  value: cat,
                  child: Text(cat),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedCategory = value!;
                });
              },
              decoration: InputDecoration(
                labelText: "Filter by Category",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),

          SizedBox(height: 10),

          // Story List / No Results
          Expanded(
            child: filteredStories.isEmpty
                ? _buildNoResultsFound()
                : AnimatedSwitcher(
                    duration: Duration(milliseconds: 400),
                    child: ListView.builder(
                      key: ValueKey(filteredStories.length),
                      controller: _scrollController,
                      padding: EdgeInsets.all(10),
                      itemCount: filteredStories.length,
                      itemBuilder: (context, index) {
                        final story = filteredStories[index];
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => StoryScreen(story: story),
                              ),
                            );
                          },
                          child: AnimatedContainer(
                            duration: Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                            margin: EdgeInsets.symmetric(vertical: 8),
                            child: Card(
                              elevation: 4,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.vertical(
                                        top: Radius.circular(12)),
                                    child: Image.asset(
                                      story.image,
                                      height: 180,
                                      width: double.infinity,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.all(12),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          story.title,
                                          style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        SizedBox(height: 6),
                                        Text(
                                          "by ${story.author} • ${story.category}",
                                          style: TextStyle(
                                            color: Theme.of(context)
                                                .textTheme
                                                .bodyMedium
                                                ?.color,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
          ),
        ],
      ),
      floatingActionButton: showScrollToTop
          ? FloatingActionButton(
              onPressed: () {
                _scrollController.animateTo(
                  0,
                  duration: Duration(milliseconds: 500),
                  curve: Curves.easeInOut,
                );
              },
              child: Icon(Icons.arrow_upward),
              tooltip: "Scroll to Top",
            )
          : null,
    );
  }

  Widget _buildNoResultsFound() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.search_off, size: 80, color: Colors.grey),
          SizedBox(height: 10),
          Text(
            "No Results Found",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 5),
          Text(
            "Try adjusting your search or filter",
            style: TextStyle(color: Colors.grey[600]),
          ),
        ],
      ),
    );
  }
}
