import 'package:get/get.dart';

class ProfileController extends GetxController {
  var isEditing = false.obs;
  var displayImage = "".obs;
  var name = "".obs;

  void setEditingMode() {
    isEditing.value = true;
  }

  void stopEditingMode() {
    isEditing.value = false;
  }

  updateDisplayImage(String path) {
    displayImage.value = path;
  }

  updateName(String updatedName) {
    name.value = updatedName;
  }
}
