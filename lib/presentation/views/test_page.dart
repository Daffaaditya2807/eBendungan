// import 'package:e_surat_bendungan/presentation/widgets/appbar.dart';
// import 'package:e_surat_bendungan/presentation/widgets/button.dart';
// import 'package:e_surat_bendungan/presentation/widgets/information.dart';
// import 'package:e_surat_bendungan/presentation/widgets/letter.dart';
// import 'package:e_surat_bendungan/presentation/widgets/text_fields.dart';
// import 'package:e_surat_bendungan/res/colors.dart';
// import 'package:e_surat_bendungan/res/margin.dart';
// import 'package:flutter/material.dart';

// class TestPage extends StatefulWidget {
//   TestPage({super.key});

//   @override
//   State<TestPage> createState() => _TestPageState();
// }

// class _TestPageState extends State<TestPage>
//     with SingleTickerProviderStateMixin {
//   late TabController _tabController;
//   TextEditingController controllerNama = TextEditingController();
//   TextEditingController controllerPassword = TextEditingController();

//   final List<Tab> menuTab = [
//     const Tab(text: "Dipesan"),
//     const Tab(text: "Diproses"),
//     const Tab(text: "Ditolak"),
//     const Tab(text: "Selesai")
//   ];

//   @override
//   void initState() {
//     super.initState();
//     _tabController = TabController(length: menuTab.length, vsync: this);
//   }

//   @override
//   void dispose() {
//     _tabController.dispose();
//     controllerNama.dispose();
//     controllerPassword.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: headerWithTabBars("Status Surat", _tabController, menuTab),
//       body: bodyTabBar([
//         _buildDipesanView(),
//         _buildDiprosesView(),
//         _buildDibatalkanView(),
//         _buildSelesaiView()
//       ], _tabController),
//     );
//   }

//   Widget _buildDipesanView() {
//     return SingleChildScrollView(
//       child: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             listLetter("Kematian", '12/02/25'),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.start,
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 buttonMenu(
//                     Icons.design_services_outlined, "Pembelian Solar", () {}),
//                 buttonMenu(Icons.design_services_outlined, "Kehilangan", () {}),
//                 buttonMenu(Icons.design_services_outlined, "Kematian", () {}),
//                 buttonMenu(Icons.design_services_outlined, "Catatan Kepolisian",
//                     () {}),
//               ],
//             ),
//             bigHeight(),
//             Row(
//               children: [
//                 Expanded(
//                   child: buttonPengaduan(
//                       "Aspirasi", () {}, greenPrimary, Icons.dock),
//                 ),
//                 mediumwidth(),
//                 Expanded(
//                   child: buttonPengaduan(
//                       "Aspirasi", () {}, redPrimaryLighter, Icons.laptop_mac),
//                 ),
//               ],
//             ),
//             mediumHeight(),
//             informationVillage()
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildDiprosesView() {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 20.0),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [mediumHeight(), uploadDocument()],
//       ),
//     );
//   }

//   Widget _buildDibatalkanView() {
//     return Center(
//       child: Text("Daftar Surat Dibatalkan", style: TextStyle(fontSize: 18)),
//     );
//   }

//   Widget _buildSelesaiView() {
//     return Center(
//       child: Text("Daftar Surat Selesai", style: TextStyle(fontSize: 18)),
//     );
//   }
// }
