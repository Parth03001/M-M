import 'package:flutter/material.dart';

class CustomBottomNavBar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemTapped;

  const CustomBottomNavBar({
    Key? key,
    required this.selectedIndex,
    required this.onItemTapped,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final primaryColor = Color(0xFFDC143C); // Crimson red

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 18),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Home
              _buildNavItem(
                context: context,
                icon: Icons.home_outlined,
                label: 'Home',
                index: 0,
                isSelected: selectedIndex == 0,
                primaryColor: primaryColor,
              ),
              // Dashboard
              _buildNavItem(
                context: context,
                icon: Icons.dashboard_outlined,
                label: 'Dashboard',
                index: 1,
                isSelected: selectedIndex == 1,
                primaryColor: primaryColor,
              ),
              // Center Action Button (Scanner)
              _buildCenterActionButton(
                context: context,
                primaryColor: primaryColor,
              ),
              // History
              _buildNavItem(
                context: context,
                icon: Icons.history_outlined,
                label: 'History',
                index: 3,
                isSelected: selectedIndex == 3,
                primaryColor: primaryColor,
              ),
              // Profile
              _buildNavItem(
                context: context,
                icon: Icons.person_outline,
                label: 'Profile',
                index: 4,
                isSelected: selectedIndex == 4,
                primaryColor: primaryColor,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required BuildContext context,
    required IconData icon,
    required String label,
    required int index,
    required bool isSelected,
    required Color primaryColor,
  }) {
    return Expanded(
      child: GestureDetector(
        onTap: () => onItemTapped(index),
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                color: isSelected ? primaryColor : Colors.grey[700],
                size: 26,
              ),
              SizedBox(height: 4),
              Text(
                label,
                style: TextStyle(
                  color: isSelected ? primaryColor : Colors.grey[700],
                  fontSize: 12,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCenterActionButton({
    required BuildContext context,
    required Color primaryColor,
  }) {
    return GestureDetector(
      onTap: () => onItemTapped(2),
      child: Container(
        width: 70,
        height: 70,
        decoration: BoxDecoration(
          color: primaryColor,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: primaryColor.withOpacity(0.3),
              blurRadius: 8,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Icon(
          Icons.qr_code_scanner,
          color: Colors.white,
          size: 30,
        ),
      ),
    );
  }
}
