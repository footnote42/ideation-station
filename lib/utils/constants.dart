import 'package:flutter/material.dart';

/// Application-wide constants for Ideation Station mind mapping app.
///
/// Includes design tokens, performance budgets, and behavioral constraints
/// per project constitution and Buzan methodology requirements.
class AppConstants {
  AppConstants._(); // Private constructor to prevent instantiation

  // ============================================================================
  // COLOR PALETTE (Buzan Methodology - Color Differentiation)
  // ============================================================================

  /// Default color palette for mind map branches.
  ///
  /// 8-12 vibrant colors for visual differentiation per Buzan methodology.
  /// Colors are selected for:
  /// - High contrast and visibility
  /// - Distinct hue differentiation
  /// - Emotional/cognitive associations
  static const List<Color> colorPalette = [
    Color(0xFFE74C3C), // Red - Energy, urgency, passion
    Color(0xFF3498DB), // Blue - Calm, trust, logic
    Color(0xFF2ECC71), // Green - Growth, nature, balance
    Color(0xFFF39C12), // Orange - Creativity, enthusiasm
    Color(0xFF9B59B6), // Purple - Imagination, luxury
    Color(0xFF1ABC9C), // Teal - Clarity, innovation
    Color(0xFFE67E22), // Dark orange - Warmth, confidence
    Color(0xFFF1C40F), // Yellow - Optimism, attention
    Color(0xFF34495E), // Dark blue-gray - Stability, depth
    Color(0xFFE91E63), // Pink - Playfulness, compassion
    Color(0xFF16A085), // Dark teal - Sophistication
    Color(0xFF95A5A6), // Gray - Neutral, balance
  ];

  /// Default color for nodes when no color is assigned
  static const Color defaultNodeColor = Color(0xFF34495E);

  /// Default background color for the canvas
  static const Color canvasBackground = Color(0xFFF5F5F5);

  // ============================================================================
  // PERFORMANCE BUDGETS (Constitution Requirements)
  // ============================================================================

  /// Maximum touch response time in milliseconds (SC-002).
  ///
  /// Touch interactions MUST complete visual feedback within this budget
  /// to feel instant to users. 100ms = imperceptible delay.
  static const int touchResponseBudgetMs = 100;

  /// Target frame rate for smooth interactions (FR-029).
  ///
  /// Canvas pan/zoom/drag operations MUST maintain 60 fps.
  static const int targetFps = 60;

  /// Frame budget in milliseconds derived from target FPS.
  ///
  /// At 60 fps, each frame has 16.67ms to render.
  static const int frameBudgetMs = 16;

  /// Maximum auto-save duration in milliseconds (SC-013).
  ///
  /// Saving must not disrupt user interaction. Background save with
  /// 500ms debounce ensures data safety without perceived lag.
  static const int autoSaveBudgetMs = 500;

  /// Maximum cold start time in milliseconds.
  ///
  /// App must be interactive within 2 seconds from launch tap.
  static const int coldStartBudgetMs = 2000;

  /// Minimum nodes for performance testing.
  ///
  /// App must handle 100+ nodes without degradation per spec.
  static const int performanceTestNodeCount = 100;

  // ============================================================================
  // CANVAS CONSTRAINTS
  // ============================================================================

  /// Minimum zoom scale factor.
  ///
  /// Allows viewing entire mind map at 50% scale.
  static const double minZoomScale = 0.5;

  /// Maximum zoom scale factor.
  ///
  /// Allows close inspection at 200% scale.
  static const double maxZoomScale = 2.0;

  /// Default zoom scale (100% - no zoom).
  static const double defaultZoomScale = 1.0;

  /// Canvas boundary margin for infinite scroll feel.
  ///
  /// Large margin prevents "edge of world" constraints.
  static const double canvasBoundaryMargin = 10000.0;

  // ============================================================================
  // NODE CONSTRAINTS
  // ============================================================================

  /// Recommended maximum text length for keywords.
  ///
  /// Buzan methodology encourages single keywords (1-4 words).
  /// Soft limit with visual feedback, not enforced.
  static const int recommendedMaxKeywordLength = 20;

  /// Minimum node tap target size for accessibility.
  ///
  /// Material Design minimum: 48x48 logical pixels.
  static const double minTapTargetSize = 48.0;

  // ============================================================================
  // VISUAL HIERARCHY (Buzan Methodology - FR-007a)
  // ============================================================================

  /// Branch line thickness for central node connections.
  ///
  /// Main branches MUST be visibly thicker than sub-branches.
  static const double mainBranchThickness = 8.0;

  /// Branch line thickness for first-level sub-branches.
  static const double subBranchThickness = 5.0;

  /// Branch line thickness for deeper nested sub-branches.
  static const double deepSubBranchThickness = 3.0;

  // ============================================================================
  // SPACING & LAYOUT
  // ============================================================================

  /// Radial distance from central node to first ring of branches.
  static const double centralNodeRadius = 150.0;

  /// Angular step for distributing nodes radially (in radians).
  ///
  /// Used for auto-positioning new nodes around parent.
  static const double radialAngleStep = 0.5236; // ~30 degrees

  /// Minimum spacing between nodes to prevent overlap.
  static const double minNodeSpacing = 80.0;
}
