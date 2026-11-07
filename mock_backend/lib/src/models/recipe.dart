import 'automation_graph.dart';

enum RecipeStatus { active, archived }

class RecipeDraft {
  const RecipeDraft({
    required this.name,
    required this.targetId,
    required this.graph,
    this.description = '',
  });

  final String name;
  final String description;
  final String targetId;
  final AutomationGraph graph;
}

class Recipe {
  const Recipe({
    required this.id,
    required this.name,
    required this.description,
    required this.status,
    required this.targetId,
    required this.graph,
    required this.createdAt,
    required this.updatedAt,
    this.archivedAt,
  });

  final String id;
  final String name;
  final String description;
  final RecipeStatus status;
  final String targetId;
  final AutomationGraph graph;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? archivedAt;

  Recipe copyWith({
    String? name,
    String? description,
    RecipeStatus? status,
    String? targetId,
    AutomationGraph? graph,
    DateTime? updatedAt,
    DateTime? archivedAt,
    bool clearArchivedAt = false,
  }) => Recipe(
    id: id,
    name: name ?? this.name,
    description: description ?? this.description,
    status: status ?? this.status,
    targetId: targetId ?? this.targetId,
    graph: graph ?? this.graph,
    createdAt: createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    archivedAt: clearArchivedAt ? null : archivedAt ?? this.archivedAt,
  );

  Map<String, Object?> toJson() => {
    'id': id,
    'name': name,
    'description': description,
    'status': status.name,
    'targetId': targetId,
    'graph': graph.toJson(),
    'createdAt': createdAt.toUtc().toIso8601String(),
    'updatedAt': updatedAt.toUtc().toIso8601String(),
    if (archivedAt != null) 'archivedAt': archivedAt!.toUtc().toIso8601String(),
  };

  factory Recipe.fromJson(Map<String, Object?> json) => Recipe(
    id: json['id']! as String,
    name: json['name']! as String,
    description: json['description']! as String,
    status: RecipeStatus.values.byName(json['status']! as String),
    targetId: json['targetId']! as String,
    graph: AutomationGraph.fromJson(
      Map<String, Object?>.from(json['graph']! as Map),
    ),
    createdAt: DateTime.parse(json['createdAt']! as String).toUtc(),
    updatedAt: DateTime.parse(json['updatedAt']! as String).toUtc(),
    archivedAt: json['archivedAt'] == null
        ? null
        : DateTime.parse(json['archivedAt']! as String).toUtc(),
  );
}

class RecipePage {
  RecipePage({
    required List<Recipe> data,
    required this.offset,
    required this.limit,
    required this.total,
  }) : data = List.unmodifiable(data);

  final List<Recipe> data;
  final int offset;
  final int limit;
  final int total;

  Map<String, Object?> toJson() => {
    'data': data.map((recipe) => recipe.toJson()).toList(growable: false),
    'pagination': {'offset': offset, 'limit': limit, 'total': total},
  };
}

class RecipeFilter {
  const RecipeFilter({
    this.search,
    this.targetId,
    this.includeArchived = false,
  });

  final String? search;
  final String? targetId;
  final bool includeArchived;
}
