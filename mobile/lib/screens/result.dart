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
  String resultMessage = "Aguardando resultado...";
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
    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(widget.formData),
      );

      if (response.statusCode == 200) {
        final int diabetesResult = jsonDecode(response.body)['diabetes'];
        setState(() {
          resultMessage = diabetesResult == 1
              ? "Baseado em seus dados, você apresenta ALTO RISCO para diabetes!\nConsidere consultar um médico."
              : "Baseado em seus dados, você apresenta BAIXO RISCO para diabetes!\nContinue cuidando da sua saúde!";
          isLoading = false;
        });
      } else {
        setState(() {
          resultMessage = 'Erro ao obter o resultado.\nTente novamente mais tarde.';
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        resultMessage = 'Erro ao conectar com o servidor.\nVerifique sua conexão.';
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Resultado',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.black),
        elevation: 0,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: isLoading
              ? const CircularProgressIndicator()
              : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      resultMessage,
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(height: 30),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        minimumSize: const Size(double.infinity, 50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'Novo Teste',
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
