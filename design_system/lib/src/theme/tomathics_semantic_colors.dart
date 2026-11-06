import 'package:flutter/material.dart';

/// Colors with meaning across the monitor, recipes, and visual editor.
@immutable
class TomathicsSemanticColors extends ThemeExtension<TomathicsSemanticColors> {
  const TomathicsSemanticColors({
    required this.success,
    required this.onSuccess,
    required this.successContainer,
    required this.warning,
    required this.onWarning,
    required this.warningContainer,
    required this.danger,
    required this.onDanger,
    required this.dangerContainer,
    required this.info,
    required this.onInfo,
    required this.infoContainer,
    required this.neutral,
    required this.onNeutral,
    required this.neutralContainer,
    required this.nodeScene,
    required this.nodeTrigger,
    required this.nodeObserve,
    required this.nodeCondition,
    required this.nodeAction,
    required this.nodeWait,
    required this.nodeRepeat,
    required this.nodeFlow,
    required this.canvasGrid,
  });

  final Color success;
  final Color onSuccess;
  final Color successContainer;
  final Color warning;
  final Color onWarning;
  final Color warningContainer;
  final Color danger;
  final Color onDanger;
  final Color dangerContainer;
  final Color info;
  final Color onInfo;
  final Color infoContainer;
  final Color neutral;
  final Color onNeutral;
  final Color neutralContainer;
  final Color nodeScene;
  final Color nodeTrigger;
  final Color nodeObserve;
  final Color nodeCondition;
  final Color nodeAction;
  final Color nodeWait;
  final Color nodeRepeat;
  final Color nodeFlow;
  final Color canvasGrid;

  static TomathicsSemanticColors light() => const TomathicsSemanticColors(
    success: Color(0xFF168653),
    onSuccess: Color(0xFFFFFFFF),
    successContainer: Color(0xFFE2F5EA),
    warning: Color(0xFF9A5A00),
    onWarning: Color(0xFFFFFFFF),
    warningContainer: Color(0xFFFFF0D8),
    danger: Color(0xFFC33F56),
    onDanger: Color(0xFFFFFFFF),
    dangerContainer: Color(0xFFFFE7EC),
    info: Color(0xFF087F8C),
    onInfo: Color(0xFFFFFFFF),
    infoContainer: Color(0xFFDDF5F6),
    neutral: Color(0xFF64718A),
    onNeutral: Color(0xFFFFFFFF),
    neutralContainer: Color(0xFFE8ECF4),
    nodeScene: Color(0xFF6D5CE8),
    nodeTrigger: Color(0xFFAF4F9B),
    nodeObserve: Color(0xFF2868C7),
    nodeCondition: Color(0xFFB27411),
    nodeAction: Color(0xFF087F8C),
    nodeWait: Color(0xFF2868C7),
    nodeRepeat: Color(0xFFAF4F9B),
    nodeFlow: Color(0xFFAF4F9B),
    canvasGrid: Color(0x1A59657C),
  );

  static TomathicsSemanticColors dark() => const TomathicsSemanticColors(
    success: Color(0xFF62D69B),
    onSuccess: Color(0xFF082B1A),
    successContainer: Color(0xFF173C2B),
    warning: Color(0xFFFFC266),
    onWarning: Color(0xFF382100),
    warningContainer: Color(0xFF473316),
    danger: Color(0xFFFF8294),
    onDanger: Color(0xFF3D0C17),
    dangerContainer: Color(0xFF48202B),
    info: Color(0xFF50D2D9),
    onInfo: Color(0xFF062C31),
    infoContainer: Color(0xFF14383E),
    neutral: Color(0xFFA7B3C9),
    onNeutral: Color(0xFF172033),
    neutralContainer: Color(0xFF28354B),
    nodeScene: Color(0xFFA99BFF),
    nodeTrigger: Color(0xFFE18AD0),
    nodeObserve: Color(0xFF78AEFF),
    nodeCondition: Color(0xFFFFC266),
    nodeAction: Color(0xFF50D2D9),
    nodeWait: Color(0xFF78AEFF),
    nodeRepeat: Color(0xFFE18AD0),
    nodeFlow: Color(0xFFE18AD0),
    canvasGrid: Color(0x24B1BCD2),
  );

  @override
  TomathicsSemanticColors copyWith({
    Color? success,
    Color? onSuccess,
    Color? successContainer,
    Color? warning,
    Color? onWarning,
    Color? warningContainer,
    Color? danger,
    Color? onDanger,
    Color? dangerContainer,
    Color? info,
    Color? onInfo,
    Color? infoContainer,
    Color? neutral,
    Color? onNeutral,
    Color? neutralContainer,
    Color? nodeScene,
    Color? nodeTrigger,
    Color? nodeObserve,
    Color? nodeCondition,
    Color? nodeAction,
    Color? nodeWait,
    Color? nodeRepeat,
    Color? nodeFlow,
    Color? canvasGrid,
  }) {
    return TomathicsSemanticColors(
      success: success ?? this.success,
      onSuccess: onSuccess ?? this.onSuccess,
      successContainer: successContainer ?? this.successContainer,
      warning: warning ?? this.warning,
      onWarning: onWarning ?? this.onWarning,
      warningContainer: warningContainer ?? this.warningContainer,
      danger: danger ?? this.danger,
      onDanger: onDanger ?? this.onDanger,
      dangerContainer: dangerContainer ?? this.dangerContainer,
      info: info ?? this.info,
      onInfo: onInfo ?? this.onInfo,
      infoContainer: infoContainer ?? this.infoContainer,
      neutral: neutral ?? this.neutral,
      onNeutral: onNeutral ?? this.onNeutral,
      neutralContainer: neutralContainer ?? this.neutralContainer,
      nodeScene: nodeScene ?? this.nodeScene,
      nodeTrigger: nodeTrigger ?? this.nodeTrigger,
      nodeObserve: nodeObserve ?? this.nodeObserve,
      nodeCondition: nodeCondition ?? this.nodeCondition,
      nodeAction: nodeAction ?? this.nodeAction,
      nodeWait: nodeWait ?? this.nodeWait,
      nodeRepeat: nodeRepeat ?? this.nodeRepeat,
      nodeFlow: nodeFlow ?? this.nodeFlow,
      canvasGrid: canvasGrid ?? this.canvasGrid,
    );
  }

  @override
  TomathicsSemanticColors lerp(
    covariant ThemeExtension<TomathicsSemanticColors>? other,
    double t,
  ) {
    if (other is! TomathicsSemanticColors) return this;
    return TomathicsSemanticColors(
      success: Color.lerp(success, other.success, t)!,
      onSuccess: Color.lerp(onSuccess, other.onSuccess, t)!,
      successContainer: Color.lerp(successContainer, other.successContainer, t)!,
      warning: Color.lerp(warning, other.warning, t)!,
      onWarning: Color.lerp(onWarning, other.onWarning, t)!,
      warningContainer: Color.lerp(warningContainer, other.warningContainer, t)!,
      danger: Color.lerp(danger, other.danger, t)!,
      onDanger: Color.lerp(onDanger, other.onDanger, t)!,
      dangerContainer: Color.lerp(dangerContainer, other.dangerContainer, t)!,
      info: Color.lerp(info, other.info, t)!,
      onInfo: Color.lerp(onInfo, other.onInfo, t)!,
      infoContainer: Color.lerp(infoContainer, other.infoContainer, t)!,
      neutral: Color.lerp(neutral, other.neutral, t)!,
      onNeutral: Color.lerp(onNeutral, other.onNeutral, t)!,
      neutralContainer: Color.lerp(neutralContainer, other.neutralContainer, t)!,
      nodeScene: Color.lerp(nodeScene, other.nodeScene, t)!,
      nodeTrigger: Color.lerp(nodeTrigger, other.nodeTrigger, t)!,
      nodeObserve: Color.lerp(nodeObserve, other.nodeObserve, t)!,
      nodeCondition: Color.lerp(nodeCondition, other.nodeCondition, t)!,
      nodeAction: Color.lerp(nodeAction, other.nodeAction, t)!,
      nodeWait: Color.lerp(nodeWait, other.nodeWait, t)!,
      nodeRepeat: Color.lerp(nodeRepeat, other.nodeRepeat, t)!,
      nodeFlow: Color.lerp(nodeFlow, other.nodeFlow, t)!,
      canvasGrid: Color.lerp(canvasGrid, other.canvasGrid, t)!,
    );
  }
}
