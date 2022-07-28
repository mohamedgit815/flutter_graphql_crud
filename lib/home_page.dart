import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

const productsGraphQl = """
query products{
  products(first: 10, channel: "default-channel") {
    edges {
      node {
        id
        name
        description
        thumbnail{
          url
        }
      }
    }
  }
}
""";

class GraphQlPage extends StatefulWidget {
  const GraphQlPage({Key? key}) : super(key: key);

  @override
  _GraphQlPageState createState() => _GraphQlPageState();
}

class _GraphQlPageState extends State<GraphQlPage> {
  late ValueNotifier<GraphQLClient> _client;

  @override
  void initState() {
    super.initState();
    final HttpLink _httpLink = HttpLink("https://demo.saleor.io/graphql/");

    _client = ValueNotifier(GraphQLClient(
        link: _httpLink ,
        cache: GraphQLCache(store: InMemoryStore())
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: GraphQLProvider(
          client: _client,
          child: Query(
              options: QueryOptions(document: gql(productsGraphQl)),
              builder: (QueryResult result , {FetchMore? fetchMore ,VoidCallback? refetch}) {

                if(result.hasException) {
                  return const Text("hasException");
                }

                if(result.isLoading || result.data == null) {
                  return const Center(child: CircularProgressIndicator.adaptive());
                }

                return Column(
                  children: [
                    Expanded(
                      child: ListView.separated(
                        separatorBuilder: (context,i)=> const Divider(thickness: 3),
                        itemCount: result.data!.length ,
                        itemBuilder: (context , i) {
                          final List<dynamic> _productList = result.data!['products']['edges'];
                          return ListTile(
                            title: Text(_productList[i]!['node']['name']),
                            subtitle: Text(_productList[i]!['node']['description']),
                            leading: CircleAvatar(backgroundImage: NetworkImage(_productList[i]!['node']['thumbnail']['url']),),
                          );
                        },
                      ),
                    ),
                  ],
                );
              }
          ),
        )
    );
  }
}