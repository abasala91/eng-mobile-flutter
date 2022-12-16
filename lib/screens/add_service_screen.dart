import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/services.dart';
import '../providers/service.dart';

class AddServiceScreen extends StatefulWidget {
  static const routeName = '/add-service';
  @override
  State<AddServiceScreen> createState() => _AddServiceScreenState();
}

class _AddServiceScreenState extends State<AddServiceScreen> {
  final _imageController = TextEditingController();
  bool showImage = false;
  final _formKey = GlobalKey<FormState>();
  var isInit = true;
  var isLoading = false;

  var _initValues = {
    'imgUrl': '',
    'title': '',
    'description': '',
  };

  var _editedService = Service(
    description: '',
    id: null,
    imgUrl: '',
    title: '',
  );

  Future<void> _submittData() async {
    final _isValid = _formKey.currentState.validate();
    if (!_isValid) {
      return;
    }
    _formKey.currentState.save();
    setState(() {
      isLoading = true;
    });

    if (_editedService.id != null) {
      Provider.of<Services>(context, listen: false)
          .updateService(_editedService.id, _editedService);
      setState(() {
        isLoading = false;
      });
      Navigator.of(context).pop();
    } else {
      try {
        await Provider.of<Services>(context, listen: false)
            .addNewService(_editedService);
      } catch (error) {
        print(error);
        await showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: Text('Error'),
            content: Text(error.toString()),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.of(ctx).pop();
                  },
                  child: Text('ok!'))
            ],
          ),
        );
      } finally {
        setState(() {
          isLoading = false;
        });
        Navigator.of(context).pop();
      }
    }
  }

  @override
  void didChangeDependencies() {
    if (isInit) {
      final serviceId = ModalRoute.of(context).settings.arguments as String;
      if (serviceId != null) {
        _editedService = Provider.of<Services>(context).findById(serviceId);
        _initValues = {
          'imgUrl': '',
          'title': _editedService.title,
          'description': _editedService.description,
          'id': serviceId
        };
        _imageController.text = _editedService.imgUrl;
      }
      ;
    }
    isInit = false;

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('New Service'),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: _submittData,
            icon: Icon(Icons.save),
          )
        ],
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : SingleChildScrollView(
              child: Container(
                child: Padding(
                  padding: EdgeInsets.all(15),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        TextFormField(
                          decoration: const InputDecoration(
                            labelText: 'Image URL',
                          ),
                          keyboardType: TextInputType.url,
                          controller: _imageController,
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'please insert valid url';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            _editedService = Service(
                              description: _editedService.description,
                              id: _editedService.id,
                              imgUrl: value,
                              title: _editedService.title,
                            );
                          },
                        ),
                        TextFormField(
                          initialValue: _initValues['title'],
                          decoration: const InputDecoration(
                            labelText: 'Title',
                          ),
                          keyboardType: TextInputType.name,
                          validator: (value) {
                            if (value.isEmpty) {
                              return '*required';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            _editedService = Service(
                              description: _editedService.description,
                              id: _editedService.id,
                              imgUrl: _editedService.imgUrl,
                              title: value,
                            );
                          },
                        ),
                        TextFormField(
                          initialValue: _initValues['description'],
                          decoration: const InputDecoration(
                            labelText: 'Description',
                          ),
                          keyboardType: TextInputType.multiline,
                          maxLines: 3,
                          validator: (value) {
                            if (value.isEmpty) {
                              return '*required';
                            }
                            if (value.length < 10) {
                              return 'must be more than 10 characters';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            _editedService = Service(
                              description: value,
                              id: _editedService.id,
                              imgUrl: _editedService.imgUrl,
                              title: _editedService.title,
                            );
                          },
                        ),
                        TextButton(
                            onPressed: () {
                              setState(() {
                                showImage = !showImage;
                              });
                            },
                            child: showImage
                                ? Text('hide image')
                                : Text('show image')),
                        const SizedBox(height: 20),
                        Container(
                          height: MediaQuery.of(context).size.height * 0.4,
                          width: MediaQuery.of(context).size.width * 0.8,
                          decoration: BoxDecoration(
                              border: Border.all(
                            width: 1,
                            color: Colors.white,
                          )),
                          child: showImage
                              ? FittedBox(
                                  child: Image.network(
                                  _imageController.text,
                                  fit: BoxFit.cover,
                                ))
                              : Container(),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
    );
  }
}
