import 'package:cepper/app/model/cep_model.dart';
import 'package:cepper/app/repository/cep_repository.dart';
import 'package:cepper/app/service/cep_service.dart';

class CEPController {
  final CEPRepository repository = CEPRepository();
  final CEPService service = CEPService();
  List<CEPModel?> ceps = [];

  Future<CEPModel?> fetchCEP(String cep) async {
    final model = await repository.findCEP(cep);
    if (model != null) {
      return model;
    }
    final serviceModel = await service.fetchCEP(cep);
    if (serviceModel != null) {
      await repository.saveCEP(serviceModel);
      await getCEPs();
      return serviceModel;
    }

    return null;
  }

  Future<void> getCEPs() async {
    var cepsList = repository.getCEPs();
    ceps = cepsList;
  }

  Future<void> deleteCEP(int index) async {
    await repository.deleteCEP(index);
    await getCEPs();
  }
}
