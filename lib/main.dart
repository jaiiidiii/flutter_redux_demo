import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:redux/redux.dart';
import 'package:flutter_redux/flutter_redux.dart';

void main() => runApp(const MyApp());

@immutable
class AppState {
  final counter;
  const AppState(this.counter);
}

//action
enum Action { increment, decrement }

//pure function
AppState reducer(AppState prev, action) {
  if (action == Action.increment) {
    return AppState(prev.counter + 1);
  } else if (action == Action.decrement) {
    return AppState(prev.counter - 1);
  }
  return prev;
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData.dark(),
      debugShowCheckedModeBanner: false,
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  final store = Store(reducer, initialState: const AppState(0));

  @override
  Widget build(BuildContext context) {
    return StoreProvider(
        store: store,
        child: Scaffold(
          appBar: AppBar(
            title: const Text("Redux App"),
          ),
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const Text(
                  'You have pushed the button this many times:',
                ),
                StoreConnector<AppState, int>(
                  converter: (store) => store.state.counter,
                  builder: (context, counter) => Text(
                    '$counter',
                    style: Theme.of(context).textTheme.displayMedium,
                  ),
                )
              ],
            ),
          ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerFloat,
          floatingActionButton: SizedBox(
            child: Padding(
              padding: const EdgeInsets.all(64.0),
              child: Row(
                // mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  StoreConnector<AppState, VoidCallback>(
                    converter: (store) {
                      return () => store.dispatch(Action.decrement);
                    },
                    builder: (context, callback) => FloatingActionButton(
                      onPressed: callback,
                      tooltip: 'Decrement',
                      child: const Icon(Icons.remove),
                    ), // This trailing comma makes auto-formatting nicer for build methods.
                  ),
                  Spacer(),
                  StoreConnector<AppState, VoidCallback>(
                    converter: (store) {
                      return () => store.dispatch(Action.increment);
                    },
                    builder: (context, callback) => FloatingActionButton(
                      onPressed: callback,
                      tooltip: 'Increment',
                      child: const Icon(Icons.add),
                    ), // This trailing comma makes auto-formatting nicer for build methods.
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}
