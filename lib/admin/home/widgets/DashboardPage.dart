
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:template/shared/constants/colors.dart';

class DashboardPage extends StatelessWidget {
  final int menuItemsCount;
  final int categoriesCount;
  final int coffeesCount;
  final int advertisementsCount;

  DashboardPage({
    required this.menuItemsCount,
    required this.categoriesCount,
    required this.coffeesCount,
    required this.advertisementsCount,
  });

  @override
  Widget build(BuildContext context) {
    return  Container(
      height: 380.sp,
        padding: const EdgeInsets.all(16.0),
        child: GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 16.0,
          mainAxisSpacing: 16.0,
          children: [
            _buildDashboardCard(
              context,
              'Menu Items',
              menuItemsCount,
              Icons.menu_book,
              Colors.blueAccent,
            ),
            _buildDashboardCard(
              context,
              'Categories',
              categoriesCount,
              Icons.category,
              Colors.orangeAccent,
            ),
            _buildDashboardCard(
              context,
              'Coffee Shops',
              coffeesCount,
              Icons.local_cafe,
              Colors.brown,
            ),
            _buildDashboardCard(
              context,
              'Advertisements',
              advertisementsCount,
              Icons.announcement,
              Colors.greenAccent,
            ),
          ],
        ),
      );
  }

  // Helper method to build each dashboard card
  Widget _buildDashboardCard(
      BuildContext context,
      String title,
      int count,
      IconData icon,
      Color color,
      ) {
    return Card(
      elevation: 4,
      color: AppColors.kWhiteColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 40,
              color: color,
            ),
            SizedBox(height: 10),
            Text(
              '$count',
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            SizedBox(height: 5),
            Text(
              title,
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }
}