class Pessoa {
  Pessoa({
    required this.nome,
    required this.identificacao,
    required this.dataEntrada,
    this.dataSaida,
  });

  Pessoa.fromJson(Map<String, dynamic> json)
    : nome = json['nome'],
      identificacao = json['identificacao'],
      dataEntrada = DateTime.parse(json['dataEntrada']),
      dataSaida = json['dataSaida'] == null
          ? null
          : DateTime.parse(json['dataSaida']);

  String nome;
  String identificacao;
  DateTime dataEntrada;
  DateTime? dataSaida;

  bool get noAmbiente => dataSaida == null;

  Map<String, dynamic> toJson() {
    return {
      'nome': nome,
      'identificacao': identificacao,
      'dataEntrada': dataEntrada.toIso8601String(),
      'dataSaida': dataSaida?.toIso8601String(),
    };
  }
}
