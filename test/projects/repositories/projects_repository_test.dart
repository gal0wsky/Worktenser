import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mock_exceptions/mock_exceptions.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:worktenser/domain/authentication/models/user_model.dart';
import 'package:worktenser/domain/projects/models/project_model.dart';
import 'package:worktenser/domain/projects/repositories/projects_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// import 'projects_repository_test.mocks.dart';

@GenerateNiceMocks([MockSpec<FirebaseFirestore>()])
void main() {
  final firestoreMock = FakeFirebaseFirestore();
  const fakeUser = User(id: 'fakeUser');

  final fakeProj1 = Project(
    id: 'jashkldf',
    name: 'Worktenser',
    userId: fakeUser.id,
    time: 37,
    description: 'Worktenser the app',
  );

  final fakeProj2 = Project(
    id: 'kaghjsdf',
    name: 'Test project',
    userId: fakeUser.id,
    time: 0,
    description: 'My test project',
  );

  test('Load projects valid', () async {
    await firestoreMock.collection('projects').add(fakeProj1.toJson());

    await firestoreMock.collection('projects').add(fakeProj2.toJson());

    final repo = ProjectsRepository(firestore: firestoreMock);

    final projects = await repo.loadProjects(fakeUser);

    expect(projects, isNotEmpty);
    expect(projects, [fakeProj1, fakeProj2]);
  });

  test('Load projects catch error', () async {
    final repo = ProjectsRepository(firestore: firestoreMock);

    final projects = await repo.loadProjects(fakeUser);

    expect(projects, isEmpty);
  });

  test('Add project valid', () async {
    final fakeFirestore = FakeFirebaseFirestore();

    final repo = ProjectsRepository(firestore: fakeFirestore);

    await repo.addProject(fakeProj1);

    final projects = await repo.loadProjects(fakeUser);

    expect(projects, isNotEmpty);
    expect(projects.length, 1);
    expect(projects[0].name, fakeProj1.name);
  });

  test('Add project invalid', () async {
    final fakeFirestore = FakeFirebaseFirestore();

    whenCalling(Invocation.method(#set, null))
        .on(fakeFirestore.collection('projects').doc())
        .thenThrow(Exception());

    final repo = ProjectsRepository(firestore: fakeFirestore);

    final result = await repo.addProject(fakeProj1);

    expect(result, false);
  });

  test('Delete project valid', () async {
    await firestoreMock.collection('projects').add(fakeProj1.toJson());
    await firestoreMock.collection('projects').add(fakeProj2.toJson());

    final repo = ProjectsRepository(firestore: firestoreMock);

    List<Project> projects = await repo.loadProjects(fakeUser);

    final result = await repo.deleteProject(projects[0]);

    projects = await repo.loadProjects(fakeUser);

    expect(result, true);
  });
}
