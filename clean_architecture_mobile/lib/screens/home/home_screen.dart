import 'package:clean_architecture_mobile/controller/product_controller.dart';
import 'package:clean_architecture_mobile/models/product.dart';
import 'package:clean_architecture_mobile/repository/product_repository.dart';
import 'package:clean_architecture_mobile/screens/product/product_screen.dart';
import 'package:clean_architecture_mobile/service/api_service.dart';
import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  
  // Models
  late List<Product> _productListModel;

  // Controllers
  late ProductController _productController;

  // Loaders
  bool _isLoadedProduct = false;


  // Others
  String selectedMethod = 'cash';

  

  Future<void> _loadAllProducts() async {
    setState(() {
      _isLoadedProduct = true;
    });

    try {
      // final sessionUser = await GeneralManagerDB.getSessionUser();

      final _loadAllPaiementMethods = await _productController.fetchAllProducts(/*sessionUser!*/);
      
      if (_loadAllPaiementMethods.code == 200) {
          // Vérifiez si le widget est toujours monté
        setState(() {
          _productListModel = _loadAllPaiementMethods.data!;
        });
      } else {
        print(_loadAllPaiementMethods.message);
      }
    } catch (e) {
      print(e.toString());
    }

    if (mounted) {
      Future.delayed(const Duration(seconds: 2), () {
        if (mounted) {
          setState(() {
            _isLoadedProduct = false;
          });
        }
      });
    }
  }

  Future<void> _loaded() async{
    // Models
    _productListModel = [];

    // Fonctions
    _loadAllProducts();
  }


  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    // Models
    _productListModel = [];

    // Controllers
    _productController = ProductController(
      productRepository: ProductRepository(
        apiService: ApiService()
      )
    );

    // Fonctions
    _loadAllProducts();
  }

  @override
  Widget build(BuildContext context) { 
    return Scaffold(
      appBar: AppBar(
        title: Skeletonizer(
          enabled: _isLoadedProduct,
          child: Text("Bienvenue")
        ),
        centerTitle: true,
      ),
      body: RefreshIndicator(
        onRefresh: _loaded,
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
        
              Skeletonizer(
                enabled: _isLoadedProduct,
                child: SizedBox(
                  height: MediaQuery.of(context).size.height * 0.9,
                  child: ListView.builder(
                    itemCount: _productListModel.length,
                    itemBuilder: (context, index){
                      return Card(
                        child: ListTile(
                          leading: Icon(Icons.person),
                          title: Text(
                            _productListModel[index].name ?? 'N/A',
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          subtitle: Text(
                            _productListModel[index].description ?? 'N/A',
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
                ),
              ),
            ],
          ),
        ),
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