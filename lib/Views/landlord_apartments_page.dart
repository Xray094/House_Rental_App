import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:house_rental_app/core/controllers/landlord_aparments_controller.dart';

class LandlordApartmentsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final ctrl = Get.put(LandlordApartmentsController());

    return Obx(() {
      if (ctrl.isLoading.value) {
        return const Center(child: CircularProgressIndicator());
      }
      if (ctrl.myApartments.isEmpty) {
        return const Center(
          child: Text("You haven't listed any apartments yet."),
        );
      }

      return ListView.builder(
        itemCount: ctrl.myApartments.length,
        padding: EdgeInsets.all(16.w),
        itemBuilder: (context, index) {
          final apt = ctrl.myApartments[index];
          return Card(
            margin: EdgeInsets.only(bottom: 16.h),
            child: ListTile(
              leading: Image.network(
                apt.attributes.galleryUrls.first,
                width: 60.w,
                fit: BoxFit.cover,
              ),
              title: Text(apt.attributes.title),
              subtitle: Text(apt.attributes.formattedPrice),
              trailing: const Icon(Icons.edit_outlined),
              onTap: () {
                // Navigate to edit page or details
              },
            ),
          );
        },
      );
    });
  }
}

class CreateApartmentPage {}
