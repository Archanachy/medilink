import 'package:flutter/material.dart';
import '../../../auth/presentation/pages/login_screen.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _controller = PageController();
  int currentIndex = 0;
  final List<String> images = [
      "assets/images/welcome to medilink logo (1).jpg",
   "assets/images/esay appointments image for onboarding screen (1).jpg",
"assets/images/esay appointments image for onboarding screen.jpg",

  ];


  final List<String> titles = [
    
    "Welcome to MediLink",
    "Easy Appointments",
    "Your Health, Simplified",
  ];

  final List<String> subtitles = [

    "Connecting you to trusted healthcare.",
    "Schedule visits with one click.",
    "All your health info in one place.",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: PageView.builder(
        
        controller: _controller,
        itemCount: titles.length,
        onPageChanged: (index) {
          setState(() => currentIndex = index);
        },
        itemBuilder: (context, index) {
          return Column(
            
            mainAxisAlignment: MainAxisAlignment.center,
            children:[

              Image.asset(
                images[index],
                height: 300,
              ),
              

              Text(
                titles[index],
                style: const TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 10),

              Text(
                subtitles[index],
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 16,
                ),
              ),
            ],
          );
        },
      ),

      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(20.0),
        child: currentIndex == titles.length - 1
            ? ElevatedButton(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const LoginScreen()),
                  );
                },
                child: const Text("Get Started"),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    onPressed: () {
                      _controller.jumpToPage(titles.length - 1);
                    },
                    child: const Text("Skip"),
                  ),

                  Row(
                    children: List.generate(titles.length, (index) {
                      return Container(
                        margin: const EdgeInsets.all(4),
                        width: currentIndex == index ? 12 : 8,
                        height: currentIndex == index ? 12 : 8,
                        decoration: BoxDecoration(
                          color: currentIndex == index ? Colors.blue : Colors.grey,
                          shape: BoxShape.circle,
                        ),
                      );
                    }),
                  ),

                  TextButton(
                    onPressed: () {
                      _controller.nextPage(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeOut,
                      );
                    },
                    child: const Text("Next"),
                  ),
                ],
              ),
      ),
    );
  }
}
