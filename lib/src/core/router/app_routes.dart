enum AppRoutes {
  createHabit('create-habit', 'create'),
  editHabit('edit-habit', ':id/edit'),
  habit('habit', ':id'),
  habits('habits', '/habits'),
  // settnigs
  settings('settings', '/settings'),
  reorderHabits('reorder-habits', 'reorder-habits'),

  splash('splash', '/splash');

  final String name;
  final String path;
  const AppRoutes(this.name, this.path);
}
