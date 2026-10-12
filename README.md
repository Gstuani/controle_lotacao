# Controle do laboratório

Aplicativo do Checkpoint 02 de Mobile Application Development, feito em Flutter/Dart para controlar a entrada e a saída de pessoas em um laboratório com capacidade de 30 pessoas.

## Integrantes

- Guilherme Soares - RM 568227 - [Guilherme-Soares00](https://github.com/Guilherme-Soares00)
- Gabriel Stuani - RM 566682 - [Gstuani](https://github.com/Gstuani)

## Funcionamento

Preencha o nome e o RM ou identificação para cadastrar uma entrada. A lista mostra os horários e a situação de cada pessoa. Deslize um registro para a esquerda para registrar a saída ou excluir, com confirmação antes da alteração.

O app bloqueia campos vazios, identificações que já estão no ambiente, saídas repetidas e entradas acima da capacidade. Os registros ficam salvos no aparelho. Quem já saiu pode entrar novamente com a mesma identificação.

## Como executar

Com Flutter 3.44 ou superior instalado e um emulador ou celular conectado:

```bash
flutter pub get
flutter run
```

Também é possível executar no navegador:

```bash
flutter run -d chrome
```

Para gerar novamente o ícone:

```bash
dart run flutter_launcher_icons
```

## Tecnologias

Flutter, Dart, intl, flutter_slidable, shared_preferences, google_fonts e flutter_launcher_icons.

## Vídeo

[Demonstração do aplicativo (1min14s)](docs/demonstracao.mp4)
