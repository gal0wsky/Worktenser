import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:worktenser/features/auth/data/models/user.dart';
import 'package:worktenser/features/auth/domain/entities/user.dart';
import 'package:worktenser/features/projects/data/models/project.dart';
import 'package:worktenser/features/projects/domain/entities/project.dart';
import 'package:worktenser/features/projects/domain/repository/projects_repository.dart';

class ProjectsRepositoryImpl implements ProjectsRepository {
  final FirebaseFirestore _db;

  ProjectsRepositoryImpl({FirebaseFirestore? firestore})
      : _db = firestore ?? FirebaseFirestore.instance;

  @override
  Future<List<ProjectModel>> loadProjects(UserEntity user) async {
    final userModel = UserModel.fromEntity(user);
    List<ProjectModel> projects = [];

    projects = await _db
        .collection('projects')
        .where('userId', isEqualTo: userModel.id)
        .get()
        .then(
      (snapshot) {
        List<ProjectModel> list = [];
        for (var docSnapshot in snapshot.docs) {
          final jsonData = docSnapshot.data();
          list.add(ProjectModel.fromJson(json: jsonData));
        }

        return list;
      },
      onError: (e) {
        projects = [];
      },
    );

    return projects;
  }

  @override
  Future<bool> addProject(ProjectEntity project) async {
    bool status = true;

    try {
      ProjectModel projectModel = ProjectModel.fromEntity(project);

      final projectDoc = _db.collection('projects').doc();

      projectModel = projectModel.copyWith(id: projectDoc.id);

      await projectDoc.set(projectModel.toJson()).onError((error, stackTrace) {
        status = false;
      });
    } catch (e) {
      status = false;
    }

    return status;
  }

  @override
  Future<bool> updateProject(ProjectEntity project) async {
    bool status = true;

    try {
      ProjectModel projectModel = ProjectModel.fromEntity(project);

      final projectDoc = _db.collection('projects').doc(project.id);

      await projectDoc
          .set(projectModel.toJson())
          .onError((error, stackTrace) => status = false);
    } catch (e) {
      status = false;
    }

    return status;
  }

  @override
  Future<bool> deleteProject(ProjectEntity project) async {
    bool status = true;

    try {
      ProjectModel projectModel = ProjectModel.fromEntity(project);

      final projectDoc = _db.collection('projects').doc(projectModel.id);

      await projectDoc.delete().onError((error, stackTrace) => status = false);
    } catch (e) {
      status = false;
    }

    return status;
  }

  @override
  int getProjectsTotalTime(List<ProjectEntity> projects) {
    if (projects.isEmpty) {
      return 0;
    }

    int totalTime = 0;

    for (var project in projects) {
      totalTime += project.time;
    }

    return totalTime;
  }
}
