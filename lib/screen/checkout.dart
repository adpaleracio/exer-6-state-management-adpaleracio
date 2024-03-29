import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../model/Item.dart';
import '../provider/shoppingcart_provider.dart';

class Checkout extends StatelessWidget {
  const Checkout({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Checkout")     // checkout page title
      ),
        body: Column(
          children: [
            const Text("Item Details"),
            const Divider(height: 4, color: Colors.black),
            payItems(context),            // calls payItems
          ],
        ),
    );
  }

  Widget payItems(BuildContext context) {
    List<Item> products = context.watch<ShoppingCart>().cart;
    return products.isEmpty
      ? const Text('No items to checkout!')           // if there are no products in the list/cart
      : Expanded(
          child: Column(
            children: [
              Flexible(
                child: ListView.builder(             // if there are products in the cart, a set of list tiles is generated
                  itemCount: products.length,
                  itemBuilder: (BuildContext context, int index) {
                    return ListTile(
                      title: Text(products[index].name),                  // product name
                      trailing: Text(products[index].price.toString(), style: const TextStyle(fontSize: 15)),           // product price
                    );
                  },
                )
              ),
              Flexible(
                child: Column(
                  children: [
                    const Divider(height: 4, color: Colors.black),
                    computeCost(),              // calls computeCost
                    Center(
                      child: ElevatedButton(                  // Pay Now button
                        onPressed: () {
                          context.read<ShoppingCart>().removeAll();          // removes all products on the list
                          Navigator.pushNamed(context, "/products");         // goes to the catalog/products page
                          ScaffoldMessenger.of(context).showSnackBar(        // shows a snackbar
                            const SnackBar(
                              content: Text("Payment successful!"),          // message
                              duration: Duration(seconds: 1, milliseconds: 100),
                            )
                          );
                        },
                        child: const Text("Pay Now")          // button label
                      )
                    )
                  ]
                )
              )
            ],
          )
        );
  }

  Widget computeCost(){
    return Consumer<ShoppingCart>(builder: (context, cart, child){
      return Text("Total Cost to Pay: ${cart.cartTotal}");            // total cost to pay
    });
  }
}
