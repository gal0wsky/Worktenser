part of 'searchbar_bloc.dart';

sealed class SearchbarEvent extends Equatable {
  const SearchbarEvent();

  @override
  List<Object> get props => [];
}

class UpdateSearchPhrase extends SearchbarEvent {
  final String searchPhrase;

  const UpdateSearchPhrase({required this.searchPhrase});

  @override
  List<Object> get props => [searchPhrase];
}

class SearchForPhrase extends SearchbarEvent {}
