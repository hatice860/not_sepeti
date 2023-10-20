import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:not_sepeti/models/notes.dart';
import 'package:not_sepeti/utils/constant.dart';
import 'package:not_sepeti/utils/database_helper.dart';
import 'package:not_sepeti/view/turkish_words.dart';

class RecognizeScreen extends StatefulWidget {
  final String? path;
  final String? text;

  RecognizeScreen({Key? key, this.path, this.text}) : super(key: key);

  @override
  State<RecognizeScreen> createState() => _RecognizeScreenState();
}

class _RecognizeScreenState extends State<RecognizeScreen> {
  DatabaseHelper databaseHelper = DatabaseHelper();
  bool _isBusy = false;
  String? notDescription; // Değişken tipini nullable olarak güncelledik
  int noteID = 1;
  String? noteName;
  DateTime? notDate;
  TextEditingController controller = TextEditingController();

  @override
  void initState() {
    super.initState();

    final InputImage inputImage = InputImage.fromFilePath(widget.path!);

    processImage(inputImage);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColor.primaryColor,
        title: const Text('Taratılmış Metin'),
      ),
      body: _isBusy
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : ListView(
              padding: EdgeInsets.all(12),
              children: [
                TextFormField(
                  maxLines: 30,
                  controller: controller,
                  onChanged: (newValue) {
                    setState(() {
                      notDescription = autocorrect(newValue);
                    });
                  },
                  decoration:
                      const InputDecoration(hintText: 'Metin işleniyor...'),
                ),
                ElevatedButton(
                  onPressed: _saveNote,
                  child: const Text('Düzenlemeyi Kaydet'),
                ),
                const SizedBox(height: 20),
                 Text(
                  'Düzeltildi: $notDescription', // Düzeltme yapılan metni burada görüntüle
                  style: TextStyle(color: Colors.red), // Kırmızı renkli metin
                ), 
              ],
            ),
    );
  }

  void processImage(InputImage image) async {
    final textRecognizer = TextRecognizer();
    setState(() {
      _isBusy = true;
    });

    log(image.filePath!);
    final RecognizedText recognisedText =
        await textRecognizer.processImage(image);

    controller.text = recognisedText.text;
    setState(() {
      notDescription = autocorrect(recognisedText.text);
    });

    setState(() {
      _isBusy = false;
    });
  }

  Future<void> _saveNote() async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Not Başlığı'),
          content: TextFormField(
            onChanged: (value) {
              noteName = value;
            },
            decoration:
                const InputDecoration(hintText: 'Not başlığını giriniz'),
          ),
          actions: [
            TextButton(
              child: const Text('Kaydet'),
              onPressed: () async {
                if (noteName!.isNotEmpty && notDescription != null) {
                  await databaseHelper.addNote(
                    Notes(
                      noteID,
                      noteName,
                      notDescription!,
                      notDate,
                    ),
                  );
                  debugPrint('Not kaydedildi');
                  Navigator.pop(context);
                  Navigator.pop(context);
                  Navigator.pop(context);
                  Navigator.pop(context);
                  Navigator.pop(context);
                }
              },
            ),
          ],
        );
      },
    );
  }

  String autocorrect(String inputText) {
    List<String> words = inputText.toLowerCase().split(' ');

    for (int i = 0; i < words.length; i++) {
      if (!turkishWords.contains(words[i])) {
        // Yanlış yazılmış kelimeyi otomatik düzeltmek için en yakın Türkçe kelimeyi bulun
        String correctedWord = findClosestTurkishWord(words[i]);
        if (correctedWord != words[i]) {
          debugPrint('Düzeltildi: ${words[i]} -> $correctedWord');
          words[i] = correctedWord;
        }
      }
    }

    return words.join(' ');
  }

  String findClosestTurkishWord(String word) {
    double minDistance = double.infinity;
    String closestWord = word;

    for (String turkishWord in turkishWords) {
      int distance = levenshteinDistance(word, turkishWord);
      if (distance < minDistance) {
        minDistance = distance.toDouble();
        closestWord = turkishWord;
      }
    }

    return closestWord;
  }

  int levenshteinDistance(String a, String b) {
    int m = a.length;
    int n = b.length;
    List<List<int>> dp =
        List.generate(m + 1, (_) => List<int>.filled(n + 1, 0));

    for (int i = 0; i <= m; i++) {
      dp[i][0] = i;
    }

    for (int j = 0; j <= n; j++) {
      dp[0][j] = j;
    }

    for (int i = 1; i <= m; i++) {
      for (int j = 1; j <= n; j++) {
        int cost = (a[i - 1] != b[j - 1]) ? 1 : 0;
        dp[i][j] = [dp[i - 1][j] + 1, dp[i][j - 1] + 1, dp[i - 1][j - 1] + cost]
            .reduce((value, element) => value > element ? element : value);
      }
    }

    return dp[m][n];
  }
}
 //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