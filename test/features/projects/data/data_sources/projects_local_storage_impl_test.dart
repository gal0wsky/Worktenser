import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:worktenser/features/auth/domain/entities/user.dart';
import 'package:worktenser/features/auth/presentation/bloc/auth/auth_bloc.dart';
import 'package:worktenser/features/projects/data/data_sources/local/projects_local_storage_impl.dart';
import 'package:worktenser/features/projects/domain/entities/project.dart';

import 'projects_local_storage_impl_test.mocks.dart';

@GenerateNiceMocks([MockSpec<SharedPreferences>(), MockSpec<AuthBloc>()])
void main() {
  final prefsMock = MockSharedPreferences();
  late ProjectsLocalStorageImpl storage;

  const storageKey = 'worktenser.projects';

  const fakeUser = UserEntity(id: 'fakeId');

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

  setUp(() => storage = ProjectsLocalStorageImpl(preferences: prefsMock));

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

  test('Add project successful', () async {
    when(prefsMock.setString(storageKey, json.encode([fakeProj1])))
        .thenAnswer((realInvocation) async => true);

    final result = await storage.add(fakeProj1);

    expect(result, true);
  });

  test('Add project invalid', () async {
    when(prefsMock.setString(storageKey, json.encode([fakeProj1])))
        .thenAnswer((realInvocation) async => false);

    final result = await storage.add(fakeProj1);

    expect(result, false);
  });

  test('Save projects successful', () async {
    final fakeProjects = [fakeProj1, fakeProj2];

    when(prefsMock.setString(storageKey, json.encode(fakeProjects)))
        .thenAnswer((realInvocation) async => true);

    final result = await storage.save(fakeProjects);

    expect(result, true);
  });

  test('Save projects invalid', () async {
    final fakeProjects = [fakeProj1, fakeProj2];

    when(prefsMock.setString(storageKey, json.encode(fakeProjects)))
        .thenAnswer((realInvocation) async => false);

    final result = await storage.save(fakeProjects);

    expect(result, false);
  });

  test('Update project successful', () async {
    final fakeProj3 = fakeProj2.copyWith(name: 'fakeProject3');

    final storedProjects = [fakeProj1, fakeProj2];
    final fakeProjects = [fakeProj1, fakeProj3];

    when(prefsMock.getString('worktenser.projects'))
        .thenAnswer((realInvocation) => json.encode(storedProjects));

    when(prefsMock.setString(storageKey, json.encode(fakeProjects)))
        .thenAnswer((realInvocation) async => true);

    final result = await storage.update(fakeProj3);

    expect(result, true);
  });

  test('Update project invalid', () async {
    final fakeProj3 = fakeProj2.copyWith(name: 'fakeProject3');

    final storedProjects = [fakeProj1, fakeProj2];
    final fakeProjects = [fakeProj1, fakeProj3];

    when(prefsMock.getString('worktenser.projects'))
        .thenAnswer((realInvocation) => json.encode(storedProjects));

    when(prefsMock.setString(storageKey, json.encode(fakeProjects)))
        .thenAnswer((realInvocation) async => false);

    final result = await storage.update(fakeProj3);

    expect(result, false);
  });

  test('Update project invalid - no saved projects', () async {
    final fakeProj3 = fakeProj2.copyWith(name: 'fakeProject3');

    final fakeProjects = [fakeProj1, fakeProj3];

    when(prefsMock.getString('worktenser.projects'))
        .thenAnswer((realInvocation) => json.encode([]));

    when(prefsMock.setString(storageKey, json.encode(fakeProjects)))
        .thenAnswer((realInvocation) async => false);

    final result = await storage.update(fakeProj3);

    expect(result, false);
  });

  test('Delete project successful', () async {
    when(prefsMock.getString('worktenser.projects'))
        .thenAnswer((realInvocation) => json.encode([fakeProj1, fakeProj2]));

    when(prefsMock.setString(storageKey, json.encode([fakeProj2])))
        .thenAnswer((realInvocation) async => true);

    final result = await storage.delete(fakeProj1);

    expect(result, true);
  });

  test('Delete project successful', () async {
    when(prefsMock.getString('worktenser.projects'))
        .thenAnswer((realInvocation) => json.encode([fakeProj1, fakeProj2]));

    when(prefsMock.setString(storageKey, json.encode([fakeProj2])))
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
