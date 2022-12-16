import 'package:eng/screens/add_service_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/services.dart';
import '../screens/services_details_screen.dart';
import '../providers/service.dart';
import 'package:intl/intl.dart';

class ManageServicesGrid extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final scaffold = Scaffold.of(context);
    final service = Provider.of<Service>(context);

    return Stack(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(15),
          child: GridTile(
            child: FittedBox(
              child: Image.network(service.imgUrl),
              fit: BoxFit.cover,
            ),
            footer: InkWell(
                onTap: () {
                  Navigator.of(context).pushNamed(
                      ServicesDetailsScreen.routeName,
                      arguments: service.id);
                },
                child: GridTileBar(
                  backgroundColor: Colors.black54,
                  title: Row(
                    // mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                          onPressed: () {
                            Navigator.of(context).pushNamed(
                                AddServiceScreen.routeName,
                                arguments: service.id);
                          },
                          icon: const Icon(Icons.edit)),
                      IconButton(
                        onPressed: () {
                          Provider.of<Services>(context, listen: false)
                              .deleteItem(service.id);
                        },
                        icon: const Icon(Icons.delete),
                      ),
                    ],
                  ),
                )),
          ),
        ),
        Center(
            child: Text(
          service.title,
          style: TextStyle(color: Colors.white, fontSize: 20),
        )),
      ],
    );
  }
}
