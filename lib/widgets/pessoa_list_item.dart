import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';
import 'package:controle_lotacao/models/pessoa.dart';

class PessoaListItem extends StatelessWidget {
  const PessoaListItem({
    super.key,
    required this.pessoa,
    required this.onSaida,
    required this.onDelete,
  });

  final Pessoa pessoa;
  final Function(Pessoa) onSaida;
  final Function(Pessoa) onDelete;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Slidable(
        endActionPane: ActionPane(
          motion: const BehindMotion(),
          extentRatio: 0.5,
          children: [
            SlidableAction(
              onPressed: (context) => onSaida(pessoa),
              backgroundColor: const Color(0xff256d46),
              icon: Icons.logout,
              label: 'Saída',
            ),
            SlidableAction(
              onPressed: (context) => onDelete(pessoa),
              backgroundColor: const Color(0xffb3261e),
              icon: Icons.delete,
              label: 'Excluir',
            ),
          ],
        ),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xfff2f2f2),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                pessoa.nome,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text('RM / ID: ${pessoa.identificacao}'),
              Text(
                'Entrada: ${DateFormat('dd/MM/yyyy HH:mm').format(pessoa.dataEntrada)}',
              ),
              if (pessoa.dataSaida != null)
                Text(
                  'Saída: ${DateFormat('dd/MM/yyyy HH:mm').format(pessoa.dataSaida!)}',
                ),
              const SizedBox(height: 4),
              Text(
                pessoa.noAmbiente ? 'No ambiente' : 'Saiu',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: pessoa.noAmbiente
                      ? const Color(0xff256d46)
                      : const Color(0xff666666),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
