import 'package:flutter/material.dart';
import 'app_preferences.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, dynamic>>(
      future: _loadUserData(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            appBar: AppBar(title: Text('Home')),
            body: Center(child: CircularProgressIndicator()),
          );
        } else if (snapshot.hasError || !snapshot.hasData) {
          return Scaffold(
            appBar: AppBar(title: Text('Home')),
            body: Center(child: Text('No data found. Please complete onboarding.')),
          );
        } else {
          final userData = snapshot.data!;
          return Scaffold(
            appBar: AppBar(title: Text('Home')),
            body: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Full Name: ${userData['fullName']}', style: TextStyle(fontSize: 18)),
                  Text('Current Weight: ${userData['currentWeight']}', style: TextStyle(fontSize: 18)),
                  Text('Target Weight: ${userData['targetWeight']}', style: TextStyle(fontSize: 18)),
                  Text('Gender: ${userData['gender']}', style: TextStyle(fontSize: 18)),
                  SizedBox(height: 20),
                  Text('Workout Days:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  ...userData['days'].entries.map<Widget>((entry) {
                    return Text('${entry.key}: ${entry.value}', style: TextStyle(fontSize: 16));
                  }).toList(),
                ],
              ),
            ),
          );
        }
      },
    );
  }

  Future<Map<String, dynamic>> _loadUserData() async {
    final appPreferences = AppPreferences();
    final userDetails = appPreferences.getData('userDetails');
    if (userDetails != null && userDetails is Map<String, dynamic>) {
      return Map<String, dynamic>.from(userDetails);
    }
    return {};
  }
}
