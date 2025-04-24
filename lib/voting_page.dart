import 'package:flutter/material.dart';
import 'components/my_textfield.dart';

class VotingHomePage extends StatefulWidget {
  @override
  _VotingHomePageState createState() => _VotingHomePageState();
}

class _VotingHomePageState extends State<VotingHomePage> {
  int _currentPage = 0;
  final _controllers = List.generate(5, (_) => TextEditingController());
  final _errorMessages = List<String?>.filled(5, null);

  @override
  void dispose() {
    for (var c in _controllers) c.dispose();
    super.dispose();
  }

  void _changePage(int page) => setState(() => _currentPage = page);

  bool _validateFields() {
    bool valid = true;
    List<String> labels = ['Name', 'Age', 'Gender', 'Phone Number', 'Country'];

    for (int i = 0; i < _controllers.length; i++) {
      final text = _controllers[i].text.trim();
      if (text.isEmpty) {
        _errorMessages[i] = '${labels[i]} is required';
        valid = false;
      } else {
        _errorMessages[i] = null;
        if (i == 1) {
          final age = int.tryParse(text);
          if (age == null || age < 18) {
            _errorMessages[i] = age == null ? 'Invalid age format' : 'Must be 18 or older';
            valid = false;
          }
        }
      }
    }
    setState(() {});
    return valid;
  }

  @override
  Widget build(BuildContext context) => Scaffold(body: Center(child: _buildPage()));

  Widget _buildPage() {
    if (_currentPage == 0) return _dashboard();
    return _registerForm(showSuccess: _currentPage == 2);
  }

  Widget _dashboard() => Container(
        width: 320,
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: const Color(0xFFB3C3D9),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(children: [
                const CircleAvatar(
                  backgroundColor: Colors.black,
                  radius: 20,
                  child: Icon(Icons.person, color: Colors.white),
                ),
                const SizedBox(width: 12),
                const Text('Hii, userName',
                    style: TextStyle(color: Colors.black, fontSize: 12)),
              ]),
              const SizedBox(height: 40),
              _dashboardButton('Vote', 72, 32, 0xFF4F6596, () => _changePage(1)),
              const SizedBox(height: 24),
              _dashboardButton('View result', 56, 24, 0xFF3F527F, () {})
            ]),
            _bottomBar(selectedIndex: 1),
          ],
        ),
      );

  Widget _dashboardButton(String text, double height, double fontSize, int color, VoidCallback? onTap) =>
      SizedBox(
        width: double.infinity,
        height: height,
        child: ElevatedButton(
          onPressed: onTap,
          style: ElevatedButton.styleFrom(
            backgroundColor: Color(color),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
          ),
          child: Text(text,
              style: TextStyle(fontSize: fontSize, fontWeight: FontWeight.w600, color: Colors.white)),
        ),
      );

  Widget _registerForm({bool showSuccess = false}) => Container(
        width: 320,
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: const Color(0xFFB3C3D9),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Stack(children: [
          Column(children: [
            Align(
              alignment: Alignment.centerLeft,
              child: IconButton(
                icon: const Icon(Icons.arrow_back, size: 28),
                color: Colors.black,
                onPressed: () => _changePage(showSuccess ? 1 : 0),
              ),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: AbsorbPointer(
                absorbing: showSuccess,
                child: Opacity(
                  opacity: showSuccess ? 0.6 : 1,
                  child: SingleChildScrollView(
                    child: Column(
                      children: List.generate(_controllers.length, (i) => _buildTextField(i))
                        ..addAll([
                          const SizedBox(height: 24),
                          _dashboardButton(
                              'Register',
                              56,
                              32,
                              0xFF3F527F,
                              showSuccess
                                  ? null
                                  : () => _changePage(_validateFields() ? 2 : 1)),
                        ]),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),
            _bottomBar(selectedIndex: showSuccess ? 0 : 1),
          ]),
          if (showSuccess) _successOverlay(),
        ]));

 Widget _buildTextField(int i) => Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
    MyTextfield(
      controller: _controllers[i],
      hintText: ['Name', 'Age', 'Gender', 'Phone Number', 'Country'][i],
      obscureText: false,
    ),
    if (_errorMessages[i] != null)
      Padding(
        padding: const EdgeInsets.only(top: 4),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              _errorMessages[i]!,
              style: const TextStyle(color: Colors.red),
            ),
          ],
        ),
      ),
    const SizedBox(height: 12),
  ],
);

  Widget _successOverlay() => Positioned(
        top: 60,
        left: 0,
        right: 0,
        child: Center(
          child: Container(
            width: 192,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF7F8AA3),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Expanded(
                  child: Text(
                    'Successfully\nRegister',
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.w700, fontSize: 16, height: 1.2),
                  ),
                ),
                GestureDetector(
                  onTap: () => _changePage(1),
                  child: const Icon(Icons.close, color: Colors.black, size: 20),
                ),
              ],
            ),
          ),
        ),
      );

  Widget _bottomBar({required int selectedIndex}) => Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: List.generate(4, (index) {
          final icons = [Icons.home, Icons.how_to_vote, Icons.list, Icons.person];
          return IconButton(
            icon: Icon(icons[index]),
            color: selectedIndex == index ? const Color(0xFF9BB3CC) : Colors.black,
            onPressed: () {},
          );
        }),
      );
}
