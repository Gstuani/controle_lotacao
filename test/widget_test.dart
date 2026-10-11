import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:controle_lotacao/main.dart';
import 'package:controle_lotacao/models/pessoa.dart';
import 'package:controle_lotacao/repositories/pessoa_repository.dart';
import 'package:controle_lotacao/widgets/pessoa_list_item.dart';

Pessoa pessoa(int id) => Pessoa(
  nome: 'Aluno $id',
  identificacao: '$id',
  dataEntrada: DateTime(2026, 10, 10, 10),
);

Future<void> abrir(
  WidgetTester tester, [
  List<Pessoa> pessoas = const [],
]) async {
  SharedPreferences.setMockInitialValues({pessoaListKey: json.encode(pessoas)});
  GoogleFonts.config.allowRuntimeFetching = false;
  await tester.pumpWidget(const MyApp());
  await tester.pumpAndSettle();
}

Future<void> cadastrar(WidgetTester tester, String nome, String id) async {
  await tester.enterText(find.byType(TextField).at(0), nome);
  await tester.enterText(find.byType(TextField).at(1), id);
  await tester.tap(find.text('Cadastrar'));
  await tester.pumpAndSettle();
}

Future<void> deslizar(WidgetTester tester) async {
  await tester.drag(find.byType(PessoaListItem).first, const Offset(-450, 0));
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('Valida campos vazios e identificação duplicada', (tester) async {
    await abrir(tester);
    await cadastrar(tester, ' ', ' ');
    expect(find.text('Preencha o nome e a identificação.'), findsOneWidget);
    await cadastrar(tester, 'Gabriel Stuani', '566682');
    expect(find.text('1 / 30'), findsOneWidget);
    expect(find.text('Gabriel Stuani'), findsOneWidget);
    await cadastrar(tester, 'Outro aluno', ' 566682 ');
    expect(
      find.text('Esta identificação já está no ambiente.'),
      findsOneWidget,
    );
    expect(find.text('1 / 30'), findsOneWidget);
    final salvas = await PessoaRepository().getListaPessoas();
    expect(salvas.length, 1);
    expect(salvas.single.identificacao, '566682');
  });

  testWidgets('Bloqueia entrada quando há 30 pessoas presentes', (
    tester,
  ) async {
    await abrir(tester, List.generate(30, pessoa));
    await cadastrar(tester, 'Mais um aluno', '31');
    expect(find.text('30 / 30'), findsOneWidget);
    expect(find.text('Laboratório lotado'), findsOneWidget);
    expect(
      find.text('Ambiente lotado! Não é possível registrar uma nova entrada.'),
      findsOneWidget,
    );
    expect((await PessoaRepository().getListaPessoas()).length, 30);
  });

  testWidgets(
    'Cancela e confirma saída, bloqueia repetição e permite nova entrada',
    (tester) async {
      await abrir(tester, [pessoa(1)]);
      await deslizar(tester);
      await tester.tap(find.text('Saída'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Cancelar'));
      await tester.pumpAndSettle();
      expect(find.text('1 / 30'), findsOneWidget);
      await deslizar(tester);
      await tester.tap(find.text('Saída'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Confirmar'));
      await tester.pumpAndSettle();
      expect(find.text('0 / 30'), findsOneWidget);
      expect(find.text('Saiu'), findsOneWidget);
      expect(
        (await PessoaRepository().getListaPessoas()).single.dataSaida,
        isNotNull,
      );
      await deslizar(tester);
      await tester.tap(find.text('Saída'));
      await tester.pumpAndSettle();
      expect(
        find.text('A saída desta pessoa já foi registrada.'),
        findsOneWidget,
      );
      await cadastrar(tester, 'Aluno 1', '1');
      expect(find.text('1 / 30'), findsOneWidget);
      expect((await PessoaRepository().getListaPessoas()).length, 2);
    },
  );

  testWidgets('Excluir uma pessoa presente libera a vaga e salva a lista', (
    tester,
  ) async {
    await abrir(tester, [pessoa(1)]);
    await deslizar(tester);
    await tester.tap(find.text('Excluir'));
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(TextButton, 'Excluir'));
    await tester.pumpAndSettle();
    expect(find.text('0 / 30'), findsOneWidget);
    expect(find.text('Nenhuma pessoa cadastrada.'), findsOneWidget);
    expect(await PessoaRepository().getListaPessoas(), isEmpty);
  });

  testWidgets('Tela pequena com teclado continua rolando sem overflow', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(360, 640);
    tester.view.devicePixelRatio = 1;
    tester.view.viewInsets = const FakeViewPadding(bottom: 300);
    addTearDown(tester.view.reset);
    await abrir(tester);
    await tester.ensureVisible(find.text('Cadastrar'));
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
  });
}
