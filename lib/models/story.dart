enum StoryStatus { pending, approved, rejected }

class Story {
  final String title;
  final String content;
  final String image;
  final String author;
  final String category;
  StoryStatus status;

  Story({
    required this.title,
    required this.content,
    required this.image,
    required this.author,
    required this.category,
    this.status = StoryStatus.approved, // default published
  });
}
