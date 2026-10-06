import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:path_provider/path_provider.dart';

class InkStroke {
  const InkStroke(this.points, this.color);
  final List<Offset> points;
  final Color color;

  Map<String, dynamic> toJson() => {
    'points': points.map((p) => [p.dx, p.dy]).toList(),
    'color': color.toARGB32(),
  };

  factory InkStroke.fromJson(Map<String, dynamic> data) => InkStroke(
    (data['points'] as List).map((p) {
      final pair = p as List;
      return Offset((pair[0] as num).toDouble(), (pair[1] as num).toDouble());
    }).toList(),
    Color(data['color'] as int),
  );
}

class SavedArtwork {
  const SavedArtwork({
    required this.id,
    required this.title,
    required this.createdAt,
    required this.strokes,
  });

  final String id;
  final String title;
  final DateTime createdAt;
  final List<InkStroke> strokes;

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'createdAt': createdAt.toIso8601String(),
    'strokes': strokes.map((stroke) => stroke.toJson()).toList(),
  };

  factory SavedArtwork.fromJson(Map<String, dynamic> data) => SavedArtwork(
    id: data['id'] as String,
    title: data['title'] as String,
    createdAt: DateTime.parse(data['createdAt'] as String),
    strokes: (data['strokes'] as List)
        .map((stroke) => InkStroke.fromJson(stroke as Map<String, dynamic>))
        .toList(),
  );
}

class AppState extends ChangeNotifier {
  AppState._(this._file) : _memoryOnly = false;

  @visibleForTesting
  AppState.forTesting(this._file) : _memoryOnly = true {
    soundOn = false;
  }

  @visibleForTesting
  AppState.forPersistenceTesting(this._file) : _memoryOnly = false {
    soundOn = false;
  }

  final File _file;
  final bool _memoryOnly;
  final FlutterTts _tts = FlutterTts();
  final Set<String> completed = {};
  final List<SavedArtwork> gallery = [];
  bool soundOn = true;
  bool _speechAvailable = true;

  static Future<AppState> load() async {
    final directory = await getApplicationDocumentsDirectory();
    final state = AppState._(File('${directory.path}/little_lines_data.json'));
    if (await state._file.exists()) {
      try {
        final data = jsonDecode(
          await state._file.readAsString(),
        ) as Map<String, dynamic>;
        state.completed.addAll(
          (data['completed'] as List? ?? []).cast<String>(),
        );
        state.gallery.addAll(
          (data['gallery'] as List? ?? []).map(
            (item) => SavedArtwork.fromJson(item as Map<String, dynamic>),
          ),
        );
        state.soundOn = data['soundOn'] as bool? ?? true;
      } catch (_) {
        state.completed.clear();
        state.gallery.clear();
        try {
          await state._file.rename(
            '${state._file.path}.corrupt.${DateTime.now().millisecondsSinceEpoch}',
          );
        } catch (_) {
          // A storage error should not prevent opening the lessons.
        }
      }
    }
    try {
      await state._tts.setLanguage('en-US');
      await state._tts.setSpeechRate(0.43);
    } catch (_) {
      state._speechAvailable = false;
    }
    return state;
  }

  Future<void> speak(String message) async {
    if (!soundOn || !_speechAvailable) return;
    try {
      await _tts.stop();
      await _tts.speak(message);
    } catch (_) {
      _speechAvailable = false;
    }
  }

  Future<void> stopSpeaking() async {
    if (!_speechAvailable) return;
    try {
      await _tts.stop();
    } catch (_) {
      _speechAvailable = false;
    }
  }

  Future<void> setSound(bool value) async {
    soundOn = value;
    if (!value) await stopSpeaking();
    notifyListeners();
    await _save();
  }

  Future<void> finishLesson(
    String lessonId,
    String title,
    List<InkStroke> strokes,
  ) async {
    completed.add(lessonId);
    if (strokes.isNotEmpty) _addArtwork(title, strokes);
    notifyListeners();
    await _save();
  }

  Future<void> saveFreeDrawing(List<InkStroke> strokes) async {
    if (strokes.isEmpty) return;
    _addArtwork('My drawing', strokes);
    notifyListeners();
    await _save();
  }

  void _addArtwork(String title, List<InkStroke> strokes) {
    final now = DateTime.now();
    gallery.insert(
      0,
      SavedArtwork(
        id: now.microsecondsSinceEpoch.toString(),
        title: title,
        createdAt: now,
        strokes: List.of(strokes),
      ),
    );
  }

  Future<void> deleteArtwork(String id) async {
    gallery.removeWhere((item) => item.id == id);
    notifyListeners();
    await _save();
  }

  Future<void> resetProgress() async {
    completed.clear();
    gallery.clear();
    notifyListeners();
    await _save();
  }

  Future<void> _save() async {
    if (_memoryOnly) return;
    final json = jsonEncode({
      'completed': completed.toList(),
      'gallery': gallery.map((item) => item.toJson()).toList(),
      'soundOn': soundOn,
    });
    final temp = File('${_file.path}.tmp');
    await temp.writeAsString(json, flush: true);
    await temp.rename(_file.path);
  }

  @override
  void dispose() {
    _tts.stop();
    super.dispose();
  }
}

class AppScope extends InheritedNotifier<AppState> {
  const AppScope({super.key, required AppState state, required super.child})
    : super(notifier: state);

  static AppState of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<AppScope>()!.notifier!;
}
