import 'package:flutter/material.dart';
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
  final _bmiController = TextEditingController();
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
    _bmiController.dispose();
    _hba1cController.dispose();
    _glucoseController.dispose();
    super.dispose();
  }

  void _onSubmit() {
    if (_formKey.currentState?.validate() ?? false) {
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
        'bmi': double.parse(_bmiController.text),
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

  String? _validateNumericField(String? value, String fieldName) {
    if (value == null || value.isEmpty) {
      return 'Por favor, digite o $fieldName';
    }
    if (double.tryParse(value) == null) {
      return 'Digite um valor numérico válido';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Verificar Diabetes', 
          style: TextStyle(color: Colors.black)),
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
              _buildFieldGroup(
                title: 'Gênero',
                child: Row(
                  children: [
                    Expanded(
                      child: RadioListTile<Gender>(
                        title: const Text('Masculino'),
                        value: Gender.male,
                        groupValue: _selectedGender,
                        onChanged: (value) => setState(() => _selectedGender = value),
                        contentPadding: EdgeInsets.zero,
                        visualDensity: const VisualDensity(
                          horizontal: VisualDensity.minimumDensity,
                          vertical: VisualDensity.minimumDensity,
                        ),
                      ),
                    ),
                    Expanded(
                      child: RadioListTile<Gender>(
                        title: const Text('Feminino'),
                        value: Gender.female,
                        groupValue: _selectedGender,
                        onChanged: (value) => setState(() => _selectedGender = value),
                        contentPadding: EdgeInsets.zero,
                        visualDensity: const VisualDensity(
                          horizontal: VisualDensity.minimumDensity,
                          vertical: VisualDensity.minimumDensity,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              
              _buildNumericField(
                controller: _ageController,
                label: 'Idade',
                hint: 'Digite a idade',
              ),
              const SizedBox(height: 16),
              
              _buildFieldGroup(
                title: 'Raça',
                child: Wrap(
                  children: Race.values.map((race) {
                    String label = switch (race) {
                      Race.africanAmerican => 'Afro-Americano',
                      Race.asian => 'Asiático',
                      Race.caucasian => 'Caucasiano',
                      Race.hispanic => 'Hispânico',
                      Race.other => 'Outro',
                    };
                    return SizedBox(
                      width: MediaQuery.of(context).size.width / 2 - 24,
                      child: RadioListTile<Race>(
                        title: Text(label),
                        value: race,
                        groupValue: _selectedRace,
                        onChanged: (value) => setState(() => _selectedRace = value),
                        contentPadding: EdgeInsets.zero,
                        visualDensity: const VisualDensity(
                          horizontal: VisualDensity.minimumDensity,
                          vertical: VisualDensity.minimumDensity,
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(height: 16),
              
              _buildFieldGroup(
                title: 'Hipertensão',
                child: Row(
                  children: [
                    Expanded(
                      child: RadioListTile<bool>(
                        title: const Text('Sim'),
                        value: true,
                        groupValue: _hasHypertension,
                        onChanged: (value) => setState(() => _hasHypertension = value),
                        contentPadding: EdgeInsets.zero,
                        visualDensity: const VisualDensity(
                          horizontal: VisualDensity.minimumDensity,
                          vertical: VisualDensity.minimumDensity,
                        ),
                      ),
                    ),
                    Expanded(
                      child: RadioListTile<bool>(
                        title: const Text('Não'),
                        value: false,
                        groupValue: _hasHypertension,
                        onChanged: (value) => setState(() => _hasHypertension = value),
                        contentPadding: EdgeInsets.zero,
                        visualDensity: const VisualDensity(
                          horizontal: VisualDensity.minimumDensity,
                          vertical: VisualDensity.minimumDensity,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              
              _buildFieldGroup(
                title: 'Doença Cardíaca',
                child: Row(
                  children: [
                    Expanded(
                      child: RadioListTile<bool>(
                        title: const Text('Sim'),
                        value: true,
                        groupValue: _hasHeartDisease,
                        onChanged: (value) => setState(() => _hasHeartDisease = value),
                        contentPadding: EdgeInsets.zero,
                        visualDensity: const VisualDensity(
                          horizontal: VisualDensity.minimumDensity,
                          vertical: VisualDensity.minimumDensity,
                        ),
                      ),
                    ),
                    Expanded(
                      child: RadioListTile<bool>(
                        title: const Text('Não'),
                        value: false,
                        groupValue: _hasHeartDisease,
                        onChanged: (value) => setState(() => _hasHeartDisease = value),
                        contentPadding: EdgeInsets.zero,
                        visualDensity: const VisualDensity(
                          horizontal: VisualDensity.minimumDensity,
                          vertical: VisualDensity.minimumDensity,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              
              _buildFieldGroup(
                title: 'Tabagismo',
                child: Wrap(
                  children: SmokingStatus.values.map((status) {
                    String label = switch (status) {
                      SmokingStatus.current => 'Fuma atualmente',
                      SmokingStatus.ever => 'Já Fumou',
                      SmokingStatus.former => 'Ex-fumante',
                      SmokingStatus.never => 'Nunca Fumou',
                      SmokingStatus.notCurrent => 'Não fuma atualmente',
                    };
                    return SizedBox(
                      width: MediaQuery.of(context).size.width / 2 - 24,
                      child: RadioListTile<SmokingStatus>(
                        title: Text(label),
                        value: status,
                        groupValue: _selectedSmokingStatus,
                        onChanged: (value) => setState(() => _selectedSmokingStatus = value),
                        contentPadding: EdgeInsets.zero,
                        visualDensity: const VisualDensity(
                          horizontal: VisualDensity.minimumDensity,
                          vertical: VisualDensity.minimumDensity,
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(height: 16),
              
              _buildNumericField(
                controller: _bmiController,
                label: 'Índice de Massa Corporal (BMI)',
                hint: 'Digite o BMI',
                decimal: true,
              ),
              const SizedBox(height: 16),
              
              _buildNumericField(
                controller: _hba1cController,
                label: 'Nível de HbA1c',
                hint: 'Digite o nível de HbA1c',
                decimal: true,
              ),
              const SizedBox(height: 16),
              
              _buildNumericField(
                controller: _glucoseController,
                label: 'Nível de Glicose no Sangue',
                hint: 'Digite o nível de glicose',
                decimal: true,
              ),
              const SizedBox(height: 24),
              
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

  Widget _buildFieldGroup({required String title, required Widget child}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(fontSize: 16)),
        const SizedBox(height: 4),
        child,
      ],
    );
  }

  Widget _buildNumericField({
    required TextEditingController controller,
    required String label,
    required String hint,
    bool decimal = false,
  }) {
    return TextFormField(
      controller: controller,
      decoration: _inputDecoration(label).copyWith(hintText: hint),
      keyboardType: TextInputType.numberWithOptions(decimal: decimal),
      validator: (value) => _validateNumericField(value, label),
    );
  }

  InputDecoration _inputDecoration(String labelText) {
    return InputDecoration(
      labelText: labelText,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    );
  }
}