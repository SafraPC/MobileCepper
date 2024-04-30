import 'dart:convert';
import 'package:cepper/app/model/cep_model.dart';
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
      throw Exception("Erro ao pegar os CEPs");
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
      return foundedCEP;
    } catch (e) {
      throw Exception(
        "Erro ao encontrar o CEP $e",
      );
    }
  }

  Future<void> saveCEP(CEPModel model) async {
    try {
      var ceps = getCEPs();
      ceps.add(model);
      localStorage.setItem(storageKey, jsonEncode(ceps));
    } catch (e) {
      throw Exception("Erro ao salvar o CEP");
    }
  }

  Future<void> deleteCEP(int index) async {
    try {
      var ceps = getCEPs();
      ceps.removeAt(index);
      localStorage.setItem(storageKey, jsonEncode(ceps));
    } catch (e) {
      throw Exception(e);
    }
  }
}
