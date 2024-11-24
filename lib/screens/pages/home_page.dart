import 'package:flutter/material.dart';
import '../widgets/sidebar/project_sidebar.dart';
import '../widgets/project_content.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Row(
        children: [
          ProjectSidebar(),
          Expanded(
            child: ProjectContent(),
          ),
        ],
      ),
    );
  }
}
