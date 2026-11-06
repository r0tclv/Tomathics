import 'package:flutter/material.dart';

/// Curated Material icon aliases grouped by Tomathics product concepts.
abstract final class TomathicsIcons {
  static const navigation = TomathicsNavigationIcons();
  static const nodes = TomathicsNodeIcons();
  static const states = TomathicsStateIcons();
  static const actions = TomathicsActionIcons();
  static const targets = TomathicsTargetIcons();
  static const resources = TomathicsResourceIcons();
}

class TomathicsNavigationIcons {
  const TomathicsNavigationIcons();

  final IconData overview = Icons.dashboard_outlined;
  final IconData editor = Icons.hub_outlined;
  final IconData recipes = Icons.account_tree_outlined;
  final IconData objectives = Icons.flag_outlined;
  final IconData monitor = Icons.monitor_heart_outlined;
  final IconData routines = Icons.bolt_outlined;
  final IconData targets = Icons.desktop_windows_outlined;
  final IconData scenes = Icons.crop_free_rounded;
  final IconData settings = Icons.settings_outlined;
  final IconData help = Icons.help_outline_rounded;
  final IconData notifications = Icons.notifications_none_rounded;
  final IconData history = Icons.history_rounded;
}

class TomathicsNodeIcons {
  const TomathicsNodeIcons();

  final IconData trigger = Icons.sensors_rounded;
  final IconData scene = Icons.crop_free_rounded;
  final IconData observe = Icons.visibility_outlined;
  final IconData condition = Icons.rule_rounded;
  final IconData action = Icons.touch_app_rounded;
  final IconData wait = Icons.hourglass_bottom_rounded;
  final IconData repeat = Icons.repeat_rounded;
  final IconData flow = Icons.account_tree_rounded;
  final IconData branch = Icons.call_split_rounded;
  final IconData variable = Icons.data_object_rounded;
}

class TomathicsStateIcons {
  const TomathicsStateIcons();

  final IconData running = Icons.play_arrow_rounded;
  final IconData completed = Icons.check_circle_outline_rounded;
  final IconData waiting = Icons.schedule_rounded;
  final IconData paused = Icons.pause_circle_outline_rounded;
  final IconData attention = Icons.priority_high_rounded;
  final IconData failed = Icons.error_outline_rounded;
  final IconData blocked = Icons.block_rounded;
  final IconData disconnected = Icons.portable_wifi_off_rounded;
  final IconData stale = Icons.update_rounded;
  final IconData idle = Icons.circle_outlined;
  final IconData loading = Icons.autorenew_rounded;
}

class TomathicsActionIcons {
  const TomathicsActionIcons();

  final IconData add = Icons.add_rounded;
  final IconData edit = Icons.edit_outlined;
  final IconData duplicate = Icons.content_copy_rounded;
  final IconData delete = Icons.delete_outline_rounded;
  final IconData search = Icons.search_rounded;
  final IconData filter = Icons.filter_list_rounded;
  final IconData sort = Icons.swap_vert_rounded;
  final IconData play = Icons.play_arrow_rounded;
  final IconData pause = Icons.pause_rounded;
  final IconData stop = Icons.stop_rounded;
  final IconData refresh = Icons.refresh_rounded;
  final IconData more = Icons.more_horiz_rounded;
  final IconData close = Icons.close_rounded;
  final IconData back = Icons.arrow_back_rounded;
  final IconData forward = Icons.arrow_forward_rounded;
  final IconData expand = Icons.expand_more_rounded;
  final IconData externalLink = Icons.open_in_new_rounded;
  final IconData visibility = Icons.visibility_outlined;
  final IconData visibilityOff = Icons.visibility_off_outlined;
}

class TomathicsTargetIcons {
  const TomathicsTargetIcons();

  final IconData desktop = Icons.desktop_windows_outlined;
  final IconData browser = Icons.language_rounded;
  final IconData emulator = Icons.phone_android_rounded;
  final IconData window = Icons.web_asset_rounded;
  final IconData connected = Icons.link_rounded;
  final IconData disconnected = Icons.link_off_rounded;
  final IconData locate = Icons.center_focus_strong_rounded;
  final IconData capture = Icons.screenshot_monitor_rounded;
}

class TomathicsResourceIcons {
  const TomathicsResourceIcons();

  final IconData input = Icons.south_east_rounded;
  final IconData output = Icons.north_east_rounded;
  final IconData inventory = Icons.inventory_2_outlined;
  final IconData time = Icons.schedule_rounded;
  final IconData machine = Icons.precision_manufacturing_outlined;
  final IconData scene = Icons.photo_camera_back_outlined;
  final IconData entity = Icons.widgets_outlined;
  final IconData dependency = Icons.account_tree_outlined;
}
