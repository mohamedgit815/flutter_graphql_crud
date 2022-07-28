import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

const String _data = """
mutation Mutation(
  \$addUserId: ID!, 
  \$firstName: String!, 
  \$userName: String!, 
  \$favNumber: Int!) {
  addUser(
    id: \$addUserId, 
    firstName: \$firstName, 
    userName: \$userName,
    favNumber:  \$favNumber
  )
}
""";


// mutation Mutation(
//   $addUserId: ID!,
//   $firstName: String!,
//   $userName: String!,
//   $favNumber: Int!) {
//   addUser(
//     id: $addUserId ,
//     firstName: $firstName ,
//     userName: $userName ,
//     favNumber:  $favNumber
//   )
// }

class SendPage extends StatefulWidget {
  const SendPage({Key? key}) : super(key: key);

  @override
  _SendPageState createState() => _SendPageState();
}

class _SendPageState extends State<SendPage> {
  final TextEditingController _controller1 = TextEditingController();
  final TextEditingController _controller2 = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          TextField(
            controller: _controller1,
          ),

          TextField(
            controller: _controller2,
          ),

          Mutation(
            options: MutationOptions(
                document: gql(_data),
                onCompleted: (dynamic resultData) {
                  print("Completed Sending");
                }),
            builder: (RunMutation runMutation,QueryResult? result){
              return MaterialButton(
                onPressed: () {
                  runMutation({
                    "addUserId": 200 ,
                    "firstName": _controller1.text ,
                    "favNumber": 3000,
                    "userName":_controller2.text
                  });

              },child: const Text("Sned"));
            }
          )
        ],
      ),
    );
  }
}
