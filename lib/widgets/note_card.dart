import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../models/note_model.dart';

/// A card widget that displays a single note's title, description preview,
/// creation date, and provides edit and delete actions.
class NoteCard extends StatelessWidget {
  final NoteModel note;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const NoteCard({
    super.key,
    required this.note,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final formattedDate =
        DateFormat('MMM d, yyyy  h:mm a').format(note.updatedAt);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            scheme.surfaceContainerHighest,
            scheme.surfaceContainerHighest.withOpacity(0.75),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: scheme.primary.withOpacity(0.25),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(20),
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: onEdit,
          child: Padding(
            padding: const EdgeInsets.all(18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── Header row: title + actions ──────────────────────
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Accent bar
                    Container(
                      width: 4,
                      height: 44,
                      decoration: BoxDecoration(
                        color: scheme.primary,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    const SizedBox(width: 12),

                    // Title
                    Expanded(
                      child: Text(
                        note.title,
                        style: GoogleFonts.outfit(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                          height: 1.3,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),

                    // Actions
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _ActionButton(
                          icon: Icons.edit_rounded,
                          color: scheme.primary,
                          onTap: onEdit,
                          tooltip: 'Edit note',
                        ),
                        const SizedBox(width: 4),
                        _ActionButton(
                          icon: Icons.delete_rounded,
                          color: const Color(0xFFE57373),
                          onTap: onDelete,
                          tooltip: 'Delete note',
                        ),
                      ],
                    ),
                  ],
                ),

                // ── Description preview ───────────────────────────────
                if (note.description.isNotEmpty) ...[
                  const SizedBox(height: 12),
                  Text(
                    note.description,
                    style: GoogleFonts.outfit(
                      fontSize: 14,
                      color: Colors.white60,
                      height: 1.5,
                    ),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],

                // ── Footer: date ──────────────────────────────────────
                const SizedBox(height: 14),
                Row(
                  children: [
                    Icon(
                      Icons.access_time_rounded,
                      size: 13,
                      color: scheme.primary.withOpacity(0.7),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      formattedDate,
                      style: GoogleFonts.outfit(
                        fontSize: 12,
                        color: Colors.white38,
                        letterSpacing: 0.3,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// A small icon action button used inside [NoteCard].
class _ActionButton extends StatelessWidget {
  final IconData icon;
  final Color color;
  final VoidCallback onTap;
  final String tooltip;

  const _ActionButton({
    required this.icon,
    required this.color,
    required this.onTap,
    required this.tooltip,
  });

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.all(6),
          child: Icon(icon, size: 20, color: color),
        ),
      ),
    );
  }
}
