import '../errors/mock_api_exception.dart';

enum AutomationNodeType {
  trigger,
  scene,
  observe,
  condition,
  action,
  wait,
  repeat,
}

extension AutomationNodeTypeJson on AutomationNodeType {
  String toJson() => name;

  static AutomationNodeType fromJson(String value) {
    return AutomationNodeType.values.firstWhere(
      (type) => type.name == value,
      orElse: () => throw FormatException('Unknown node type: $value'),
    );
  }
}

/// Discriminator for node configuration. Per-type fields remain intentionally
/// open until the first product flows and integrations are defined.
sealed class NodeConfiguration {
  NodeConfiguration(Map<String, Object?> values)
    : values = Map.unmodifiable(values);

  final Map<String, Object?> values;
  AutomationNodeType get type;

  Map<String, Object?> toJson() => Map.unmodifiable(values);

  static NodeConfiguration forType(
    AutomationNodeType type, [
    Map<String, Object?> values = const {},
  ]) {
    return switch (type) {
      AutomationNodeType.trigger => TriggerConfiguration(values),
      AutomationNodeType.scene => SceneConfiguration(values),
      AutomationNodeType.observe => ObserveConfiguration(values),
      AutomationNodeType.condition => ConditionConfiguration(values),
      AutomationNodeType.action => ActionConfiguration(values),
      AutomationNodeType.wait => WaitConfiguration(values),
      AutomationNodeType.repeat => RepeatConfiguration(values),
    };
  }

  static NodeConfiguration fromJson(
    AutomationNodeType type,
    Map<String, Object?> json,
  ) => forType(type, json);
}

final class TriggerConfiguration extends NodeConfiguration {
  TriggerConfiguration([super.values = const {}]);

  @override
  AutomationNodeType get type => AutomationNodeType.trigger;
}

final class SceneConfiguration extends NodeConfiguration {
  SceneConfiguration([super.values = const {}]);

  @override
  AutomationNodeType get type => AutomationNodeType.scene;
}

final class ObserveConfiguration extends NodeConfiguration {
  ObserveConfiguration([super.values = const {}]);

  @override
  AutomationNodeType get type => AutomationNodeType.observe;
}

final class ConditionConfiguration extends NodeConfiguration {
  ConditionConfiguration([super.values = const {}]);

  @override
  AutomationNodeType get type => AutomationNodeType.condition;
}

final class ActionConfiguration extends NodeConfiguration {
  ActionConfiguration([super.values = const {}]);

  @override
  AutomationNodeType get type => AutomationNodeType.action;
}

final class WaitConfiguration extends NodeConfiguration {
  WaitConfiguration([super.values = const {}]);

  @override
  AutomationNodeType get type => AutomationNodeType.wait;
}

final class RepeatConfiguration extends NodeConfiguration {
  RepeatConfiguration([super.values = const {}]);

  @override
  AutomationNodeType get type => AutomationNodeType.repeat;
}

class CanvasPosition {
  const CanvasPosition({required this.x, required this.y});

  final double x;
  final double y;

  Map<String, Object?> toJson() => {'x': x, 'y': y};

  factory CanvasPosition.fromJson(Map<String, Object?> json) => CanvasPosition(
    x: (json['x'] as num).toDouble(),
    y: (json['y'] as num).toDouble(),
  );
}

class AutomationNode {
  AutomationNode({
    required this.id,
    required this.type,
    required this.title,
    required this.position,
    required this.config,
  }) : assert(type == config.type);

  final String id;
  final AutomationNodeType type;
  final String title;
  final CanvasPosition position;
  final NodeConfiguration config;

  Map<String, Object?> toJson() => {
    'id': id,
    'type': type.toJson(),
    'title': title,
    'position': position.toJson(),
    'config': config.toJson(),
  };

  factory AutomationNode.fromJson(Map<String, Object?> json) {
    final type = AutomationNodeTypeJson.fromJson(json['type']! as String);
    final config = NodeConfiguration.fromJson(
      type,
      Map<String, Object?>.from(json['config']! as Map),
    );
    return AutomationNode(
      id: json['id']! as String,
      type: type,
      title: json['title']! as String,
      position: CanvasPosition.fromJson(
        Map<String, Object?>.from(json['position']! as Map),
      ),
      config: config,
    );
  }
}

class AutomationEdge {
  const AutomationEdge({
    required this.id,
    required this.source,
    required this.target,
    this.sourcePort,
    this.targetPort,
  });

  final String id;
  final String source;
  final String target;
  final String? sourcePort;
  final String? targetPort;

  Map<String, Object?> toJson() => {
    'id': id,
    'source': source,
    'target': target,
    if (sourcePort != null) 'sourcePort': sourcePort,
    if (targetPort != null) 'targetPort': targetPort,
  };

  factory AutomationEdge.fromJson(Map<String, Object?> json) => AutomationEdge(
    id: json['id']! as String,
    source: json['source']! as String,
    target: json['target']! as String,
    sourcePort: json['sourcePort'] as String?,
    targetPort: json['targetPort'] as String?,
  );
}

class AutomationGraph {
  AutomationGraph({
    required List<AutomationNode> nodes,
    required List<AutomationEdge> edges,
    Map<String, Object?> extensions = const {},
  }) : nodes = List.unmodifiable(nodes),
       edges = List.unmodifiable(edges),
       extensions = Map.unmodifiable(extensions);

  final List<AutomationNode> nodes;
  final List<AutomationEdge> edges;
  final Map<String, Object?> extensions;

  Map<String, Object?> toJson() => {
    'nodes': nodes.map((node) => node.toJson()).toList(growable: false),
    'edges': edges.map((edge) => edge.toJson()).toList(growable: false),
    if (extensions.isNotEmpty) 'extensions': extensions,
  };

  factory AutomationGraph.fromJson(
    Map<String, Object?> json,
  ) => AutomationGraph(
    nodes: (json['nodes']! as List)
        .map(
          (node) =>
              AutomationNode.fromJson(Map<String, Object?>.from(node as Map)),
        )
        .toList(growable: false),
    edges: (json['edges']! as List)
        .map(
          (edge) =>
              AutomationEdge.fromJson(Map<String, Object?>.from(edge as Map)),
        )
        .toList(growable: false),
    extensions: json['extensions'] == null
        ? const {}
        : Map<String, Object?>.from(json['extensions']! as Map),
  );

  Map<String, List<String>> validate() {
    final errors = <String, List<String>>{};
    final nodeIds = <String>{};
    final edgeIds = <String>{};

    for (var index = 0; index < nodes.length; index++) {
      final node = nodes[index];
      final field = 'graph.nodes[$index]';
      if (node.id.trim().isEmpty) {
        _addError(errors, '$field.id', 'Node ID is required.');
      } else if (!nodeIds.add(node.id)) {
        _addError(errors, '$field.id', 'Node IDs must be unique.');
      }
      if (node.title.trim().isEmpty) {
        _addError(errors, '$field.title', 'Node title is required.');
      }
      if (!node.position.x.isFinite || !node.position.y.isFinite) {
        _addError(errors, '$field.position', 'Position must be finite.');
      }
      if (node.config.type != node.type) {
        _addError(errors, '$field.config', 'Config type must match node type.');
      }
    }

    for (var index = 0; index < edges.length; index++) {
      final edge = edges[index];
      final field = 'graph.edges[$index]';
      if (edge.id.trim().isEmpty) {
        _addError(errors, '$field.id', 'Edge ID is required.');
      } else if (!edgeIds.add(edge.id)) {
        _addError(errors, '$field.id', 'Edge IDs must be unique.');
      }
      if (!nodeIds.contains(edge.source)) {
        _addError(errors, '$field.source', 'Source node does not exist.');
      }
      if (!nodeIds.contains(edge.target)) {
        _addError(errors, '$field.target', 'Target node does not exist.');
      }
    }
    return errors;
  }

  void validateOrThrow() {
    final errors = validate();
    if (errors.isNotEmpty) {
      throw MockApiException(
        statusCode: 400,
        code: 'VALIDATION_ERROR',
        message: 'The automation graph is invalid.',
        fieldErrors: errors,
      );
    }
  }

  static void _addError(
    Map<String, List<String>> errors,
    String field,
    String message,
  ) {
    errors.putIfAbsent(field, () => []).add(message);
  }
}
