import 'package:equatable/equatable.dart';

abstract class CreateServiceState extends Equatable {
  @override
  List<Object?> get props => [];
}

class CreateServiceInitial extends CreateServiceState {}

class CreateServiceLoadingCategories extends CreateServiceState {}

class CreateServiceCategoriesLoaded extends CreateServiceState {
  final List<String> categories;

  CreateServiceCategoriesLoaded({required this.categories});

  @override
  List<Object?> get props => [categories];
}

class CreateServiceLoading extends CreateServiceState {}

class CreateServiceSuccess extends CreateServiceState {}

class CreateServiceFailure extends CreateServiceState {
  final String error;

  CreateServiceFailure({required this.error});

  @override
  List<Object?> get props => [error];
}
