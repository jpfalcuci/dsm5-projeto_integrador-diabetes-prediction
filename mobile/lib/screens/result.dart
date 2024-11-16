import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Result extends StatefulWidget {
  final Map<String, dynamic> formData;

  const Result({super.key, required this.formData});

  @override
  _ResultState createState() => _ResultState();
}

class _ResultState extends State<Result> {
  String result = "Aguardando resultado...";
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchResult();
  }

  Future<void> _fetchResult() async {
    setState(() {
      isLoading = true;
    });

    await dotenv.load(fileName: '.env');

    final String apiUrl = dotenv.env['API_URL'] ?? '';
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(widget.formData),
    );

    if (response.statusCode == 200) {
      setState(() {
        result = jsonDecode(response.body)['diabetes'].toString();
        isLoading = false;
      });
    } else {
      setState(() {
        result = 'Erro ao obter o resultado.';
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Resultado')),
      body: Center(
        child: isLoading
            ? const CircularProgressIndicator()
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(result, style: const TextStyle(fontSize: 20)),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text('Novo Teste'),
                  ),
                ],
              ),
      ),
    );
  }
}
