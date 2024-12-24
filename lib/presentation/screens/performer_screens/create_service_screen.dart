import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../blocs/create_service/create_service_bloc.dart';
import '../../blocs/create_service/create_service_event.dart';
import '../../blocs/create_service/create_service_state.dart';

import '../../../domain/entities/user.dart' as app_user;


class CreateServiceScreen extends StatefulWidget {
  final String userEmail;

  CreateServiceScreen({required this.userEmail});

  @override
  _CreateServiceScreenState createState() => _CreateServiceScreenState();
}

class _CreateServiceScreenState extends State<CreateServiceScreen> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController unitController = TextEditingController();
  String? selectedCategory;
  String selectedCurrency = 'Сом';

  @override
  void initState() {
    super.initState();
    context.read<CreateServiceBloc>().add(LoadCategoriesEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Создать услугу'),
      ),
      body: BlocListener<CreateServiceBloc, CreateServiceState>(
        listener: (context, state) {
          if (state is CreateServiceLoading) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Создание услуги...')),
            );
          } else if (state is CreateServiceSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Услуга успешно создана!')),
            );
            Navigator.pop(context);
          } else if (state is CreateServiceFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Ошибка: ${state.error}')),
            );
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextField(
                  controller: titleController,
                  decoration: InputDecoration(
                    labelText: 'Название услуги',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: descriptionController,
                  decoration: InputDecoration(
                    labelText: 'Описание услуги',
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 3,
                ),
                const SizedBox(height: 16),
                BlocBuilder<CreateServiceBloc, CreateServiceState>(
                  builder: (context, state) {
                    if (state is CreateServiceCategoriesLoaded) {
                      return DropdownButtonFormField<String>(
                        value: selectedCategory,
                        items: state.categories.map((category) {
                          return DropdownMenuItem(
                            value: category,
                            child: Text(category),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            selectedCategory = value;
                          });
                        },
                        decoration: InputDecoration(
                          labelText: 'Категория',
                          border: OutlineInputBorder(),
                        ),
                      );
                    } else if (state is CreateServiceLoadingCategories) {
                      return Center(child: CircularProgressIndicator());
                    } else {
                      return Text('Ошибка загрузки категорий');
                    }
                  },
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: priceController,
                  decoration: InputDecoration(
                    labelText: 'Стоимость',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  value: selectedCurrency,
                  items: ['Сом', 'Доллар'].map((currency) {
                    return DropdownMenuItem(
                      value: currency,
                      child: Text(currency),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedCurrency = value!;
                    });
                  },
                  decoration: InputDecoration(
                    labelText: 'Валюта',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: unitController,
                  decoration: InputDecoration(
                    labelText: 'За что идет цена (например, килограмм, метр)',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    if (titleController.text.isEmpty ||
                        descriptionController.text.isEmpty ||
                        priceController.text.isEmpty ||
                        unitController.text.isEmpty ||
                        selectedCategory == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Пожалуйста, заполните все обязательные поля')),
                      );
                      return;
                    }

                    final serviceData = {
                      'title': titleController.text.trim(),
                      'description': descriptionController.text.trim(),
                      'price': double.parse(priceController.text.trim()),
                      'currency': selectedCurrency,
                      'unit': unitController.text.trim(),
                      'category': selectedCategory,
                      'createdBy': widget.userEmail, // Используем email из конструктора
                      'createdAt': FieldValue.serverTimestamp(),
                    };

                    context.read<CreateServiceBloc>().add(SubmitServiceEvent(serviceData));
                  },
                  child: Text('Создать услугу'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}


