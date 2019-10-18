import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import '../providers/plantings.dart';

class PlantingsGrid extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final plantings = Provider.of<Plantings>(context);

    String _formatDate(DateTime dateToConvert) {
      String formatted = DateFormat('dd.MM.yyyy').format(dateToConvert);
      return formatted;
    }

    return GridView.builder(
      padding:
          const EdgeInsets.only(top: 25.0, bottom: 25.0, left: 20, right: 20),
      itemCount: plantings.items.length,
      itemBuilder: (ctx, i) => ChangeNotifierProvider.value(
        value: plantings.items[i],
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: GridTile(
            child: GestureDetector(
              onTap: () {
                print('clicando no item da grade');
              },
              child: Container(
                  padding: const EdgeInsets.all(10.0),
                  decoration: new BoxDecoration(
                      color: Color.fromRGBO(229, 229, 229, 1),
                      borderRadius:
                          new BorderRadius.all(const Radius.circular(20.0)),
                      boxShadow: [
                        BoxShadow(
                          color: Color.fromRGBO(229, 229, 229, 1),
                          blurRadius: 2.0,
                          offset: Offset(6.0, 6.0),
                        )
                      ]),
                  child: Row(children: <Widget>[
                    CircleAvatar(
                      radius: MediaQuery.of(context).size.width / 8,
                      backgroundColor: Colors.transparent,
                      backgroundImage: NetworkImage(plantings.items[i].pictureUrl),
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          margin: EdgeInsets.only(top: 10.0, left: 15.0),
                          width: 210.0,
                          child: Text(
                            'Plantio - ' +
                                _formatDate(plantings.items[i].plantingDate),
                            style: TextStyle(
                                fontSize: 23.0,
                                fontWeight: FontWeight.bold,
                                color: Color(0xff575757)),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 10.0, left: 15.0),
                          width: 210.0,
                          child: Text(
                            'Início do ciclo: ' +
                                _formatDate(plantings.items[i].plantingDate),
                            style: TextStyle(
                                fontSize: 18.0,
                                fontWeight: FontWeight.w600,
                                color: Color(0xff575757)),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 10.0, left: 15.0),
                          width: 210.0,
                          child: Text(
                            plantings.items[i].cycleFinished
                                ? 'Fim do ciclo: Encerrado em ' +
                                    _formatDate(
                                        plantings.items[i].cycleEndingDate)
                                : ' Fim do ciclo: Em andamento',
                            style: TextStyle(
                                fontSize: 18.0,
                                fontWeight: FontWeight.w600,
                                color: Color(0xff575757)),
                          ),
                        ),
                      ],
                    )
                  ])),
            ),
          ),
        ),
      ),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 1,
        childAspectRatio: 4 / 2,
        crossAxisSpacing: 15,
        mainAxisSpacing: 20,
      ),
    );
  }
}
