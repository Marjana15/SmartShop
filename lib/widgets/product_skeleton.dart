// lib/widgets/product_skeleton.dart
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ProductSkeleton extends StatelessWidget {
  const ProductSkeleton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext _) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: Column(
        children: [
          Expanded(
            child: Container(
              margin: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
          Container(height: 16, margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4), color: Colors.white),
          Container(height: 16, margin: const EdgeInsets.symmetric(horizontal: 40, vertical: 4), color: Colors.white),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}
