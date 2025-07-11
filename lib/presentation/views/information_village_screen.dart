import 'package:e_surat_bendungan/presentation/controller/controller_information_village.dart';
import 'package:e_surat_bendungan/res/colors.dart';
import 'package:e_surat_bendungan/res/fonts_style.dart';
import 'package:e_surat_bendungan/res/page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../config/routes.dart';
import '../../res/padding.dart';
import '../../res/rounded.dart';
import '../../res/size.dart';
import '../widgets/information.dart';

class InformationVillageScreen extends StatelessWidget {
  InformationVillageScreen({super.key});

  final controller = Get.find<
      ControllerInformationVillage>(); // Use Get.find instead of Get.put

  @override
  Widget build(BuildContext context) {
    return bodyApp(
      appbar: AppBar(
        centerTitle: true,
        title: Text(
          "Berita Desa",
          style: boldFont.copyWith(
            color: greenPrimaryDarker,
          ),
        ),
        elevation: 0,
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: greenPrimaryDarker),
          onPressed: () {
            controller.resetFilter(); // Reset filter before navigating back
            Get.back();
          },
        ),
      ),
      child: Column(
        children: [
          // Search input field
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: TextField(
              style: regularFont.copyWith(
                  color: Colors.black, fontSize: mediumFontSize),
              cursorColor: greyPrimary,
              cursorWidth: 1.5,
              decoration: InputDecoration(
                hintText: "Cari berdasarkan judul atau kategori...",
                filled: true,

                fillColor: Color.fromARGB(255, 248, 248, 248),
                // prefixIcon: Icon(Icons.search, color: greyPrimary),
                border: OutlineInputBorder(
                  borderRadius: borderRoundedMedium,
                  borderSide: BorderSide(color: Color(0xffD0D5DD), width: 1.0),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: borderRoundedMedium,
                  borderSide: BorderSide(color: Color(0xffD0D5DD), width: 1.0),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: borderRoundedMedium,
                  borderSide: BorderSide(color: greenPrimary, width: 1.0),
                ),
              ),
              onChanged: (value) => controller.searchInformation(value),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
// Category filter
          Obx(() => SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    // "All" category to reset category filter
                    _buildCategoryChip(
                      label: "Semua",
                      isSelected: controller.selectedCategory.value.isEmpty,
                      onTap: () => controller.filterInformation(category: ''),
                    ),
                    ...controller.uniqueCategories.map((category) => Padding(
                          padding: const EdgeInsets.only(left: 8),
                          child: _buildCategoryChip(
                            label: category,
                            isSelected:
                                controller.selectedCategory.value == category,
                            onTap: () => controller.filterInformation(
                                category: category),
                          ),
                        )),
                  ],
                ),
              )),
          const SizedBox(
            height: 10,
          ),
          // Content
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value) {
                return Center(
                  child: CircularProgressIndicator(
                    color: greenPrimary,
                  ),
                );
              }
              return Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                child: GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 16,
                    crossAxisSpacing: 10,
                    childAspectRatio: 1.2,
                    mainAxisExtent: 210,
                  ),
                  itemCount: controller.filteredInformationList.length,
                  itemBuilder: (context, index) {
                    final info = controller.filteredInformationList[index];
                    return InkWell(
                      onTap: () => Get.toNamed(Routes.detailInformationVillage,
                          arguments: {'data': info}),
                      child: informationVillageDetail(info),
                    );
                  },
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  // Helper method to build category chip
  Widget _buildCategoryChip({
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: isSelected ? greenPrimary : Color.fromARGB(255, 248, 248, 248),
          border: !isSelected ? Border.all(color: Color(0xffD0D5DD)) : null,
          borderRadius: borderRoundedMedium,
        ),
        child: Padding(
          padding: allMediumPadding,
          child: Text(
            label,
            style: regularFont.copyWith(
              color: isSelected ? Colors.white : Colors.black,
            ),
          ),
        ),
      ),
    );
  }
}
