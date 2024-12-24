import 'package:equatable/equatable.dart';

abstract class CreateServiceEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoadCategoriesEvent extends CreateServiceEvent {}

class SubmitServiceEvent extends CreateServiceEvent {
  final Map<String, dynamic> serviceData;

  SubmitServiceEvent(this.serviceData);

  @override
  List<Object?> get props => [serviceData];
}
