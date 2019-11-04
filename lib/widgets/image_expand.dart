import 'package:flutter/material.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../providers/plantings.dart';

class ImageExpand extends StatelessWidget {
  static const routeName = '/image-detail';

  @override
  Widget build(BuildContext context) {
    final plantingId = ModalRoute.of(context).settings.arguments as int;

    final loadedPlanting = Provider.of<Plantings>(
      context,
      listen: false,
    ).findById(plantingId);

    String _formatDate(DateTime dateToConvert) {
      String formatted = DateFormat('dd/MM/yyyy').format(dateToConvert);
      return formatted;
    }

    double defaultScreenWidth = 420.0;
    double defaultScreenHeight = 830.0;
    ScreenUtil.instance = ScreenUtil(
      width: defaultScreenWidth,
      height: defaultScreenHeight,
      allowFontScaling: true,
    )..init(context);

    return Scaffold(
        body: Stack(
      children: <Widget>[
        ClipRRect(
          borderRadius:
              new BorderRadius.only(bottomLeft: const Radius.circular(50.0)),
          child: Container(
            width: double.infinity,
            height: ScreenUtil.instance.setHeight(100.0),
            margin: EdgeInsets.all(0),
            color: Color.fromRGBO(144, 201, 82, 1),
            child: Container(
              margin: EdgeInsets.only(
                  top: ScreenUtil.instance.setHeight(25.0),
                  left: ScreenUtil.instance.setWidth(30.0)),
              child: Text(
                loadedPlanting.name +
                    ' - ' +
                    _formatDate(loadedPlanting.plantingDate),
                style: TextStyle(
                    fontSize: ScreenUtil.instance.setSp(35),
                    color: Colors.white,
                    fontWeight: FontWeight.w500),
                textAlign: TextAlign.left,
              ),
            ),
          ),
        ),
        Container(
            alignment: Alignment(ScreenUtil.instance.setWidth(0.0),
                ScreenUtil.instance.setHeight(-0.5)),
            margin: EdgeInsets.only(
                top: ScreenUtil.instance.setHeight(120.0),
                left: ScreenUtil.instance.setWidth(10.0),
                right: ScreenUtil.instance.setWidth(10.0)),
            child: loadedPlanting.pictureUrl.isNotEmpty
                ? ClipRRect(
                    borderRadius:
                        new BorderRadius.all(const Radius.circular(30.0)),
                    child: RotatedBox(
                      quarterTurns: 5,
                      child: FadeInImage.memoryNetwork(
                        placeholder: kTransparentImage,
                        image: loadedPlanting.pictureUrl,
                      ),
                    ),
                  )
                : Center(
                    child: Text(
                      'Este ciclo não possui imagem.',
                      style: TextStyle(
                          fontSize: ScreenUtil.instance.setSp(30.0),
                          fontWeight: FontWeight.bold,
                          color: Color(0xff575757)),
                    ),
                  ))
      ],
    ));
  }
}
