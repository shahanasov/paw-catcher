import 'package:dog_catcher/core/theme.dart';
import 'package:dog_catcher/presentation/auth/widgets/widgets.dart';
import 'package:flutter/material.dart';

class AddReportPage extends StatelessWidget {
  const AddReportPage({super.key});

  @override
  Widget build(BuildContext context) {
    TextEditingController controller = TextEditingController();
    TextEditingController descriptionController = TextEditingController();
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            spacing: 20,
            children: [
              Container(
                decoration: BoxDecoration(
                    color: AppTheme().softPink,
                    borderRadius: BorderRadius.circular(10)),
                height: 180,
                child: Center(
                  child: IconButton(
                      onPressed: () {},
                      icon: Icon(
                        Icons.add_photo_alternate,
                        size: 50,
                      )),
                ),
              ),
              Text('Enter Your location'),
              textfield(
                  controller: controller, hint: "Please Enter you concern"),
              TextFormField(
                maxLines: 10,
                controller: descriptionController,
                decoration: InputDecoration(
                  hintStyle: TextStyle(color: AppTheme().textSecondary),
                  hintText: 'Type here....',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide.none),
                  filled: true,
                  fillColor: AppTheme().softPink,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
