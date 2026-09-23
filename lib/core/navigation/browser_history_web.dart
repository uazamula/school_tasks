import 'package:web/web.dart' as web;

void replaceCurrentBrowserHistory(String path) {
  web.window.history.replaceState(null, '', path);
}
