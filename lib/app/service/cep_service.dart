import 'package:cepper/app/model/cep_model.dart';
import 'package:dio/dio.dart';

class CEPService {
  final Dio dio = Dio();
  Future<CEPModel?> fetchCEP(String cep) async {
    try {
      final response = await dio.get("https://viacep.com.br/ws/$cep/json/");
      return CEPModel.fromJson(response.data);
    } catch (e) {
      return null;
    }
  }
}
