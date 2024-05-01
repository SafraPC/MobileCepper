import 'dart:convert';
import 'package:cepper/app/model/cep_model.dart';
import 'package:cepper/app/utils/toast.dart';
import 'package:localstorage/localstorage.dart';
import 'package:collection/collection.dart';

class CEPRepository {
  final String storageKey = "@CEPPER";

  List<CEPModel> getCEPs() {
    try {
      String? encodedCeps = localStorage.getItem(storageKey);
      if (encodedCeps == null || encodedCeps.isEmpty || encodedCeps == "null") {
        return [];
      }
      List<dynamic> decodedCeps = jsonDecode(encodedCeps);
      List<CEPModel> ceps =
          decodedCeps.map((e) => CEPModel.fromJson(e)).toList();
      return ceps;
    } catch (e) {
      Toaster.showToast("Houve um erro ao listar os CEPs", true);
      return [];
    }
  }

  Future<CEPModel?>? findCEP(String cep) async {
    try {
      List<CEPModel?>? ceps = getCEPs();
      if (ceps.isEmpty) {
        return null;
      }
      var foundedCEP = ceps.firstWhereOrNull(
          (element) => element?.cep?.replaceAll('-', '') == cep);
      if (foundedCEP != null) {
        Toaster.showToast("CEP encontrado no cache!", false);
      }
      return foundedCEP;
    } catch (e) {
      throw Exception("Erro ao encontrar o CEP");
    }
  }

  Future<void> saveCEP(CEPModel model) async {
    try {
      if (model.cep == null) {
        Toaster.showToast("CEP não encontrado.", true);
        return;
      }
      var ceps = getCEPs();
      ceps.insert(
        0,
        model,
      );
      localStorage.setItem(storageKey, jsonEncode(ceps));
    } catch (e) {
      Toaster.showToast("Houve um erro ao salvar o CEP", true);
    }
  }

  Future<void> deleteCEP(int index) async {
    try {
      var ceps = getCEPs();
      ceps.removeAt(index);
      localStorage.setItem(storageKey, jsonEncode(ceps));
      Toaster.showToast("CEP deletado com sucesso!", false);
    } catch (e) {
      Toaster.showToast("Houve um erro ao deletar o CEP", true);
    }
  }
}
