import 'dart:io';

import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:umkm_application/Const/const_color.dart';
import 'package:umkm_application/Event/bloc/bloc/event_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:umkm_application/Event/ui/event_list.dart';
import 'package:umkm_application/Model/event.dart';

class EventFormPage extends StatefulWidget {
  EventFormPage(
      {Key? key,
      required this.event})
      : super(key: key);

  Event event;
  @override
  _EventFormPageState createState() => _EventFormPageState(
      event : event);
}

class _EventFormPageState extends State<EventFormPage> {
  _EventFormPageState(
      {required this.event});
  final Event event;
  TextEditingController nameController = TextEditingController(text: "");
  TextEditingController locController = TextEditingController(text: "");
  TextEditingController descController = TextEditingController(text: "");
  TextEditingController authorController = TextEditingController(text: "");
  TextEditingController cpController = TextEditingController(text: "");
  TextEditingController linkController = TextEditingController(text: "");
  DateTime _selectedDate = DateTime.now();
  File _imageFile = File('');
  final ImagePicker picker = ImagePicker();
  late EventBloc _eventBloc;
  bool isLoading = false;

  void _onSelectionChanged(DateRangePickerSelectionChangedArgs args) {
    setState(() {
      _selectedDate = args.value;
    });
  }

  Widget _backButton() {
    return InkWell(
      onTap: () {
        Navigator.pop(context);
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10),
        child: Row(
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(left: 0, top: 10, bottom: 10),
              child: Icon(Icons.keyboard_arrow_left, color: ConstColor.secondaryTextDatalab),
            ),
            Text('Kembali',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color:ConstColor.secondaryTextDatalab))
          ],
        ),
      ),
    );
  }

  Widget _entryField(
      String title, String hintText, TextEditingController controller,
      {bool isPassword = false, bool isCP = false, Icon? entryIcon}) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            title,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15,color:ConstColor.textDatalab),
          ),
          SizedBox(
            height: 10,
          ),
          isCP
              ? InternationalPhoneNumberInput(
                  onInputChanged: (PhoneNumber number) {
                    print(number.phoneNumber);
                  },
                  selectorConfig: SelectorConfig(
                    selectorType: PhoneInputSelectorType.BOTTOM_SHEET,
                  ),
                  ignoreBlank: false,
                  selectorTextStyle: TextStyle(color: ConstColor.textDatalab),
                  textFieldController: controller,
                )
              : TextField(
                  controller: controller,
                  obscureText: isPassword,
                  decoration: InputDecoration(
                      border: InputBorder.none,
                      prefixIcon: entryIcon,
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: ConstColor.darkDatalab),
                          borderRadius: BorderRadius.circular(15)),
                      fillColor: Color(0xfff3f3f4),
                      filled: true,
                      hintText: hintText))
        ],
      ),
    );
  }

  Widget _datePicker(String title) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            title,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
          ),
          SizedBox(
            height: 10,
          ),
          SfDateRangePicker(
            onSelectionChanged: _onSelectionChanged,
            selectionMode: DateRangePickerSelectionMode.single,
            initialSelectedDate: event.id != "" ? _selectedDate : DateTime.now(),
            initialDisplayDate: event.id != "" ? _selectedDate : DateTime.now(),
            selectionColor: ConstColor.textDatalab,
            todayHighlightColor: ConstColor.secondaryTextDatalab,
            initialSelectedRange: PickerDateRange(
                event.id != ""
                    ? _selectedDate.subtract(const Duration(days: 4))
                    : DateTime.now().subtract(const Duration(days: 4)),
                event.id != ""
                    ? _selectedDate.add(const Duration(days: 3))
                    : DateTime.now().add(const Duration(days: 3))),
          )
        ],
      ),
    );
  }

  Widget _imagePicker(String title) {
    return Container(
      alignment: Alignment.centerLeft,
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            title,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
          ),
          SizedBox(
            height: 10,
          ),
          Text(_imageFile.path),
          SizedBox(
            height: 10,
          ),
          _imagePickerButton(context)
        ],
      ),
    );
  }

  Widget _imagePickerButton(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(5)),
          boxShadow: <BoxShadow>[
            BoxShadow(
                color: Colors.grey.shade200,
                offset: Offset(2, 4),
                blurRadius: 5,
                spreadRadius: 2)
          ],
          gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: [ConstColor.darkDatalab,ConstColor.darkDatalab])),
      child: Material(
          color: Colors.transparent,
          child: InkWell(
            splashColor: Colors.blueGrey,
            onTap: () async {
              final XFile? image =
                  await picker.pickImage(source: ImageSource.gallery);
              setState(() {
                _imageFile = File(image!.path);
              });
            },
            child: Container(
                alignment: Alignment.center,
                width: MediaQuery.of(context).size.width * 0.5,
                padding: EdgeInsets.symmetric(vertical: 10),
                child: Text('Upload Gambar',
                    style: TextStyle(fontSize: 14, color: Colors.white))),
          )),
    );
  }

  Widget _submitButton(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(5)),
          boxShadow: <BoxShadow>[
            BoxShadow(
                color: Colors.grey.shade200,
                offset: Offset(2, 4),
                blurRadius: 5,
                spreadRadius: 2)
          ],
          gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: [ConstColor.darkDatalab,ConstColor.darkDatalab])),
      child: Material(
          color: Colors.transparent,
          child: InkWell(
            splashColor: Colors.blueGrey,
            onTap: () async {
              event.id != ''
                  ? _eventBloc.add(updateEventButtonPressed(
                      eventID: event.id,
                      author: authorController.text,
                      contactPerson: cpController.text,
                      description: descController.text,
                      image: _imageFile,
                      link: linkController.text,
                      imageLink: event.image,
                      location: locController.text,
                      name: nameController.text,
                      date: _selectedDate))
                  : _eventBloc.add(addEventButtonPressed(
                      name: nameController.text,
                      location: locController.text,
                      description: descController.text,
                      author: authorController.text,
                      contactPerson: cpController.text,
                      link: linkController.text,
                      date: _selectedDate,
                      imageFile: _imageFile));
            },
            child: Container(
                alignment: Alignment.center,
                width: MediaQuery.of(context).size.width,
                padding: EdgeInsets.symmetric(vertical: 15),
                child: Text(event.id != "" ? "Update Event" : 'Tambahkan Event',
                    style: TextStyle(fontSize: 20, color: ConstColor.secondaryTextDatalab))),
          )),
    );
  }

  Widget _deleteButton(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(5)),
          boxShadow: <BoxShadow>[
            BoxShadow(
                color: Colors.grey.shade200,
                offset: Offset(2, 4),
                blurRadius: 5,
                spreadRadius: 2)
          ],
          gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: [ConstColor.failedNotification,ConstColor.failedNotification])),
      child: Material(
          color: Colors.transparent,
          child: InkWell(
            splashColor: Colors.blueGrey,
            onTap: () async {
              _eventBloc.add(deleteEventButtonPressed(eventID: event.id));
            },
            child: Container(
                alignment: Alignment.center,
                width: MediaQuery.of(context).size.width,
                padding: EdgeInsets.symmetric(vertical: 15),
                child: Text("Hapus Event",
                    style: TextStyle(fontSize: 20, color: Colors.white))),
          )),
    );
  }

  Widget _form() {
    return Column(
      children: <Widget>[
        _entryField("Nama Event", "Masukkan nama event", nameController,
            entryIcon: Icon(
              Icons.event_outlined,
              color: ConstColor.darkDatalab,
            )),
        _entryField("Lokasi Event", "Masukkan tempat event diselenggarakan",
            locController,
            entryIcon: Icon(Icons.location_city_outlined,
                color: ConstColor.darkDatalab)),
        _entryField("Deskripsi Event", "Deskripsi event yang diselenggarakan",
            descController,
            entryIcon: Icon(Icons.list_alt, color: ConstColor.darkDatalab)),
        _entryField("Penyelenggara Event",
            "Masukkan instansi penyelenggara event", authorController,
            entryIcon:
                Icon(Icons.people_alt_outlined, color: ConstColor.darkDatalab)),
        _entryField("Link Pendaftaran",
            "Masukkan link pendaftaran untuk event apabila ada", linkController,
            entryIcon:
                Icon(Icons.link_outlined, color: ConstColor.darkDatalab)),
        _entryField("Kontak Panitia",
            "Masukkan Kontak Panitia yang dapat dihubungi", cpController,
            isCP: true),
        _datePicker("Tanggal Event"),
        _imagePicker("Gambar Event")
      ],
    );
  }

  showLoaderDialog(BuildContext context) {
    AlertDialog alert = AlertDialog(
      content: new Row(
        children: [
          CircularProgressIndicator(color: ConstColor.darkDatalab,),
          Container(
              margin: EdgeInsets.only(left: 7), child: Text("Loading...")),
        ],
      ),
    );
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  void initVariable() {
    if (event.id != "") {
      setState(() {
        nameController.text = event.name;
        locController.text = event.location;
        descController.text = event.description;
        authorController.text = event.author;
        cpController.text = event.contactPerson;
        linkController.text = event.link;
        _selectedDate = event.date;
      });
    }
  }

  @override
  void initState() {
    initVariable();
    _eventBloc = BlocProvider.of<EventBloc>(context);
    super.initState();
  }

  @override
  void dispose() {
    nameController.dispose();
    locController.dispose();
    descController.dispose();
    authorController.dispose();
    cpController.dispose();
    linkController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return BlocListener<EventBloc, EventState>(listener: (context, state) {
      if (state is EventFailed) {
        setState(() {
          isLoading = false;
        });
        Flushbar(
          title: event.id != ""
              ? "Penyuntingan Event Gagal"
              : "Penambahan Event Gagal",
          titleColor: Colors.white,
          message: state.message,
          messageColor: Colors.white,
          duration: Duration(seconds: 2),
          backgroundColor: ConstColor.failedNotification,
          flushbarPosition: FlushbarPosition.TOP,
          flushbarStyle: FlushbarStyle.FLOATING,
          reverseAnimationCurve: Curves.decelerate,
          forwardAnimationCurve: Curves.elasticOut,
          leftBarIndicatorColor: Colors.blue[300],
        )..show(context);
      }
      if (state is DeleteEventFailed) {
        setState(() {
          isLoading = false;
        });
        Flushbar(
          title: "Penghapusan Event Gagal",
          titleColor: Colors.white,
          message: state.message,
          messageColor: Colors.white,
          duration: Duration(seconds: 2),
          backgroundColor: ConstColor.failedNotification,
          flushbarPosition: FlushbarPosition.TOP,
          flushbarStyle: FlushbarStyle.FLOATING,
          reverseAnimationCurve: Curves.decelerate,
          forwardAnimationCurve: Curves.elasticOut,
          leftBarIndicatorColor: Colors.blue[300],
        )..show(context);
      }

      if (state is DeleteEventSucceed) {
        setState(() {
          isLoading = false;
        });
        Flushbar(
          title: "Penghapusan Event Berhasil",
          titleColor: Colors.white,
          message: "Event Berhasil Dihapus.",
          messageColor: Colors.white,
          duration: Duration(seconds: 2),
          backgroundColor: ConstColor.successNotification,
          flushbarPosition: FlushbarPosition.TOP,
          flushbarStyle: FlushbarStyle.FLOATING,
          reverseAnimationCurve: Curves.decelerate,
          forwardAnimationCurve: Curves.elasticOut,
          leftBarIndicatorColor: Colors.blue[300],
        )..show(context).then((r) => Navigator.push(
            context, MaterialPageRoute(builder: (context) => EventPage())));
      }
      if (state is EventLoading) {
        print('loading');
        setState(() {
          isLoading = true;
        });
      }

      if (state is EventSucceed) {
        setState(() {
          isLoading = false;
        });

        Flushbar(
          title: event.id != ""
              ? "Penyuntingan Event Berhasil"
              : "Penambahan Event Berhasil",
          titleColor: Colors.white,
          message: event.id != ""
              ? "Informasi Event Berhasil Diubah."
              : "Informasi Event Berhasil Ditambahkan",
          messageColor: Colors.white,
          duration: Duration(seconds: 2),
          backgroundColor: ConstColor.successNotification,
          flushbarPosition: FlushbarPosition.TOP,
          flushbarStyle: FlushbarStyle.FLOATING,
          reverseAnimationCurve: Curves.decelerate,
          forwardAnimationCurve: Curves.elasticOut,
          leftBarIndicatorColor: Colors.blue[300],
        )..show(context).then((r) => Navigator.pop(context));
      }
    }, child: BlocBuilder<EventBloc, EventState>(
      builder: (context, state) {
        return Scaffold(
          body: Container(
            height: height,
            child: Stack(
              children: <Widget>[
                Positioned(top: 40, left: 0, child: _backButton()),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        SizedBox(height: height * .1),
                        // _title(),
                        _form(),
                        SizedBox(
                          height: 20,
                        ),
                        _submitButton(context),
                        SizedBox(
                          height: 15,
                        ),
                        _deleteButton(context),
                        SizedBox(height: height * .15),
                      ],
                    ),
                  ),
                ),
                isLoading
                    ? Center(
                        child: Container(
                            height: 100,
                            width: 100,
                            child: CircularProgressIndicator(color: ConstColor.darkDatalab,)),
                      )
                    : Container()
              ],
            ),
          ),
        );
      },
    ));
  }
}
