import 'app_card_quick_actions.dart';
export 'app_card_quick_actions.dart' show AppCardQuickAction;

/// Footer de acciones prioritarias. Las acciones administrativas van al menú.
class AppCardActions extends AppCardQuickActions {
  const AppCardActions({
    super.key,
    super.navigationAction,
    super.secondaryNavigationAction,
    super.operationalAction,
  });
}
