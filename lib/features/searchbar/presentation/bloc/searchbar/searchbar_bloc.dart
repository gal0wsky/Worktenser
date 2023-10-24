import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:worktenser/features/projects/domain/entities/project.dart';
import 'package:worktenser/features/projects/presentation/bloc/projects/projects_bloc.dart';

part 'searchbar_event.dart';
part 'searchbar_state.dart';

class SearchbarBloc extends Bloc<SearchbarEvent, SearchbarState> {
  final ProjectsBloc _projectsBloc;
  late StreamSubscription _projectsSubscription;

  SearchbarBloc({required ProjectsBloc projectsBloc})
      : _projectsBloc = projectsBloc,
        super(SearchbarInitial()) {
    on<UpdateSearchPhrase>(_onUpdateSearchPhrase);
    on<SearchForPhrase>(_onSearchForPhrase);

    _projectsSubscription = _projectsBloc.stream.listen((event) {
      add(SearchForPhrase());
    });
  }

  void _onUpdateSearchPhrase(
      UpdateSearchPhrase event, Emitter<SearchbarState> emit) {
    emit(SearchPhraseUpdated(
        searchPhrase: event.searchPhrase,
        filteredProjects: state.filteredProjects));

    // add(SearchForPhrase());
  }

  void _onSearchForPhrase(SearchForPhrase event, Emitter<SearchbarState> emit) {
    final projectsState = _projectsBloc.state;

    List<ProjectEntity> filteredProjects = [];

    if (projectsState is ProjectsLoaded) {
      if (state.searchPhrase.isEmpty) {
        emit(SearchbarSearchApplied(
            searchPhrase: state.searchPhrase,
            filteredProjects: projectsState.projects));
      } else {
        for (var project in projectsState.projects) {
          if (project.name
              .toLowerCase()
              .contains(state.searchPhrase.toLowerCase())) {
            filteredProjects.add(project);
          }
        }

        emit(SearchbarSearchApplied(
            searchPhrase: state.searchPhrase,
            filteredProjects: filteredProjects));
      }
    } else {
      emit(
          const SearchbarSearchApplied(searchPhrase: '', filteredProjects: []));
    }
  }

  @override
  Future<void> close() {
    _projectsSubscription.cancel();
    return super.close();
  }
}
