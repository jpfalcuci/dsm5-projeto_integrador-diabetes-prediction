import 'package:flutter/material.dart';
import '../components/numeric_field.dart';
import '../components/radio_group.dart';
import '../components/field_group.dart';
import 'result.dart';

// Enums para valores fixos
enum Gender { male, female }
enum Race { africanAmerican, asian, caucasian, hispanic, other }
enum SmokingStatus { current, ever, former, never, notCurrent }

class DiabetesFormScreen extends StatefulWidget {
  const DiabetesFormScreen({super.key});

  @override
  State<DiabetesFormScreen> createState() => _DiabetesFormScreenState();
}

class _DiabetesFormScreenState extends State<DiabetesFormScreen> {
  final _formKey = GlobalKey<FormState>();

  // Controllers para campos de texto
  final _ageController = TextEditingController();
  final _weightController = TextEditingController();
  final _heightController = TextEditingController();
  final _hba1cController = TextEditingController();
  final _glucoseController = TextEditingController();

  // Estado do formulário
  Gender? _selectedGender;
  Race? _selectedRace;
  SmokingStatus? _selectedSmokingStatus;
  bool? _hasHypertension;
  bool? _hasHeartDisease;

  @override
  void dispose() {
    _ageController.dispose();
    _weightController.dispose();
    _heightController.dispose();
    _hba1cController.dispose();
    _glucoseController.dispose();
    super.dispose();
  }

  void _onSubmit() {
    if (_formKey.currentState?.validate() ?? false) {
      final weight = double.parse(_weightController.text);
      final height = double.parse(_heightController.text);
      final bmi = weight / (height * height);

      final genderValue = _selectedGender == Gender.male ? 1 : 0;

      final raceValues = {
        'race:AfricanAmerican': _selectedRace == Race.africanAmerican ? 1 : 0,
        'race:Asian': _selectedRace == Race.asian ? 1 : 0,
        'race:Caucasian': _selectedRace == Race.caucasian ? 1 : 0,
        'race:Hispanic': _selectedRace == Race.hispanic ? 1 : 0,
        'race:Other': _selectedRace == Race.other ? 1 : 0,
      };

      final smokingValues = {
        'smoking_history_current': _selectedSmokingStatus == SmokingStatus.current ? 1 : 0,
        'smoking_history_ever': _selectedSmokingStatus == SmokingStatus.ever ? 1 : 0,
        'smoking_history_former': _selectedSmokingStatus == SmokingStatus.former ? 1 : 0,
        'smoking_history_never': _selectedSmokingStatus == SmokingStatus.never ? 1 : 0,
        'smoking_history_not current': _selectedSmokingStatus == SmokingStatus.notCurrent ? 1 : 0,
      };

      final formData = {
        'gender': genderValue,
        'age': int.parse(_ageController.text),
        ...raceValues,
        'hypertension': _hasHypertension == true ? 1 : 0,
        'heart_disease': _hasHeartDisease == true ? 1 : 0,
        'bmi': bmi,
        'hbA1c_level': double.parse(_hba1cController.text),
        'blood_glucose_level': double.parse(_glucoseController.text),
        ...smokingValues,
      };

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => Result(formData: formData),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Verificar Diabetes', style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.black),
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              // Idade
              NumericField(
                controller: _ageController,
                label: 'Idade',
                hint: 'Digite a idade',
              ),
              const SizedBox(height: 16),

              // Gênero
              RadioGroup<Gender>(
                title: 'Gênero',
                values: Gender.values,
                selectedValue: _selectedGender,
                onChanged: (value) => setState(() => _selectedGender = value),
                labels: {
                  Gender.male: 'Masculino',
                  Gender.female: 'Feminino',
                },
              ),
              const SizedBox(height: 16),

              // Raça
              RadioGroup<Race>(
                title: 'Raça',
                values: Race.values,
                selectedValue: _selectedRace,
                onChanged: (value) => setState(() => _selectedRace = value),
                labels: {
                  Race.africanAmerican: 'Afro-Americano',
                  Race.asian: 'Asiático',
                  Race.caucasian: 'Caucasiano',
                  Race.hispanic: 'Hispânico',
                  Race.other: 'Outro',
                },
              ),
              const SizedBox(height: 16),

              // Hipertensão
              RadioGroup<bool>(
                title: 'Hipertensão',
                values: [true, false],
                selectedValue: _hasHypertension,
                onChanged: (value) => setState(() => _hasHypertension = value),
                labels: {true: 'Sim', false: 'Não'},
              ),
              const SizedBox(height: 16),

              // Doença Cardíaca
              RadioGroup<bool>(
                title: 'Doença Cardíaca',
                values: [true, false],
                selectedValue: _hasHeartDisease,
                onChanged: (value) => setState(() => _hasHeartDisease = value),
                labels: {true: 'Sim', false: 'Não'},
              ),
              const SizedBox(height: 16),

              // Tabagismo
              RadioGroup<SmokingStatus>(
                title: 'Tabagismo',
                values: SmokingStatus.values,
                selectedValue: _selectedSmokingStatus,
                onChanged: (value) => setState(() => _selectedSmokingStatus = value),
                labels: {
                  SmokingStatus.current: 'Fuma atualmente',
                  SmokingStatus.ever: 'Já Fumou',
                  SmokingStatus.former: 'Ex-fumante',
                  SmokingStatus.never: 'Nunca Fumou',
                  SmokingStatus.notCurrent: 'Não fuma atualmente',
                },
              ),
              const SizedBox(height: 16),

              // Peso e Altura
              FieldGroup(
                title: 'IMC (Peso e Altura)',
                child: Row(
                  children: [
                    Expanded(
                      child: NumericField(
                        controller: _weightController,
                        label: 'Peso (kg)',
                        hint: 'Digite o peso',
                        decimal: true,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: NumericField(
                        controller: _heightController,
                        label: 'Altura (m)',
                        hint: 'Digite a altura',
                        decimal: true,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // HbA1c
              NumericField(
                controller: _hba1cController,
                label: 'Nível de HbA1c',
                hint: 'Digite o nível de HbA1c',
                decimal: true,
              ),
              const SizedBox(height: 16),

              // Glicose
              NumericField(
                controller: _glucoseController,
                label: 'Nível de Glicose no Sangue',
                hint: 'Digite o nível de glicose',
                decimal: true,
              ),
              const SizedBox(height: 24),

              // Botão Enviar
              ElevatedButton(
                onPressed: _onSubmit,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Enviar Dados',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}