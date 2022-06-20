import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Material App',
      home: Scaffold(
        appBar: AppBar(
          title: Text('Material App Bar'),
        ),
        body: Column(
          children: <Widget>[
            Text('Deliver features faster'),
            Text('Craft beautiful UIs'),
            Row(
              children: [
                Container(
                  color: Colors.amber,
                  width: 100,
                  height: 150,
                ),
                Expanded(child: Image(image: AssetImage("assets/shiba1.png"))),
              ],
            ),
            Row(
              children: [
                //우선적으로 Size에 맞게 그림
                Container(
                  color: Colors.red,
                  width: 150,
                  height: 100,
                ),
                //Flexible vs Flexible or Expanded 와 비율에 맞춰 화면 채움
                Flexible(
                  //flex : 다른 flex혹은 같은 row or column의 widget과의 비중을 나타냄
                  flex: 2,
                  //FlexFit.loose(Defualt) : Row가 화면의 크기를 넘어갈 경우 화면크기에 맞추고
                  //넘어가지 않는 경우 그 사이즈에 맞춤
                  //FlexFit.tight : Row 화면 크기에 맞춰 남은 공간을 채움
                  fit: FlexFit.tight,
                  child: Container(
                    color: Colors.lime,
                    width: 150,
                    height: 100,
                  ),
                ),
                Flexible(
                  flex: 2,
                  fit: FlexFit.tight,
                  child: Container(
                    color: Colors.blue,
                    width: 150,
                    height: 100,
                  ),
                ),
              ],
            ),
            Expanded(
                child: FittedBox(
              fit: BoxFit.contain,
              child: FlutterLogo(),
            ))
          ],
        ),
      ),
    );
  }
}
