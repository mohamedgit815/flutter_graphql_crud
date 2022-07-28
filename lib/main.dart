import 'package:flutter/material.dart';
import 'package:flutter_grahpql_app/home_page.dart';
import 'package:flutter_grahpql_app/send_page.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:graphql_flutter/graphql_flutter.dart';


const dataGraphQl = """
query Query {
  getAllUsers {
    favNumber ,
    firstName
  }
}
""";


void main() {
  final HttpLink _httpLink = HttpLink("http://192.168.1.17:4000/graphql");
  //final HttpLink _httpLink = HttpLink("https://demo.saleor.io/graphql/");
  final ValueNotifier<GraphQLClient> _client = ValueNotifier(GraphQLClient(
      link: _httpLink,
      cache: GraphQLCache(store: InMemoryStore())
  ));

  final GraphQLProvider _runApp = GraphQLProvider(
      client: _client, child: const ProviderScope(child: MyApp()));

  runApp(_runApp);
}
class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Example"),actions: [
        IconButton(onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(builder: (context)=>const GraphQlPage()));
        }, icon: const Icon(Icons.add)) ,

        IconButton(onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(builder: (context)=>const SendPage()));
        }, icon: const Icon(Icons.add,color: Colors.green,))
      ],),

      body: Query(
        options: QueryOptions(document: gql(dataGraphQl)),
        builder: (QueryResult result , {FetchMore? fetchMore ,VoidCallback? refetch}) {

          if(result.hasException) {
            return const Text("hasException");
          }

          if(result.isLoading || result.data == null) {
            return const Center(child: CircularProgressIndicator.adaptive());
          }

          return ListView.builder(
              itemCount: result.data!.length ,
              itemBuilder: (context,i) {
                final List<dynamic> _data =  result.data!['getAllUsers'];
                print(result.data!['getAllUsers'][i]);
               return ListTile(
                  title: Text(_data.elementAt(i)['firstName']) ,
                   subtitle: Text(_data.elementAt(i)['favNumber'].toString())
            );
          });
        },
      )
    );
  }
}

