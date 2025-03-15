import 'package:flutter/material.dart';

class ProgressScreen extends StatefulWidget {
  const ProgressScreen({super.key});

  @override
  _ProgressScreenState createState() => _ProgressScreenState();
}

class _ProgressScreenState extends State<ProgressScreen>
    with SingleTickerProviderStateMixin {
  int _currentStep = 0;
  late AnimationController _controller;
  late Animation<double> _heightAnimation;
  final List<String> steps = [
    "Cart",
    "Address",
    "Payment",
    "Verification",
    "Processing",
    "Shipping",
    "Delivered"
  ];

  late List<String> statuses;

  @override
  void initState() {
    super.initState();

    statuses = List.filled(steps.length, "Pending");
    statuses[0] = "In Progress";

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    _heightAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );

    _startProgress();
  }

  void _startProgress() async {
    _currentStep = 0;
    for (int i = 0; i < steps.length; i++) {
      if (i > 0) {
        await Future.delayed(const Duration(seconds: 2));
        setState(() {
          _currentStep = i;
          statuses[i] = "In Progress";
        });
        _controller.reset();
        _controller.forward();
      } else {
        _controller.reset();
        _controller.forward();
      }
      await Future.delayed(const Duration(seconds: 2));
      setState(() {
        statuses[i] = "Completed";
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
      ),
      backgroundColor: Colors.white,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: VerticalStepIndicator(
            steps: steps,
            statuses: statuses,
            currentStep: _currentStep,
            heightAnimation: _heightAnimation,
          ),
        ),
      ),
    );
  }
}

class VerticalStepIndicator extends StatelessWidget {
  final List<String> steps;
  final List<String> statuses;
  final int currentStep;
  final Animation<double> heightAnimation;

  const VerticalStepIndicator({
    required this.steps,
    required this.statuses,
    required this.currentStep,
    required this.heightAnimation,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: steps.asMap().entries.map((entry) {
          int index = entry.key;
          String step = entry.value;
          bool isLast = index == steps.length - 1;
          Color nodeColor = statuses[index] == "Completed"
              ? Color(0xff557FFE)
              : statuses[index] == "In Progress"
                  ? Color(0xff557FFE)
                  : Color(0xffAABFFF);
          String statusText = statuses[index];
          Widget iconWidget = Icon(
            statuses[index] == "Completed" ? Icons.check : null,
            size: 18,
            color: Colors.white,
          );

          return Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    flex: 4,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              step,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: nodeColor,
                              ),
                            ),
                            Text(
                              statusText,
                              style: TextStyle(
                                fontSize: 14,
                                color: nodeColor,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(width: 16),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: 30,
                    child: Column(
                      children: [
                        Container(
                          width: 28,
                          height: 28,
                          decoration: BoxDecoration(
                            color: nodeColor,
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: iconWidget,
                          ),
                        ),
                        if (!isLast)
                          AnimatedBuilder(
                            animation: heightAnimation,
                            builder: (context, child) {
                              Color staticLineColor = index < currentStep &&
                                      statuses[index] == "Completed"
                                  ? Color(0xff557FFE)
                                  : Color(0xffAABFFF);
                              ;
                              Color animatedLineColor = Color(0xff557FFE);

                              return Stack(
                                alignment: Alignment.topCenter,
                                children: [
                                  Container(
                                    width: 3,
                                    height: 50,
                                    color: staticLineColor,
                                  ),
                                  if (index == currentStep)
                                    Container(
                                      width: 3,
                                      height: 50 * heightAnimation.value,
                                      color: animatedLineColor,
                                    ),
                                ],
                              );
                            },
                          ),
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 4,
                    child: Container(),
                  ),
                ],
              ),
              if (!isLast) const SizedBox(height: 5),
            ],
          );
        }).toList(),
      ),
    );
  }
}
