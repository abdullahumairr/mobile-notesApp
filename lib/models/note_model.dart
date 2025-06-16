class Note {
  final int? id; // Nullable untuk insert baru
  final String title;
  final String content;
  final String dateTime;
  final String image;

  Note({
    this.id, // Optional
    required this.title,
    required this.content,
    required this.dateTime,
    required this.image,
  });

  // Convert Note object to Map untuk database
  Map<String, dynamic> toMap() {
    final map = <String, dynamic>{
      'title': title,
      'content': content,
      'dateTime': dateTime,
      'image': image,
    };

    // Hanya tambahkan id jika tidak null (untuk update)
    if (id != null) {
      map['id'] = id!;
    }

    return map;
  }

  // Create Note object from Map (dari database)
  factory Note.fromMap(Map<String, dynamic> map) {
    return Note(
      id: map['id'] as int?, // Cast ke int?
      title: map['title'] as String? ?? '',
      content: map['content'] as String? ?? '',
      dateTime: map['dateTime'] as String? ?? '',
      image: map['image'] as String? ?? 'note_icon_1.png',
    );
  }

  // Create copy of Note with updated fields
  Note copyWith({
    int? id,
    String? title,
    String? content,
    String? dateTime,
    String? image,
  }) {
    return Note(
      id: id ?? this.id,
      title: title ?? this.title,
      content: content ?? this.content,
      dateTime: dateTime ?? this.dateTime,
      image: image ?? this.image,
    );
  }

  @override
  String toString() {
    return 'Note{id: $id, title: $title, content: $content, dateTime: $dateTime, image: $image}';
  }

  // Getter untuk mendapatkan id yang pasti ada (untuk keperluan navigation)
  int get safeId => id ?? 0;
}
