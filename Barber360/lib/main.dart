import 'package:flutter/material.dart';
import '../models/person.dart';
import '../services/person_service.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.blue,
        scaffoldBackgroundColor: const Color(0xFFF7F8FA),
      ),
      home: PersonList(),
    );
  }
}

class PersonList extends StatefulWidget {
  @override
  State<PersonList> createState() => _PersonListState();
}

class _PersonListState extends State<PersonList> {
  final PersonService service = PersonService();
  List<Person> persons = [];

  @override
  void initState() {
    super.initState();
    loadPersons();
  }

  Future<void> loadPersons() async {
    final data = await service.getAll();
    setState(() => persons = data);
  }

  Future<void> deletePerson(int id) async {
    await service.delete(id);
    loadPersons();
  }

  void openForm({Person? person}) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) =>
            PersonForm(onSave: loadPersons, person: person),
      ),
    );
  }

  String formatDateDisplay(String date) {
    try {
      final d = DateTime.parse(date);
      return "${d.day}/${d.month}/${d.year}";
    } catch (_) {
      return date;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Personas"),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => openForm(),
        child: const Icon(Icons.add),
      ),
      body: persons.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: persons.length,
        itemBuilder: (context, index) {
          final p = persons[index];

          return TweenAnimationBuilder(
            duration:
            Duration(milliseconds: 400 + index * 100),
            tween: Tween<double>(begin: 0, end: 1),
            builder: (context, double value, child) {
              return Opacity(
                opacity: value,
                child: Transform.translate(
                  offset: Offset(0, (1 - value) * 20),
                  child: child,
                ),
              );
            },
            child: Dismissible(
              key: Key(p.id.toString()),
              direction: DismissDirection.endToStart,
              onDismissed: (_) => deletePerson(p.id),
              background: Container(
                decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(20),
                ),
                alignment: Alignment.centerRight,
                padding: const EdgeInsets.symmetric(
                    horizontal: 20),
                margin: const EdgeInsets.symmetric(vertical: 8),
                child:
                const Icon(Icons.delete, color: Colors.white),
              ),
              child: Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
                margin:
                const EdgeInsets.symmetric(vertical: 8),
                child: ListTile(
                  onTap: () => openForm(person: p),
                  contentPadding:
                  const EdgeInsets.all(16),
                  leading: CircleAvatar(
                    child: Text(
                        p.name.isNotEmpty ? p.name[0] : '?'),
                  ),
                  title: Text(
                    p.name,
                    style: const TextStyle(
                        fontWeight: FontWeight.w600),
                  ),
                  subtitle: Column(
                    crossAxisAlignment:
                    CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 5),
                      Text("📧 ${p.email}"),
                      Text("🆔 ${p.identification}"),
                      Text(
                          " ${formatDateDisplay(p.birthDate)}"),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class PersonForm extends StatefulWidget {
  final VoidCallback onSave;
  final Person? person;

  const PersonForm({required this.onSave, this.person});

  @override
  State<PersonForm> createState() => _PersonFormState();
}

class _PersonFormState extends State<PersonForm> {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final identificationController =
  TextEditingController();

  final PersonService service = PersonService();

  DateTime? selectedDate;

  @override
  void initState() {
    super.initState();

    if (widget.person != null) {
      final p = widget.person!;
      nameController.text = p.name;
      emailController.text = p.email;
      identificationController.text = p.identification;
      selectedDate = DateTime.tryParse(p.birthDate);
    }
  }

  String formatDate(DateTime date) {
    return "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";
  }

  Future<void> pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime(2000),
      firstDate: DateTime(1950),
      lastDate: DateTime.now(),
    );

    if (picked != null) {
      setState(() => selectedDate = picked);
    }
  }

  Future<void> save() async {
    if (nameController.text.isEmpty ||
        emailController.text.isEmpty ||
        identificationController.text.isEmpty ||
        selectedDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text(" Completa todos los campos")),
      );
      return;
    }

    final person = Person(
      id: widget.person?.id ?? 0,
      name: nameController.text,
      email: emailController.text,
      identification: identificationController.text,
      birthDate: formatDate(selectedDate!),
    );

    if (widget.person != null) {
      await service.update(person);
    } else {
      await service.create(person);
    }

    widget.onSave();
    Navigator.pop(context);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(widget.person != null
            ? "Actualizado "
            : "Creado "),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.person != null
            ? "Editar Persona"
            : "Nueva Persona"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: nameController,
              decoration:
              const InputDecoration(labelText: "Nombre"),
            ),
            TextField(
              controller: emailController,
              decoration:
              const InputDecoration(labelText: "Email"),
            ),
            TextField(
              controller: identificationController,
              decoration:
              const InputDecoration(labelText: "Cédula"),
            ),
            const SizedBox(height: 15),
            GestureDetector(
              onTap: pickDate,
              child: Container(
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Row(
                  mainAxisAlignment:
                  MainAxisAlignment.spaceBetween,
                  children: [
                    Text(selectedDate == null
                        ? "Seleccionar fecha"
                        : "${formatDate(selectedDate!)}"),
                    const Icon(Icons.calendar_month),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: save,
              child: const Text("Guardar"),
            ),
          ],
        ),
      ),
    );
  }
}