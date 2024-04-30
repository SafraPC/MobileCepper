import 'package:cepper/app/controller/cep_controller.dart';
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
                      setState(() {});
                    },
                  )
                }
            },
            decoration: const InputDecoration(
                labelText: "CEP", hintText: "Digite o CEP"),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height - 250,
            child: ListView.builder(
              itemCount: controller.ceps.length,
              itemBuilder: (context, index) {
                final cep = controller.ceps[index];
                return ListTile(
                  title: Text(cep?.cep ?? "Não encontrado"),
                  subtitle: Text(cep?.logradouro ?? "Não encontrado"),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () {
                      if (cep == null) {
                        return;
                      }
                      controller
                          .deleteCEP(index)
                          .then((value) => {setState(() {})});
                    },
                  ),
                );
              },
            ),
          )
        ],
      ),
    );
  }
}
