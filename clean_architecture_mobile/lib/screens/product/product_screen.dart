
import 'package:clean_architecture_mobile/controller/product_controller.dart';
import 'package:clean_architecture_mobile/models/product.dart';
import 'package:clean_architecture_mobile/repository/product_repository.dart';
import 'package:clean_architecture_mobile/service/api_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';

class ProductScreen extends StatefulWidget {
  final bool isCreate;
  final int? idProduct;

  const ProductScreen({
    super.key, 
    required this.isCreate, 
    this.idProduct
  });

  @override
  State<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
    
  // Models
  late Product _productListModel;

  // Controllers
  late ProductController _productController;

  // Loaders
  bool _isLoadedProduct = false;


  // Others
  final _formKey = GlobalKey<FormState>();
  var _sended = false;

  // Valeur des champs
  // var _enteredName = '';
  // var _enteredDescription = '';
  // var _enteredPrice = 1;

  final TextEditingController enteredName = TextEditingController();
  final TextEditingController enteredDescription = TextEditingController();
  final TextEditingController enteredPrice = TextEditingController();



  Future<void> loadInfoData() async{
    
    // final sessionUser = await GeneralManagerDB.getSessionUser();
    
    if (widget.isCreate == false) {

      setState(() {
        _isLoadedProduct = true;
      });

      print("widget.isCreate is ${widget.isCreate}");
      
      final response = await _productController.fetchProductDetails(/*sessionUser!,*/ widget.idProduct!);

      if (response.code == 200) {
        _productListModel = response.data!;

        print("""
          Values Are
        
          _enteredName = ${_productListModel.name} ?? 'N/A';
          _enteredDescription = ${_productListModel.description} ?? 'N/A';
          _enteredPrice = ${_productListModel.price!.toInt()};

          """
        );
        
        // REMPLISSAGE DES CHAMPS
          enteredName.text = _productListModel.name ?? 'N/A';
          enteredDescription.text = _productListModel.description ?? 'N/A';
          enteredPrice.text = _productListModel.price!.toString();
        
        
        if (mounted) {
          Future.delayed(const Duration(seconds: 2), () {
            if (mounted) {
              setState(() {
                _isLoadedProduct = false;
              });
            }
          });
        }

      } else {
        print(response.message);
        _showError(response.message);
      }

    }
  }


  Future<void>_create() async{

    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      setState(() {
        _sended = true;
      });
    }

    final body ={
      "name":enteredName.text,
      "description": enteredDescription.text,
      "price": double.tryParse(enteredPrice.text)
    };

    print("The body send is $body");
    
      
      Navigator.of(context).pop(
        Product(
          id: 5, 
          name: enteredName.text,
          description: enteredDescription.text,
          price: double.tryParse(enteredPrice.text),
        )
      );

  }



  Future<void>_modif() async{

    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      setState(() {
        _sended = true;
      });
    }

    final body ={
      "id": widget.idProduct,
      "name":enteredName.text,
      "description": enteredDescription.text,
      "price": double.tryParse(enteredPrice.text)
    };

    print("The body send is $body");
    
      
      Navigator.of(context).pop(
        Product(
          id: widget.idProduct, 
          name: enteredName.text,
          description: enteredDescription.text,
          price: double.tryParse(enteredPrice.text),
        )
      );

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
    _productListModel = Product();

    // Fonctions
    loadInfoData();
  }


  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    // Models
    _productListModel = Product();

    // Controllers
    _productController = ProductController(
      productRepository: ProductRepository(
        apiService: ApiService()
      )
    );

    // Fonctions
    loadInfoData();
  }


  @override
  Widget build(BuildContext context) {

    // final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.isCreate == true 
          ? 'Creation de Produits'
          : 'Modification'
        ),
      ),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Skeletonizer(
              enabled: _isLoadedProduct,
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    
                    const SizedBox(height: 8),
                    TextFormField(
                      maxLength: 50,
                      decoration: const InputDecoration(
                        label: Text('Name')
                      ),
                      controller: enteredName,
                      validator: (value) {
                        if (value == null || 
                          value.isEmpty || 
                          value.trim().length <= 1 ){
                          return 'Doit contenir entre 1 et 50 caractere';
                        }
                        return null;
                      },
                      // onSaved: (newValue) {
                      //   _enteredName = newValue!;
                      // },
                    ),
              
                    TextFormField(
                      maxLength: 150,
                      decoration: const InputDecoration(
                        label: Text('Description')
                      ),
                      // initialValue: _enteredDescription,
                      controller: enteredDescription,
                      validator: (value) {
                        if (value == null || 
                          value.isEmpty || 
                          value.trim().length <= 1 ){
                          return 'Doit contenir entre 1 et 150 caractere';
                        }
                        return null;
                      },
                      // onSaved: (newValue) {
                      //   _enteredDescription = newValue!;
                      // },
                    ),
              
                    
                    TextFormField(
                      decoration: const InputDecoration(
                        label: Text('Price')
                      ),
                      // initialValue: _enteredPrice.toString(),
                      keyboardType: TextInputType.number,
                      controller: enteredPrice,
                      validator: (value) {
                        if (value == null || 
                          value.isEmpty || 
                          int.tryParse(value) == null ||
                          int.tryParse(value)! < 0){
                          return 'Doit être un nombre valide positif';
                        }
                        return null;
                      },
                      // onSaved: (newValue) {
                      //   _enteredPrice = int.parse(newValue!);
                      // },
                    ),
                    
                    
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          onPressed: _sended ? null : (){
                            _formKey.currentState!.reset();
                          }, 
                          child: const Text('Annuler')
                        ),
                        widget.isCreate ?
                          ElevatedButton(
                            onPressed: _sended ? null : _create, // Ajouter pour que quand on envoie et que sa charge on ne puisse pas re-envoyer
                            child: _sended ? 
                              const SizedBox(height: 16, width: 16, child: CircularProgressIndicator(),) 
                            : const Text("Ajouter")
                          )
                        :
                          ElevatedButton(
                            onPressed: _sended ? null : _modif,
                            child: _sended ? 
                              const SizedBox(height: 16, width: 16, child: CupertinoActivityIndicator(),) 
                            : const Text("Modifier")
                          )
                      ],
                    )
              
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}