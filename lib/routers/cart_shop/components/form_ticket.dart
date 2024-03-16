import 'package:flutter/material.dart';
import 'package:toggle_switch/toggle_switch.dart';
import 'package:date_field/date_field.dart';
import 'package:intl/intl.dart';
import 'package:pdvtex/store/store_pdv.dart';
import 'package:provider/provider.dart';

class FormTicket extends StatelessWidget {
  const FormTicket({super.key});

  @override
  Widget build(BuildContext context) {

    final store = Provider.of<StorePdv>(context);

    return Container(
      color: Colors.black,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Padding(
            padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
            child: ToggleTipoPedido(),
          ),
          const Padding(
            padding: EdgeInsets.fromLTRB(15, 10, 15, 0),
            child: DateVenda(),
          ),
          const Padding(
            padding: EdgeInsets.fromLTRB(15, 10, 15, 0),
            child: Text('Forma de Pagamento', style: TextStyle(color: Colors.white),),
          ),
          const Padding(
            padding: EdgeInsets.fromLTRB(15, 10, 15, 0),
            child: SelectTipoPagto(),
          ),
          Visibility(
            visible: store.tipoVenda == 'E',
            child: const Text('Só é visivel com uma condição', style: TextStyle(color: Colors.white,),),
          ),
        ],
      ),
    );
  }
}

class ToggleTipoPedido extends StatelessWidget {
  const ToggleTipoPedido({super.key});

  @override
  Widget build(BuildContext context) {
    final store = Provider.of<StorePdv>(context);
    return ToggleSwitch(
      minWidth: 120,
      minHeight: 30,
      activeFgColor: Colors.amber,
      inactiveBgColor: Colors.grey.shade700,
      inactiveFgColor: Colors.grey,
      initialLabelIndex: 0,
      totalSwitches: 2,
      labels: const ['BALCÃO', 'ENCOMENDA'],
      onToggle: (index) {
        if (index != null) {
          store.changeTipoVenda(index);
        }
      },
    );
  }
}

class DateVenda extends StatefulWidget {
  const DateVenda({super.key});

  @override
  State<DateVenda> createState() => _DateVendaState();
}

class _DateVendaState extends State<DateVenda> {
  @override
  Widget build(BuildContext context) {
    final store = Provider.of<StorePdv>(context);
    DateTime? dataSelecionada = store.dataPedido;

    return DateTimeField(
      dateFormat: DateFormat('dd/MM/yyyy'),
      style: const TextStyle (color: Colors.white),
      value: dataSelecionada,
      mode: DateTimeFieldPickerMode.date,
      decoration: const InputDecoration(
        hoverColor: Colors.blue,
        suffixIconColor: Colors.white,
        prefixIconColor: Colors.white,
        labelText: 'Data do Pedido', 
        labelStyle: TextStyle(color: Colors.white),

      ),
      onChanged: (value) {
        if (value != null) {
          store.dataPedido = value;
          setState(() {
            dataSelecionada = value;
          });
        }
      },
    );
  }
}

class SelectTipoPagto extends StatefulWidget {
  const SelectTipoPagto({super.key});

  @override
  State<SelectTipoPagto> createState() => _SelectTipoPagtoState();
}

class _SelectTipoPagtoState extends State<SelectTipoPagto> {
  @override
  Widget build(BuildContext context) {
    final store = Provider.of<StorePdv>(context);
    final List<String> tipoPagto = [
      'PIX',
      'DIN',
      'DEB01',
      'CRED01L',
      'DEB02',
      'CRED02',
      'CRED02L'
    ];
    String valorSelecionado = tipoPagto.first;

    return DropdownButton(
      dropdownColor: Colors.black,
        value: valorSelecionado,
        isExpanded: true,
        items: tipoPagto.map((String valor) {
          return DropdownMenuItem(value: valor, child: Text(valor, style: const TextStyle(color: Colors.white),));
        }).toList(),
        onChanged: (String? valor) {
          if (valor != null) {
            store.changeTipoPagto(valor);
            setState(() {
              valorSelecionado = valor;
            });
          }
        });
  }
}
