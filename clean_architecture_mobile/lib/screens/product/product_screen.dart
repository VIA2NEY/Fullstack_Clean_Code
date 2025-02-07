
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ProductScreen extends StatefulWidget {
  final bool isCreate;

  const ProductScreen({
    super.key, 
    required this.isCreate
  });

  @override
  State<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  
  final _formKey = GlobalKey<FormState>();
  var _sended = false;

  // Valeur des champs
  var _enteredName = '';
  var _enteredDescription = '';
  var _enteredPrice = 1;



  Future<void>_create() async{

    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      setState(() {
        _sended = true;
      });
    }

    final body ={
      "name":_enteredName,
      "description": _enteredDescription,
      "price": _enteredPrice
    };

    print("The body send is $body");

  }

  @override
  Widget build(BuildContext context) {

    // final theme = Theme.of(context);

    return Scaffold(
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(12.0),
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
                    validator: (value) {
                      if (value == null || 
                        value.isEmpty || 
                        value.trim().length <= 1 ){
                        return 'Doit contenir entre 1 et 50 caractere';
                      }
                      return null;
                    },
                    onSaved: (newValue) {
                      _enteredName = newValue!;
                    },
                  ),
            
                  TextFormField(
                    maxLength: 150,
                    decoration: const InputDecoration(
                      label: Text('Description')
                    ),
                    initialValue: "Hello MFs",
                    validator: (value) {
                      if (value == null || 
                        value.isEmpty || 
                        value.trim().length <= 1 ){
                        return 'Doit contenir entre 1 et 150 caractere';
                      }
                      return null;
                    },
                    onSaved: (newValue) {
                      _enteredDescription = newValue!;
                    },
                  ),

                  
                  TextFormField(
                    decoration: const InputDecoration(
                      label: Text('Price')
                    ),
                    initialValue: _enteredPrice.toString(),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || 
                        value.isEmpty || 
                        int.tryParse(value) == null ||
                        int.tryParse(value)! < 0){
                        return 'Doit être un nombre valide positif';
                      }
                      return null;
                    },
                    onSaved: (newValue) {
                      _enteredPrice = int.parse(newValue!);
                    },
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
                          onPressed: _sended ? null : (){},
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
    );
  }
}