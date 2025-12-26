/// Represents the hierarchical type of a node in the mind map.
///
/// Follows Buzan mind mapping methodology with clear hierarchical structure:
/// - CENTRAL: The main topic at the center of the mind map (only one per map)
/// - BRANCH: Main ideas radiating directly from the central node
/// - SUB_BRANCH: Sub-ideas extending from branch nodes (can nest further)
enum NodeType {
  /// The central node - the main topic of the mind map.
  /// Only one central node exists per mind map.
  central,

  /// A main branch node - connects directly to the central node.
  /// Represents primary themes or major categories.
  branch,

  /// A sub-branch node - extends from a parent branch or sub-branch.
  /// Represents supporting ideas, details, or nested concepts.
  subBranch,
}
