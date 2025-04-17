import 'package:collection/collection.dart';
import 'package:finvu_flutter_sdk/common/models/bottom_navigation_item.dart';
import 'package:finvu_flutter_sdk/common/utils/analytics_events.dart';
import 'package:finvu_flutter_sdk/common/utils/finvu_colors.dart';
import 'package:finvu_flutter_sdk/common/utils/ui_utils.dart';
import 'package:finvu_flutter_sdk/common/widgets/base_page.dart';
import 'package:finvu_flutter_sdk/features/accounts/accounts_page.dart';
import 'package:finvu_flutter_sdk/features/consents/consents_home_page.dart';
import 'package:finvu_flutter_sdk/features/home/home_page.dart';
import 'package:flutter/material.dart';
import 'package:finvu_flutter_sdk/l10n/app_localizations.dart';

class MainPage extends BasePage {
  final String handleId;

  const MainPage({super.key, required this.handleId});

  @override
  State<MainPage> createState() => _MainPageState();

  static Route<void> route(
    String handleId,
  ) {
    return MaterialPageRoute<void>(
      builder: (_) => MainPage(
        handleId: handleId,
      ),
    );
  }

  @override
  String routeName() {
    return FinvuScreens.mainPage;
  }
}

class _MainPageState extends State<MainPage> {
  static const List<BottomNavigationItem> _navigationItems =
      BottomNavigationItem.values;

  BottomNavigationItem _selectedItem = _navigationItems.first;
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    // Show welcome message after the widget is built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          SnackBar(
            content: Text(
              AppLocalizations.of(context)!
                  .welcomeYourAAHandleIs(widget.handleId),
            ),
          ),
        );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: UIUtils.getFinvuAppBar(),
      backgroundColor: FinvuColors.lightBlue,
      body: _getWidget(_selectedItem),
      bottomNavigationBar: BottomNavigationBar(
        items: _navigationItems
            .mapIndexed(
              (index, item) => BottomNavigationBarItem(
                icon: Icon(_getIcon(item)),
                label: _getTitle(context, item),
              ),
            )
            .toList(),
        currentIndex: _selectedIndex,
        selectedItemColor: FinvuColors.blue,
        unselectedItemColor: FinvuColors.grey81858F,
        onTap: (index) {
          _onSwitchActiveTab(_navigationItems[index]);
        },
      ),
    );
  }

  String _getTitle(BuildContext context, BottomNavigationItem item) {
    switch (item) {
      case BottomNavigationItem.home:
        return AppLocalizations.of(context)!.home;

      case BottomNavigationItem.accounts:
        return AppLocalizations.of(context)!.accounts;

      case BottomNavigationItem.consents:
        return AppLocalizations.of(context)!.consents;

      default:
        throw Exception("Unhandled item $item");
    }
  }

  IconData _getIcon(BottomNavigationItem item) {
    switch (item) {
      case BottomNavigationItem.home:
        return Icons.home_outlined;

      case BottomNavigationItem.accounts:
        return Icons.account_balance_outlined;

      case BottomNavigationItem.consents:
        return Icons.verified_user_outlined;

      default:
        throw Exception("Unhandled item $item");
    }
  }

  Widget _getWidget(BottomNavigationItem item) {
    switch (item) {
      case BottomNavigationItem.home:
        return const HomePage();

      case BottomNavigationItem.accounts:
        return const AccountsPage();

      case BottomNavigationItem.consents:
        return const ConsentsHomePage();

      default:
        throw Exception("Unhandled item $item");
    }
  }

  void _onSwitchActiveTab(BottomNavigationItem item) {
    final index = _navigationItems.indexOf(item);
    setState(() {
      _selectedIndex = index;
      _selectedItem = item;
    });
  }
}
