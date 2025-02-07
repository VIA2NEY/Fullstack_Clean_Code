import 'package:clean_architecture_mobile/screens/product/product_screen.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) { 
    return Scaffold(
      appBar: AppBar(
        title: Text("Bienvenue"),
        centerTitle: true,
      ),
      body: ListView.builder(
        itemCount: 3/*getclient.length*/,
        itemBuilder: (context, index){
          return Card(
            child: ListTile(
              leading: Icon(Icons.person),
              title: Text(
                "Bruno"
                /*getclient[index].nomClt.toString()*/,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              subtitle: Text(
                "0987654321"
                /*getclient[index].contact.toString()*/,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: Icon(Icons.edit) ,
                    onPressed: () async {
                      
                      // Navigator.push(
                      //   context, 
                      //   MaterialPageRoute(builder: (context) => ModifierClient(getclient[index]) )
                      // ).then((data) {
                      //   if (data != null) {
                      //     getClient();// En gros c'est sa qui permet de reload automatiquement
                      //     showBoiteDialog("Succes", " Les details de "+ data.toString() +" ont été mis a jour avec succes");
                      //   } 
            
                      // });
            
                    }
                  ),
                  IconButton(
                    icon: Icon(Icons.delete) ,
                    onPressed: () async{
                      // Client client = await ClientApi().suprimClientById(getclient[index].idClt!); /*nulcheck a cause de erreur a rgler la ou jai mis les we en null la */
            
                      // getClient();
                      // showBoiteDialog("Succes", " Les details de "+ client.toString() +" on été suprimer avec succés avec succes");
                    }
                  )
                ],
              ),
            )
          );
        },
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: (){
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (ctx){
                return ProductScreen(
                  isCreate: true,
                );
              }
            )
          );
        },
        tooltip: 'Ajouter',
        child: const Icon(Icons.add),
      ), 



    );
  }
}