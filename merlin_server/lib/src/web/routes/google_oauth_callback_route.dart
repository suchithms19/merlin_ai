import 'package:serverpod/serverpod.dart';
import '../../services/google_oauth_service.dart';

/// Simple widget that renders raw HTML content
class HtmlWidget extends WebWidget {
  final String html;

  HtmlWidget(this.html);

  Future<String> render(Session session, Request request) async {
    return html;
  }
}

/// Route handler for Google OAuth callback.
/// This route handles the OAuth callback server-side and exchanges the code for tokens.
class GoogleOAuthCallbackRoute extends WidgetRoute {
  @override
  Future<WebWidget> build(Session session, Request request) async {
    // Get the authorization code and state from query parameters
    final code = request.url.queryParameters['code'];
    final state = request.url.queryParameters['state'];
    final error = request.url.queryParameters['error'];

    // Handle error from Google
    if (error != null) {
      return HtmlWidget(_buildErrorHtml('Authentication failed: $error'));
    }

    // Validate required parameters
    if (code == null || code.isEmpty) {
      return HtmlWidget(_buildErrorHtml('No authorization code received'));
    }

    if (state == null || state.isEmpty) {
      return HtmlWidget(_buildErrorHtml('Invalid state parameter'));
    }

    try {
      // Exchange the code for tokens server-side
      final oauthService = GoogleOAuthService(session);
      await oauthService.exchangeCodeForTokensWithState(code, state);

      // Return success page
      return HtmlWidget(_buildSuccessHtml());
    } catch (e) {
      session.log(
        'OAuth callback error: $e',
        level: LogLevel.error,
      );
      return HtmlWidget(_buildErrorHtml('Failed to connect: ${e.toString()}'));
    }
  }

  String _buildSuccessHtml() {
    return '''
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Google Connected</title>
    <style>
        body {
            font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, 'Helvetica Neue', Arial, sans-serif;
            display: flex;
            justify-content: center;
            align-items: center;
            min-height: 100vh;
            margin: 0;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
        }
        .container {
            background: white;
            padding: 40px;
            border-radius: 12px;
            box-shadow: 0 10px 40px rgba(0,0,0,0.2);
            text-align: center;
            max-width: 400px;
        }
        .success {
            color: #10b981;
            font-size: 48px;
            margin-bottom: 20px;
        }
        h2 {
            color: #1f2937;
            margin-bottom: 10px;
        }
        p {
            color: #6b7280;
            line-height: 1.5;
        }
        .close-btn {
            margin-top: 20px;
            padding: 12px 24px;
            background: #667eea;
            color: white;
            border: none;
            border-radius: 6px;
            cursor: pointer;
            font-size: 16px;
            font-weight: 600;
        }
        .close-btn:hover {
            background: #5568d3;
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="success">✓</div>
        <h2>Successfully Connected!</h2>
        <p>Your Google account has been connected. You can close this window and return to the app.</p>
        <button class="close-btn" onclick="window.close()">Close Window</button>
    </div>
    <script>
        // Auto-close after 3 seconds
        setTimeout(() => {
            window.close();
        }, 3000);
    </script>
</body>
</html>
''';
  }

  String _buildErrorHtml(String message) {
    return '''
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Connection Failed</title>
    <style>
        body {
            font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, 'Helvetica Neue', Arial, sans-serif;
            display: flex;
            justify-content: center;
            align-items: center;
            min-height: 100vh;
            margin: 0;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
        }
        .container {
            background: white;
            padding: 40px;
            border-radius: 12px;
            box-shadow: 0 10px 40px rgba(0,0,0,0.2);
            text-align: center;
            max-width: 400px;
        }
        .error {
            color: #ef4444;
            font-size: 48px;
            margin-bottom: 20px;
        }
        h2 {
            color: #1f2937;
            margin-bottom: 10px;
        }
        p {
            color: #6b7280;
            line-height: 1.5;
        }
        .close-btn {
            margin-top: 20px;
            padding: 12px 24px;
            background: #667eea;
            color: white;
            border: none;
            border-radius: 6px;
            cursor: pointer;
            font-size: 16px;
            font-weight: 600;
        }
        .close-btn:hover {
            background: #5568d3;
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="error">✗</div>
        <h2>Connection Failed</h2>
        <p>$message</p>
        <button class="close-btn" onclick="window.close()">Close Window</button>
    </div>
</body>
</html>
''';
  }
}
