import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:pluto_grid/pluto_grid.dart';
import 'package:shimmer/shimmer.dart';

class DefaultGrid extends StatelessWidget {
  final List<PlutoColumn> columns;
  final List<PlutoRow> rows;
  final Function(PlutoGridOnLoadedEvent)? onLoaded;
  final Widget Function(PlutoGridStateManager)? createFooter;
  final bool? isLoading;

  const DefaultGrid({
    super.key,
    required this.columns,
    required this.rows,
    this.createFooter,
    this.onLoaded,
    this.isLoading,
  });

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    bool isDesktop = screenWidth > 600;
    return Stack(
      children: [
        SizedBox(
          height:
              isDesktop ? ((screenHeight * 2 / 3) - 40) : screenHeight - 200,
          child: PlutoGrid(
            configuration: PlutoGridConfiguration(
              columnSize: const PlutoGridColumnSizeConfig(
                autoSizeMode: PlutoAutoSizeMode.scale,
              ),
              style: PlutoGridStyleConfig(
                rowHeight: 55,
                borderColor: Colors.grey.shade100,
                gridBorderRadius: BorderRadius.circular(10),
                gridBorderColor: Colors.grey.shade300,
                evenRowColor: Colors.grey.shade50,
                defaultCellPadding: const EdgeInsets.symmetric(
                  horizontal: 16.0,
                  vertical: 8.0,
                ),
              ),
            ),
            columns: columns,
            rows: rows,
            onLoaded: onLoaded,
            createFooter: createFooter,
          ),
        ),
        if (isLoading ?? false)
          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 1.0, sigmaY: 1.0),
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                ),
                child: const Center(
                  child: CircularProgressIndicator(),
                ),
              ),
            ),
          ),
      ],
    );
  }
}

PlutoColumn buildTxtClm(String title, String field, double width,
    {bool? hide,
    bool? isCenter,
    Function(PlutoColumnRendererContext)? renderer}) {
  return PlutoColumn(
    title: title,
    enableEditingMode: false,
    field: field,
    type: PlutoColumnType.text(),
    enableContextMenu: false,
    enableDropToResize: false,
    width: width,
    textAlign: isCenter ?? false
        ? PlutoColumnTextAlign.center
        : PlutoColumnTextAlign.start,
    hide: hide ?? false,
    renderer: (renderer != null)
        ? (ctx) {
            return renderer(ctx);
          }
        : null,
  );
}

PlutoColumn buildNumClm(String title, String field, double width) {
  return PlutoColumn(
    title: title,
    enableEditingMode: false,
    field: field,
    type: PlutoColumnType.number(),
    width: width,
  );
}

PlutoColumn buildDateClm(String title, String field, double width) {
  return PlutoColumn(
    title: title,
    enableEditingMode: false,
    field: field,
    type: PlutoColumnType.date(),
    width: width,
  );
}

PlutoColumn buildIconClm(
    String field, IconData icon, Function(PlutoColumnRendererContext) onTap) {
  return PlutoColumn(
    title: '',
    field: field,
    enableColumnDrag: false,
    enableRowDrag: false,
    enableAutoEditing: false,
    enableContextMenu: false,
    enableEditingMode: false,
    enableDropToResize: false,
    enableSorting: false,
    type: PlutoColumnType.text(),
    width: 50,
    renderer: (ctx) => InkWell(
      onTap: () => onTap(ctx),
      child: Icon(icon),
    ),
  );
}

PlutoColumn buildDropdownClm(
    String title, String field, double width, List<String> listOfItems) {
  return PlutoColumn(
    title: title,
    field: field,
    enableDropToResize: false,
    enableSorting: false,
    type: PlutoColumnType.select(listOfItems),
    width: width,
  );
}
