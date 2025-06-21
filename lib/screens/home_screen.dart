import 'package:flutter/material.dart';
import 'package:notes/models/note_model.dart';
import 'package:notes/service/note_service.dart';
import 'package:notes/utils/date_util.dart';
import '../widgets/app_header.dart';
import 'add_screen.dart';
import 'detail_screen.dart';
import 'update_screen.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final NoteService _noteService =
      NoteService(); // instance untuk akses database

  List<Note> notesList = []; // daftar catatan yang akan ditampilkan

  @override
  void initState() {
    super.initState();
    _loadNotes(); // ambil data dari database saat layar pertama kali ditampilkan
  }

  void _loadNotes() async {
    final data =
        await _noteService.getAllNotes(); // ambil semua catatan dari database
    setState(() {
      notesList = data; // simpan hasil ke dalam notesList agar ditampilkan
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(56),
        child: AppHeader(),
      ),
      backgroundColor: const Color.fromARGB(248, 17, 24, 39),
      body: SafeArea(
        child: notesList.isEmpty ? _buildEmptyState() : _buildNotesListView(),
      ),
      floatingActionButton: FloatingActionButton(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddScreen()),
          );

          if (result == true) {
            _loadNotes(); // refresh data dari database
          }
        },
        backgroundColor: const Color.fromARGB(237, 255, 193, 7),
        child: Icon(
          Icons.add,
          size: 32,
          color: Colors.white,
        ),
      ),
    );
  }

  // Widget untuk tampilan kosong (gambar kiri)
  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Ilustrasi menggunakan asset gambar empty.png
          Container(
            width: 200,
            height: 200,
            child: Image.asset(
              'images/empty.png',
              fit: BoxFit.contain,
            ),
          ),
          SizedBox(height: 40),
          Text(
            'Add your first note',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: const Color.fromARGB(214, 255, 193, 7),
            ),
          ),
          SizedBox(height: 12),
          Text(
            'Save your thoughts, tasks\nor inspirations',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              color: const Color.fromARGB(204, 255, 255, 255),
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  // Widget untuk tampilan dengan notes (gambar kanan)
  Widget _buildNotesListView() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: ListView.builder(
            padding: EdgeInsets.all(16),
            itemCount: notesList.length,
            itemBuilder: (context, index) {
              final Note note = notesList[index];
              return GestureDetector(
                // Tambahkan onTap untuk navigasi ke DetailScreen
                onTap: () async {
                  final result = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DetailScreen(note: note),
                    ),
                  );

                  if (result == true) {
                    _loadNotes(); // refresh data dari database
                  }
                },
                child: Container(
                  margin: EdgeInsets.only(bottom: 16),
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: const Color(0xFF111827),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 10,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      // Menggunakan note_icon_1.png, note_icon_2.png, etc.
                      Container(
                        width: 64,
                        height: 64,
                        child: Image.asset(
                          'images/${note.image}',
                          fit: BoxFit.contain,
                        ),
                      ),
                      SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              note.title,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: const Color.fromARGB(214, 255, 193, 7),
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              note.content,
                              style: TextStyle(
                                fontSize: 14,
                                color: const Color.fromARGB(204, 255, 255, 255),
                              ),
                              maxLines: 2, // Batasi maksimal 2 baris
                              overflow: TextOverflow
                                  .ellipsis, // Tambahkan ... jika terlalu panjang
                            ),
                            SizedBox(height: 8),
                            Text(
                              formatDateTime(note.dateTime),
                              style: TextStyle(
                                fontSize: 12,
                                color: const Color.fromARGB(200, 158, 158, 158),
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Tambahkan icon panah untuk menunjukkan bahwa item bisa diklik
                      Icon(
                        Icons.arrow_forward_ios,
                        size: 16,
                        color: Colors.grey[400],
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
