import 'dart:async';

import 'package:flutter/material.dart';

void main() {
  runApp(const StudyFlowApp());
}

class StudyFlowApp extends StatelessWidget {
  const StudyFlowApp({super.key});

  @override
  Widget build(BuildContext context) {
    const primary = Color(0xFF4C5FD5);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'StudyFlow',
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFFF7F8FC),
        colorScheme: ColorScheme.fromSeed(
          seedColor: primary,
          brightness: Brightness.light,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFFF7F8FC),
          foregroundColor: Color(0xFF19202E),
          elevation: 0,
          scrolledUnderElevation: 0,
        ),
        textTheme: ThemeData.light().textTheme.apply(
          bodyColor: const Color(0xFF19202E),
          displayColor: const Color(0xFF19202E),
        ),
      ),
      home: const StudyFlowHome(),
    );
  }
}

class StudyFlowHome extends StatefulWidget {
  const StudyFlowHome({super.key});

  @override
  State<StudyFlowHome> createState() => _StudyFlowHomeState();
}

class _StudyFlowHomeState extends State<StudyFlowHome> {
  final List<StudyTask> _tasks = [
    StudyTask(
      'Revise DSA: Trees',
      'Data Structures',
      '10:00 AM',
      const Color(0xFF5B6EE1),
    ),
    StudyTask(
      'Complete DBMS lab',
      'Database Systems',
      '1:30 PM',
      const Color(0xFF0DAA88),
    ),
    StudyTask(
      'Read OS scheduling',
      'Operating Systems',
      '4:00 PM',
      const Color(0xFFF39C4A),
    ),
    StudyTask(
      'Submit CN assignment',
      'Computer Networks',
      '7:00 PM',
      const Color(0xFFB969D5),
    ),
  ];

  final List<ScheduleItem> _schedule = const [
    ScheduleItem(
      '10:00',
      'DSA revision',
      'Binary trees and traversal practice',
      Color(0xFF5B6EE1),
    ),
    ScheduleItem(
      '13:30',
      'DBMS lab',
      'SQL joins and normalization worksheet',
      Color(0xFF0DAA88),
    ),
    ScheduleItem(
      '16:00',
      'OS study block',
      'CPU scheduling notes',
      Color(0xFFF39C4A),
    ),
  ];

  Timer? _timer;
  int _selectedDay = 3;
  int _secondsLeft = 25 * 60;
  bool _isFocusing = false;

  int get _completedTasks => _tasks.where((task) => task.completed).length;

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _toggleTask(int index, bool? value) {
    setState(() => _tasks[index].completed = value ?? false);
  }

  void _toggleFocus() {
    if (_isFocusing) {
      _timer?.cancel();
      setState(() => _isFocusing = false);
      return;
    }

    setState(() => _isFocusing = true);
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) return;
      if (_secondsLeft == 0) {
        timer.cancel();
        setState(() {
          _isFocusing = false;
          _secondsLeft = 25 * 60;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Nice work — your focus session is complete!'),
          ),
        );
        return;
      }
      setState(() => _secondsLeft--);
    });
  }

  void _showAddTaskMessage() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'Tip: edit the sample tasks in lib/main.dart to personalise StudyFlow.',
        ),
      ),
    );
  }

  String get _focusTime {
    final minutes = (_secondsLeft ~/ 60).toString().padLeft(2, '0');
    final seconds = (_secondsLeft % 60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 78,
        title: const Padding(
          padding: EdgeInsets.only(left: 8),
          child: _Brand(),
        ),
        actions: [
          IconButton(
            tooltip: 'Notifications',
            onPressed: () {},
            icon: const Badge(
              smallSize: 8,
              child: Icon(Icons.notifications_none_rounded),
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(left: 8, right: 20),
            child: CircleAvatar(
              radius: 18,
              backgroundColor: Color(0xFFE0E5FF),
              child: Text(
                'AK',
                style: TextStyle(
                  color: Color(0xFF4C5FD5),
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        top: false,
        child: LayoutBuilder(
          builder: (context, constraints) {
            final wideLayout = constraints.maxWidth >= 940;
            return SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 1180),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _Greeting(
                        completedTasks: _completedTasks,
                        taskCount: _tasks.length,
                      ),
                      const SizedBox(height: 24),
                      _WeekSelector(
                        selectedDay: _selectedDay,
                        onDaySelected: (index) =>
                            setState(() => _selectedDay = index),
                      ),
                      const SizedBox(height: 24),
                      if (wideLayout)
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(flex: 6, child: _taskPanel()),
                            const SizedBox(width: 24),
                            Expanded(flex: 4, child: _rightColumn()),
                          ],
                        )
                      else ...[
                        _taskPanel(),
                        const SizedBox(height: 24),
                        _rightColumn(),
                      ],
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: 0,
        onDestinationSelected: (_) {},
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.grid_view_rounded),
            label: 'Dashboard',
          ),
          NavigationDestination(
            icon: Icon(Icons.calendar_month_outlined),
            label: 'Calendar',
          ),
          NavigationDestination(
            icon: Icon(Icons.insights_outlined),
            label: 'Progress',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline_rounded),
            label: 'Profile',
          ),
        ],
      ),
    );
  }

  Widget _taskPanel() {
    return _SectionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Today's plan",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    SizedBox(height: 3),
                    Text(
                      'Small steps, steady progress.',
                      style: TextStyle(color: Color(0xFF747C90)),
                    ),
                  ],
                ),
              ),
              TextButton.icon(
                onPressed: _showAddTaskMessage,
                icon: const Icon(Icons.add_rounded, size: 18),
                label: const Text('Add task'),
              ),
            ],
          ),
          const SizedBox(height: 14),
          ...List.generate(_tasks.length, (index) {
            final task = _tasks[index];
            return Padding(
              padding: EdgeInsets.only(
                bottom: index == _tasks.length - 1 ? 0 : 10,
              ),
              child: _TaskTile(
                task: task,
                onChanged: (value) => _toggleTask(index, value),
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _rightColumn() {
    return Column(
      children: [
        _FocusCard(
          focusTime: _focusTime,
          isFocusing: _isFocusing,
          onPressed: _toggleFocus,
        ),
        const SizedBox(height: 24),
        _ScheduleCard(schedule: _schedule),
      ],
    );
  }
}

class _Brand extends StatelessWidget {
  const _Brand();

  @override
  Widget build(BuildContext context) {
    return const Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _BrandMark(),
        SizedBox(width: 10),
        Text(
          'StudyFlow',
          style: TextStyle(fontWeight: FontWeight.w900, letterSpacing: -0.6),
        ),
      ],
    );
  }
}

class _BrandMark extends StatelessWidget {
  const _BrandMark();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 32,
      height: 32,
      decoration: BoxDecoration(
        color: const Color(0xFF4C5FD5),
        borderRadius: BorderRadius.circular(10),
      ),
      child: const Icon(
        Icons.auto_graph_rounded,
        color: Colors.white,
        size: 19,
      ),
    );
  }
}

class _Greeting extends StatelessWidget {
  const _Greeting({required this.completedTasks, required this.taskCount});

  final int completedTasks;
  final int taskCount;

  @override
  Widget build(BuildContext context) {
    final progress = taskCount == 0 ? 0.0 : completedTasks / taskCount;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF4C5FD5), Color(0xFF7787F3)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'THURSDAY, OCTOBER 2',
            style: TextStyle(
              color: Color(0xFFDCE1FF),
              fontWeight: FontWeight.w700,
              letterSpacing: 1.1,
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Good afternoon, Alex!',
            style: TextStyle(
              color: Colors.white,
              fontSize: 28,
              fontWeight: FontWeight.w900,
              letterSpacing: -0.8,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            completedTasks == 0
                ? 'Ready to turn your plan into progress?'
                : 'You are building momentum. Keep it going!',
            style: const TextStyle(color: Color(0xFFE9EBFF), fontSize: 15),
          ),
          const SizedBox(height: 22),
          Row(
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(99),
                  child: LinearProgressIndicator(
                    value: progress,
                    minHeight: 9,
                    color: Colors.white,
                    backgroundColor: Colors.white.withValues(alpha: 0.24),
                  ),
                ),
              ),
              const SizedBox(width: 14),
              Text(
                '$completedTasks / $taskCount completed',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _WeekSelector extends StatelessWidget {
  const _WeekSelector({required this.selectedDay, required this.onDaySelected});

  final int selectedDay;
  final ValueChanged<int> onDaySelected;

  static const _days = [
    ('Mon', '29'),
    ('Tue', '30'),
    ('Wed', '01'),
    ('Thu', '02'),
    ('Fri', '03'),
    ('Sat', '04'),
    ('Sun', '05'),
  ];

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(_days.length, (index) {
        final isSelected = selectedDay == index;
        return Expanded(
          child: Padding(
            padding: EdgeInsets.only(right: index == _days.length - 1 ? 0 : 6),
            child: InkWell(
              borderRadius: BorderRadius.circular(16),
              onTap: () => onDaySelected(index),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                padding: const EdgeInsets.symmetric(vertical: 11),
                decoration: BoxDecoration(
                  color: isSelected ? const Color(0xFF4C5FD5) : Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: isSelected
                      ? [
                          BoxShadow(
                            color: const Color(0xFF4C5FD5)
                                .withValues(alpha: 0.22),
                            blurRadius: 12,
                            offset: const Offset(0, 5),
                          ),
                        ]
                      : null,
                ),
                child: Column(
                  children: [
                    Text(
                      _days[index].$1,
                      style: TextStyle(
                        color: isSelected
                            ? const Color(0xFFDCE1FF)
                            : const Color(0xFF747C90),
                        fontWeight: FontWeight.w700,
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      _days[index].$2,
                      style: TextStyle(
                        color: isSelected
                            ? Colors.white
                            : const Color(0xFF19202E),
                        fontWeight: FontWeight.w900,
                        fontSize: 17,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      }),
    );
  }
}

class _TaskTile extends StatelessWidget {
  const _TaskTile({required this.task, required this.onChanged});

  final StudyTask task;
  final ValueChanged<bool?> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(8, 10, 14, 10),
      decoration: BoxDecoration(
        color: task.completed ? const Color(0xFFF6F7FA) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: task.completed
              ? const Color(0xFFE8EAF0)
              : const Color(0xFFECEEF4),
        ),
      ),
      child: Row(
        children: [
          Checkbox(
            value: task.completed,
            onChanged: onChanged,
            activeColor: task.color,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5),
            ),
          ),
          Container(
            width: 4,
            height: 42,
            decoration: BoxDecoration(
              color: task.color,
              borderRadius: BorderRadius.circular(99),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  task.title,
                  style: TextStyle(
                    fontWeight: FontWeight.w800,
                    decoration: task.completed
                        ? TextDecoration.lineThrough
                        : null,
                    color: task.completed
                        ? const Color(0xFF8C93A4)
                        : const Color(0xFF252C3C),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  task.course,
                  style: const TextStyle(
                    color: Color(0xFF747C90),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Text(
            task.time,
            style: const TextStyle(
              color: Color(0xFF747C90),
              fontSize: 12,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class _FocusCard extends StatelessWidget {
  const _FocusCard({
    required this.focusTime,
    required this.isFocusing,
    required this.onPressed,
  });

  final String focusTime;
  final bool isFocusing;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: const Color(0xFF18213D),
        borderRadius: BorderRadius.circular(22),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.timer_outlined, color: Color(0xFFAEBBFF), size: 20),
              SizedBox(width: 8),
              Text(
                'FOCUS MODE',
                style: TextStyle(
                  color: Color(0xFFAEBBFF),
                  fontWeight: FontWeight.w800,
                  letterSpacing: 1.1,
                  fontSize: 12,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            focusTime,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 42,
              height: 1,
              fontWeight: FontWeight.w900,
              letterSpacing: -1.5,
            ),
          ),
          const SizedBox(height: 7),
          Text(
            isFocusing
                ? 'Focus session in progress'
                : 'A calm 25-minute study sprint',
            style: const TextStyle(color: Color(0xFFBAC2D9)),
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: FilledButton.icon(
              style: FilledButton.styleFrom(
                backgroundColor: const Color(0xFFE8EBFF),
                foregroundColor: const Color(0xFF25335E),
                padding: const EdgeInsets.symmetric(vertical: 13),
              ),
              onPressed: onPressed,
              icon: Icon(
                isFocusing ? Icons.pause_rounded : Icons.play_arrow_rounded,
              ),
              label: Text(isFocusing ? 'Pause focus' : 'Start focus'),
            ),
          ),
        ],
      ),
    );
  }
}

class _ScheduleCard extends StatelessWidget {
  const _ScheduleCard({required this.schedule});

  final List<ScheduleItem> schedule;

  @override
  Widget build(BuildContext context) {
    return _SectionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Coming up',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 16),
          ...List.generate(schedule.length, (index) {
            final item = schedule[index];
            return Padding(
              padding: EdgeInsets.only(
                bottom: index == schedule.length - 1 ? 0 : 18,
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 45,
                    child: Text(
                      item.time,
                      style: const TextStyle(
                        color: Color(0xFF747C90),
                        fontWeight: FontWeight.w800,
                        fontSize: 12,
                      ),
                    ),
                  ),
                  Container(
                    width: 3,
                    height: 42,
                    decoration: BoxDecoration(
                      color: item.color,
                      borderRadius: BorderRadius.circular(99),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.title,
                          style: const TextStyle(fontWeight: FontWeight.w800),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          item.detail,
                          style: const TextStyle(
                            color: Color(0xFF747C90),
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  const _SectionCard({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: const Color(0xFFECEEF4)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x080E1836),
            blurRadius: 16,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: child,
    );
  }
}

class StudyTask {
  StudyTask(
    this.title,
    this.course,
    this.time,
    this.color, {
    this.completed = false,
  });

  final String title;
  final String course;
  final String time;
  final Color color;
  bool completed;
}

class ScheduleItem {
  const ScheduleItem(this.time, this.title, this.detail, this.color);

  final String time;
  final String title;
  final String detail;
  final Color color;
}
