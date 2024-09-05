// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';

class CustomShimmerListScreen extends StatefulWidget {
  const CustomShimmerListScreen({super.key});

  @override
  _CustomShimmerListScreenState createState() =>
      _CustomShimmerListScreenState();
}

class _CustomShimmerListScreenState extends State<CustomShimmerListScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: simmerLoding(
        _controller,
      ),
    );
  }
}

ListView simmerLoding(AnimationController controller) {
  return ListView.builder(
    itemCount: 10,
    itemBuilder: (context, index) {
      return SizedBox(
        height: 80.0,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ShimmerWidget(controller: controller),
        ),
      );
    },
  );
}

class ShimmerWidget extends StatelessWidget {
  final AnimationController controller;

  const ShimmerWidget({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        return ShaderMask(
          shaderCallback: (bounds) {
            return LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              stops: [
                controller.value - 0.3,
                controller.value,
                controller.value + 0.3,
              ],
              colors: [
                Colors.grey[300]!,
                Colors.grey[100]!,
                Colors.grey[300]!,
              ],
            ).createShader(bounds);
          },
          child: child,
        );
      },
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 50.0,
            height: 50.0,
            color: Colors.white,
          ),
          const SizedBox(width: 8.0),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: double.infinity,
                  height: 8.0,
                  color: Colors.white,
                ),
                const SizedBox(height: 8.0),
                Container(
                  width: double.infinity,
                  height: 8.0,
                  color: Colors.white,
                ),
                const SizedBox(height: 8.0),
                Container(
                  width: 40.0,
                  height: 8.0,
                  color: Colors.white,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
