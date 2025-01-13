class Scheduler {
  final String division, task;
  final DateTime commencement;
  final Duration duration;

  Scheduler(
      {required this.division,
      required this.task,
      required this.commencement,
      required this.duration});
}
