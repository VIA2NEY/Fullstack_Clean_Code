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

  Future<void> _deleteProduct(int idProduct) async {
    bool confirm = await showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Confirmer la suppression"),
        content: const Text("Voulez-vous vraiment supprimer ce produit ?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: Text(
              "Annuler",
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: Text(
              "Supprimer",
              style: Theme.of(context).textTheme.bodyLarge!.copyWith(color: Colors.white),
            ),
          ),
        ],
      ),
    );

    if (confirm == true) {
      setState(() {
        _isLoadedProduct = true;
      });

      try {
        final response = await _productController.deleteProduct(idProduct);

        if (response.code == 200) {
          _showError(
            "Produit supprimé avec succès!",
            timeDuration: 5,
            backgroundColor: Colors.green,
          );
          _loaded();
        } else {
          _showError(
            response.message,
            timeDuration: 8
          );
        }
      } catch (e) {
        _showError(
          "Exception : $e",
          backgroundColor: Colors.red,
          timeDuration: 8
        );
      }

      setState(() {
        _isLoadedProduct = false;
      });
    }
  }
  

  void _showError(String errorMessage, {Color? backgroundColor, TextStyle? style, int? timeDuration}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: backgroundColor ?? Theme.of(context).colorScheme.primary,
        content: Text(
          errorMessage,
          style: style ?? Theme.of(context).textTheme.bodyMedium!.copyWith(
            color: Colors.white
          ),
        ),
        duration: Duration(seconds: timeDuration ?? 4),
      ),
    );
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
          child: SingleChildScrollView(
            child: Skeletonizer(
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
                                
                                Navigator.push(
                                  context, 
                                  MaterialPageRoute(
                                    builder: (context) => ProductScreen(
                                      isCreate: false,
                                      idProduct: _productListModel[index].id,
                                    ) 
                                  )
                                ).then((data) {
                                  if (data != null) {
                                    _loaded();
                                    // showBoiteDialog("Succes", " Les details de "+ data.toString() +" ont été mis a jour avec succes");
                                  } 
                      
                                });
                      
                              }
                            ),
                            IconButton(
                              icon: Icon(Icons.delete) ,
                              onPressed: () async{
                                _deleteProduct(_productListModel[index].id!);
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
          ).then((data) {
            if (data != null) {
              _loaded();
            } 
          });
        },
        tooltip: 'Ajouter',
        child: const Icon(Icons.add),
      ), 



    );
  }
}