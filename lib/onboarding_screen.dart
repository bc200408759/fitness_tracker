import 'package:flutter/material.dart';
import 'app_preferences.dart';
import 'home_screen.dart';

class OnboardingScreen extends StatefulWidget {
  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final _formKey = GlobalKey<FormState>();

  // Track the current step
  int currentStep = 0;

  // Step 1
  String fullName = '';
  double currentWeight = 0;
  double targetWeight = 0;
  String gender = 'Male';
  final List<String> genders = ['Male', 'Female'];

  // Step 2
  Map<String, String> days = {
    'Monday': '',
    'Tuesday': '',
    'Wednesday': '',
    'Thursday': '',
    'Friday': '',
    'Saturday': '',
    'Sunday': ''
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Onboarding')),
      body: Form(
        key: _formKey,
        child: Stepper(
          type: StepperType.horizontal,
          currentStep: currentStep, // Set current step
          steps: [
            Step(
              title: Text('Step 1'),
              content: Column(
                children: [
                  TextFormField(
                    decoration: InputDecoration(labelText: 'Full Name'),
                    validator: (value) => value!.isEmpty ? 'Enter your name' : null,
                    onChanged: (value) => fullName = value,
                  ),
                  TextFormField(
                    decoration: InputDecoration(labelText: 'Current Weight'),
                    keyboardType: TextInputType.number,
                    validator: (value) =>
                        value!.isEmpty ? 'Enter current weight' : null,
                    onChanged: (value) => currentWeight = double.tryParse(value) ?? 0,
                  ),
                  TextFormField(
                    decoration: InputDecoration(labelText: 'Target Weight'),
                    keyboardType: TextInputType.number,
                    validator: (value) =>
                        value!.isEmpty ? 'Enter target weight' : null,
                    onChanged: (value) => targetWeight = double.tryParse(value) ?? 0,
                  ),
                  DropdownButtonFormField<String>(
                    value: gender,
                    items: genders.map((gender) {
                      return DropdownMenuItem(value: gender, child: Text(gender));
                    }).toList(),
                    onChanged: (value) => setState(() => gender = value!),
                    decoration: InputDecoration(labelText: 'Gender'),
                  ),
                ],
              ),
            ),
            Step(
  title: Text('Step 2'),
  content: Column(
    children: days.keys.map((day) {
      bool isRestDay = days[day] == 'Rest Day';

      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Day Label
          Text(day),

          // Conditionally Render Input Field or Label
          Expanded(
            child: isRestDay
                ? Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Text(
                      'Selected as Rest Day',
                      style: TextStyle(color: Colors.grey),
                    ),
                  )
                : TextFormField(
                    decoration: InputDecoration(labelText: 'Workout Name'),
                    onChanged: (value) => days[day] = value,
                  ),
          ),

          // Rest Day Toggle Button
          TextButton(
            onPressed: () {
              setState(() {
                if (isRestDay) {
                  // Toggle off Rest Day
                  days[day] = '';
                } else {
                  // Toggle on Rest Day
                  days[day] = 'Rest Day';
                }
              });
            },
            child: Text(
              isRestDay ? 'Rest Day' : 'Rest Day',
              style: TextStyle(
                color: isRestDay ? Colors.white : Colors.red,
              ),
            ),
            style: TextButton.styleFrom(
              backgroundColor: isRestDay ? Colors.red : null,
              side: BorderSide(color: Colors.red),
            ),
          ),
        ],
      );
    }).toList(),
  ),
)

          ],
          onStepContinue: () {
            if (_formKey.currentState!.validate()) {
              if (currentStep < 1) {
                // Move to the next step
                setState(() {
                  currentStep++;
                });
              } else {
                // Final step - Save data and navigate
                _saveForm();
              }
            }
          },
          onStepCancel: () {
            if (currentStep > 0) {
              setState(() {
                currentStep--;
              });
            }
          },
        ),
      ),
    );
  }

  void _saveForm() async {
  final appPreferences = AppPreferences();
  await appPreferences.saveData('isFormSaved', true);
  await appPreferences.saveData('userDetails', {
    'fullName': fullName,
    'currentWeight': currentWeight,
    'targetWeight': targetWeight,
    'gender': gender,
    'days': days,
  });
  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomeScreen()));
}

}
