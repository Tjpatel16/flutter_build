import 'package:flutter/material.dart';

import '../widgets/app_icon_generator/app_icon_generator.dart';
import '../widgets/project_content.dart';
import '../widgets/sidebar/project_sidebar.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: const Scaffold(
        body: Row(
          children: [
            ProjectSidebar(),
            Expanded(
              child: Column(
                children: [
                  TabBar(
                    tabs: [
                      Tab(text: 'App Builder'),
                      Tab(text: 'App Icon Generator'),
                    ],
                  ),
                  Expanded(
                    child: TabBarView(
                      physics: NeverScrollableScrollPhysics(),
                      children: [
                        ProjectContent(),
                        AppIconGenerator(), // Add the AppIconGenerater widget here
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
