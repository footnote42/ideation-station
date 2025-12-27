import 'package:flutter/material.dart';

/// Error boundary widget that catches and displays errors gracefully (T105).
///
/// Wraps child widgets and provides a fallback UI when errors occur,
/// preventing the Flutter red screen of death in production.
class ErrorBoundary extends StatefulWidget {
  final Widget child;
  final Widget Function(FlutterErrorDetails)? errorBuilder;

  const ErrorBoundary({
    super.key,
    required this.child,
    this.errorBuilder,
  });

  @override
  State<ErrorBoundary> createState() => _ErrorBoundaryState();
}

class _ErrorBoundaryState extends State<ErrorBoundary> {
  FlutterErrorDetails? _errorDetails;

  @override
  void initState() {
    super.initState();
    // Capture errors during build
    FlutterError.onError = (details) {
      if (mounted) {
        setState(() {
          _errorDetails = details;
        });
      }
      // Still log to console for debugging
      FlutterError.presentError(details);
    };
  }

  @override
  Widget build(BuildContext context) {
    if (_errorDetails != null) {
      // Show custom error UI
      return widget.errorBuilder?.call(_errorDetails!) ??
          _buildDefaultErrorWidget(_errorDetails!);
    }

    return widget.child;
  }

  /// Default error widget shown when no custom builder is provided.
  Widget _buildDefaultErrorWidget(FlutterErrorDetails details) {
    return Material(
      child: Container(
        color: Colors.white,
        padding: const EdgeInsets.all(24),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.error_outline,
                color: Colors.red,
                size: 64,
              ),
              const SizedBox(height: 24),
              const Text(
                'Something went wrong',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'An unexpected error occurred. Please try restarting the app.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: () {
                  setState(() {
                    _errorDetails = null;
                  });
                },
                icon: const Icon(Icons.refresh),
                label: const Text('Try Again'),
              ),
              if (const bool.fromEnvironment('dart.vm.product') == false)
                Padding(
                  padding: const EdgeInsets.only(top: 24),
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.red[50],
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.red[200]!),
                    ),
                    child: SingleChildScrollView(
                      child: Text(
                        'Debug Info:\n${details.exception}\n\n${details.stack}',
                        style: TextStyle(
                          fontSize: 12,
                          fontFamily: 'monospace',
                          color: Colors.red[900],
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Global error handler configuration (T105).
///
/// Call this in main() to set up global error handling.
void configureErrorHandling() {
  // Override default error widget with custom one
  ErrorWidget.builder = (FlutterErrorDetails details) {
    return Material(
      child: Container(
        color: Colors.white,
        padding: const EdgeInsets.all(24),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.warning_amber_rounded,
                color: Colors.orange,
                size: 48,
              ),
              const SizedBox(height: 16),
              const Text(
                'Widget Error',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                const bool.fromEnvironment('dart.vm.product')
                    ? 'An error occurred while displaying this content.'
                    : details.exception.toString(),
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 14),
              ),
            ],
          ),
        ),
      ),
    );
  };
}
