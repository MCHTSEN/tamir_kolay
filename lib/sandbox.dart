import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:tamir_kolay/service/gemini_service.dart';

class Sandbox extends ConsumerStatefulWidget {
  const Sandbox({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SandboxState();
}

class _SandboxState extends ConsumerState<Sandbox> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _controller = TextEditingController();
  bool _containsProfanity = false;
  bool _isLoading = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _checkProfanity() async {
    setState(() {
      _containsProfanity = false;
    });
    final response = await GeminiService().checkProfanity(_controller.text);
    setState(() {
      _containsProfanity = response; // Sonucu güncelle
      print('Profanity check result: $_containsProfanity');
    });
  }

  String? _validateText(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter some text';
    }
    if (_containsProfanity) {
      return 'Text contains profanity!';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextFormField(
                
                controller: _controller,
                validator: _validateText,
                decoration:  const InputDecoration(
                  hintText: 'Enter some text',
                ),
              ),
              Gap(1.h),
              _isLoading
                  ? Row(
                      children: [
                        Gap(4.w),
                        const SizedBox(
                            height: 15,
                            width: 15,
                            child: CircularProgressIndicator(
                              strokeWidth: 3,
                            )),
                        Gap(2.w),
                        const Text('Checking for profanity...',
                            style: TextStyle(fontSize: 12)),
                      ],
                    )
                  : const SizedBox.shrink(),
              ElevatedButton(
                  onPressed: () async {
                    changeStatus();
                    await _checkProfanity();
                    if (_formKey.currentState?.validate() ?? false) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Processing Data')),
                      );
                    }
                    changeStatus();
                  },
                  child: const Text('Send Me')),
            ],
          ),
        ),
      ),
    );
  }

  void changeStatus() {
    setState(() {
      _isLoading = !_isLoading;
    });
  }
}
