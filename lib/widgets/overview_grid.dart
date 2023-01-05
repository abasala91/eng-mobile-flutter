import 'package:eng/providers/services.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth.dart';
import '../screens/services_details_screen.dart';
import '../providers/service.dart';

class OverviewGrid extends StatelessWidget {
  Function refreshAfterPop;
  OverviewGrid(this.refreshAfterPop);
  @override
  Widget build(BuildContext context) {
    final scaffold = Scaffold.of(context);
    final service = Provider.of<Service>(context);
    final authData = Provider.of<Auth>(context);

    return ClipRRect(
      borderRadius: BorderRadius.circular(15),
      child: GridTile(
        child: FittedBox(
          child: Image.network(service.imgUrl),
          fit: BoxFit.cover,
        ),
        footer: InkWell(
            onTap: () async {
              await Navigator.of(context).pushNamed(
                  ServicesDetailsScreen.routeName,
                  arguments: service.id);

              refreshAfterPop();
            },
            child: GridTileBar(
              backgroundColor: Colors.black54,
              subtitle: Center(
                child: Text(
                  DateFormat.yMMMMd().format(service.timeStamp).toString(),
                  style: TextStyle(color: Colors.white),
                ),
              ),
              title: Center(
                child: Text(
                  service.title,
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
              leading: service.validDays != null
                  ? Text(
                      '''valid till
${DateFormat.yMMMMd().format(service.validDays).toString()}''',
                      style: TextStyle(color: Colors.white),
                    )
                  : null,
            )),
      ),
    );
  }
}
