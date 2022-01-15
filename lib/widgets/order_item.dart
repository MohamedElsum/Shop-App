import 'dart:math';

import 'package:flutter/material.dart';
import 'package:shop_app/providers/orders.dart' as ord;
import 'package:intl/intl.dart';

class OrderItem extends StatefulWidget {
  final ord.OrderItem order;

  OrderItem({required this.order});

  @override
  State<OrderItem> createState() => _OrderItemState();
}

class _OrderItemState extends State<OrderItem> {
  bool expanded = false;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: AnimatedContainer(
        duration: Duration(milliseconds: 300),
        curve: Curves.linear,
        child: Card(
          margin: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              ListTile(
                title: Text('\$${widget.order.amount}'),
                subtitle: Text(
                    DateFormat('dd/MM/yyyy hh:mm').format(widget.order.dateTime)),
                trailing: IconButton(
                  icon:
                      expanded ? Icon(Icons.expand_less) : Icon(Icons.expand_more),
                  onPressed: () {
                    setState(() {
                      expanded = !expanded;
                    });
                  },
                ),
              ),
              if (expanded)
                Container(
                  padding: const EdgeInsets.all(10.0),
                  decoration: BoxDecoration(
                    color: Colors.white54.withOpacity(0.5),
                  ),
                  height: min(widget.order.products.length * 20.0 + 100, 180.0),
                  child: ListView(
                    children: widget.order.products.map((prod) {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            prod.title,
                            style: TextStyle(
                                fontSize: 25.0, fontWeight: FontWeight.bold,color: Colors.purple),
                          ),
                          Text('${prod.quantity} x / \$ ${prod.price}'),
                        ],
                      );
                    }).toList(),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
