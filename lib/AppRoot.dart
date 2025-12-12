import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'features/categories/categories_page.dart';
import 'features/dashboard/dashboard_page.dart';
import 'features/transactions/transactions_page.dart';
import 'features/reports/reports_page.dart';

class AppRoot extends StatefulWidget {
  const AppRoot({super.key});

  @override
  State<AppRoot> createState() => _AppRootState();
}

class _AppRootState extends State<AppRoot> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    const DashboardPage(),      // Dashboard + Reports inside
    const TransactionsPage(),
    const CategoriesPage(),
    const ReportsPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        type: BottomNavigationBarType.fixed,
        onTap: (index) => setState(() => _currentIndex = index),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.dashboard), label: 'Dashboard'),
          BottomNavigationBarItem(icon: Icon(Icons.list), label: 'Transactions'),
          BottomNavigationBarItem(icon: Icon(Icons.category), label: 'Categories'),
          BottomNavigationBarItem(icon: Icon(Icons.bar_chart), label: 'Summary'),
        ],
      ),
    );
  }
}

// class _AppRootState extends State<AppRoot> {
//   int _currentIndex = 0;
//
//   final List<Widget> _pages = [
//     const TransactionsPage(), // your existing transaction page
//     const CategoriesPage(),   // list categories & add category
//     const BudgetPage(),       // monthly budget page
//     const ReportsPage(),      // charts & reports
//   ];
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: _pages[_currentIndex],
//       bottomNavigationBar: BottomNavigationBar(
//         currentIndex: _currentIndex,
//         onTap: (index) => setState(() => _currentIndex = index),
//         type: BottomNavigationBarType.fixed,
//         items: const [
//           BottomNavigationBarItem(icon: Icon(Icons.list), label: 'Transactions'),
//           BottomNavigationBarItem(icon: Icon(Icons.category), label: 'Categories'),
//           BottomNavigationBarItem(icon: Icon(Icons.account_balance_wallet), label: 'Budget'),
//           BottomNavigationBarItem(icon: Icon(Icons.bar_chart), label: 'Reports'),
//         ],
//       ),
//     );
//   }
// }