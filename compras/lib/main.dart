// Importa a biblioteca principal do Flutter com os componentes visuais Material Design.
import 'package:flutter/material.dart';


// A função main() é o primeiro ponto executado quando o aplicativo inicia.
void main() {
  // runApp coloca o widget principal na tela.
  runApp(const MainApp());
}

// Criando constantes para não repetir códigos de cores em todo o arquivo.
const Color corPrincipal = Color.fromARGB(255, 245, 210, 36);
const Color corPrincipalEscura = Color.fromARGB(255, 197, 109, 22);
const Color corFundo = Color(0xFFF4F7F7);
const Color corTexto = Color(0xFF202A2A);
const Color corTextoSecundario = Color.fromARGB(255, 85, 43, 67);


// StatelessWidget é usado porque esta classe apenas configura o aplicativo.
// Ela não precisa guardar informações que mudam durante o uso.
class MainApp extends StatelessWidget {
  // Construtor constante melhora a otimização do Flutter.
  const MainApp({super.key});

  // build() descreve o que este widget vai mostrar.
  @override
  Widget build(BuildContext context) {
    // MaterialApp configura tema, nome e tela inicial do aplicativo.
    return MaterialApp(
      // Remove a faixa vermelha "DEBUG" do canto da tela.
      debugShowCheckedModeBanner: false,

      // Nome interno do aplicativo.
      title: '2Do MinimaList',

      // Tema visual usado em todas as telas.
      theme: ThemeData(
        // Ativa o Material Design 3.
        useMaterial3: true,

        // Define a cor principal usada pelo Flutter para criar o esquema de cores.
        colorScheme: ColorScheme.fromSeed(
          seedColor: corPrincipal,
          brightness: Brightness.light,
        ),

        // Define a cor padrão do fundo das telas.
        scaffoldBackgroundColor: corFundo,

        // Configuração padrão das barras superiores.
        appBarTheme: const AppBarTheme(
          // Remove a elevação/sombra tradicional da AppBar.
          elevation: 0,

          // Mantém o título alinhado à esquerda.
          centerTitle: false,

          // Define fundo transparente, pois criaremos um cabeçalho personalizado.
          backgroundColor: Colors.transparent,

          // Define a cor dos ícones e textos da AppBar.
          foregroundColor: Colors.white,

          // Impede que a AppBar adicione uma cor quando rolamos a lista.
          surfaceTintColor: Colors.transparent,
        ),

        // Configuração global dos campos de texto.
        inputDecorationTheme: InputDecorationTheme(
          // Coloca um fundo nos campos.
          filled: true,

          // Define a cor do fundo do campo.
          fillColor: Colors.white,

          // Define o espaçamento interno.
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 15,
          ),

          // Borda normal do campo.
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none,
          ),

          // Borda quando o campo está habilitado.
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(
              color: Colors.grey.shade200,
            ),
          ),

          // Borda quando o usuário toca no campo.
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(
              color: corPrincipal,
              width: 1.8,
            ),
          ),
        ),

        // Configuração padrão dos SnackBars.
        snackBarTheme: SnackBarThemeData(
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
      ),

      // Define a primeira tela exibida.
      home: const TarefaScreen(),
    );
  }
}


// Esta classe representa uma tarefa do aplicativo.
class Tarefa {
  // Identificador único da tarefa.
  final String id;

  // Texto/título da tarefa.
  String titulo;

  // Informa se a tarefa foi concluída.
  bool concluida;

  // Data em que a tarefa foi criada.
  final DateTime criadaEm;

  // Construtor usado para criar uma nova tarefa.
  Tarefa({
    required this.id,
    required this.titulo,
    this.concluida = false,
    DateTime? criadaEm,
  }) : criadaEm = criadaEm ?? DateTime.now();
}


// Enum é uma lista fechada de opções.
// Aqui ele representa os filtros da lista.
enum FiltroTarefa {
  todas,
  pendentes,
  concluidas,
}

// StatefulWidget é usado porque a tela muda conforme o usuário interage. (tela principal )
class TarefaScreen extends StatefulWidget {
  // Construtor da tela principal.
  const TarefaScreen({super.key});

  // Cria o objeto de estado responsável por controlar a tela.
  @override
  State<TarefaScreen> createState() => _TarefaScreenState();
}

// Classe que guarda todos os dados mutáveis da tela principal.
class _TarefaScreenState extends State<TarefaScreen> {
  

  // Lista inicial apenas para demonstração.
  // Você pode apagar essas tarefas se quiser iniciar o app vazio.
  final List<Tarefa> _tarefas = [
    Tarefa(
      id: '1',
      titulo: 'Comprar pão, leite e ovos',
    ),
    Tarefa(
      id: '2',
      titulo: 'Responder os e-mails importantes',
      concluida: true,
    ),
    Tarefa(
      id: '3',
      titulo: 'Estudar para a prova',
    ),
  ];



  // Controla o texto digitado no campo de adicionar/editar tarefa.
  final TextEditingController _tarefaController = TextEditingController();

  // Controla o texto digitado na barra de pesquisa.
  final TextEditingController _pesquisaController = TextEditingController();

 

  // Guarda qual filtro está selecionado atualmente.
  FiltroTarefa _filtroAtual = FiltroTarefa.todas;

  // Guarda o texto usado na pesquisa.
  String _pesquisa = '';

  // ==========================================================
  // GETTERS / VALORES CALCULADOS
  // ==========================================================

  // Retorna a quantidade de tarefas pendentes.
  int get _quantidadePendentes {
    return _tarefas.where((tarefa) => !tarefa.concluida).length;
  }

  // Retorna a quantidade de tarefas concluídas.
  int get _quantidadeConcluidas {
    return _tarefas.where((tarefa) => tarefa.concluida).length;
  }

  // Retorna a porcentagem de conclusão entre 0.0 e 1.0.
  double get _progresso {
    // Evita divisão por zero quando não existem tarefas.
    if (_tarefas.isEmpty) {
      return 0;
    }

    // Calcula concluídas dividido pelo total.
    return _quantidadeConcluidas / _tarefas.length;
  }

  // Retorna uma lista já filtrada e pesquisada.
  List<Tarefa> get _tarefasVisiveis {
    // Começamos fazendo uma cópia da lista original.
    List<Tarefa> resultado = List<Tarefa>.from(_tarefas);

    // Aplica o filtro escolhido.
    switch (_filtroAtual) {
      case FiltroTarefa.todas:
        // Não precisa alterar nada.
        break;

      case FiltroTarefa.pendentes:
        // Mantém apenas tarefas ainda não concluídas.
        resultado = resultado
            .where((tarefa) => !tarefa.concluida)
            .toList();
        break;

      case FiltroTarefa.concluidas:
        // Mantém apenas tarefas concluídas.
        resultado = resultado
            .where((tarefa) => tarefa.concluida)
            .toList();
        break;
    }

    // Remove espaços extras e deixa a busca em letras minúsculas.
    final String textoPesquisa = _pesquisa.trim().toLowerCase();

    // Só aplica a busca quando existe algo digitado.
    if (textoPesquisa.isNotEmpty) {
      resultado = resultado.where((tarefa) {
        // Converte o título da tarefa para minúsculas.
        final String titulo = tarefa.titulo.toLowerCase();

        // Mantém apenas títulos que possuem o texto pesquisado.
        return titulo.contains(textoPesquisa);
      }).toList();
    }

    // Ordena colocando pendentes primeiro e concluídas depois.
    resultado.sort((a, b) {
      // Se uma está concluída e a outra não, a pendente vem primeiro.
      if (a.concluida != b.concluida) {
        return a.concluida ? 1 : -1;
      }

      // Caso tenham o mesmo status, a mais recente vem primeiro.
      return b.criadaEm.compareTo(a.criadaEm);
    });

    // Devolve a lista pronta para aparecer na tela.
    return resultado;
  }

  // ==========================================================
  // ADICIONAR NOVA TAREFA
  // ==========================================================

  // Abre o painel inferior usado para criar uma tarefa.
  void _abrirNovaTarefa() {
    // Limpa qualquer texto antigo do campo.
    _tarefaController.clear();

    // Abre o formulário sem passar uma tarefa existente.
    _abrirFormularioTarefa();
  }

  // ==========================================================
  // EDITAR TAREFA
  // ==========================================================

  // Abre o painel inferior preenchido com os dados da tarefa escolhida.
  void _abrirEdicaoTarefa(Tarefa tarefa) {
    // Coloca o título atual no campo de texto.
    _tarefaController.text = tarefa.titulo;

    // Abre o mesmo formulário, mas informa qual tarefa será editada.
    _abrirFormularioTarefa(tarefa: tarefa);
  }

  // ==========================================================
  // FORMULÁRIO DE ADICIONAR / EDITAR
  // ==========================================================

  // Este método é reutilizado para criar e editar tarefas.
  void _abrirFormularioTarefa({Tarefa? tarefa}) {
    // Se tarefa for diferente de null, significa que estamos editando.
    final bool editando = tarefa != null;

    // Abre um BottomSheet que sobe pela parte inferior da tela.
    showModalBottomSheet<void>(
      context: context,

      // Permite que o painel se ajuste quando o teclado aparecer.
      isScrollControlled: true,

      // Deixa o fundo do BottomSheet transparente para o Container decidir o visual.
      backgroundColor: Colors.transparent,

      // builder constrói o conteúdo do painel.
      builder: (BuildContext bottomSheetContext) {
        // SafeArea impede que o conteúdo encoste nas áreas do sistema.
        return SafeArea(
          top: false,
          child: Container(
            // Espaço lateral e superior.
            padding: EdgeInsets.fromLTRB(
              20,
              16,
              20,
              // Adiciona espaço equivalente ao teclado + 20 pixels.
              MediaQuery.of(bottomSheetContext).viewInsets.bottom + 20,
            ),

            // Decoração do painel.
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(28),
              ),
            ),

            // Wrap permite que o conteúdo ocupe apenas o espaço necessário.
            child: Wrap(
              children: [
                // Coluna principal do formulário.
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Pequena barra decorativa no topo.
                    Center(
                      child: Container(
                        width: 42,
                        height: 5,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade300,
                          borderRadius: BorderRadius.circular(99),
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Linha com ícone e textos do formulário.
                    Row(
                      children: [
                        // Fundo circular do ícone.
                        Container(
                          width: 48,
                          height: 48,
                          decoration: BoxDecoration(
                            color: corPrincipal.withAlpha(28),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Icon(
                            editando
                                ? Icons.edit_rounded
                                : Icons.add_task_rounded,
                            color: corPrincipal,
                          ),
                        ),

                        const SizedBox(width: 12),

                        // Textos ocupam o espaço restante da linha.
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Título muda de acordo com a ação.
                              Text(
                                editando ? 'Editar tarefa' : 'Nova tarefa',
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w800,
                                  color: corTexto,
                                ),
                              ),

                              const SizedBox(height: 3),

                              // Texto auxiliar.
                              Text(
                                editando
                                    ? 'Altere o texto e salve as mudanças.'
                                    : 'Adicione uma atividade à sua lista.',
                                style: const TextStyle(
                                  fontSize: 13,
                                  color: corTextoSecundario,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),

                    // Campo de texto da tarefa.
                    TextField(
                      controller: _tarefaController,
                      autofocus: true,
                      textCapitalization: TextCapitalization.sentences,
                      maxLength: 100,
                      decoration: const InputDecoration(
                        labelText: 'Descrição da tarefa',
                        hintText: 'Ex.: Fazer o trabalho de história',
                        prefixIcon: Icon(Icons.edit_note_rounded),
                      ),

                      // Enter no teclado também salva.
                      onSubmitted: (_) {
                        _salvarTarefa(
                          tarefaEditada: tarefa,
                          bottomSheetContext: bottomSheetContext,
                        );
                      },
                    ),

                    const SizedBox(height: 6),

                    // Botão principal do formulário.
                    FilledButton.icon(
                      onPressed: () {
                        _salvarTarefa(
                          tarefaEditada: tarefa,
                          bottomSheetContext: bottomSheetContext,
                        );
                      },
                      style: FilledButton.styleFrom(
                        backgroundColor: corPrincipal,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      icon: Icon(
                        editando
                            ? Icons.save_rounded
                            : Icons.add_rounded,
                      ),
                      label: Text(
                        editando ? 'Salvar alterações' : 'Adicionar tarefa',
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // ==========================================================
  // SALVAR TAREFA
  // ==========================================================

  // Salva uma nova tarefa ou atualiza uma existente.
  void _salvarTarefa({
    required BuildContext bottomSheetContext,
    Tarefa? tarefaEditada,
  }) {
    // Remove espaços desnecessários antes e depois do texto.
    final String texto = _tarefaController.text.trim();

    // Não permite salvar uma tarefa sem texto.
    if (texto.isEmpty) {
      // Mostra uma mensagem curta para o usuário.
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Digite uma descrição para a tarefa.'),
        ),
      );

      // Interrompe o método.
      return;
    }

    // setState informa ao Flutter que os dados mudaram.
    setState(() {
      // Se tarefaEditada for null, estamos criando uma nova tarefa.
      if (tarefaEditada == null) {
        // Adiciona a tarefa no início da lista.
        _tarefas.insert(
          0,
          Tarefa(
            // Usa o horário atual para gerar um ID simples e único.
            id: DateTime.now().microsecondsSinceEpoch.toString(),
            titulo: texto,
          ),
        );
      } else {
        // Quando estamos editando, apenas substituímos o título.
        tarefaEditada.titulo = texto;
      }
    });

    // Limpa o campo depois de salvar.
    _tarefaController.clear();

    // Fecha o BottomSheet atual.
    Navigator.of(bottomSheetContext).pop();

    // Mostra uma confirmação na parte inferior da tela.
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          tarefaEditada == null
              ? 'Tarefa adicionada com sucesso!'
              : 'Tarefa atualizada com sucesso!',
        ),
      ),
    );
  }

  // ==========================================================
  // ALTERAR STATUS DA TAREFA
  // ==========================================================

  // Alterna entre tarefa pendente e concluída.
  void _alternarStatus(Tarefa tarefa) {
    // Atualiza o estado da tela.
    setState(() {
      // Inverte o valor atual: true vira false e false vira true.
      tarefa.concluida = !tarefa.concluida;
    });
  }

  // ==========================================================
  // CONFIRMAR EXCLUSÃO
  // ==========================================================

  // Exibe uma caixa de diálogo antes de apagar definitivamente.
  Future<void> _confirmarExclusao(Tarefa tarefa) async {
    // showDialog retorna true ou false conforme o botão escolhido.
    final bool? confirmou = await showDialog<bool>(
      context: context,
      builder: (BuildContext dialogContext) {
        // AlertDialog cria uma caixa de diálogo padrão do Material Design.
        return AlertDialog(
          icon: const Icon(
            Icons.delete_outline_rounded,
            color: Colors.redAccent,
            size: 34,
          ),
          title: const Text('Excluir tarefa?'),
          content: Text(
            'A tarefa “${tarefa.titulo}” será removida da lista.',
          ),
          actions: [
            // Botão de cancelar.
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop(false);
              },
              child: const Text('Cancelar'),
            ),

            // Botão de confirmar a exclusão.
            FilledButton(
              onPressed: () {
                Navigator.of(dialogContext).pop(true);
              },
              style: FilledButton.styleFrom(
                backgroundColor: Colors.redAccent,
                foregroundColor: Colors.white,
              ),
              child: const Text('Excluir'),
            ),
          ],
        );
      },
    );

    // Só exclui quando o usuário confirmou explicitamente.
    if (confirmou == true) {
      _deletarTarefa(tarefa);
    }
  }

  // ==========================================================
  // EXCLUIR TAREFA
  // ==========================================================

  // Remove uma tarefa e oferece a opção de desfazer.
  void _deletarTarefa(Tarefa tarefa) {
    // Descobre a posição original da tarefa na lista.
    final int indice = _tarefas.indexOf(tarefa);

    // Se a tarefa não existir, não fazemos nada.
    if (indice == -1) {
      return;
    }

    // Atualiza o estado removendo a tarefa.
    setState(() {
      _tarefas.removeAt(indice);
    });

    // Remove qualquer SnackBar anterior antes de mostrar outro.
    ScaffoldMessenger.of(context).hideCurrentSnackBar();

    // Mostra a mensagem com botão de desfazer.
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('“${tarefa.titulo}” foi excluída.'),
        action: SnackBarAction(
          label: 'DESFAZER',
          onPressed: () {
            // Reinsere a tarefa na mesma posição original.
            setState(() {
              // Garante que o índice continua válido.
              final int indiceSeguro = indice.clamp(0, _tarefas.length).toInt();
              _tarefas.insert(indiceSeguro, tarefa);
            });
          },
        ),
      ),
    );
  }

  // ==========================================================
  // LIMPAR CONCLUÍDAS
  // ==========================================================

  // Remove todas as tarefas já concluídas.
  Future<void> _limparConcluidas() async {
    // Se não houver nenhuma concluída, apenas avisa o usuário.
    if (_quantidadeConcluidas == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Não existem tarefas concluídas para remover.'),
        ),
      );
      return;
    }

    // Pergunta ao usuário antes de apagar várias tarefas.
    final bool? confirmou = await showDialog<bool>(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Limpar concluídas?'),
          content: Text(
            '$_quantidadeConcluidas tarefa(s) concluída(s) serão removidas.',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop(false);
              },
              child: const Text('Cancelar'),
            ),
            FilledButton(
              onPressed: () {
                Navigator.of(dialogContext).pop(true);
              },
              child: const Text('Limpar'),
            ),
          ],
        );
      },
    );

    // Encerra se o usuário não confirmar.
    if (confirmou != true) {
      return;
    }

    // Remove todas as concluídas.
    setState(() {
      _tarefas.removeWhere((tarefa) => tarefa.concluida);
    });

    // Informa que a limpeza foi concluída.
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Tarefas concluídas removidas.'),
      ),
    );
  }

  // ==========================================================
  // ALTERAR FILTRO
  // ==========================================================

  // Atualiza o filtro selecionado.
  void _selecionarFiltro(FiltroTarefa filtro) {
    setState(() {
      _filtroAtual = filtro;
    });
  }

  // ==========================================================
  // BUILD PRINCIPAL DA TELA
  // ==========================================================

  @override
  Widget build(BuildContext context) {
    // Obtém a lista final que realmente será mostrada.
    final List<Tarefa> tarefasVisiveis = _tarefasVisiveis;

    // Scaffold fornece a estrutura básica da tela.
    return Scaffold(
      // Cor de fundo da tela.
      backgroundColor: corFundo,

      // SafeArea evita que o conteúdo fique atrás da barra do sistema.
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            // Cabeçalho colorido do aplicativo.
            _cabecalho(),

            // Restante da tela ocupa todo o espaço disponível.
            Expanded(
              child: Column(
                children: [
                  // Campo de pesquisa.
                  _barraPesquisa(),

                  // Filtros: Todas, Pendentes e Concluídas.
                  _barraFiltros(),

                  // Linha com título e botão de limpar concluídas.
                  _cabecalhoLista(tarefasVisiveis.length),

                  // Lista ocupa o espaço restante.
                  Expanded(
                    child: _conteudoLista(tarefasVisiveis),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),

      // Botão flutuante para criar uma nova tarefa.
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _abrirNovaTarefa,
        backgroundColor: corPrincipal,
        foregroundColor: Colors.white,
        elevation: 3,
        icon: const Icon(Icons.add_rounded),
        label: const Text(
          'Nova tarefa',
          style: TextStyle(
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }

  // ==========================================================
  // CABEÇALHO SUPERIOR
  // ==========================================================

  // Constrói a área colorida no topo da tela.
  Widget _cabecalho() {
    // Container permite definir cor, tamanho e decoração.
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(20, 18, 20, 22),
      decoration: const BoxDecoration(
        // Gradiente deixa o cabeçalho mais moderno.
        gradient: LinearGradient(
          colors: [
            corPrincipalEscura,
            corPrincipal,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        // Arredonda apenas a parte inferior.
        borderRadius: BorderRadius.vertical(
          bottom: Radius.circular(30),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Primeira linha do cabeçalho.
          Row(
            children: [
              // Ícone do aplicativo.
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: Colors.white.withAlpha(35),
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(
                    color: Colors.white.withAlpha(45),
                  ),
                ),
                child: const Icon(
                  Icons.checklist_rounded,
                  color: Colors.white,
                  size: 29,
                ),
              ),

              const SizedBox(width: 12),

              // Nome e frase do aplicativo.
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '2Do MinimaList',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    SizedBox(height: 2),
                    Text(
                      'Organize seu dia de forma simples.',
                      style: TextStyle(
                        color: Color(0xDFFFFFFF),
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),

              // Pequeno indicador com o total de tarefas.
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withAlpha(34),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Text(
                  '${_tarefas.length}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 22),

          // Linha dos dois cartões de resumo.
          Row(
            children: [
              // Cartão de pendentes.
              Expanded(
                child: _cardResumo(
                  icone: Icons.schedule_rounded,
                  numero: _quantidadePendentes,
                  texto: 'Pendentes',
                ),
              ),

              const SizedBox(width: 10),

              // Cartão de concluídas.
              Expanded(
                child: _cardResumo(
                  icone: Icons.task_alt_rounded,
                  numero: _quantidadeConcluidas,
                  texto: 'Concluídas',
                ),
              ),
            ],
          ),

          const SizedBox(height: 18),

          // Linha com texto do progresso.
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Progresso geral',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                '${(_progresso * 100).round()}%',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 13,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),

          const SizedBox(height: 8),

          // Barra visual de progresso.
          ClipRRect(
            borderRadius: BorderRadius.circular(99),
            child: LinearProgressIndicator(
              value: _progresso,
              minHeight: 8,
              backgroundColor: Colors.white.withAlpha(45),
              valueColor: const AlwaysStoppedAnimation<Color>(
                Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ==========================================================
  // CARD DE RESUMO
  // ==========================================================

  // Widget reutilizável usado no cabeçalho.
  Widget _cardResumo({
    required IconData icone,
    required int numero,
    required String texto,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 14,
        vertical: 13,
      ),
      decoration: BoxDecoration(
        color: Colors.white.withAlpha(30),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: Colors.white.withAlpha(35),
        ),
      ),
      child: Row(
        children: [
          // Ícone do cartão.
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: Colors.white.withAlpha(35),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icone,
              color: Colors.white,
              size: 21,
            ),
          ),

          const SizedBox(width: 10),

          // Número e legenda.
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '$numero',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    height: 1,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  texto,
                  style: const TextStyle(
                    color: Color(0xDFFFFFFF),
                    fontSize: 11.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ==========================================================
  // BARRA DE PESQUISA
  // ==========================================================

  // Constrói a caixa usada para pesquisar tarefas pelo texto.
  Widget _barraPesquisa() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 18, 16, 10),
      child: TextField(
        controller: _pesquisaController,
        onChanged: (String valor) {
          // Atualiza a pesquisa a cada letra digitada.
          setState(() {
            _pesquisa = valor;
          });
        },
        decoration: InputDecoration(
          hintText: 'Pesquisar tarefa...',
          prefixIcon: const Icon(
            Icons.search_rounded,
            color: corTextoSecundario,
          ),

          // Mostra botão X somente quando existe pesquisa.
          suffixIcon: _pesquisa.isEmpty
              ? null
              : IconButton(
                  tooltip: 'Limpar pesquisa',
                  onPressed: () {
                    // Limpa o texto do controlador.
                    _pesquisaController.clear();

                    // Limpa também o estado usado para filtrar.
                    setState(() {
                      _pesquisa = '';
                    });
                  },
                  icon: const Icon(Icons.close_rounded),
                ),
        ),
      ),
    );
  }

  // ==========================================================
  // BARRA DE FILTROS
  // ==========================================================

  // Cria os três botões de filtro.
  Widget _barraFiltros() {
    return SizedBox(
      height: 46,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        children: [
          _chipFiltro(
            titulo: 'Todas',
            icone: Icons.list_alt_rounded,
            filtro: FiltroTarefa.todas,
          ),
          const SizedBox(width: 8),
          _chipFiltro(
            titulo: 'Pendentes',
            icone: Icons.schedule_rounded,
            filtro: FiltroTarefa.pendentes,
          ),
          const SizedBox(width: 8),
          _chipFiltro(
            titulo: 'Concluídas',
            icone: Icons.check_circle_outline_rounded,
            filtro: FiltroTarefa.concluidas,
          ),
        ],
      ),
    );
  }

  // Cria um único botão de filtro.
  Widget _chipFiltro({
    required String titulo,
    required IconData icone,
    required FiltroTarefa filtro,
  }) {
    // Verifica se esse filtro é o selecionado no momento.
    final bool selecionado = _filtroAtual == filtro;

    return ChoiceChip(
      selected: selecionado,
      onSelected: (_) {
        _selecionarFiltro(filtro);
      },
      showCheckmark: false,
      avatar: Icon(
        icone,
        size: 18,
        color: selecionado ? Colors.white : corTextoSecundario,
      ),
      label: Text(titulo),
      labelStyle: TextStyle(
        color: selecionado ? Colors.white : corTexto,
        fontWeight: FontWeight.w600,
      ),
      selectedColor: corPrincipal,
      backgroundColor: Colors.white,
      side: BorderSide(
        color: selecionado ? corPrincipal : Colors.grey.shade200,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: 5,
        vertical: 8,
      ),
    );
  }

  // ==========================================================
  // CABEÇALHO DA LISTA
  // ==========================================================

  // Mostra o número de resultados e o botão para limpar concluídas.
  Widget _cabecalhoLista(int quantidadeVisivel) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(18, 14, 10, 5),
      child: Row(
        children: [
          // Título da seção.
          const Text(
            'Minhas tarefas',
            style: TextStyle(
              color: corTexto,
              fontSize: 17,
              fontWeight: FontWeight.w800,
            ),
          ),

          const SizedBox(width: 8),

          // Pequeno contador de resultados visíveis.
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 8,
              vertical: 4,
            ),
            decoration: BoxDecoration(
              color: corPrincipal.withAlpha(20),
              borderRadius: BorderRadius.circular(99),
            ),
            child: Text(
              '$quantidadeVisivel',
              style: const TextStyle(
                color: corPrincipalEscura,
                fontSize: 11,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),

          const Spacer(),

          // Menu com ações extras.
          PopupMenuButton<String>(
            tooltip: 'Mais opções',
            onSelected: (String valor) {
              if (valor == 'limpar_concluidas') {
                _limparConcluidas();
              }
            },
            itemBuilder: (BuildContext context) {
              return const [
                PopupMenuItem<String>(
                  value: 'limpar_concluidas',
                  child: Row(
                    children: [
                      Icon(Icons.cleaning_services_outlined),
                      SizedBox(width: 10),
                      Text('Limpar concluídas'),
                    ],
                  ),
                ),
              ];
            },
            icon: const Icon(
              Icons.more_horiz_rounded,
              color: corTextoSecundario,
            ),
          ),
        ],
      ),
    );
  }

  // ==========================================================
  // CONTEÚDO DA LISTA
  // ==========================================================

  // Decide se mostramos tarefas ou uma tela vazia.
  Widget _conteudoLista(List<Tarefa> tarefasVisiveis) {
    // Se a lista filtrada está vazia, mostra um estado vazio.
    if (tarefasVisiveis.isEmpty) {
      return _estadoVazio();
    }

    // Caso contrário, mostra a lista de tarefas.
    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 110),
      itemCount: tarefasVisiveis.length,
      itemBuilder: (BuildContext context, int index) {
        // Obtém a tarefa correspondente à posição atual.
        final Tarefa tarefa = tarefasVisiveis[index];

        // Constrói o card visual da tarefa.
        return _cardTarefa(tarefa);
      },
    );
  }

  // ==========================================================
  // CARD INDIVIDUAL DA TAREFA
  // ==========================================================

  // Monta o visual de uma única tarefa.
  Widget _cardTarefa(Tarefa tarefa) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: tarefa.concluida
              ? corPrincipal.withAlpha(40)
              : Colors.grey.shade200,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(8),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(18),

        // Tocar no card altera o status.
        onTap: () {
          _alternarStatus(tarefa);
        },
        child: Padding(
          padding: const EdgeInsets.fromLTRB(12, 12, 8, 12),
          child: Row(
            children: [
              // Checkbox da tarefa.
              Checkbox(
                value: tarefa.concluida,
                activeColor: corPrincipal,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5),
                ),
                onChanged: (_) {
                  _alternarStatus(tarefa);
                },
              ),

              const SizedBox(width: 2),

              // Texto da tarefa ocupa todo o espaço disponível.
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Título principal.
                    Text(
                      tarefa.titulo,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 15,
                        height: 1.3,
                        fontWeight: FontWeight.w700,
                        color: tarefa.concluida
                            ? corTextoSecundario
                            : corTexto,
                        decoration: tarefa.concluida
                            ? TextDecoration.lineThrough
                            : TextDecoration.none,
                      ),
                    ),

                    const SizedBox(height: 7),

                    // Linha com o status da tarefa.
                    Row(
                      children: [
                        Icon(
                          tarefa.concluida
                              ? Icons.check_circle_rounded
                              : Icons.circle_outlined,
                          size: 14,
                          color: tarefa.concluida
                              ? corPrincipal
                              : corTextoSecundario,
                        ),
                        const SizedBox(width: 5),
                        Text(
                          tarefa.concluida ? 'Concluída' : 'Pendente',
                          style: TextStyle(
                            color: tarefa.concluida
                                ? corPrincipalEscura
                                : corTextoSecundario,
                            fontSize: 11.5,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 6),

              // Menu individual da tarefa.
              PopupMenuButton<String>(
                tooltip: 'Opções da tarefa',
                onSelected: (String valor) {
                  if (valor == 'editar') {
                    _abrirEdicaoTarefa(tarefa);
                  }

                  if (valor == 'excluir') {
                    _confirmarExclusao(tarefa);
                  }
                },
                itemBuilder: (BuildContext context) {
                  return const [
                    PopupMenuItem<String>(
                      value: 'editar',
                      child: Row(
                        children: [
                          Icon(Icons.edit_outlined),
                          SizedBox(width: 10),
                          Text('Editar'),
                        ],
                      ),
                    ),
                    PopupMenuItem<String>(
                      value: 'excluir',
                      child: Row(
                        children: [
                          Icon(
                            Icons.delete_outline_rounded,
                            color: Colors.redAccent,
                          ),
                          SizedBox(width: 10),
                          Text(
                            'Excluir',
                            style: TextStyle(
                              color: Colors.redAccent,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ];
                },
                icon: const Icon(
                  Icons.more_vert_rounded,
                  color: corTextoSecundario,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ==========================================================
  // ESTADO VAZIO
  // ==========================================================

  // Tela exibida quando nenhuma tarefa corresponde aos filtros.
  Widget _estadoVazio() {
    // Verifica se a lista original está completamente vazia.
    final bool semNenhumaTarefa = _tarefas.isEmpty;

    // Verifica se existe pesquisa digitada.
    final bool pesquisando = _pesquisa.trim().isNotEmpty;

    // Define o título conforme a situação atual.
    final String titulo = semNenhumaTarefa
        ? 'Sua lista está vazia'
        : pesquisando
            ? 'Nenhuma tarefa encontrada'
            : 'Nada por aqui';

    // Define o texto auxiliar conforme a situação.
    final String descricao = semNenhumaTarefa
        ? 'Crie sua primeira tarefa e comece a organizar o seu dia.'
        : pesquisando
            ? 'Tente pesquisar usando outra palavra.'
            : 'Não existem tarefas nesse filtro no momento.';

    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(28, 20, 28, 120),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Círculo decorativo com ícone.
            Container(
              width: 92,
              height: 92,
              decoration: BoxDecoration(
                color: corPrincipal.withAlpha(18),
                shape: BoxShape.circle,
              ),
              child: Icon(
                pesquisando
                    ? Icons.search_off_rounded
                    : Icons.task_alt_rounded,
                size: 46,
                color: corPrincipal,
              ),
            ),

            const SizedBox(height: 20),

            // Título do estado vazio.
            Text(
              titulo,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: corTexto,
                fontSize: 20,
                fontWeight: FontWeight.w800,
              ),
            ),

            const SizedBox(height: 8),

            // Descrição do estado vazio.
            Text(
              descricao,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: corTextoSecundario,
                fontSize: 13.5,
                height: 1.5,
              ),
            ),

            // Só mostra o botão se realmente não houver tarefa nenhuma.
            if (semNenhumaTarefa) ...[
              const SizedBox(height: 22),
              FilledButton.icon(
                onPressed: _abrirNovaTarefa,
                style: FilledButton.styleFrom(
                  backgroundColor: corPrincipal,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 14,
                  ),
                ),
                icon: const Icon(Icons.add_rounded),
                label: const Text('Criar primeira tarefa'),
              ),
            ],
          ],
        ),
      ),
    );
  }

  // ==========================================================
  // DESCARTAR CONTROLADORES
  // ==========================================================

  // dispose é chamado quando esta tela deixa de existir.
  @override
  void dispose() {
    // Libera a memória usada pelo controlador da tarefa.
    _tarefaController.dispose();

    // Libera a memória usada pelo controlador da pesquisa.
    _pesquisaController.dispose();

    // Chama o dispose da classe pai.
    super.dispose();
  }
}
