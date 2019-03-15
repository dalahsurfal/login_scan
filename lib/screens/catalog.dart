import 'package:login_scan/models/src/item.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:flutter/material.dart';
import 'package:login_scan/home_page.dart';
import 'package:login_scan/models/cart.dart';

class MyCatalog extends StatefulWidget{

  @override
  State<StatefulWidget> createState() => _MyCatalogPageState();
}


class _MyCatalogPageState extends State<MyCatalog>{

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          HomePage(),
          SliverToBoxAdapter(child: SizedBox(height: 12)),
        ],
      ),
    );
  }
}

class MyListItem extends StatelessWidget {
  final int index;

  final Item item;

  MyListItem(
      this.index, {
        Key key,
      })  : item = Item(index),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: LimitedBox(
        maxHeight: 48,
        child: Row(
          children: [
            AspectRatio(
              aspectRatio: 1,
              child: Container(
                color: Colors.primaries[index % Colors.primaries.length],
              ),
            ),
            SizedBox(width: 24),
            Expanded(
              child: Text(item.name, style: Theme.of(context).textTheme.title),
            ),
            SizedBox(width: 24),
            _AddButton(item: item),
          ],
        ),
      ),
    );
  }
}

class _AddButton extends StatelessWidget {
  final Item item;

  const _AddButton({
    Key key,
    @required this.item,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Here is where we access the shared state of the cart. Because we
    // need to change the UI here according to the contents of the cart,
    // we use the ScopedModelDescendant widget (instead of ScopedModel.of).
//    return null;
    return ScopedModelDescendant<CartModel>(
      builder: (context, child, cart) => FlatButton(
        // We check whether the cart already has the item in it,
        // and if so, we give `null` to onPressed (making it disabled).
        // Otherwise, we provide a callback that calls a method
        // on the cart model.
        onPressed: cart.items.contains(item) ? null : () => cart.add(item),
        splashColor: Colors.yellow,
        // Similarly, we change the content of the button according
        // to the state of the cart.
        child: cart.items.contains(item) ? Icon(Icons.check) : Text('ADD'),
      ),
    );
  }
}