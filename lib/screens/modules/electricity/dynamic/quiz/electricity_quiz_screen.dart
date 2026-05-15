import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:audioplayers/audioplayers.dart';

const Color primaryColor = Color(0xFF4FC3F7);
const Color backgroundColor = Color(0xFFE1F5FE);
const Color textColor = Color(0xFF01579B);

/// =========================
/// SOUND + HAPTIC
/// =========================
class FeedbackService {
  static final AudioPlayer _player = AudioPlayer();

  static Future<void> correct() async {
    HapticFeedback.mediumImpact();
    await _player.stop();
    await _player.play(AssetSource('sounds/correct.mp3'));
  }

  static Future<void> wrong() async {
    HapticFeedback.heavyImpact();
    await _player.stop();
    await _player.play(AssetSource('sounds/incorrect.mp3'));
  }
}

/// =========================
/// QUIZ SCREEN
/// =========================
class ElectricityQuizScreen extends StatefulWidget {
  const ElectricityQuizScreen({super.key});

  @override
  State<ElectricityQuizScreen> createState() => _ElectricityQuizScreenState();
}

class _ElectricityQuizScreenState extends State<ElectricityQuizScreen> {
  List<Map<String, dynamic>> questions = [];

  int currentQuestion = 0;
  int selectedAnswer = -1;

  bool isAnswered = false;
  bool isCorrect = false;

  int score = 0;

  @override
  void initState() {
    super.initState();
    loadQuestions();
  }

  Future<void> loadQuestions() async {
    final String response = await rootBundle.loadString(
      'assets/data/dynamic_electricity_quiz.json',
    );

    final List data = json.decode(response);

    setState(() {
      questions = data.cast<Map<String, dynamic>>();
    });
  }

  /// =========================
  /// CHECK ANSWER (NO AUTO NEXT)
  /// =========================
  void checkAnswer(int index) {
    if (isAnswered) return;

    final correctIndex = questions[currentQuestion]['answer'];

    setState(() {
      selectedAnswer = index;
      isAnswered = true;
      isCorrect = index == correctIndex;
    });

    if (isCorrect) {
      score++;
      FeedbackService.correct();
    } else {
      FeedbackService.wrong();
    }
  }

  /// =========================
  /// NEXT QUESTION
  /// =========================
  void nextQuestion() {
    if (currentQuestion < questions.length - 1) {
      setState(() {
        currentQuestion++;
        selectedAnswer = -1;
        isAnswered = false;
        isCorrect = false;
      });
    } else {
      finishQuiz();
    }
  }

  void finishQuiz() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => QuizResultScreen(
          score: score,
          total: questions.length,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (questions.isEmpty) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final q = questions[currentQuestion];
    final correctIndex = q['answer'];

    return Scaffold(
      backgroundColor: backgroundColor,

      appBar: AppBar(
        backgroundColor: primaryColor,
        title: const Text("Quiz Listrik Statis"),
      ),

      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            /// PROGRESS
            LinearProgressIndicator(
              value: (currentQuestion + 1) / questions.length,
              backgroundColor: Colors.white,
              color: Colors.green,
              minHeight: 8,
            ),

            const SizedBox(height: 20),

            /// QUESTION
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
              ),
              child: Text(
                q['question'],
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: textColor,
                ),
              ),
            ),

            const SizedBox(height: 20),

            /// OPTIONS
            Expanded(
              child: ListView.builder(
                itemCount: q['options'].length,
                itemBuilder: (context, index) {
                  final option = q['options'][index];
                  final selected = selectedAnswer == index;

                  Color bgColor = Colors.white;

                  if (selected) {
                    if (isAnswered) {
                      bgColor =
                          (index == correctIndex) ? Colors.green : Colors.red;
                    } else {
                      bgColor = primaryColor;
                    }
                  }

                  return GestureDetector(
                    onTap: () => checkAnswer(index),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      margin: const EdgeInsets.only(bottom: 14),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: bgColor,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: Colors.grey.shade300),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            selected
                                ? (isAnswered
                                    ? (index == correctIndex
                                        ? Icons.check
                                        : Icons.close)
                                    : Icons.radio_button_checked)
                                : Icons.radio_button_off,
                            color: selected ? Colors.white : Colors.grey,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              option,
                              style: TextStyle(
                                color: selected ? Colors.white : textColor,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),

            /// BUTTON (FIXED FLOW)
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: isAnswered ? nextQuestion : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                ),
                child: Text(
                  currentQuestion == questions.length - 1
                      ? "Selesai"
                      : "Lanjut",
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// =========================
/// RESULT SCREEN
/// =========================
class QuizResultScreen extends StatelessWidget {
  final int score;
  final int total;

  const QuizResultScreen({
    super.key,
    required this.score,
    required this.total,
  });

  @override
  Widget build(BuildContext context) {
    final percent = ((score / total) * 100).toStringAsFixed(0);

    return Scaffold(
      backgroundColor: backgroundColor,
      body: Center(
        child: Container(
          padding: const EdgeInsets.all(24),
          margin: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.emoji_events,
                  size: 80, color: Colors.amber),

              const SizedBox(height: 20),

              const Text(
                "Quiz Selesai 🎉",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 12),

              Text(
                "$score / $total ($percent%)",
                style: const TextStyle(fontSize: 20),
              ),

              const SizedBox(height: 20),

              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("Kembali"),
              )
            ],
          ),
        ),
      ),
    );
  }
}