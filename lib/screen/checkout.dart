import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../model/Item.dart';
import '../provider/shoppingcart_provider.dart';

class Checkout extends StatelessWidget {
  const Checkout({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Checkout")),
      body: Column(
        children: [
          const Text("Item Details"),
          const Divider(height: 4, color: Colors.black),
          payItems(context),
        ],
      ),
    );
  }

  Widget payItems(BuildContext context) {
    List<Item> products = context.watch<ShoppingCart>().cart;
    return products.isEmpty
      ? const Text('No items to checkout!')
      : Expanded(
          child: Column(
            children: [
              Flexible(
                child: ListView.builder(
                  itemCount: products.length,
                  itemBuilder: (BuildContext context, int index) {
                    return ListTile(
                      title: Text(products[index].name),
                      trailing: Text(products[index].price.toString(), style: const TextStyle(fontSize: 15)),
                    );
                  },
                )
              ),
              Flexible(
                child: Column(
                  children: [
                    const Divider(height: 4, color: Colors.black),
                    computeCost(),
                    Center(
                      child: ElevatedButton(
                        onPressed: () {
                          context.read<ShoppingCart>().removeAll();
                          Navigator.pushNamed(context, "/products");
                          ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text("Payment successful!"),
                                duration: Duration(seconds: 1, milliseconds: 100),
                              )
                            );
                        },
                        child: const Text("Pay Now")
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
      return Text("Total Cost to Pay: ${cart.cartTotal}");
    });
  }
}
