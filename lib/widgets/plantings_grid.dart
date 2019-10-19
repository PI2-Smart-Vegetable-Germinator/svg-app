import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../providers/plantings.dart';

class PlantingsGrid extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final plantings = Provider.of<Plantings>(context);

    String _formatDate(DateTime dateToConvert) {
      String formatted = DateFormat('dd.MM.yyyy').format(dateToConvert);
      return formatted;
    }

    double defaultScreenWidth = 380.0;
    double defaultScreenHeight = 800.0;
    ScreenUtil.instance = ScreenUtil(
      width: defaultScreenWidth,
      height: defaultScreenHeight,
      allowFontScaling: true,
    )..init(context);

    return GridView.builder(
      padding: EdgeInsets.only(
          top: ScreenUtil.instance.setHeight(25.0),
          bottom: ScreenUtil.instance.setHeight(25.0),
          left: ScreenUtil.instance.setWidth(20),
          right: ScreenUtil.instance.setWidth(20)),
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
                  padding: EdgeInsets.all(ScreenUtil.instance.setWidth(10.0)),
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
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Flexible(
                          child: Container(
                            height: 90,
                            width: 90,
                            child: CircleAvatar(
                              radius: MediaQuery.of(context).size.width / 8,
                              backgroundColor: Colors.transparent,
                              backgroundImage:
                                  NetworkImage(plantings.items[i].pictureUrl),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Container(
                            width: ScreenUtil.instance.setWidth(210.0),
                            margin: EdgeInsets.only(
                                top: ScreenUtil.instance.setHeight(10.0),
                                left: ScreenUtil.instance.setWidth(15.0)),
                            // width: ScreenUtil.instance.setWidth(210.0),
                            child: AutoSizeText(
                              'Plantio - ' +
                                  _formatDate(plantings.items[i].plantingDate),
                              style: TextStyle(
                                  fontSize: ScreenUtil.instance.setSp(23.0),
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xff575757)),
                              maxLines: 1,
                            )),
                        Container(
                          margin: EdgeInsets.only(
                              top: ScreenUtil.instance.setHeight(10.0),
                              left: ScreenUtil.instance.setWidth(15.0)),
                          width: ScreenUtil.instance.setWidth(210.0),
                          child: AutoSizeText(
                            'Início do ciclo: ' +
                                _formatDate(plantings.items[i].plantingDate),
                            style: TextStyle(
                                fontSize: ScreenUtil.instance.setSp(17.0),
                                fontWeight: FontWeight.w600,
                                color: Color(0xff575757)),
                            maxLines: 2,
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(
                              top: ScreenUtil.instance.setHeight(10.0),
                              left: ScreenUtil.instance.setWidth(15.0)),
                          width: ScreenUtil.instance.setWidth(210.0),
                          child: AutoSizeText(
                            plantings.items[i].cycleFinished
                                ? 'Fim do ciclo: Encerrado em ' +
                                    _formatDate(
                                        plantings.items[i].cycleEndingDate)
                                : 'Fim do ciclo: Em andamento',
                            style: TextStyle(
                                fontSize: ScreenUtil.instance.setSp(17.0),
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
        childAspectRatio: 2 / 1,
        crossAxisSpacing: 15,
        mainAxisSpacing: 20,
      ),
    );
  }
}
