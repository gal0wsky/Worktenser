import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:worktenser/features/auth/domain/entities/user.dart';
import 'package:worktenser/features/projects/data/models/project.dart';
import 'package:worktenser/features/projects/data/repository/projects_repository_impl.dart';
import 'package:worktenser/features/projects/domain/entities/project.dart';

import 'projects_repository_impl_test.mocks.dart';

@GenerateNiceMocks([MockSpec<FirebaseFirestore>()])
void main() {
  final firestoreMock = FakeFirebaseFirestore();

  const fakeUser = UserEntity(
    id: 'veryFakeID',
    name: 'fakeUser',
    email: 'fake@email.com',
    password: 'fakePassword123',
  );

  final fakeProj1 = ProjectEntity(
    id: 'jashkldf',
    name: 'Worktenser',
    userId: fakeUser.id,
    time: 37,
    description: 'Worktenser the app',
  );

  final fakeProj2 = ProjectEntity(
    id: 'kaghjsdf',
    name: 'Test project',
    userId: fakeUser.id,
    time: 0,
    description: 'My test project',
  );

  test('Load projects', () async {
    await firestoreMock
        .collection('projects')
        .add(ProjectModel.fromEntity(fakeProj1).toJson());

    await firestoreMock
        .collection('projects')
        .add(ProjectModel.fromEntity(fakeProj2).toJson());

    final repo = ProjectsRepositoryImpl(firestore: firestoreMock);

    final projects = await repo.loadProjects(fakeUser);

    expect(projects, isNotEmpty);
    expect(projects, [
      ProjectModel.fromEntity(fakeProj1),
      ProjectModel.fromEntity(fakeProj2)
    ]);
  });

  test('Load projects catch error', () async {
    final fakeFirestore = FakeFirebaseFirestore();

    final repo = ProjectsRepositoryImpl(firestore: fakeFirestore);

    final projects = await repo.loadProjects(fakeUser);

    expect(projects, isEmpty);
  });

  test('Add project valid', () async {
    final fakeFirestore = FakeFirebaseFirestore();

    final repo = ProjectsRepositoryImpl(firestore: fakeFirestore);

    await repo.addProject(fakeProj1);

    final projects = await repo.loadProjects(fakeUser);

    expect(projects, isNotEmpty);
    expect(projects.length, 1);
    expect(projects[0].name, fakeProj1.name);
  });

  test('Add project invalid', () async {
    final fakeFirestore = MockFirebaseFirestore();

    when(fakeFirestore.collection('projects'))
        .thenThrow(FirebaseException(plugin: 'firestore'));

    final repo = ProjectsRepositoryImpl(firestore: fakeFirestore);

    final result = await repo.addProject(fakeProj1);

    expect(result, false);
  });

  test('Delete project valid', () async {
    await firestoreMock
        .collection('projects')
        .add(ProjectModel.fromEntity(fakeProj1).toJson());
    await firestoreMock
        .collection('projects')
        .add(ProjectModel.fromEntity(fakeProj2).toJson());

    final repo = ProjectsRepositoryImpl(firestore: firestoreMock);

    List<ProjectEntity> projects = await repo.loadProjects(fakeUser);

    final result = await repo.deleteProject(projects[0]);

    projects = await repo.loadProjects(fakeUser);

    expect(result, true);
  });
}
