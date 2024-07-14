// ignore_for_file: prefer_const_constructors

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/route_manager.dart';
import 'package:nepstyle_management_system/Logic/Bloc/reportBloc/report_bloc.dart';
import 'package:nepstyle_management_system/utils/customwidgets/dividerText.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:syncfusion_flutter_charts/sparkcharts.dart';

import '../../constants/color/color.dart';

class Report extends StatefulWidget {
  const Report({super.key});

  @override
  State<Report> createState() => _ReportState();
}

class _ReportState extends State<Report> {
  List<_SalesData1> data1 = [
    // _SalesData1('Jan', 35000),
    // _SalesData1('Feb', 28000),
    // _SalesData1('Mar', 34000),
    // _SalesData1('April', 32000),
    // _SalesData1('May', 40000)
  ];
  List<_SalesData> data = [
    // _SalesData('Jersey', 35),
    // _SalesData('Futsal Boots', 28),
    // _SalesData('Football Boots', 34),
    // _SalesData('Gloves', 32),
    // _SalesData('T-Shirts', 40)
  ];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    BlocProvider.of<ReportBloc>(context).add(ReportLoadEvent());
  }

  @override
  Widget build(BuildContext context) {
    return NestedScrollView(
      headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
        return <Widget>[
          SliverAppBar(
            expandedHeight: 120.0,
            backgroundColor: primaryColor,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(30.0),
              bottomRight: Radius.circular(30.0),
            )),
            floating: true,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              // centerTitle: true,
              title: Padding(
                padding: const EdgeInsets.only(right: 20, bottom: 10),
                child: Text("Report",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16.0,
                    )),
              ),
            ),
          ),
        ];
      },
      body: BlocBuilder<ReportBloc, ReportState>(
        builder: (context, state) {
          if (state is ReportInitial) {
            return Center(child: CircularProgressIndicator());
          }
          if (state is ReportLoaded) {
            final report = state.report;
            final List<_SalesData1> data1 = report.map((data) {
              return _SalesData1(
                  data.category, double.parse(data.value.toString()));
            }).toList();
            log(report.toString());
            return SingleChildScrollView(
              child: Column(
                children: [
                  // Row(
                  //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //   children: [
                  //     dividerText(
                  //       context: context,
                  //       dividerText: "Report",
                  //       desc: "",
                  //     ),
                  //   ],
                  // ),
                  Divider(
                    thickness: 0.5,
                  ),
                  Container(
                    height: Get.height * 0.6,
                    width: Get.width * 0.5,
                    child: SfCartesianChart(
                        primaryXAxis: CategoryAxis(),
                        // Chart title
                        title: ChartTitle(text: 'Half yearly sales analysis'),
                        // Enable legend
                        legend: Legend(isVisible: true),
                        // Enable tooltip
                        tooltipBehavior: TooltipBehavior(enable: true),
                        series: <CartesianSeries<_SalesData, String>>[
                          LineSeries<_SalesData, String>(
                              dataSource: data,
                              xValueMapper: (_SalesData sales, _) => sales.year,
                              yValueMapper: (_SalesData sales, _) =>
                                  sales.sales,
                              name: 'Sales',
                              // Enable data label
                              dataLabelSettings:
                                  DataLabelSettings(isVisible: true))
                        ]),
                  ),
                  Container(
                    height: Get.height * 0.6,
                    width: Get.width * 0.5,
                    child: SfCartesianChart(
                      primaryXAxis: CategoryAxis(),
                      primaryYAxis: NumericAxis(),
                      legend: Legend(isVisible: true),
                      series: [
                        ColumnSeries<_SalesData1, String>(
                            dataSource: data1,
                            xValueMapper: (_SalesData1 sales, _) =>
                                sales.category,
                            yValueMapper: (_SalesData1 sales, _) =>
                                sales.quantity,
                            name: 'Stock',
                            dataLabelSettings:
                                DataLabelSettings(isVisible: true))
                      ],
                    ),
                  ),
                  // Expanded(
                  //   child: Padding(
                  //     padding: const EdgeInsets.all(8.0),
                  //     //Initialize the spark charts widget
                  //     child: SfSparkLineChart.custom(
                  //       //Enable the trackball
                  //       trackball: SparkChartTrackball(
                  //           activationMode: SparkChartActivationMode.tap),
                  //       //Enable marker
                  //       marker: SparkChartMarker(
                  //           displayMode: SparkChartMarkerDisplayMode.all),
                  //       //Enable data label
                  //       labelDisplayMode: SparkChartLabelDisplayMode.all,
                  //       xValueMapper: (int index) => data[index].year,
                  //       yValueMapper: (int index) => data[index].sales,
                  //       dataCount: 5,
                  //     ),
                  //   ),
                  // )
                ],
              ),
            );
          } else {
            return Center(child: Text('Failed to load customers'));
          }
        },
      ),
    );
  }
}

class _SalesData {
  final String year;
  final double sales;

  _SalesData(this.year, this.sales);
}

class _SalesData1 {
  final String category;
  final double quantity;

  _SalesData1(this.category, this.quantity);
}
