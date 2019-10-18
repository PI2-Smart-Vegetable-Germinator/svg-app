import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/planting_history.dart';

class PlantingssGrid extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    // final plantings = Provider.of<PlantingHistory>(context);

    // return GridView.builder(
    //   padding: const EdgeInsets.all(10.0),
    //   itemCount: 3,
    //   itemBuilder: (ctx, i) => ChangeNotifierProvider.value(
    //         // builder: (c) => products[i],
    //         value: 'oi',
    //         // child: ProductItem(
    //         //     // products[i].id,
    //         //     // products[i].title,
    //         //     // products[i].imageUrl,
    //         //     ),
    //       ),
    //   gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
    //     crossAxisCount: 2,
    //     childAspectRatio: 3 / 2,
    //     crossAxisSpacing: 10,
    //     mainAxisSpacing: 10,
    //   ),
    // );

    return Scaffold(
      body: Container(
        child: Center(
          child: Text("um item"),
        ),
      ),
    );
  }
}
