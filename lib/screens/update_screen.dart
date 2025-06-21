import 'package:flutter/material.dart';
import 'package:notes/models/note_model.dart';
import 'package:notes/service/note_service.dart';

class UpdateScreen extends StatefulWidget {
  final Note note; // Ubah dari Map menjadi Note object

  const UpdateScreen({super.key, required this.note});

  @override
  State<UpdateScreen> createState() => _UpdateScreenState();
}

class _UpdateScreenState extends State<UpdateScreen> {
  final NoteService _noteService =
      NoteService(); // Instance untuk akses database

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();
  int selectedImageIndex = 1; // Default selected image index (note_icon_2.png)

  // List of available note icons
  final List<String> noteIcons = [
    'images/note_icon_1.png',
    'images/note_icon_2.png',
    'images/note_icon_3.png',
    'images/note_icon_4.png',
  ];

  @override
  void initState() {
    super.initState();
    // Isi form dengan data dari Note object
    _titleController.text = widget.note.title;
    _contentController.text = widget.note.content;

    // Cari index icon yang sesuai berdasarkan image Note
    String currentIcon = 'images/${widget.note.image}';
    selectedImageIndex = noteIcons.indexOf(currentIcon);
    if (selectedImageIndex == -1) {
      selectedImageIndex = 1; // Default jika tidak ditemukan
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(248, 17, 24, 39),
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: const Color.fromARGB(237, 255, 193, 7),
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Update Note',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: const Color.fromARGB(204, 255, 255, 255),
          ),
        ),
        backgroundColor: const Color(0xFF111827),
        elevation: 0,
      ),
      body: Padding(
        padding: EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
              controller: _titleController,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'Note Title',
                hintStyle: const TextStyle(
                    color: const Color.fromARGB(204, 255, 255, 255)),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(
                      color: const Color.fromARGB(204, 255, 255, 255)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide:
                      const BorderSide(color: Color.fromARGB(237, 255, 193, 7)),
                ),
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
              ),
              validator: (value) =>
                  value == null || value.isEmpty ? 'Judul wajib diisi' : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _contentController,
              maxLines: 5,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintStyle: const TextStyle(
                    color: const Color.fromARGB(204, 255, 255, 255)),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(
                      color: const Color.fromARGB(204, 255, 255, 255)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide:
                      const BorderSide(color: Color.fromARGB(237, 255, 193, 7)),
                ),
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
              ),
              validator: (value) =>
                  value == null || value.isEmpty ? 'Konten wajib diisi' : null,
            ),

            SizedBox(height: 30),

            // Image Selection - Horizontal Scrollable like in the image
            Container(
              height: 100,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: noteIcons.length,
                itemBuilder: (context, index) {
                  bool isSelected = selectedImageIndex == index;
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedImageIndex = index;
                      });
                    },
                    child: Container(
                      width: 120,
                      height: 120,
                      margin: EdgeInsets.only(right: 12),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: isSelected
                              ? Color.fromARGB(237, 255, 193, 7)
                              : const Color.fromARGB(204, 255, 255, 255),
                          width: isSelected ? 3 : 1.5,
                        ),
                        borderRadius: BorderRadius.circular(12),
                        color: const Color(0xFF111827),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Padding(
                          padding: EdgeInsets.all(8),
                          child: Image.asset(
                            noteIcons[index],
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),

            // Spacer to push button to bottom
            Spacer(),

            // Update Button
            Container(
              width: double.infinity,
              margin: EdgeInsets.only(bottom: 20),
              child: ElevatedButton(
                onPressed: () async {
                  final title = _titleController.text.trim();
                  final content = _contentController.text.trim();

                  if (title.isEmpty || content.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content:
                            Text('Judul dan isi catatan tidak boleh kosong.'),
                        backgroundColor: Colors.redAccent,
                      ),
                    );
                    return;
                  }

                  // Ambil nama file dari path lengkap (contoh: dari 'images/note_icon_2.png' menjadi 'note_icon_2.png')
                  String selectedImageFile =
                      noteIcons[selectedImageIndex].split('/').last;

                  final updatedNote = Note(
                    id: widget.note.id,
                    title: title,
                    content: content,
                    image: selectedImageFile,
                    dateTime: DateTime.now().toString(),
                  );

                  await _noteService
                      .updateNote(updatedNote); // Simpan ke database

                  // Success action
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Note updated successfully!'),
                      backgroundColor: Colors.green,
                    ),
                  );

                  Navigator.pop(
                      context, true); // Kirim sinyal bahwa update selesai
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(237, 255, 193, 7),
                  foregroundColor: const Color.fromARGB(204, 255, 255, 255),
                  padding: EdgeInsets.symmetric(vertical: 18),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                ),
                child: Text(
                  'Update',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }
}
