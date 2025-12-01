import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

// Cores personalizadas
class AppColors {
  static const Color lapisLazuli = Color(0xFF26619C);
  static const Color lapisLazuliLight = Color(0xFF4A8BC6);
  static const Color lapisLazuliDark = Color(0xFF1A4773);
  static const Color white = Colors.white;
  static const Color textOnDark = Colors.white;
  static const Color textOnLight = Colors.black87;
  static const Color background = Color(0xFFF5F7FA);
  static const Color cardBackground = Colors.white;
  static const Color error = Color(0xFFD32F2F);
  static const Color success = Color(0xFF388E3C);
}

@HiveType(typeId: 2)
class Paciente extends HiveObject {
  @HiveField(0)
  String nome;

  @HiveField(1)
  DateTime dataNascimento;

  @HiveField(2)
  String cep;

  @HiveField(3)
  String endereco;

  @HiveField(4)
  String observacoes;

  Paciente({
    required this.nome,
    required this.dataNascimento,
    required this.cep,
    required this.endereco,
    required this.observacoes,
  });

  int get idade {
    int idade = DateTime.now().year - dataNascimento.year;
    if (DateTime.now().month < dataNascimento.month ||
        (DateTime.now().month == dataNascimento.month &&
            DateTime.now().day < dataNascimento.day)) {
      idade--;
    }
    return idade;
  }

  @override
  String toString() => nome;
}

class PacienteAdapter extends TypeAdapter<Paciente> {
  @override
  final int typeId = 2;

  @override
  Paciente read(BinaryReader reader) {
    final nome = reader.readString();
    final dataNascimento = DateTime.fromMillisecondsSinceEpoch(reader.readInt());
    final cep = reader.readString();
    final endereco = reader.readString();
    final observacoes = reader.readString();

    return Paciente(
      nome: nome,
      dataNascimento: dataNascimento,
      cep: cep,
      endereco: endereco,
      observacoes: observacoes,
    );
  }

  @override
  void write(BinaryWriter writer, Paciente obj) {
    writer.writeString(obj.nome);
    writer.writeInt(obj.dataNascimento.millisecondsSinceEpoch);
    writer.writeString(obj.cep);
    writer.writeString(obj.endereco);
    writer.writeString(obj.observacoes);
  }
}

@HiveType(typeId: 1)
class Relatorio extends HiveObject {
  @HiveField(0)
  String pacienteNome;

  @HiveField(1)
  DateTime data;

  @HiveField(2)
  bool presencial;

  @HiveField(3)
  int humor;

  @HiveField(4)
  String observacoes;

  Relatorio({
    required this.pacienteNome,
    required this.data,
    required this.presencial,
    required this.humor,
    required this.observacoes,
  });
}

class RelatorioAdapter extends TypeAdapter<Relatorio> {
  @override
  final int typeId = 1;

  @override
  Relatorio read(BinaryReader reader) {
    final pacienteNome = reader.readString();
    final data = DateTime.fromMillisecondsSinceEpoch(reader.readInt());
    final presencial = reader.readBool();
    final humor = reader.readInt();
    final observacoes = reader.readString();

    return Relatorio(
      pacienteNome: pacienteNome,
      data: data,
      presencial: presencial,
      humor: humor,
      observacoes: observacoes,
    );
  }

  @override
  void write(BinaryWriter writer, Relatorio obj) {
    writer.writeString(obj.pacienteNome);
    writer.writeInt(obj.data.millisecondsSinceEpoch);
    writer.writeBool(obj.presencial);
    writer.writeInt(obj.humor);
    writer.writeString(obj.observacoes);
  }
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(PacienteAdapter());
  Hive.registerAdapter(RelatorioAdapter());
  await Hive.openBox<Paciente>('pacientes');
  await Hive.openBox<Relatorio>('relatorios');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'p2_relatorios_psicologo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        primaryColor: AppColors.lapisLazuli,
        colorScheme: ColorScheme.fromSwatch(
          primarySwatch: Colors.blue,
        ).copyWith(
          secondary: AppColors.lapisLazuliLight,
          surface: AppColors.background,
        ),
        scaffoldBackgroundColor: AppColors.background,
        appBarTheme: const AppBarTheme(
          backgroundColor: AppColors.lapisLazuli,
          foregroundColor: AppColors.textOnDark,
          elevation: 4,
        ),
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: AppColors.lapisLazuli,
          foregroundColor: AppColors.textOnDark,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.lapisLazuli,
            foregroundColor: AppColors.textOnDark,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: AppColors.lapisLazuli.withOpacity(0.3)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: AppColors.lapisLazuli, width: 2),
          ),
          filled: true,
          fillColor: Colors.white,
        ),
      ),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  final pages = const [PacientesPage(), RelatoriosPage()];
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        backgroundColor: AppColors.lapisLazuli,
        selectedItemColor: AppColors.textOnDark,
        unselectedItemColor: AppColors.textOnDark.withOpacity(0.7),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Pacientes'),
          BottomNavigationBarItem(icon: Icon(Icons.description), label: 'Relatórios'),
        ],
        onTap: (i) => setState(() => _currentIndex = i),
      ),
    );
  }
}

class PacientesPage extends StatefulWidget {
  const PacientesPage({super.key});
  @override
  State createState() => _PacientesPageState();
}

class _PacientesPageState extends State<PacientesPage> {
  final Box<Paciente> pacientesBox = Hive.box<Paciente>('pacientes');
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pacientes'),
        backgroundColor: AppColors.lapisLazuli,
        foregroundColor: AppColors.textOnDark,
      ),
      body: ValueListenableBuilder<Box<Paciente>>(
        valueListenable: pacientesBox.listenable(),
        builder: (context, box, _) {
          if (box.isEmpty) {
            return Center(
              child: Text(
                'Nenhum paciente cadastrado.',
                style: TextStyle(color: AppColors.textOnLight.withOpacity(0.6)),
              ),
            );
          }
          
          final list = box.values.toList();
          
          return ListView.builder(
            itemCount: list.length,
            padding: const EdgeInsets.all(8),
            itemBuilder: (context, index) {
              final paciente = list[index];
              
              return Card(
                margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                elevation: 2,
                color: AppColors.cardBackground,
                child: ListTile(
                  title: Text(
                    paciente.nome,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    'Idade: ${paciente.idade} • CEP: ${paciente.cep}\nEndereço: ${paciente.endereco}',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  isThreeLine: true,
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (_) => PacienteDetalhesPage(paciente: paciente),
                    ));
                  },
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: AppColors.error),
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text('Confirmar exclusão'),
                          content: Text('Deseja excluir o paciente ${paciente.nome}?'),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: const Text('Cancelar'),
                            ),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.error,
                              ),
                              onPressed: () {
                                paciente.delete();
                                Navigator.pop(context);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Paciente removido'),
                                    backgroundColor: AppColors.success,
                                  ),
                                );
                              },
                              child: const Text('Excluir', style: TextStyle(color: Colors.white)),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.lapisLazuli,
        foregroundColor: AppColors.textOnDark,
        child: const Icon(Icons.add),
        onPressed: () => Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => const AdicionarPacientePage()),
        ),
      ),
    );
  }
}

class PacienteDetalhesPage extends StatelessWidget {
  final Paciente paciente;
  const PacienteDetalhesPage({super.key, required this.paciente});
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detalhes: ${paciente.nome}'),
        backgroundColor: AppColors.lapisLazuli,
        foregroundColor: AppColors.textOnDark,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          elevation: 2,
          color: AppColors.cardBackground,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Nome: ${paciente.nome}', 
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 12),
                _buildInfoRow('Idade:', '${paciente.idade} anos'),
                _buildInfoRow('Nascimento:', DateFormat('dd/MM/yyyy').format(paciente.dataNascimento)),
                _buildInfoRow('CEP:', paciente.cep),
                _buildInfoRow('Endereço:', paciente.endereco),
                const SizedBox(height: 16),
                const Text('Observações:', style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.background,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(paciente.observacoes),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
  
  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(label, style: const TextStyle(fontWeight: FontWeight.w500)),
          ),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }
}

class AdicionarPacientePage extends StatefulWidget {
  const AdicionarPacientePage({super.key});
  @override
  State createState() => _AdicionarPacientePageState();
}

class _AdicionarPacientePageState extends State<AdicionarPacientePage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController nomeController = TextEditingController();
  final TextEditingController cepController = TextEditingController();
  final TextEditingController enderecoController = TextEditingController();
  final TextEditingController obsController = TextEditingController();
  final Box<Paciente> pacientesBox = Hive.box<Paciente>('pacientes');
  bool loadingCep = false;
  DateTime? dataNascimento;

  Future<void> buscarCep() async {
    final cep = cepController.text.trim().replaceAll(RegExp(r'[^0-9]'), '');
    if (cep.length != 8) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('CEP inválido'), backgroundColor: AppColors.error),
        );
      }
      return;
    }
    setState(() => loadingCep = true);
    try {
      final url = Uri.parse('https://viacep.com.br/ws/$cep/json/');
      final res = await http.get(url);
      if (res.statusCode == 200) {
        final data = json.decode(res.body);
        if (data['erro'] == true) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('CEP não encontrado'), backgroundColor: AppColors.error),
            );
          }
        } else {
          final endereco =
              '${data['logradouro'] ?? ''} ${data['bairro'] ?? ''}, ${data['localidade'] ?? ''} - ${data['uf'] ?? ''}';
          enderecoController.text = endereco.trim();
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Endereço preenchido'), backgroundColor: AppColors.success),
            );
          }
        }
      } else {
         if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Erro ao buscar CEP'), backgroundColor: AppColors.error),
            );
          }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro de conexão: $e'), backgroundColor: AppColors.error),
        );
      }
    } finally {
      if (mounted) {
        setState(() => loadingCep = false);
      }
    }
  }

  void salvar() {
    if (!_formKey.currentState!.validate()) return;
    if (dataNascimento == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Selecione a data de nascimento'), backgroundColor: AppColors.error),
      );
      return;
    }
    final paciente = Paciente(
      nome: nomeController.text.trim(),
      dataNascimento: dataNascimento!,
      cep: cepController.text.trim(),
      endereco: enderecoController.text.trim(),
      observacoes: obsController.text.trim(),
    );
    pacientesBox.add(paciente);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Paciente salvo'), backgroundColor: AppColors.success),
    );
    Navigator.of(context).pop();
  }

  @override
  void dispose() {
    nomeController.dispose();
    cepController.dispose();
    enderecoController.dispose();
    obsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Adicionar Paciente'),
        backgroundColor: AppColors.lapisLazuli,
        foregroundColor: AppColors.textOnDark,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: nomeController,
                decoration: const InputDecoration(
                  labelText: 'Nome',
                  prefixIcon: Icon(Icons.person),
                ),
                validator: (v) => (v == null || v.trim().isEmpty) ? 'Informe o nome' : null,
              ),
              const SizedBox(height: 12),
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                elevation: 2,
                child: ListTile(
                  title: Text(
                    dataNascimento == null
                        ? 'Selecione a data de nascimento'
                        : DateFormat('dd/MM/yyyy').format(dataNascimento!),
                  ),
                  trailing: const Icon(Icons.calendar_today, color: AppColors.lapisLazuli),
                  onTap: () async {
                    final dt = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(1900),
                      lastDate: DateTime.now(),
                    );
                    if (dt != null) setState(() => dataNascimento = dt);
                  },
                ),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: cepController,
                decoration: const InputDecoration(
                  labelText: 'CEP',
                  prefixIcon: Icon(Icons.location_on),
                ),
                keyboardType: TextInputType.number,
                validator: (v) => (v == null || v.trim().length < 8) ? 'CEP inválido' : null,
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  if (loadingCep)
                    const SizedBox(width: 24, height: 24, child: CircularProgressIndicator())
                  else
                    ElevatedButton.icon(
                      icon: const Icon(Icons.search, size: 18),
                      label: const Text('Buscar CEP'),
                      onPressed: buscarCep,
                    ),
                ],
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: enderecoController,
                decoration: const InputDecoration(
                  labelText: 'Endereço',
                  prefixIcon: Icon(Icons.home),
                ),
                readOnly: enderecoController.text.isNotEmpty,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: obsController,
                decoration: const InputDecoration(
                  labelText: 'Observações',
                  prefixIcon: Icon(Icons.note),
                ),
                maxLines: 4,
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                icon: const Icon(Icons.save),
                label: const Text('Salvar Paciente'),
                onPressed: salvar,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class RelatoriosPage extends StatefulWidget {
  const RelatoriosPage({super.key});
  @override
  State createState() => _RelatoriosPageState();
}

class _RelatoriosPageState extends State<RelatoriosPage> {
  final Box<Relatorio> relatoriosBox = Hive.box<Relatorio>('relatorios');
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Relatórios'),
        backgroundColor: AppColors.lapisLazuli,
        foregroundColor: AppColors.textOnDark,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton.icon(
              icon: const Icon(Icons.add),
              label: const Text('Novo Relatório'),
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const NovoRelatorioPage()),
                );
              },
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 48),
              ),
            ),
          ),
          Expanded(
            child: ValueListenableBuilder<Box<Relatorio>>(
              valueListenable: relatoriosBox.listenable(),
              builder: (context, box, _) {
                if (box.isEmpty) {
                  return Center(
                    child: Text(
                      'Nenhum relatório cadastrado.',
                      style: TextStyle(color: AppColors.textOnLight.withOpacity(0.6)),
                    ),
                  );
                }
                
                final list = box.values.toList();
                list.sort((a, b) => b.data.compareTo(a.data));
                
                return ListView.builder(
                  itemCount: list.length,
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  itemBuilder: (context, index) {
                    final rel = list[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(vertical: 4),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      elevation: 2,
                      color: AppColors.cardBackground,
                      child: ListTile(
                        title: Row(
                          children: [
                            Expanded(
                              child: Text(
                                rel.pacienteNome,
                                style: const TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                              decoration: BoxDecoration(
                                color: rel.presencial 
                                    ? AppColors.lapisLazuli.withOpacity(0.1)
                                    : Colors.grey.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                rel.presencial ? 'Presencial' : 'Online',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: rel.presencial ? AppColors.lapisLazuli : Colors.grey,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 4),
                            Text(DateFormat('dd/MM/yyyy').format(rel.data)),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                const Text('Humor: '),
                                _buildHumorIndicator(rel.humor),
                                Text(' ${rel.humor}/10'),
                              ],
                            ),
                            if (rel.observacoes.isNotEmpty) ...[
                              const SizedBox(height: 8),
                              Text(
                                rel.observacoes,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(color: AppColors.textOnLight.withOpacity(0.8)),
                              ),
                            ],
                          ],
                        ),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete, color: AppColors.error),
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: const Text('Confirmar exclusão'),
                                content: Text('Deseja excluir o relatório de ${rel.pacienteNome}?'),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.pop(context),
                                    child: const Text('Cancelar'),
                                  ),
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: AppColors.error,
                                    ),
                                    onPressed: () {
                                      rel.delete();
                                      Navigator.pop(context);
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(
                                          content: Text('Relatório excluído'),
                                          backgroundColor: AppColors.success,
                                        ),
                                      );
                                    },
                                    child: const Text('Excluir', style: TextStyle(color: Colors.white)),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildHumorIndicator(int humor) {
    Color color;
    if (humor <= 3) {
      color = Colors.red;
    } else if (humor <= 6) {
      color = Colors.orange;
    } else {
      color = Colors.green;
    }
    
    return Container(
      width: 12,
      height: 12,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
      ),
    );
  }
}

class NovoRelatorioPage extends StatefulWidget {
  const NovoRelatorioPage({super.key});
  @override
  State createState() => _NovoRelatorioPageState();
}

class _NovoRelatorioPageState extends State<NovoRelatorioPage> {
  final Box<Paciente> pacientesBox = Hive.box<Paciente>('pacientes');
  final Box<Relatorio> relatoriosBox = Hive.box<Relatorio>('relatorios');

  String? pacienteSelecionado;
  DateTime dataSelecionada = DateTime.now();
  bool presencial = true;
  double humor = 5;
  final TextEditingController obsController = TextEditingController();

  void salvar() {
    if (pacienteSelecionado == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Selecione um paciente'), backgroundColor: AppColors.error),
      );
      return;
    }
    final rel = Relatorio(
      pacienteNome: pacienteSelecionado!,
      data: dataSelecionada,
      presencial: presencial,
      humor: humor.round(),
      observacoes: obsController.text.trim(),
    );
    relatoriosBox.add(rel);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Relatório salvo'), backgroundColor: AppColors.success),
    );
    Navigator.of(context).pop();
  }

  Future<void> escolherData() async {
    final dt = await showDatePicker(
      context: context,
      initialDate: dataSelecionada,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );
    if (dt != null) setState(() => dataSelecionada = dt);
  }

  @override
  Widget build(BuildContext context) {
    final pacientes = pacientesBox.values.toList();
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Novo Relatório'),
        backgroundColor: AppColors.lapisLazuli,
        foregroundColor: AppColors.textOnDark,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: DropdownButtonFormField<String>(
                  initialValue: pacienteSelecionado,
                  decoration: const InputDecoration(
                    labelText: 'Paciente',
                    border: InputBorder.none,
                    prefixIcon: Icon(Icons.person),
                  ),
                  items: pacientes.isEmpty 
                      ? [] 
                      : pacientes.map((p) => DropdownMenuItem(
                          value: p.nome,
                          child: Text(p.nome),
                        )).toList(),
                  onChanged: (v) => setState(() => pacienteSelecionado = v),
                  validator: (v) => v == null ? 'Selecione um paciente' : null,
                ),
              ),
            ),
            const SizedBox(height: 12),
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              elevation: 2,
              child: ListTile(
                title: Text('Data: ${DateFormat('dd/MM/yyyy').format(dataSelecionada)}'),
                trailing: const Icon(Icons.calendar_today, color: AppColors.lapisLazuli),
                onTap: escolherData,
              ),
            ),
            const SizedBox(height: 12),
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Tipo de Sessão', style: TextStyle(fontWeight: FontWeight.w500)),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                          decoration: BoxDecoration(
                            color: presencial 
                                ? AppColors.lapisLazuli.withOpacity(0.1)
                                : Colors.grey.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                presencial ? Icons.person : Icons.computer,
                                size: 16,
                                color: presencial ? AppColors.lapisLazuli : Colors.grey,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                presencial ? 'Presencial' : 'Online',
                                style: TextStyle(
                                  color: presencial ? AppColors.lapisLazuli : Colors.grey,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    SwitchListTile(
                      title: const Text('Presencial'),
                      value: presencial,
                      onChanged: (v) => setState(() => presencial = v),
                      activeThumbColor: AppColors.lapisLazuli,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Humor do Paciente: ${humor.round()}',
                      style: const TextStyle(fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(height: 8),
                    Text('(1 = Ruim, 10 = Ótimo)', style: TextStyle(color: AppColors.textOnLight.withOpacity(0.6))),
                    const SizedBox(height: 16),
                    Slider(
                      value: humor,
                      min: 1,
                      max: 10,
                      divisions: 9,
                      label: humor.round().toString(),
                      onChanged: (v) => setState(() => humor = v),
                      activeColor: _getHumorColor(humor),
                      inactiveColor: Colors.grey[300],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: List.generate(10, (index) {
                        final value = index + 1;
                        return Column(
                          children: [
                            Container(
                              width: 20,
                              height: 20,
                              decoration: BoxDecoration(
                                color: value <= humor ? _getHumorColor(value.toDouble()) : Colors.grey[300],
                                shape: BoxShape.circle,
                              ),
                            ),
                            Text('$value', style: const TextStyle(fontSize: 10)),
                          ],
                        );
                      }),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Observações',
                      style: TextStyle(fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: obsController,
                      decoration: const InputDecoration(
                        hintText: 'Descreva a sessão...',
                        border: InputBorder.none,
                      ),
                      maxLines: 5,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              icon: const Icon(Icons.save),
              label: const Text('Salvar Relatório'),
              onPressed: salvar,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  Color _getHumorColor(double value) {
    if (value <= 3) {
      return Colors.red;
    } else if (value <= 6) {
      return Colors.orange;
    } else {
      return Colors.green;
    }
  }
}