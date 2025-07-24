import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class ChartConfig {
  final String label;
  final IconData? icon;
  final Color color;

  ChartConfig({
    required this.label,
    this.icon,
    required this.color,
  });
}

class ChartContainer extends StatelessWidget {
  final Map<String, ChartConfig> config;
  final List<BarChartGroupData> barGroups;
  final String title;
  final bool showLegend;

  const ChartContainer({
    super.key,
    required this.config,
    required this.barGroups,
    this.title = '',
    this.showLegend = true,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (title.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Text(
              title,
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ),
        AspectRatio(
          aspectRatio: 1.5,
          child: BarChart(
            BarChartData(
              barGroups: barGroups,
              titlesData: FlTitlesData(
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(showTitles: true),
                ),
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(showTitles: true),
                ),
              ),
              borderData: FlBorderData(show: false),
              gridData: FlGridData(show: true),
              barTouchData: BarTouchData(
                enabled: true,
                touchTooltipData: BarTouchTooltipData(
                  tooltipBgColor: Colors.black87,
                  getTooltipItem: (group, groupIndex, rod, rodIndex) {
                    final key = config.keys.elementAt(groupIndex);
                    final conf = config[key]!;
                    return BarTooltipItem(
                      '${conf.label}\n${rod.toY.toInt()}',
                      const TextStyle(color: Colors.white),
                    );
                  },
                ),
              ),
            ),
          ),
        ),
        if (showLegend) ChartLegend(config: config),
      ],
    );
  }
}

class ChartLegend extends StatelessWidget {
  final Map<String, ChartConfig> config;

  const ChartLegend({super.key, required this.config});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 16,
      runSpacing: 8,
      alignment: WrapAlignment.center,
      children: config.entries.map((entry) {
        final conf = entry.value;
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 12,
              height: 12,
              margin: const EdgeInsets.only(right: 6),
              decoration: BoxDecoration(
                color: conf.color,
                shape: BoxShape.rectangle,
              ),
            ),
            if (conf.icon != null) Icon(conf.icon, size: 14),
            if (conf.icon != null) const SizedBox(width: 4),
            Text(conf.label, style: const TextStyle(fontSize: 12)),
          ],
        );
      }).toList(),
    );
  }
}
