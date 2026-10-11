import 'package:flutter/material.dart';
import 'package:controle_lotacao/models/pessoa.dart';
import 'package:controle_lotacao/repositories/pessoa_repository.dart';
import 'package:controle_lotacao/widgets/pessoa_list_item.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController nomeController = TextEditingController();
  final TextEditingController identificacaoController = TextEditingController();
  final PessoaRepository pessoaRepository = PessoaRepository();
  List<Pessoa> listPessoas = [];
  final int capacidadeMaxima = 30;
  bool carregando = true;

  int get quantidadePresentes =>
      listPessoas.where((pessoa) => pessoa.noAmbiente).length;
  bool get isFull => quantidadePresentes >= capacidadeMaxima;

  @override
  void initState() {
    super.initState();
    carregarPessoas();
  }

  Future<void> carregarPessoas() async {
    try {
      final pessoas = await pessoaRepository.getListaPessoas();
      if (!mounted) return;
      setState(() {
        listPessoas = pessoas;
        carregando = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() => carregando = false);
      mostrarMensagem('Não foi possível carregar os registros.');
    }
  }

  @override
  void dispose() {
    nomeController.dispose();
    identificacaoController.dispose();
    super.dispose();
  }

  void mostrarMensagem(String mensagem) {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(mensagem)));
  }

  Future<void> salvarPessoas() async {
    try {
      await pessoaRepository.saveListaPessoas(listPessoas);
    } catch (e) {
      if (!mounted) return;
      mostrarMensagem('Não foi possível salvar os registros no aparelho.');
    }
  }

  void cadastrarPessoa() {
    final nome = nomeController.text.trim();
    final identificacao = identificacaoController.text.trim();

    if (nome.isEmpty || identificacao.isEmpty) {
      mostrarMensagem('Preencha o nome e a identificação.');
      return;
    }
    for (Pessoa pessoa in listPessoas) {
      if (pessoa.identificacao.toLowerCase() == identificacao.toLowerCase() &&
          pessoa.noAmbiente) {
        mostrarMensagem('Esta identificação já está no ambiente.');
        return;
      }
    }
    if (isFull) {
      mostrarMensagem(
        'Ambiente lotado! Não é possível registrar uma nova entrada.',
      );
      return;
    }

    setState(() {
      listPessoas.add(
        Pessoa(
          nome: nome,
          identificacao: identificacao,
          dataEntrada: DateTime.now(),
        ),
      );
    });
    salvarPessoas();
    nomeController.clear();
    identificacaoController.clear();
    mostrarMensagem('Pessoa cadastrada com sucesso!');
  }

  void registrarSaida(Pessoa pessoa) {
    if (!pessoa.noAmbiente) {
      mostrarMensagem('A saída desta pessoa já foi registrada.');
      return;
    }
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Registrar saída?'),
        content: Text('Deseja registrar a saída de ${pessoa.nome}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(dialogContext).pop();
              setState(() => pessoa.dataSaida = DateTime.now());
              salvarPessoas();
              mostrarMensagem('Saída registrada com sucesso!');
            },
            child: const Text('Confirmar'),
          ),
        ],
      ),
    );
  }

  void excluirPessoa(Pessoa pessoa) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Excluir registro?'),
        content: Text('Deseja excluir o registro de ${pessoa.nome}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(dialogContext).pop();
              setState(() => listPessoas.remove(pessoa));
              salvarPessoas();
              mostrarMensagem('Registro excluído com sucesso!');
            },
            child: const Text('Excluir'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xffed145b),
        foregroundColor: Colors.white,
        title: const Text('Controle do laboratório'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: ListView(
              children: [
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xff181818),
                    borderRadius: BorderRadius.circular(6),
                    image: const DecorationImage(
                      image: AssetImage('assets/images/fiap_bg.png'),
                      fit: BoxFit.cover,
                      opacity: 0.2,
                    ),
                  ),
                  child: Column(
                    children: [
                      const Icon(Icons.computer, color: Colors.white, size: 32),
                      const SizedBox(height: 8),
                      Text(
                        '$quantidadePresentes / $capacidadeMaxima',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 32,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Text(
                        isFull ? 'Laboratório lotado' : 'Pode entrar',
                        style: const TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: nomeController,
                  decoration: const InputDecoration(
                    labelText: 'Nome',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: identificacaoController,
                        decoration: const InputDecoration(
                          labelText: 'RM / Identificação',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton(
                      onPressed: carregando ? null : cadastrarPessoa,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xffed145b),
                        foregroundColor: Colors.white,
                      ),
                      child: const Text('Cadastrar'),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                const Text(
                  'Deslize um registro para a esquerda para ver as ações.',
                ),
                const SizedBox(height: 8),
                if (carregando)
                  const Center(child: CircularProgressIndicator())
                else if (listPessoas.isEmpty)
                  const Center(child: Text('Nenhuma pessoa cadastrada.'))
                else
                  for (Pessoa pessoa in listPessoas)
                    PessoaListItem(
                      pessoa: pessoa,
                      onSaida: registrarSaida,
                      onDelete: excluirPessoa,
                    ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
