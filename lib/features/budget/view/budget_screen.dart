import 'dart:ui';

import 'package:flutter/material.dart';

class BudgetScreen extends StatelessWidget {
  const BudgetScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F0F0),
      appBar: AppBar(
        title: const Text('Budget'),
        backgroundColor: const Color(0xFFF0F0F0),
        surfaceTintColor: Colors.transparent,
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          // fake placeholder content underneath
          ListView(
            padding: const EdgeInsets.all(16),
            children: const [
              _PlaceholderCard(height: 80),
              SizedBox(height: 12),
              _PlaceholderCard(height: 120),
              SizedBox(height: 12),
              _PlaceholderCard(height: 80),
              SizedBox(height: 12),
              _PlaceholderCard(height: 100),
              SizedBox(height: 12),
              _PlaceholderCard(height: 80),
            ],
          ),
          // blur overlay
          ClipRect(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              child: const ColoredBox(color: Colors.transparent),
            ),
          ),
          // coming soon text
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Coming Soon',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    letterSpacing: -0.5,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Budget tracking is on its way.',
                  style: TextStyle(color: Colors.black54, fontSize: 15),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _PlaceholderCard extends StatelessWidget {
  const _PlaceholderCard({required this.height});
  final double height;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Container(height: 12, width: 120, decoration: BoxDecoration(color: Colors.black12, borderRadius: BorderRadius.circular(6))),
          Container(height: 10, width: 200, decoration: BoxDecoration(color: Colors.black12, borderRadius: BorderRadius.circular(6))),
          if (height > 90)
            Container(height: 10, width: 160, decoration: BoxDecoration(color: Colors.black12, borderRadius: BorderRadius.circular(6))),
        ],
      ),
    );
  }
}
