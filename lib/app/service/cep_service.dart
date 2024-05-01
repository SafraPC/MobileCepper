import 'package:cepper/app/model/cep_model.dart';
import 'package:cepper/app/utils/toast.dart';
import 'package:dio/dio.dart';

class CEPService {
  final Dio dio = Dio();
  Future<CEPModel?> fetchCEP(String cep) async {
    try {
      final response = await dio.get("https://viacep.com.br/ws/$cep/json/");
      Toaster.showToast("CEP encontrado com sucesso", false);
      return CEPModel.fromJson(response.data);
    } catch (e) {
      Toaster.showToast("Houve um erro ao buscar o CEP: $cep", true);
      return null;
    }
  }
}
