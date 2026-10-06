import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import 'animal_art.dart';
import 'app_state.dart';
import 'branding.dart';
import 'drawing_canvas.dart';
import 'lessons.dart';
import 'playful_home.dart';

const _muted = Color(0xFF71809C);
const _appStoreId = '6819308063';
final _appStoreUrl = Uri.parse('https://apps.apple.com/app/id$_appStoreId');
final _appStoreReviewUrl = Uri.parse(
  'https://apps.apple.com/app/id$_appStoreId?action=write-review',
);
final _privacyPolicyUrl = Uri.parse(
  'https://kidslearn1.blogspot.com/2026/10/blog-post.html#privacy',
);

void _open(BuildContext context, Widget page) {
  Navigator.of(context).push(MaterialPageRoute(builder: (_) => page));
}

class _PageBody extends StatelessWidget {
  const _PageBody({required this.child, this.maxWidth = 820});
  final Widget child;
  final double maxWidth;

  @override
  Widget build(BuildContext context) => SafeArea(
    child: Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: maxWidth),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 28),
          child: child,
        ),
      ),
    ),
  );
}

class _BigButton extends StatelessWidget {
  const _BigButton({required this.label, required this.onPressed, this.icon});
  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;

  @override
  Widget build(BuildContext context) => SizedBox(
    width: double.infinity,
    height: 58,
    child: FilledButton.icon(
      onPressed: onPressed,
      icon: Icon(icon ?? Icons.arrow_forward_rounded),
      label: Text(
        label,
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
      ),
      style: FilledButton.styleFrom(
        backgroundColor: const Color(0xFF7459D9),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      ),
    ),
  );
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final state = AppScope.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          appDisplayName,
          maxLines: 2,
          style: TextStyle(
            fontSize: 17,
            height: 1.1,
            fontWeight: FontWeight.w900,
          ),
        ),
        actions: [
          IconButton(
            tooltip: 'Settings',
            onPressed: () => _open(context, const ParentPage()),
            icon: const Icon(Icons.settings_rounded),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: _PageBody(
        child: ListView(
          children: [
            const SizedBox(height: 18),
            PlayfulWelcome(
              completed: state.completed.length,
              total: lessons.length,
            ),
            const SizedBox(height: 26),
            const Text(
              'What shall we draw?',
              style: TextStyle(fontSize: 23, fontWeight: FontWeight.w900),
            ),
            const SizedBox(height: 14),
            _CategoryCard(
              title: 'Letters',
              subtitle: 'Meet the alphabet! A to Z',
              icon: Icons.abc_rounded,
              color: const Color(0xFF7459D9),
              background: const Color(0xFFF0ECFF),
              onTap: () =>
                  _open(context, const CategoryPage(kind: LessonKind.letter)),
            ),
            _CategoryCard(
              title: 'Numbers',
              subtitle: 'Count, doodle, giggle! 0 to 19',
              icon: Icons.onetwothree_rounded,
              color: const Color(0xFFE88A3B),
              background: const Color(0xFFFFF0E3),
              onTap: () =>
                  _open(context, const CategoryPage(kind: LessonKind.number)),
            ),
            _CategoryCard(
              title: 'Animals',
              subtitle: 'Say hello to 20 animal friends',
              icon: Icons.pets_rounded,
              color: const Color(0xFF24A891),
              background: const Color(0xFFE2F6F1),
              onTap: () =>
                  _open(context, const CategoryPage(kind: LessonKind.animal)),
            ),
            _CategoryCard(
              title: 'Shapes',
              subtitle: 'Circles, stars & silly shapes',
              icon: Icons.category_rounded,
              color: const Color(0xFFBA65CE),
              background: const Color(0xFFF8EAFB),
              onTap: () =>
                  _open(context, const CategoryPage(kind: LessonKind.shape)),
            ),
            _CategoryCard(
              title: 'Vehicles',
              subtitle: '20 vehicles to draw',
              icon: Icons.directions_car_rounded,
              color: const Color(0xFF4186CE),
              background: const Color(0xFFE7F2FF),
              onTap: () =>
                  _open(context, const CategoryPage(kind: LessonKind.vehicle)),
            ),
            _CategoryCard(
              title: 'Nature',
              subtitle: '20 nature pictures',
              icon: Icons.park_rounded,
              color: const Color(0xFF57A85B),
              background: const Color(0xFFE9F7E9),
              onTap: () =>
                  _open(context, const CategoryPage(kind: LessonKind.nature)),
            ),
            _CategoryCard(
              title: 'Food',
              subtitle: '20 yummy drawings',
              icon: Icons.restaurant_rounded,
              color: const Color(0xFFE66D70),
              background: const Color(0xFFFFEBEB),
              onTap: () =>
                  _open(context, const CategoryPage(kind: LessonKind.food)),
            ),
            const SizedBox(height: 12),
            _CategoryCard(
              title: 'Free drawing',
              subtitle: 'Make your own picture',
              icon: Icons.palette_rounded,
              color: const Color(0xFFE7638D),
              background: const Color(0xFFFFE9F0),
              onTap: () => _open(context, const FreeDrawPage()),
            ),
            _CategoryCard(
              title: 'My gallery',
              subtitle: '${state.gallery.length} saved pictures',
              icon: Icons.photo_library_rounded,
              color: const Color(0xFF4186CE),
              background: const Color(0xFFE7F2FF),
              onTap: () => _open(context, const GalleryPage()),
            ),
          ],
        ),
      ),
    );
  }
}

class _CategoryCard extends StatelessWidget {
  const _CategoryCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
    required this.background,
    required this.onTap,
  });
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final Color background;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 12),
    child: Material(
      color: background,
      borderRadius: BorderRadius.circular(24),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(24),
        child: Padding(
          padding: const EdgeInsets.all(17),
          child: Row(
            children: [
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: .75),
                  borderRadius: BorderRadius.circular(18),
                ),
                child: BouncyCategoryIcon(icon: icon, color: color),
              ),
              const SizedBox(width: 17),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    Text(
                      subtitle,
                      style: const TextStyle(fontSize: 14, color: _muted),
                    ),
                  ],
                ),
              ),
              Icon(Icons.chevron_right_rounded, size: 30, color: color),
            ],
          ),
        ),
      ),
    ),
  );
}

class CategoryPage extends StatelessWidget {
  const CategoryPage({super.key, required this.kind});
  final LessonKind kind;

  @override
  Widget build(BuildContext context) {
    final state = AppScope.of(context);
    final items = lessonsOf(kind);
    final title = switch (kind) {
      LessonKind.letter => 'Letters',
      LessonKind.number => 'Numbers',
      LessonKind.animal => 'Animals',
      LessonKind.shape => 'Shapes',
      LessonKind.vehicle => 'Vehicles',
      LessonKind.nature => 'Nature',
      LessonKind.food => 'Food',
    };
    final pictureCategory =
        kind != LessonKind.letter && kind != LessonKind.number;
    return Scaffold(
      appBar: AppBar(
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w900)),
      ),
      body: _PageBody(
        child: LayoutBuilder(
          builder: (context, box) {
            final columns = pictureCategory
                ? (box.maxWidth > 620 ? 3 : 2)
                : (box.maxWidth > 620 ? 5 : 3);
            return ListView(
              children: [
                const SizedBox(height: 10),
                Text(
                  'Pick a ${kind == LessonKind.animal ? 'friend' : 'lesson'} to draw',
                  style: const TextStyle(
                    fontSize: 23,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  '${items.where((item) => state.completed.contains(item.id)).length} of ${items.length} completed',
                  style: const TextStyle(color: _muted),
                ),
                const SizedBox(height: 4),
                Text(
                  'Scroll down to see all ${items.length} lessons',
                  style: const TextStyle(color: _muted, fontSize: 13),
                ),
                const SizedBox(height: 20),
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: items.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: columns,
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 12,
                    childAspectRatio: pictureCategory ? 1.1 : .95,
                  ),
                  itemBuilder: (context, index) {
                    final item = items[index];
                    final done = state.completed.contains(item.id);
                    return Material(
                      color: item.color.withValues(alpha: .11),
                      borderRadius: BorderRadius.circular(23),
                      child: InkWell(
                        onTap: () => _open(context, LessonPage(lesson: item)),
                        borderRadius: BorderRadius.circular(23),
                        child: Stack(
                          children: [
                            Center(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  pictureCategory
                                      ? kind == LessonKind.animal
                                            ? AnimalArt(id: item.id, size: 70)
                                            : SizedBox(
                                                width: 62,
                                                height: 62,
                                                child: CustomPaint(
                                                  painter: LessonPreviewPainter(
                                                    item,
                                                  ),
                                                ),
                                              )
                                      : Text(
                                          item.title,
                                          style: TextStyle(
                                            color: item.color,
                                            fontSize: 49,
                                            fontWeight: FontWeight.w900,
                                          ),
                                        ),
                                  if (pictureCategory) ...[
                                    const SizedBox(height: 5),
                                    Text(
                                      item.title,
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w800,
                                      ),
                                    ),
                                  ],
                                ],
                              ),
                            ),
                            if (done)
                              const Positioned(
                                right: 8,
                                top: 8,
                                child: Icon(
                                  Icons.check_circle_rounded,
                                  color: Color(0xFF24A891),
                                ),
                              ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

enum _LessonPhase { watch, trace, create, finished }

class LessonPage extends StatefulWidget {
  const LessonPage({super.key, required this.lesson});
  final LessonData lesson;

  @override
  State<LessonPage> createState() => _LessonPageState();
}

class _LessonPageState extends State<LessonPage>
    with SingleTickerProviderStateMixin {
  late final AnimationController _demo;
  final ScrollController _scroll = ScrollController();
  _LessonPhase phase = _LessonPhase.watch;
  int strokeCount = 0;
  List<InkStroke> drawing = [];
  Color selectedColor = inkColors.first;
  bool saving = false;

  @override
  void initState() {
    super.initState();
    _demo = AnimationController(
      vsync: this,
      duration: Duration(
        milliseconds: (widget.lesson.strokes.length * 650).clamp(1900, 7500),
      ),
    )..forward();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) AppScope.of(context).speak(widget.lesson.prompt);
    });
  }

  @override
  void dispose() {
    _demo.dispose();
    _scroll.dispose();
    super.dispose();
  }

  void _nextPhase(_LessonPhase value, String message) {
    setState(() => phase = value);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted && _scroll.hasClients) {
        _scroll.animateTo(
          0,
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOut,
        );
      }
    });
    AppScope.of(context).speak(message);
  }

  Future<void> _finish() async {
    if (saving) return;
    setState(() => saving = true);
    try {
      await AppScope.of(context)
          .finishLesson(widget.lesson.id, widget.lesson.title, drawing);
      if (!mounted) return;
      _nextPhase(_LessonPhase.finished, 'Wonderful drawing! You did it!');
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not save yet. Please try again.')),
      );
    } finally {
      if (mounted) setState(() => saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final lesson = widget.lesson;
    final phaseLabel = switch (phase) {
      _LessonPhase.watch => 'Watch the lines',
      _LessonPhase.trace => 'Follow the bright dot',
      _LessonPhase.create => 'Make your own drawing',
      _LessonPhase.finished => 'Hooray!',
    };
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '${lesson.title} · $phaseLabel',
          style: const TextStyle(fontWeight: FontWeight.w900),
        ),
      ),
      body: _PageBody(
        maxWidth: 620,
        child: ListView(
          controller: _scroll,
          children: [
            const SizedBox(height: 8),
            Text(
              lesson.subtitle,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w900),
            ),
            const SizedBox(height: 5),
            Text(
              phaseLabel,
              textAlign: TextAlign.center,
              style: const TextStyle(color: _muted, fontSize: 17),
            ),
            if (lesson.kind == LessonKind.number) ...[
              const SizedBox(height: 10),
              _CountingDots(
                count: int.parse(lesson.title),
                color: lesson.color,
              ),
            ],
            if (lesson.kind == LessonKind.animal &&
                phase != _LessonPhase.finished) ...[
              const SizedBox(height: 10),
              Center(
                child: AnimalArt(
                  id: lesson.id,
                  size: phase == _LessonPhase.watch ? 150 : 95,
                ),
              ),
              const Text(
                'A shaded picture to inspire your drawing',
                textAlign: TextAlign.center,
                style: TextStyle(color: _muted, fontSize: 13),
              ),
            ],
            const SizedBox(height: 16),
            if (phase == _LessonPhase.watch) ...[
              DrawingBoardFrame(
                child: AnimatedBuilder(
                  animation: _demo,
                  builder: (context, _) => CustomPaint(
                    painter: DrawingPainter(
                      lesson: lesson,
                      demoFraction: _demo.value,
                    ),
                    size: Size.infinite,
                  ),
                ),
              ),
              const SizedBox(height: 18),
              _BigButton(
                label: 'Start tracing',
                icon: Icons.edit_rounded,
                onPressed: () => _nextPhase(
                  _LessonPhase.trace,
                  'Start at the bright dot and follow the line.',
                ),
              ),
              TextButton.icon(
                onPressed: () => _demo.forward(from: 0),
                icon: const Icon(Icons.replay_rounded),
                label: const Text('Watch again'),
              ),
            ],
            if (phase == _LessonPhase.trace) ...[
              TracingBoard(
                lesson: lesson,
                onStrokeDone: (count) => setState(() => strokeCount = count),
                onComplete: () => _nextPhase(
                  _LessonPhase.create,
                  'Great tracing! Now make your own drawing.',
                ),
              ),
              const SizedBox(height: 14),
              Text(
                'Line $strokeCount of ${lesson.strokes.length}',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: _muted,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 10),
              TextButton.icon(
                onPressed: () => _nextPhase(
                  _LessonPhase.create,
                  'Now make your own drawing.',
                ),
                icon: const Icon(Icons.palette_rounded),
                label: const Text('Draw freely'),
              ),
            ],
            if (phase == _LessonPhase.create) ...[
              FreeDrawingBoard(
                color: selectedColor,
                strokes: drawing,
                onChanged: (value) => setState(() => drawing = value),
              ),
              const SizedBox(height: 14),
              _ColorTools(
                selected: selectedColor,
                onSelect: (value) => setState(() => selectedColor = value),
                onUndo: drawing.isEmpty
                    ? null
                    : () => setState(() => drawing.removeLast()),
                onClear: drawing.isEmpty
                    ? null
                    : () => setState(() => drawing = []),
              ),
              const SizedBox(height: 14),
              _BigButton(
                label: saving ? 'Saving...' : 'Finish lesson',
                icon: Icons.star_rounded,
                onPressed: saving ? null : _finish,
              ),
            ],
            if (phase == _LessonPhase.finished) ...[
              Container(
                height: 230,
                decoration: BoxDecoration(
                  color: const Color(0xFFFFF0D9),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.auto_awesome_rounded,
                      size: 90,
                      color: Color(0xFFE9A03E),
                    ),
                    Text(
                      'You did it!',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    Text(
                      'Every line is a little adventure.',
                      style: TextStyle(color: _muted),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              _BigButton(
                label: 'Choose another lesson',
                onPressed: () => Navigator.of(context).pop(),
              ),
              if (drawing.isNotEmpty)
                TextButton.icon(
                  onPressed: () => _open(context, const GalleryPage()),
                  icon: const Icon(Icons.photo_library_rounded),
                  label: const Text('See my drawing'),
                ),
            ],
          ],
        ),
      ),
    );
  }
}

class _CountingDots extends StatelessWidget {
  const _CountingDots({required this.count, required this.color});
  final int count;
  final Color color;

  @override
  Widget build(BuildContext context) {
    Widget row(int stars) => Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(
        stars,
        (_) => Icon(Icons.star_rounded, size: 23, color: color),
      ),
    );
    return SizedBox(
      height: count > 10 ? 52 : 29,
      child: Center(
        child: count == 0
            ? const Text(
                'Zero means none yet!',
                style: TextStyle(color: _muted),
              )
            : Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  row(count > 10 ? 10 : count),
                  if (count > 10) row(count - 10),
                ],
              ),
      ),
    );
  }
}

class _ColorTools extends StatelessWidget {
  const _ColorTools({
    required this.selected,
    required this.onSelect,
    required this.onUndo,
    required this.onClear,
  });
  final Color selected;
  final ValueChanged<Color> onSelect;
  final VoidCallback? onUndo;
  final VoidCallback? onClear;

  @override
  Widget build(BuildContext context) => Column(
    children: [
      Wrap(
        alignment: WrapAlignment.center,
        spacing: 10,
        runSpacing: 8,
        children: [
          for (final color in inkColors)
            Semantics(
              label: 'Choose color',
              button: true,
              child: InkWell(
                onTap: () => onSelect(color),
                borderRadius: BorderRadius.circular(40),
                child: Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: color,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 4),
                    boxShadow: selected == color
                        ? [
                            BoxShadow(
                              color: color.withValues(alpha: .4),
                              blurRadius: 8,
                              spreadRadius: 3,
                            ),
                          ]
                        : [],
                  ),
                  child: selected == color
                      ? const Icon(Icons.check, color: Colors.white)
                      : null,
                ),
              ),
            ),
        ],
      ),
      const SizedBox(height: 8),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TextButton.icon(
            onPressed: onUndo,
            icon: const Icon(Icons.undo_rounded),
            label: const Text('Undo'),
          ),
          TextButton.icon(
            onPressed: onClear,
            icon: const Icon(Icons.delete_outline_rounded),
            label: const Text('Clear'),
          ),
        ],
      ),
    ],
  );
}

class FreeDrawPage extends StatefulWidget {
  const FreeDrawPage({super.key});

  @override
  State<FreeDrawPage> createState() => _FreeDrawPageState();
}

class _FreeDrawPageState extends State<FreeDrawPage> {
  List<InkStroke> drawing = [];
  Color color = inkColors.first;
  bool saving = false;

  Future<void> _save() async {
    if (saving || drawing.isEmpty) return;
    setState(() => saving = true);
    try {
      await AppScope.of(context).saveFreeDrawing(drawing);
      if (!mounted) return;
      setState(() => drawing = []);
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Saved in My gallery!')));
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not save yet. Please try again.')),
      );
    } finally {
      if (mounted) setState(() => saving = false);
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: const Text(
        'Free drawing',
        style: TextStyle(fontWeight: FontWeight.w900),
      ),
    ),
    body: _PageBody(
      maxWidth: 620,
      child: ListView(
        children: [
          const SizedBox(height: 10),
          const Text(
            'Draw anything you imagine!',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900),
          ),
          const SizedBox(height: 18),
          FreeDrawingBoard(
            color: color,
            strokes: drawing,
            onChanged: (value) => setState(() => drawing = value),
          ),
          const SizedBox(height: 16),
          _ColorTools(
            selected: color,
            onSelect: (value) => setState(() => color = value),
            onUndo: drawing.isEmpty
                ? null
                : () => setState(() => drawing.removeLast()),
            onClear: drawing.isEmpty
                ? null
                : () => setState(() => drawing = []),
          ),
          const SizedBox(height: 16),
          _BigButton(
            label: saving ? 'Saving...' : 'Save to my gallery',
            icon: Icons.save_rounded,
            onPressed: drawing.isEmpty || saving ? null : _save,
          ),
        ],
      ),
    ),
  );
}

class GalleryPage extends StatelessWidget {
  const GalleryPage({super.key});

  @override
  Widget build(BuildContext context) {
    final state = AppScope.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'My gallery',
          style: TextStyle(fontWeight: FontWeight.w900),
        ),
      ),
      body: _PageBody(
        child: state.gallery.isEmpty
            ? const Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.image_outlined, size: 76, color: _muted),
                    SizedBox(height: 12),
                    Text(
                      'Your drawings will appear here!',
                      style: TextStyle(
                        fontSize: 21,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
              )
            : LayoutBuilder(
                builder: (context, box) => GridView.builder(
                  itemCount: state.gallery.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: box.maxWidth > 620 ? 3 : 2,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: .82,
                  ),
                  itemBuilder: (context, index) {
                    final artwork = state.gallery[index];
                    return Material(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      child: InkWell(
                        onTap: () =>
                            _open(context, ArtworkPage(artwork: artwork)),
                        borderRadius: BorderRadius.circular(20),
                        child: Padding(
                          padding: const EdgeInsets.all(9),
                          child: Column(
                            children: [
                              Expanded(
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(12),
                                  child: ColoredBox(
                                    color: const Color(0xFFF8FAFF),
                                    child: CustomPaint(
                                      painter: DrawingPainter(
                                        ink: artwork.strokes,
                                      ),
                                      child: const SizedBox.expand(),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 7),
                              Text(
                                artwork.title,
                                maxLines: 1,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w800,
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
    );
  }
}

class ArtworkPage extends StatelessWidget {
  const ArtworkPage({super.key, required this.artwork});
  final SavedArtwork artwork;

  Future<void> _delete(BuildContext context) async {
    final yes = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete this drawing?'),
        content: const Text('This will remove it from the gallery.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
    if (yes != true || !context.mounted) return;
    await AppScope.of(context).deleteArtwork(artwork.id);
    if (context.mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: Text(artwork.title),
      actions: [
        IconButton(
          tooltip: 'Delete drawing',
          onPressed: () => _delete(context),
          icon: const Icon(Icons.delete_outline_rounded),
        ),
      ],
    ),
    body: _PageBody(
      maxWidth: 620,
      child: Center(
        child: DrawingBoardFrame(
          child: CustomPaint(
            painter: DrawingPainter(ink: artwork.strokes),
            child: const SizedBox.expand(),
          ),
        ),
      ),
    ),
  );
}

Future<bool> _verifyAdult(BuildContext context) async {
  final allowed = await showDialog<bool>(
    context: context,
    builder: (_) => const _ParentGateDialog(),
  );
  return allowed == true;
}

class _ParentGateDialog extends StatefulWidget {
  const _ParentGateDialog();

  @override
  State<_ParentGateDialog> createState() => _ParentGateDialogState();
}

class _ParentGateDialogState extends State<_ParentGateDialog> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _continue() => Navigator.pop(context, _controller.text.trim() == '15');

  @override
  Widget build(BuildContext context) => AlertDialog(
    scrollable: true,
    title: const Text('For grown-ups'),
    content: Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('What is 8 + 7?'),
        const SizedBox(height: 10),
        TextField(
          controller: _controller,
          keyboardType: TextInputType.number,
          textInputAction: TextInputAction.done,
          onSubmitted: (_) => _continue(),
          decoration: const InputDecoration(labelText: 'Answer'),
        ),
      ],
    ),
    actions: [
      TextButton(
        onPressed: () => Navigator.pop(context, false),
        child: const Text('Cancel'),
      ),
      FilledButton(onPressed: _continue, child: const Text('Continue')),
    ],
  );
}

class ParentPage extends StatelessWidget {
  const ParentPage({super.key});

  void _message(BuildContext context, String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  Future<void> _rate(BuildContext context) async {
    if (!await _verifyAdult(context) || !context.mounted) return;
    try {
      if (!await launchUrl(
            _appStoreReviewUrl,
            mode: LaunchMode.externalApplication,
          ) &&
          context.mounted) {
        _message(
          context,
          'Could not open the App Store. Please try again later.',
        );
      }
    } catch (_) {
      if (context.mounted) {
        _message(
          context,
          'Could not open the App Store. Please try again later.',
        );
      }
    }
  }

  Future<void> _share(BuildContext context) async {
    if (!await _verifyAdult(context) || !context.mounted) return;
    final box = context.findRenderObject() as RenderBox?;
    final origin = box == null
        ? null
        : box.localToGlobal(Offset.zero) & box.size;
    try {
      await SharePlus.instance.share(
        ShareParams(
          text:
              '$appDisplayName helps children learn to draw letters, numbers, animals, and more.\n$_appStoreUrl',
          sharePositionOrigin: origin,
        ),
      );
    } catch (_) {
      if (context.mounted) {
        _message(context, 'Could not open sharing. Please try again later.');
      }
    }
  }

  Future<void> _openPrivacyPolicy(BuildContext context) async {
    if (!await _verifyAdult(context) || !context.mounted) return;
    try {
      if (!await launchUrl(
            _privacyPolicyUrl,
            mode: LaunchMode.externalApplication,
          ) &&
          context.mounted) {
        _message(
          context,
          'Could not open the privacy policy. Please try again later.',
        );
      }
    } catch (_) {
      if (context.mounted) {
        _message(
          context,
          'Could not open the privacy policy. Please try again later.',
        );
      }
    }
  }

  Future<void> _reset(BuildContext context) async {
    final yes = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Reset all progress?'),
        content: const Text(
          'This deletes completed lessons and saved artwork from this device.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: const Text('Reset'),
          ),
        ],
      ),
    );
    if (yes == true && context.mounted) {
      await AppScope.of(context).resetProgress();
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = AppScope.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Settings',
          style: TextStyle(fontWeight: FontWeight.w900),
        ),
      ),
      body: _PageBody(
        maxWidth: 620,
        child: ListView(
          children: [
            const SizedBox(height: 12),
            const Text(
              'Learning progress',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.w900),
            ),
            const SizedBox(height: 12),
            for (final kind in LessonKind.values)
              ListTile(
                leading: Icon(switch (kind) {
                  LessonKind.letter => Icons.abc_rounded,
                  LessonKind.number => Icons.onetwothree_rounded,
                  LessonKind.animal => Icons.pets_rounded,
                  LessonKind.shape => Icons.category_rounded,
                  LessonKind.vehicle => Icons.directions_car_rounded,
                  LessonKind.nature => Icons.park_rounded,
                  LessonKind.food => Icons.restaurant_rounded,
                }),
                title: Text(switch (kind) {
                  LessonKind.letter => 'Letters',
                  LessonKind.number => 'Numbers',
                  LessonKind.animal => 'Animals',
                  LessonKind.shape => 'Shapes',
                  LessonKind.vehicle => 'Vehicles',
                  LessonKind.nature => 'Nature',
                  LessonKind.food => 'Food',
                }),
                trailing: Text(
                  '${lessonsOf(kind).where((lesson) => state.completed.contains(lesson.id)).length}/${lessonsOf(kind).length}',
                  style: const TextStyle(fontWeight: FontWeight.w800),
                ),
              ),
            const Divider(height: 36),
            SwitchListTile(
              title: const Text('Spoken instructions'),
              subtitle: const Text('The app reads lesson prompts aloud.'),
              value: state.soundOn,
              onChanged: state.setSound,
            ),
            const Divider(height: 36),
            const Text(
              'About the app',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900),
            ),
            const SizedBox(height: 8),
            ListTile(
              leading: const Icon(Icons.star_rounded),
              title: const Text('Rate this app'),
              subtitle: const Text('Leave a review on the App Store'),
              onTap: () => _rate(context),
            ),
            Builder(
              builder: (tileContext) => ListTile(
                leading: const Icon(Icons.share_rounded),
                title: const Text('Share this app'),
                subtitle: const Text('Tell someone about the app'),
                onTap: () => _share(tileContext),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.privacy_tip_rounded),
              title: const Text('Privacy policy'),
              subtitle: const Text('Read our policy online'),
              onTap: () => _openPrivacyPolicy(context),
            ),
            const Divider(height: 36),
            const Text(
              'Data stays on this device. No child account is needed.',
              style: TextStyle(color: _muted),
            ),
            const SizedBox(height: 14),
            OutlinedButton.icon(
              onPressed: () => _reset(context),
              icon: const Icon(Icons.restart_alt_rounded),
              label: const Text('Reset progress and gallery'),
            ),
          ],
        ),
      ),
    );
  }
}
