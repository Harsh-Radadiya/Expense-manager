import 'package:expencemanager/router/routing_constants.dart';
import 'package:expencemanager/utils/assets.dart';
import 'package:flutter/material.dart';

class Drawerwidget extends StatelessWidget {
  Drawerwidget({required this.advancedDrawerController});
  final advancedDrawerController;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        child: ListTileTheme(
          textColor: Colors.white,
          iconColor: Colors.white,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Container(
                width: 100.0,
                height: 100.0,
                margin: const EdgeInsets.only(
                  top: 24.0,
                  bottom: 64.0,
                ),
                clipBehavior: Clip.antiAlias,
                decoration: BoxDecoration(
                  color: Colors.black26,
                  shape: BoxShape.circle,
                ),
                child: Image.asset(
                  AppAsset.appLogo,
                  fit: BoxFit.fill,
                ),
              ),
              Divider(
                height: 10,
                color: Colors.white,
              ),
              ListTile(
                onTap: () {
                  advancedDrawerController.hideDrawer();
                },
                leading: Icon(Icons.home),
                title: Text('Dashboard'),
              ),
              ListTile(
                onTap: () {
                  advancedDrawerController.hideDrawer();
                  Navigator.pushNamed(context, EXPENSELIST_PAGE_ROUTE);
                },
                leading: Image.asset(
                  AppAsset.cash,
                  color: Colors.white,
                  height: 20,
                ),
                title: Text('Expenses'),
              ),
              ListTile(
                onTap: () {
                  advancedDrawerController.hideDrawer();
                  Navigator.pushNamed(context, STATEMENT_PAGE_ROUTE);
                },
                leading: Icon(Icons.thumbs_up_down_sharp),
                title: Text('Statement'),
              ),
              ListTile(
                onTap: () {
                  advancedDrawerController.hideDrawer();
                  Navigator.pushNamed(context, CATEGORY_LIST_PAGE_ROUTE);
                },
                leading: Icon(Icons.category),
                title: Text('Category'),
              ),
              Divider(
                height: 10,
                color: Colors.white,
              ),
              ListTile(
                onTap: () {
                  advancedDrawerController.hideDrawer();
                },
                leading: Icon(Icons.settings),
                title: Text('Settings'),
              ),
              Spacer(),
              DefaultTextStyle(
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.white54,
                ),
                child: Container(
                  margin: const EdgeInsets.symmetric(
                    vertical: 16.0,
                  ),
                  child: Text('Terms of Service | Privacy Policy'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
