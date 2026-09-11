import 'package:test/test.dart';
import 'package:fev_api_client/fev_api_client.dart';

/// tests for TrainingApi
void main() {
  final instance = FevApiClient().getTrainingApi();

  group(TrainingApi, () {
    // Complete Training Module
    //
    // Scores the attempt and records pass or fail against the module's threshold.
    //
    //Future<TrainingProgressResponse> completeTrainingModule(String moduleId) async
    test('test completeTrainingModule', () async {
      // TODO
    });

    // Complete Training Step
    //
    // Idempotent -- replaying a recorded step does not double-count its score.
    //
    //Future<TrainingProgressResponse> completeTrainingStep(String moduleId, String stepId, CompleteTrainingStepRequest completeTrainingStepRequest) async
    test('test completeTrainingStep', () async {
      // TODO
    });

    // Get Training Module
    //
    //Future<TrainingModuleResponse> getTrainingModule(String moduleId) async
    test('test getTrainingModule', () async {
      // TODO
    });

    // List Training Modules
    //
    //Future<TrainingModuleListPage> listTrainingModules({ String facilityId, String kind }) async
    test('test listTrainingModules', () async {
      // TODO
    });

    // List Training Progress
    //
    // The caller's own training record, newest attempt first.
    //
    //Future<TrainingProgressListPage> listTrainingProgress({ String moduleId }) async
    test('test listTrainingProgress', () async {
      // TODO
    });

    // Start Training Module
    //
    // Resumes an attempt already in progress rather than discarding it, so a dropped headset connection does not lose the run.
    //
    //Future<TrainingProgressResponse> startTrainingModule(String moduleId) async
    test('test startTrainingModule', () async {
      // TODO
    });
  });
}
