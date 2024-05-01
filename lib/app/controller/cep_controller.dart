import 'package:cepper/app/model/cep_model.dart';
import 'package:cepper/app/repository/cep_repository.dart';
import 'package:cepper/app/service/cep_service.dart';
import 'package:cepper/app/utils/toast.dart';
import 'package:flutter/material.dart';

class CEPController extends ChangeNotifier {
  final CEPRepository repository = CEPRepository();
  final CEPService service = CEPService();
  CEPStatus status = CEPStatus.loading;
  List<CEPModel?> ceps = [];

  void changeStatus(CEPStatus status) {
    this.status = status;
    notifyListeners();
  }

  Future<CEPModel?> fetchCEP(String cep) async {
    try {
      changeStatus(CEPStatus.loading);
      final model = await repository.findCEP(cep);
      if (model != null) {
        changeStatus(CEPStatus.loaded);
        return model;
      }
      final serviceModel = await service.fetchCEP(cep);
      if (serviceModel != null) {
        await repository.saveCEP(serviceModel);
        await getCEPs();
        changeStatus(CEPStatus.loaded);
        return serviceModel;
      }
      changeStatus(CEPStatus.error);
      return null;
    } catch (e) {
      changeStatus(CEPStatus.error);
      Toaster.showToast("Houve um erro ao processar o CEP", true);
      return null;
    }
  }

  Future<void> getCEPs() async {
    var cepsList = repository.getCEPs();
    ceps = cepsList;
    if (cepsList.isEmpty) {
      status = CEPStatus.empty;
    } else {
      status = CEPStatus.loaded;
    }
  }

  Future<void> deleteCEP(int index) async {
    await repository.deleteCEP(index);
    await getCEPs();
  }
}

enum CEPStatus { loading, loaded, empty, error }
