part of 'searchbar_bloc.dart';

sealed class SearchbarState extends Equatable {
  final String searchPhrase;
  final List<ProjectEntity> filteredProjects;

  const SearchbarState(
      {this.searchPhrase = '', this.filteredProjects = const []});

  @override
  List<Object?> get props => [searchPhrase, filteredProjects];
}

class SearchbarInitial extends SearchbarState {}

class SearchbarSearchApplied extends SearchbarState {
  const SearchbarSearchApplied(
      {required String searchPhrase,
      required List<ProjectEntity> filteredProjects})
      : super(searchPhrase: searchPhrase, filteredProjects: filteredProjects);
}

class SearchPhraseUpdated extends SearchbarState {
  const SearchPhraseUpdated(
      {required String searchPhrase,
      required List<ProjectEntity> filteredProjects})
      : super(searchPhrase: searchPhrase, filteredProjects: filteredProjects);
}
