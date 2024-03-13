import 'package:flutter/material.dart';
import 'package:hive_example/person.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'boxes.dart';

void main() async {
  await Hive.initFlutter();
  Hive.registerAdapter(PersonAdapter());
  boxPersons =  await Hive.openBox<Person>('personsBox');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Hive Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
    
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  TextEditingController nameController = TextEditingController();
  TextEditingController ageController = TextEditingController();


  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // TRY THIS: Try changing the color here to a specific color (to
        // Colors.amber, perhaps?) and trigger a hot reload to see the AppBar
        // change color while the other colors stay the same.
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Column(
        children: [
          const SizedBox(height: 10.0),
          Padding(
            padding: const EdgeInsets.all(5.0),
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  children: [
                    TextField(
                      controller: nameController,
                      decoration: const InputDecoration(
                        hintText: "Name",
                        border: OutlineInputBorder(),
                        ),
                    ),
                    const SizedBox(height: 10.0,),
                    TextField(
                      controller: ageController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        border:  OutlineInputBorder(),
                        hintText: "Age",
                      ),
                    ),
                    const SizedBox(height: 10.0,),
                    TextButton(onPressed: (){
                      setState(() {
                        Person pers = Person(name: nameController.text, age: int.parse(ageController.text) );
                        boxPersons.put(
                          //'key_${nameController.text}',
                          pers.hashCode,
                          pers
                        );
                      });

                    },
                     child: const Text("Add"))
                  ],
                ),
              ),
            
          ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(5.0),
              child: Card(
                child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: ListView.builder(
                        itemCount: boxPersons.length,
                        itemBuilder: (context, index){
                          Person pers = boxPersons.getAt(index);
                              return ListTile(
                                    leading: IconButton(
                                      onPressed: (){
                                        setState(() {
                                          boxPersons.deleteAt(index);
                                        });
                                        //Todo .deleteAtA()

                                      },
                                      icon: const Icon(
                                        Icons.remove,
                                      ),
                                      ),
                                      title: Text(pers.name),
                                      subtitle: const Text("Name"),
                                      trailing: Text('age: ${pers.age.toString()}'),
                              );
                        },

                    ),
                    ),
              )
            )
          ),
          TextButton.icon(
            onPressed: (){
              setState(() {
                 boxPersons.clear();
              });
            },
            icon: const Icon(Icons.delete_outline),
            label: const Text("Delete All"),
          ),

        ],
      ),
    );
  }
}
