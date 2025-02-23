import 'package:dog_catcher/core/fonts.dart';
import 'package:dog_catcher/core/theme.dart';
import 'package:dog_catcher/data/services/report_services.dart';
import 'package:dog_catcher/presentation/pages/chat/chat_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

Widget volunteerButton({
  required BuildContext context,
  String? adminId,
}) {
  return Consumer(
    builder: (context, ref, child) {
      if (adminId == null) {
        return ElevatedButton(
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(35),
            ),
            fixedSize: Size(327, 48),
            backgroundColor: Colors.grey,
          ),
          onPressed: null, // Disabled when no adminId is provided
          child: Text(
            'No Volunteer Yet',
            style: TextStyle(color: AppTheme.textPrimary),
          ),
        );
      }

      final volunteerDetailsAsync =
          ref.watch(volunteerDetailsProvider(adminId));
      return volunteerDetailsAsync.when(
        data: (data) {
          bool isVolunteerTaken = data?.isNotEmpty ?? false;
          final volunteerInfo = data ?? {};

          return ElevatedButton(
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(35),
              ),
              fixedSize: Size(327, 48),
              backgroundColor:
                  isVolunteerTaken ? AppTheme.softPink : Colors.grey,
            ),
            onPressed: () {
              if (isVolunteerTaken) {
                showVolunteerDetailsBottomSheet(
                  context: context,
                  name: volunteerInfo['name'] ?? 'N/A',
                  email: volunteerInfo['email'] ?? 'N/A',
                  phone: volunteerInfo['phone'] ?? 'N/A',
                  id: adminId,
                );
              }
            },
            child: Text(
              isVolunteerTaken ? 'Show Volunteer Details' : 'No Volunteer Yet',
              style: TextStyle(color: AppTheme.textPrimary),
            ),
          );
        },
        loading: () => Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) => ElevatedButton(
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(35),
            ),
            fixedSize: Size(327, 48),
            backgroundColor: Colors.grey,
          ),
          onPressed: null,
          child: Text('Error Loading Data',
              style: TextStyle(color: AppTheme.textPrimary)),
        ),
      );
    },
  );
}

void showVolunteerDetailsBottomSheet(
    {required BuildContext context,
    required String name,
    required String email,
    required String phone,
    required String id
    }) {
      // fetch Admin Model
      //  model=
  showModalBottomSheet(
    isScrollControlled: true,
    context: context,
    builder: (context) {
      return Container(
        width: double.infinity, // Makes the width match the device
        padding: EdgeInsets.all(16), // Adds padding around content
        decoration: BoxDecoration(
          color: AppTheme.softPink,
          borderRadius: BorderRadius.vertical(
              top: Radius.circular(16)), // Adds a rounded top corner
        ),
        child: Column(
          spacing: 10,
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Volunteer Details',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),
            Text(
              'Name: $name',
              style: Fonts.poppins,
            ),
            Text(
              'Email: $email',
              style: Fonts.poppins,
            ),
            Text(
              'Phone: $phone',
              style: Fonts.poppins,
            ),
            // SizedBox(height: 16),
            Card(
                color: AppTheme.backgroundColor,
                child: ListTile(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => ChatPage(
                              recieverId: id,
                              // recieverEmail: '',
                              valunteerName: name,
                              // user: null,
                            )));
                  },
                  leading: Icon(Icons.chat),
                  title: Text('Chat with Volunteer'),
                )),
          ],
        ),
      );
    },
  );
}
