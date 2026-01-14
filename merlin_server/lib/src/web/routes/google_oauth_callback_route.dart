import 'dart:io';

import 'package:serverpod/serverpod.dart';

/// Simple widget that renders raw HTML content
class HtmlWidget extends WebWidget {
  final String html;

  HtmlWidget(this.html);

  Future<String> render(Session session, Request request) async {
    return html;
  }
}

/// Route handler for Google OAuth callback.
/// This route serves the auth_callback.html page and handles the OAuth callback.
class GoogleOAuthCallbackRoute extends WidgetRoute {
  @override
  Future<WebWidget> build(Session session, Request request) async {
    // Read the callback HTML file
    final file = File(Uri(path: 'web/pages/auth_callback.html').toFilePath());
    
    if (!file.existsSync()) {
      return HtmlWidget(
        '''
<!DOCTYPE html>
<html>
<head>
  <title>OAuth Callback Error</title>
</head>
<body>
  <h1>Error</h1>
  <p>OAuth callback page not found.</p>
</body>
</html>
        ''',
      );
    }
    
    final htmlContent = await file.readAsString();
    return HtmlWidget(htmlContent);
  }
}
