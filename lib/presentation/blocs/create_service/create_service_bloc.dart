import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'create_service_event.dart';
import 'create_service_state.dart';

class CreateServiceBloc extends Bloc<CreateServiceEvent, CreateServiceState> {
  CreateServiceBloc() : super(CreateServiceInitial()) {
    on<LoadCategoriesEvent>(_onLoadCategories);
    on<SubmitServiceEvent>(_onSubmitService);
  }

  Future<void> _onLoadCategories(
      LoadCategoriesEvent event, Emitter<CreateServiceState> emit) async {
    emit(CreateServiceLoadingCategories());
    try {
      final snapshot =
          await FirebaseFirestore.instance.collection('categories').get();
      final categories =
          snapshot.docs.map((doc) => doc['name'].toString()).toList();
      emit(CreateServiceCategoriesLoaded(categories: categories));
    } catch (e) {
      emit(CreateServiceFailure(error: 'Ошибка загрузки категорий: $e'));
    }
  }

  Future<void> _onSubmitService(
      SubmitServiceEvent event, Emitter<CreateServiceState> emit) async {
    emit(CreateServiceLoading());
    try {
      await FirebaseFirestore.instance
          .collection('services')
          .add(event.serviceData);
      emit(CreateServiceSuccess());
    } catch (e) {
      emit(CreateServiceFailure(error: 'Ошибка создания услуги: $e'));
    }
  }
}
