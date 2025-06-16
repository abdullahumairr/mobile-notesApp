import 'package:flutter/material.dart';
import 'package:notes/models/note_model.dart';
import 'package:notes/service/note_service.dart';
import 'package:notes/utils/date_util.dart';
import 'update_screen.dart';

class DetailScreen extends StatefulWidget {
  final Note note; // Ubah dari Map menjadi Note object

  const DetailScreen({
    super.key,
    required this.note,
  });

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  final NoteService _noteService = NoteService(); // untuk akses ke database

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Color(0xFFFF5722),
            size: 24,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Note Details',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: Colors.black87,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: false,
      ),
      body: Column(
        children: [
          // Content Area
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 32),

                    // Large Icon Section - exactly like in image
                    Center(
                      child: Container(
                        width: 258,
                        height: 187,
                        margin: EdgeInsets.only(bottom: 32),
                        child: Image.asset(
                          'images/${widget.note.image}',
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),

                    // Title - left aligned like in image
                    Text(
                      widget.note.title,
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                        letterSpacing: -0.5,
                      ),
                    ),

                    SizedBox(height: 6),

                    // Date - smaller and lighter
                    Text(
                      formatDateTime(widget.note.dateTime),
                      style: TextStyle(
                        fontSize: 13,
                        color: Color(0xFF9E9E9E),
                        fontWeight: FontWeight.w400,
                      ),
                    ),

                    SizedBox(height: 24),

                    // Description/Content - exactly matching the spacing
                    Text(
                      widget.note.content,
                      style: TextStyle(
                        fontSize: 15,
                        color: Color(0xFF616161),
                        height: 1.5,
                        letterSpacing: 0.1,
                      ),
                    ),

                    SizedBox(height: 40),
                  ],
                ),
              ),
            ),
          ),

          // Bottom Buttons - exactly like in image
          Container(
            width: double.infinity,
            padding: EdgeInsets.fromLTRB(24, 16, 24, 32),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.04),
                  blurRadius: 8,
                  offset: Offset(0, -2),
                ),
              ],
            ),
            child: Row(
              children: [
                // Update Button - matching the orange color exactly
                Expanded(
                  child: Container(
                    height: 48,
                    child: ElevatedButton(
                      onPressed: () async {
                        final result = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                UpdateScreen(note: widget.note),
                          ),
                        );

                        if (result == true) {
                          Navigator.pop(context,
                              true); // kirim sinyal ke HomeScreen untuk refresh
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFFFF5722),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        elevation: 0,
                        shadowColor: Colors.transparent,
                      ),
                      child: Text(
                        'Update',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          letterSpacing: 0.2,
                        ),
                      ),
                    ),
                  ),
                ),

                SizedBox(width: 16),

                // Delete Button - matching the red color exactly
                Expanded(
                  child: Container(
                    height: 48,
                    child: ElevatedButton(
                      onPressed: () async {
                        // Tampilkan dialog konfirmasi
                        final confirm = await showDialog<bool>(
                          context: context,
                          builder: (context) => AlertDialog(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            title: Text(
                              'Delete Note',
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                color: Colors.black87,
                              ),
                            ),
                            content: Text(
                              'Are you sure you want to delete this note? This action cannot be undone.',
                              style: TextStyle(
                                color: Color(0xFF616161),
                                fontSize: 15,
                              ),
                            ),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context, false),
                                child: Text(
                                  'Cancel',
                                  style: TextStyle(
                                    color: Color(0xFF9E9E9E),
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                              ElevatedButton(
                                onPressed: () => Navigator.pop(context, true),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Color(0xFFE53935),
                                  foregroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  elevation: 0,
                                ),
                                child: Text(
                                  'Delete',
                                  style: TextStyle(fontWeight: FontWeight.w500),
                                ),
                              ),
                            ],
                          ),
                        );

                        // Jika pengguna memilih delete
                        if (confirm == true) {
                          await _noteService
                              .deleteNote(widget.note.id!); // hapus dari SQLite

                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Note deleted successfully!'),
                              backgroundColor: Colors.red,
                            ),
                          );

                          Navigator.pop(context,
                              true); // kirim sinyal ke HomeScreen untuk refresh
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFFE53935),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        elevation: 0,
                        shadowColor: Colors.transparent,
                      ),
                      child: Text(
                        'Delete',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          letterSpacing: 0.2,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
