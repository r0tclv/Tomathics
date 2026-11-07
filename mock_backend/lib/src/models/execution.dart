enum ExecutionStatus {
  queued,
  running,
  waiting,
  paused,
  completed,
  failed,
  cancelled,
}

enum ExecutionScenario { success, failure, waiting }

class Execution {
  const Execution({
    required this.id,
    required this.recipeId,
    required this.status,
    required this.progress,
    required this.createdAt,
    required this.updatedAt,
    this.failureMessage,
  });

  final String id;
  final String recipeId;
  final ExecutionStatus status;
  final double progress;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String? failureMessage;

  Map<String, Object?> toJson() => {
    'id': id,
    'recipeId': recipeId,
    'status': status.name,
    'progress': progress,
    'createdAt': createdAt.toUtc().toIso8601String(),
    'updatedAt': updatedAt.toUtc().toIso8601String(),
    if (failureMessage != null) 'failureMessage': failureMessage,
  };
}

class ExecutionEvent {
  const ExecutionEvent({
    required this.id,
    required this.executionId,
    required this.type,
    required this.message,
    required this.createdAt,
    this.status,
  });

  final String id;
  final String executionId;
  final String type;
  final String message;
  final DateTime createdAt;
  final ExecutionStatus? status;

  Map<String, Object?> toJson() => {
    'id': id,
    'executionId': executionId,
    'type': type,
    'message': message,
    'createdAt': createdAt.toUtc().toIso8601String(),
    if (status != null) 'status': status!.name,
  };
}

class ExecutionEventPage {
  ExecutionEventPage({
    required List<ExecutionEvent> data,
    required this.offset,
    required this.limit,
    required this.total,
  }) : data = List.unmodifiable(data);

  final List<ExecutionEvent> data;
  final int offset;
  final int limit;
  final int total;

  Map<String, Object?> toJson() => {
    'data': data.map((event) => event.toJson()).toList(growable: false),
    'pagination': {'offset': offset, 'limit': limit, 'total': total},
  };
}

class DemoSession {
  const DemoSession({
    required this.id,
    required this.displayName,
    required this.email,
  });

  final String id;
  final String displayName;
  final String email;

  Map<String, Object?> toJson() => {
    'id': id,
    'displayName': displayName,
    'email': email,
  };
}
