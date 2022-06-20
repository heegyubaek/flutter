import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Material App',
      home: MyStatelessWidget(),
    );
  }
}

class MyStatelessWidget extends StatelessWidget {
  const MyStatelessWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AppBar Demo'),
        leading: IconButton(
          icon: Image.asset("assets/shiba1.png", width: 50, height: 40),
          tooltip: 'introduce',
          onPressed: () {
            showDialog(
                context: context,
                builder: (BuildContext context) {
                  return buildSimpleDialog(context);
                });
          },
        ),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.add_alert),
            tooltip: 'Show Snackbar',
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('This is a snackbar')));
            },
          ),
          IconButton(
            icon: const Icon(Icons.navigate_next),
            tooltip: 'Go to the next page',
            onPressed: () {
              Navigator.push(context, MaterialPageRoute<void>(
                builder: (BuildContext context) {
                  return Scaffold(
                    appBar: AppBar(
                      title: const Text('Next page'),
                    ),
                    body: const Center(
                      child: Text(
                        'This is the next page',
                        style: TextStyle(fontSize: 24),
                      ),
                    ),
                  );
                },
              ));
            },
          ),
        ],
      ),
      body: Center(
        child: Container(
          child: Column(
            children: [
              const Image(image: AssetImage('assets/shiba1.png')),
              Text(
                'This is the home page',
                style: TextStyle(fontSize: 24),
              ),
            ],
          ),
        ),
      ),
    );
  }

  SimpleDialog buildSimpleDialog(BuildContext context) {
    return SimpleDialog(
      title: Text("Introduce"),
      children: [
        SimpleDialogOption(
          onPressed: () => Navigator.pop(context, "yo"),
          child: const Text("Hi Shiba"),
        ),
        TextButton(
          child: Text(
            '확인',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.blue),
          ),
          onPressed:() => Navigator.of(context).pop(),
        )
      ],
    );
  }
}
