import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    url: 'https://YOUR_SUPABASE_URL.supabase.co',
    anonKey: 'YOUR_ANON_KEY',
  );
  runApp(MupyApp());
}

class MupyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MUPY',
      theme: ThemeData(primaryColor: Color(0xFFFFD600), scaffoldBackgroundColor: Colors.white),
      home: LoginPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final phoneCtrl = TextEditingController();
  final pinCtrl = TextEditingController();
  bool isSignup = false;
  final nameCtrl = TextEditingController();
  final userCtrl = TextEditingController();

  Future<void> submit() async {
    final supabase = Supabase.instance.client;
    final phone = phoneCtrl.text.trim();
    final pin = pinCtrl.text.trim();
    final email = '$phone@mupy.ug';
    try {
      if (isSignup) {
        await supabase.auth.signUp(email: email, password: pin + 'Mupy123!', data: {'full_name': nameCtrl.text, 'username': userCtrl.text, 'phone': phone});
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Account Created! Welcome to MUPY')));
      } else {
        await supabase.auth.signInWithPassword(email: email, password: pin + 'Mupy123!');
      }
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => DashboardPage(name: isSignup ? nameCtrl.text : phone)));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding: EdgeInsets.all(24),
        child: Column(
          children: [
            SizedBox(height: 60),
            CircleAvatar(radius: 45, backgroundColor: Color(0xFFFFD600), child: Text('M', style: TextStyle(fontSize: 50, fontWeight: FontWeight.bold, color: Colors.black))),
            SizedBox(height: 12),
            Text('MUPY', style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold)),
            Text('MWITANZIGE UNITED YOUTH PLATFORM', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
            Text('United in Purpose - 2,000 UGX Daily Savings', style: TextStyle(color: Colors.grey)),
            SizedBox(height: 24),
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              ElevatedButton(onPressed: () => setState(() => isSignup = false), child: Text('Sign In'), style: ElevatedButton.styleFrom(backgroundColor: !isSignup ? Color(0xFFFFD600) : Colors.grey[200])),
              SizedBox(width: 10),
              ElevatedButton(onPressed: () => setState(() => isSignup = true), child: Text('Sign Up'), style: ElevatedButton.styleFrom(backgroundColor: isSignup ? Color(0xFFFFD600) : Colors.grey[200])),
            ]),
            SizedBox(height: 20),
            if (isSignup) ...[
              TextField(controller: nameCtrl, decoration: InputDecoration(labelText: 'Full Name', border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)))),
              SizedBox(height: 12),
              TextField(controller: userCtrl, decoration: InputDecoration(labelText: 'Username', prefixText: '@', border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)))),
              SizedBox(height: 12),
            ],
            TextField(controller: phoneCtrl, keyboardType: TextInputType.phone, decoration: InputDecoration(labelText: 'Phone Number', hintText: '077XXXXXXX', border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)))),
            SizedBox(height: 12),
            TextField(controller: pinCtrl, keyboardType: TextInputType.number, obscureText: true, maxLength: 6, decoration: InputDecoration(labelText: '6-Digit PIN', border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)))),
            SizedBox(height: 20),
            SizedBox(width: double.infinity, height: 50, child: ElevatedButton(onPressed: submit, child: Text(isSignup ? 'Join MUPY' : 'Login to MUPY', style: TextStyle(fontWeight: FontWeight.bold)), style: ElevatedButton.styleFrom(backgroundColor: Color(0xFFFFD600), foregroundColor: Colors.black))),
            SizedBox(height: 12),
            Text('By joining you agree to MUPY Constitution & Savings Policy', textAlign: TextAlign.center, style: TextStyle(fontSize: 11, color: Colors.grey)),
          ],
        ),
      ),
    );
  }
}

class DashboardPage extends StatelessWidget {
  final String name;
  DashboardPage({required this.name});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('MUPY - Welcome $name'), backgroundColor: Color(0xFFFFD600), foregroundColor: Colors.black),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            Container(padding: EdgeInsets.all(20), decoration: BoxDecoration(color: Color(0xFFFFD600), borderRadius: BorderRadius.circular(16)), child: Column(children: [Text('TOTAL SAVINGS', style: TextStyle(fontWeight: FontWeight.bold)), Text('0 UGX', style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold)), Text('Daily Target: 2,000 UGX • 0% Progress')])),
            SizedBox(height: 16),
            GridView.count(crossAxisCount: 2, shrinkWrap: true, children: [
              _card('💰 Savings', 'Save 2,000 Daily'),
              _card('💸 Loans', 'Apply for Loan'),
              _card('👥 Members', 'View Members'),
              _card('📊 Reports', 'My Statement'),
            ]),
            SizedBox(height: 20),
            SizedBox(width: double.infinity, height: 50, child: ElevatedButton(onPressed: () {}, child: Text('SAVE 2,000 UGX NOW'), style: ElevatedButton.styleFrom(backgroundColor: Colors.black, foregroundColor: Color(0xFFFFD600)))),
          ],
        ),
      ),
    );
  }
  Widget _card(String t, String s) => Card(child: Padding(padding: EdgeInsets.all(16), child: Column(children: [Text(t, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)), SizedBox(height: 8), Text(s)])));
}
