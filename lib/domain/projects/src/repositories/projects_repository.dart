import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:worktenser/domain/authentication/models/user_model.dart';
import 'package:worktenser/domain/projects/src/models/project_model.dart';
import 'package:worktenser/domain/projects/src/repositories/iprojects_repository.dart';

class ProjectsRepository implements IProjectsRepository {
  final FirebaseFirestore _db;

  ProjectsRepository({FirebaseFirestore? firestore})
      : _db = firestore ?? FirebaseFirestore.instance;

  @override
  Future<List<Project>> loadProjects(User user) async {
    List<Project> projects = [];

    projects = await _db
        .collection('projects')
        .where('userId', isEqualTo: user.id)
        .get()
        .then(
      (snapshot) {
        List<Project> list = [];
        for (var docSnapshot in snapshot.docs) {
          final jsonData = docSnapshot.data();
          list.add(Project.fromJson(jsonData));
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
  Future<bool> addProject(Project project) async {
    bool status = true;

    try {
      final projectDoc = _db.collection('projects').doc();

      project = project.copyWith(id: projectDoc.id);

      await projectDoc.set(project.toJson()).onError((error, stackTrace) {
        status = false;
      });
    } catch (e) {
      status = false;
    }

    return status;
  }

  @override
  Future<bool> updateProject(Project project) async {
    bool status = true;

    final projectDoc = _db.collection('projects').doc(project.id);

    await projectDoc
        .set(project.toJson())
        .onError((error, stackTrace) => status = false);

    return status;
  }

  @override
  Future<bool> deleteProject(Project project) async {
    bool status = true;

    final projectDoc = _db.collection('projects').doc(project.id);

    await projectDoc.delete().onError((error, stackTrace) => status = false);

    return status;
  }
}
