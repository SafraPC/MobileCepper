import 'package:cepper/app/controller/cep_controller.dart';
import 'package:cepper/app/model/cep_model.dart';
import 'package:flutter/material.dart';

class CepView extends StatefulWidget {
  const CepView({super.key});

  @override
  State<CepView> createState() => _CepViewState();
}

class _CepViewState extends State<CepView> {
  TextEditingController cepInputController = TextEditingController();
  late CEPController controller;

  @override
  void initState() {
    super.initState();
    controller = CEPController();
    controller.getCEPs().then(
      (value) {
        setState(() {});
      },
    );
  }

  errorRender() {
    return const Center(
      child: Text(
        "Houve um erro ao processar o CEP",
        style: TextStyle(fontSize: 20, color: Colors.redAccent),
      ),
    );
  }

  loadedRender() {
    return ListView.builder(
      itemCount: controller.ceps.length,
      itemBuilder: (context, index) {
        final cep = controller.ceps[index];
        return ListTile(
          onTap: () {
            if (cep == null) {
              return;
            }
            handlePress(cep);
          },
          title: Text(cep?.cep ?? "Não encontrado"),
          subtitle: Text(cep?.logradouro ?? "Não encontrado"),
          trailing: IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () {
              if (cep == null) {
                return;
              }
              controller.deleteCEP(index).then((value) => {setState(() {})});
            },
          ),
        );
      },
    );
  }

  emptyRender() {
    return const Center(
      child: Text(
        "Nenhum CEP encontrado",
        style: TextStyle(fontSize: 20, color: Colors.redAccent),
      ),
    );
  }

  loadingRender() {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }

  managementRender() {
    if (controller.status == CEPStatus.error) {
      return errorRender();
    }
    if (controller.status == CEPStatus.loaded) {
      return loadedRender();
    }
    if (controller.status == CEPStatus.empty) {
      return emptyRender();
    }
    return loadingRender();
  }

  Widget renderCEPData(String info, String value) {
    return SizedBox(
      height: 32,
      width: double.infinity,
      child: Wrap(
        alignment: WrapAlignment.spaceBetween,
        spacing: 4,
        runSpacing: 64,
        runAlignment: WrapAlignment.spaceBetween,
        children: [
          Text(
            '$info:',
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
          ),
          Text(
            value,
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.normal),
          ),
        ],
      ),
    );
  }

  void handlePress(CEPModel model) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Center(
              child: Text(
                model.cep ?? "Não encontrado",
              ),
            ),
            content: SizedBox(
                height: 150,
                child: Center(
                  child: Column(
                    children: [
                      renderCEPData(
                          "Logradouro", model.logradouro ?? "Não encontrado"),
                      renderCEPData("Bairro", model.bairro ?? "Não encontrado"),
                      renderCEPData(
                          "Localidade", model.localidade ?? "Não encontrado"),
                      renderCEPData("UF", model.uf ?? "Não encontrado"),
                    ],
                  ),
                )),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text(
                  "OK!",
                  style: TextStyle(fontSize: 16),
                ),
              )
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          TextField(
            controller: cepInputController,
            maxLength: 8,
            keyboardType: TextInputType.number,
            onChanged: (value) => {
              if (value.length == 8)
                {
                  controller.fetchCEP(value).then(
                    (value) {
                      setState(() {
                        cepInputController.clear();
                      });
                    },
                  )
                }
            },
            decoration: const InputDecoration(
                labelText: "CEP", hintText: "Digite o CEP"),
          ),
          SizedBox(
              height: MediaQuery.of(context).size.height - 250,
              child: AnimatedBuilder(
                animation: controller,
                builder: (context, child) {
                  return managementRender();
                },
              ))
        ],
      ),
    );
  }
}
