import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../model/Item.dart';
import '../provider/shoppingcart_provider.dart';

class MyCart extends StatelessWidget {
  const MyCart({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("My Cart")),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          getItems(context),
          Flexible(
            child: Column(
              children: [
                const Divider(height: 4, color: Colors.black),
                computeCost(),
                Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          context.read<ShoppingCart>().removeAll();
                        }, 
                        child: const Text("Reset")
                      ),
                      ElevatedButton(                          // checkout button
                        onPressed: () {
                          Navigator.pushNamed(context, "/checkout");      // goes to checkout page
                        },
                        child: const Text("Checkout")
                      )
                    ]
                  )
                )
              ]
            )
          ),
          TextButton(
            child: const Text("Go back to Product Catalog"),
            onPressed: () {
              Navigator.pushNamed(context, "/products");
            },
          ),
        ],
      ),
    );
  }

  Widget getItems(BuildContext context) {
    List<Item> products = context.watch<ShoppingCart>().cart;
    String productname = "";
    return products.isEmpty ? const Text('No items yet!')
      : Expanded(
          child: Column(
            children: [
              Flexible(
                child: ListView.builder(
                  itemCount: products.length,
                  itemBuilder: (BuildContext context, int index) {
                    return ListTile(
                      leading: const Icon(Icons.shopping_cart),
                      title: Text(products[index].name),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () {
                          productname = products[index].name;
                          context.read<ShoppingCart>().removeItem(productname);
                          if (products.isNotEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text("$productname removed!"),
                                duration: const Duration(seconds: 1, milliseconds: 100),
                              )
                            );
                          }
                          else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text("Cart Empty!"),
                                duration: Duration(seconds: 1, milliseconds: 100),
                              )
                            );
                          }
                        },
                      ),
                    );
                  },
                )
              ),
            ],
          )
        );
  }

  Widget computeCost(){
    return Consumer<ShoppingCart>(builder: (context, cart, child){
      return Text("Total: ${cart.cartTotal}");
    });
  }
}
