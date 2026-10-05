import 'package:flutter_test/flutter_test.dart';
import 'package:compras/main.dart';

void main() {
  testWidgets(
    'Aplicativo de tarefas inicia corretamente',
    (WidgetTester tester) async {
      await tester.pumpWidget(const MainApp());

      // Verifica o título principal
      expect(find.text('2Do MinimaList'), findsOneWidget);

      // Verifica as tarefas iniciais
      expect(
        find.text('Comprar pão, leite e ovo'),
        findsOneWidget,
      );

      expect(
        find.text('Responder e-mails do trabalho'),
        findsOneWidget,
      );

      expect(
        find.text('Academia às 18h'),
        findsOneWidget,
      );

      // Verifica o botão para adicionar tarefa
      expect(find.text('Nova tarefa'), findsOneWidget);
    },
  );
}