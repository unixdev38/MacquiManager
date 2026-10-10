import 'package:flutter/material.dart';
import 'core/theme/app_theme.dart';
import 'state/app_state.dart';
import 'screens/sale_screen.dart';
import 'screens/cart_screen.dart';
import 'screens/confirmation_screen.dart';
import 'screens/orders_screen.dart';
import 'screens/order_detail_screen.dart';
import 'screens/payment_screen.dart';
import 'screens/drink_management_screen.dart';
import 'screens/stock_screen.dart';
import 'screens/history_screen.dart';
import 'screens/activity_screen.dart';
import 'screens/settings_screen.dart';
import 'models/order.dart';
import 'core/theme/app_colors.dart';
import 'core/theme/app_typography.dart';

class MacquiApp extends StatefulWidget {
  const MacquiApp({super.key});
  @override
  State<MacquiApp> createState() => _MacquiAppState();
}

class _MacquiAppState extends State<MacquiApp> {
  final AppState appState = AppState();
  int _currentIndex = 0;
  String _currentRoute = 'sale';
  String? _selectedOrderId;
  Order? _lastConfirmedOrder;

  void _navigate(String route, {String? orderId}) {
    setState(() {
      _currentRoute = route;
      if (orderId != null) _selectedOrderId = orderId;
      // Update bottom nav index
      if (route == 'sale' || route == 'cart' || route == 'confirmation') _currentIndex = 0;
      else if (route == 'orders' || route == 'order_detail' || route == 'payment') _currentIndex = 1;
      else if (route == 'stock') _currentIndex = 2;
      else if (route == 'history') _currentIndex = 3;
      else _currentIndex = 4;
    });
  }

  Widget _buildCurrentScreen() {
    switch (_currentRoute) {
      case 'sale':
        return SaleScreen(
          appState: appState,
          onViewCart: () => _navigate('cart'),
          onOpenOrders: () => _navigate('orders'),
          onOpenMenu: () => _openDrawer(),
        );
      case 'cart':
        return CartScreen(
          appState: appState,
          onContinue: () => _navigate('sale'),
          onValidate: () {
            final order = appState.validateCurrentOrder();
            if (order != null) {
              setState(() => _lastConfirmedOrder = order);
              _navigate('confirmation');
            }
          },
        );
      case 'confirmation':
        if (_lastConfirmedOrder == null) return SaleScreen(appState: appState, onViewCart: () => _navigate('cart'), onOpenOrders: () => _navigate('orders'), onOpenMenu: () => _openDrawer());
        return ConfirmationScreen(order: _lastConfirmedOrder!, onBackToSale: () => _navigate('sale'));
      case 'orders':
        return OrdersScreen(appState: appState, onOrderTap: (id) => _navigate('order_detail', orderId: id), onBack: () => _navigate('sale'));
      case 'order_detail':
        if (_selectedOrderId == null) return OrdersScreen(appState: appState, onOrderTap: (id) => _navigate('order_detail', orderId: id), onBack: () => _navigate('sale'));
        return OrderDetailScreen(
          appState: appState,
          orderId: _selectedOrderId!,
          onBack: () => _navigate('orders'),
          onPay: () => _navigate('payment', orderId: _selectedOrderId),
          onAddItems: () => _navigate('sale'),
        );
      case 'payment':
        if (_selectedOrderId == null) return OrdersScreen(appState: appState, onOrderTap: (id) => _navigate('order_detail', orderId: id), onBack: () => _navigate('sale'));
        return PaymentScreen(appState: appState, orderId: _selectedOrderId!, onBack: () => _navigate('order_detail', orderId: _selectedOrderId), onPaid: () => _navigate('sale'));
      case 'drink_management':
        return DrinkManagementScreen(appState: appState, onBack: () => _navigate('sale'));
      case 'stock':
        return StockScreen(appState: appState, onBack: () => _navigate('sale'));
      case 'history':
        return HistoryScreen(appState: appState, onOrderTap: (id) => _navigate('order_detail', orderId: id), onBack: () => _navigate('sale'));
      case 'activity':
        return ActivityScreen(appState: appState, onBack: () => _navigate('sale'));
      case 'settings':
        return SettingsScreen(appState: appState, onBack: () => _navigate('sale'));
      default:
        return SaleScreen(appState: appState, onViewCart: () => _navigate('cart'), onOpenOrders: () => _navigate('orders'), onOpenMenu: () => _openDrawer());
    }
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  void _openDrawer() {
    _scaffoldKey.currentState?.openDrawer();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Maquis Manager',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      home: Scaffold(
        key: _scaffoldKey,
        drawer: _buildDrawer(),
        body: _buildCurrentScreen(),
        bottomNavigationBar: _currentRoute == 'confirmation' ? null : BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (idx) {
            switch (idx) {
              case 0: _navigate('sale'); break;
              case 1: _navigate('orders'); break;
              case 2: _navigate('stock'); break;
              case 3: _navigate('history'); break;
              case 4: _scaffoldKey.currentState?.openDrawer(); break;
            }
          },
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.storefront_rounded), label: 'Vente'),
            BottomNavigationBarItem(icon: Icon(Icons.receipt_long_rounded), label: 'Commandes'),
            BottomNavigationBarItem(icon: Icon(Icons.inventory_2_rounded), label: 'Stock'),
            BottomNavigationBarItem(icon: Icon(Icons.history_rounded), label: 'Historique'),
            BottomNavigationBarItem(icon: Icon(Icons.menu_rounded), label: 'Plus'),
          ],
        ),
      ),
    );
  }

  Widget _buildDrawer() {
    return Drawer(
      backgroundColor: AppColors.surface,
      child: SafeArea(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              color: AppColors.primary,
              child: Row(
                children: [
                  Container(padding: const EdgeInsets.all(10), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)), child: const Icon(Icons.local_bar_rounded, color: AppColors.primary, size: 28)),
                  const SizedBox(width: 12),
                  Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text(appState.maquisName, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 16)),
                    Text('Serveur: ${appState.serverName}', style: const TextStyle(color: Colors.white70, fontSize: 12)),
                  ])),
                ],
              ),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(12),
                children: [
                  _drawerItem(Icons.storefront_rounded, 'Vente', 'Écran principal', () { Navigator.pop(context); _navigate('sale'); }, isSelected: _currentRoute == 'sale'),
                  _drawerItem(Icons.receipt_long_rounded, 'Commandes en cours', '${appState.openOrdersCount} ouvertes', () { Navigator.pop(context); _navigate('orders'); }),
                  _drawerItem(Icons.inventory_2_rounded, 'Stock', '${appState.stock.where((s) => s.isLow).length} alertes', () { Navigator.pop(context); _navigate('stock'); }),
                  _drawerItem(Icons.history_rounded, 'Historique ventes', '${appState.history.length} ventes', () { Navigator.pop(context); _navigate('history'); }),
                  const Divider(height: 24),
                  Padding(padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6), child: Text('GESTION', style: AppTypography.bodySmall.copyWith(fontWeight: FontWeight.w800, letterSpacing: 1))),
                  _drawerItem(Icons.local_drink_rounded, 'Boissons & Formats', 'Gérer les boissons', () { Navigator.pop(context); _navigate('drink_management'); }),
                  _drawerItem(Icons.bar_chart_rounded, 'Activité', 'Résumé gérant', () { Navigator.pop(context); _navigate('activity'); }),
                  _drawerItem(Icons.settings_rounded, 'Paramètres', 'Maquis & connexion', () { Navigator.pop(context); _navigate('settings'); }),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.all(12),
              child: Row(children: [
                Container(width: 8, height: 8, decoration: BoxDecoration(color: appState.isConnected ? AppColors.success : AppColors.error, shape: BoxShape.circle)),
                const SizedBox(width: 8),
                Text(appState.isConnected ? 'Central connecté' : 'Hors ligne', style: AppTypography.bodySmall),
                const Spacer(),
                Text('v1.0.0', style: AppTypography.bodySmall.copyWith(color: AppColors.textHint)),
              ]),
            ),
          ],
        ),
      ),
    );
  }

  Widget _drawerItem(IconData icon, String title, String subtitle, VoidCallback onTap, {bool isSelected = false}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 6),
      decoration: BoxDecoration(color: isSelected ? AppColors.primary.withOpacity(0.1) : Colors.transparent, borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: Container(padding: const EdgeInsets.all(8), decoration: BoxDecoration(color: isSelected ? AppColors.primary : AppColors.surfaceVariant, borderRadius: BorderRadius.circular(8)), child: Icon(icon, size: 20, color: isSelected ? Colors.white : AppColors.textPrimary)),
        title: Text(title, style: AppTypography.titleSmall.copyWith(fontSize: 13, color: isSelected ? AppColors.primary : AppColors.textPrimary)),
        subtitle: Text(subtitle, style: AppTypography.bodySmall.copyWith(fontSize: 11)),
        onTap: onTap,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }
}
