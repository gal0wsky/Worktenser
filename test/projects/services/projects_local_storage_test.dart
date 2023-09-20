import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:worktenser/blocs/blocs.dart';
import 'package:worktenser/domain/authentication/models/user_model.dart';
import 'package:worktenser/domain/projects/projects.dart';
import 'package:worktenser/domain/projects/src/services/projects_local_storage.dart';

import 'projects_local_storage_test.mocks.dart';

@GenerateNiceMocks([MockSpec<SharedPreferences>(), MockSpec<AuthBloc>()])
void main() {
  final prefsMock = MockSharedPreferences();
  final authBloc = MockAuthBloc();
  late ProjectsLocalStorage storage;

  const fakeUser = User(id: 'fakeId');

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

  setUp(() =>
      storage = ProjectsLocalStorage(prefs: prefsMock, authBloc: authBloc));

  test('Load projects successful', () {
    final fakeProjects = [fakeProj1.toJson(), fakeProj2.toJson()];

    when(prefsMock.getString('worktenser.projects'))
        .thenAnswer((realInvocation) => json.encode(fakeProjects));

    final result = storage.load();

    expect(result, isNotEmpty);
    expect(result.length, 2);
    expect(result, [fakeProj1, fakeProj2]);
  });

  test('Load projects invalid', () {
    when(prefsMock.getString('worktenser.projects'))
        .thenAnswer((realInvocation) => null);

    final result = storage.load();

    expect(result, isEmpty);
    expect(result.length, 0);
  });

  test('Save projects successful', () async {
    final fakeProjects = [fakeProj1, fakeProj2];

    when(authBloc.state).thenAnswer(
        (realInvocation) => const AuthState.authenticated(fakeUser));

    when(prefsMock.setString(fakeUser.id, json.encode(fakeProjects)))
        .thenAnswer((realInvocation) async => true);

    final result = await storage.save(fakeProjects);

    expect(result, true);
  });

  test('Save projects invalid', () async {
    final fakeProjects = [fakeProj1, fakeProj2];

    when(authBloc.state).thenAnswer(
        (realInvocation) => const AuthState.authenticated(fakeUser));

    when(prefsMock.setString(fakeUser.id, json.encode(fakeProjects)))
        .thenAnswer((realInvocation) async => false);

    final result = await storage.save(fakeProjects);

    expect(result, false);
  });

  test('Update project successful', () async {
    final fakeProj3 = fakeProj2.copyWith(name: 'fakeProject3');

    final storedProjects = [fakeProj1, fakeProj2];
    final fakeProjects = [fakeProj1, fakeProj3];

    when(authBloc.state).thenAnswer(
        (realInvocation) => const AuthState.authenticated(fakeUser));

    when(prefsMock.getString('worktenser.projects'))
        .thenAnswer((realInvocation) => json.encode(storedProjects));

    when(prefsMock.setString(fakeUser.id, json.encode(fakeProjects)))
        .thenAnswer((realInvocation) async => true);

    final result = await storage.update(fakeProj3);

    expect(result, true);
  });

  test('Update project invalid', () async {
    final fakeProj3 = fakeProj2.copyWith(name: 'fakeProject3');

    final storedProjects = [fakeProj1, fakeProj2];
    final fakeProjects = [fakeProj1, fakeProj3];

    when(authBloc.state).thenAnswer(
        (realInvocation) => const AuthState.authenticated(fakeUser));

    when(prefsMock.getString('worktenser.projects'))
        .thenAnswer((realInvocation) => json.encode(storedProjects));

    when(prefsMock.setString(fakeUser.id, json.encode(fakeProjects)))
        .thenAnswer((realInvocation) async => false);

    final result = await storage.update(fakeProj3);

    expect(result, false);
  });

  test('Update project invalid - no saved projects', () async {
    final fakeProj3 = fakeProj2.copyWith(name: 'fakeProject3');

    final fakeProjects = [fakeProj1, fakeProj3];

    when(authBloc.state).thenAnswer(
        (realInvocation) => const AuthState.authenticated(fakeUser));

    when(prefsMock.getString('worktenser.projects'))
        .thenAnswer((realInvocation) => json.encode([]));

    when(prefsMock.setString(fakeUser.id, json.encode(fakeProjects)))
        .thenAnswer((realInvocation) async => false);

    final result = await storage.update(fakeProj3);

    expect(result, false);
  });

  test('Delete project successful', () async {
    when(authBloc.state).thenAnswer(
        (realInvocation) => const AuthState.authenticated(fakeUser));

    when(prefsMock.getString('worktenser.projects'))
        .thenAnswer((realInvocation) => json.encode([fakeProj1, fakeProj2]));

    when(prefsMock.setString(fakeUser.id, json.encode([fakeProj2])))
        .thenAnswer((realInvocation) async => true);

    final result = await storage.delete(fakeProj1);

    expect(result, true);
  });

  test('Delete project successful', () async {
    when(authBloc.state).thenAnswer(
        (realInvocation) => const AuthState.authenticated(fakeUser));

    when(prefsMock.getString('worktenser.projects'))
        .thenAnswer((realInvocation) => json.encode([fakeProj1, fakeProj2]));

    when(prefsMock.setString(fakeUser.id, json.encode([fakeProj2])))
        .thenAnswer((realInvocation) async => false);

    final result = await storage.delete(fakeProj1);

    expect(result, false);
  });

  test('Clear local projects storage successful', () async {
    when(prefsMock.remove('worktenser.projects'))
        .thenAnswer((realInvocation) async => true);

    final result = await storage.clear();

    expect(result, true);
  });

  test('Clear local projects storage invalid', () async {
    when(prefsMock.remove('worktenser.projects'))
        .thenAnswer((realInvocation) async => false);

    final result = await storage.clear();

    expect(result, false);
  });
}
