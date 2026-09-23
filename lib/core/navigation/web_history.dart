import 'package:web/web.dart' as web;

/// Replaces the current browser history entry with [path].
///
/// Used when the current Flutter route is about to be left because of
/// browser Back, but we don't want that route to remain available through
/// browser Forward.
void replaceCurrentBrowserHistory(String path) {
  web.window.history.replaceState(null, '', path);
}
