import '../entities/revenue_metrics.dart';

class RevenueMockData {
  static const RevenueMetrics metrics = RevenueMetrics(
    monthlyRevenue: 12450.0,
    yearlyRevenue: 148200.0,
    activeSubscriptions: 1247,
    monthlyChange: 12.5,
    yearlyChange: 8.2,
    newSubscriptions: 23,
  );

  // Historical data for multiple years
  static final Map<int, List<RevenueDataPoint>> yearlyTrends = {
    2022: [
      RevenueDataPoint(month: 'Jan', revenue: 7200.0, subscriptions: 750, year: 2022),
      RevenueDataPoint(month: 'Feb', revenue: 8100.0, subscriptions: 780, year: 2022),
      RevenueDataPoint(month: 'Mar', revenue: 8900.0, subscriptions: 820, year: 2022),
      RevenueDataPoint(month: 'Apr', revenue: 9500.0, subscriptions: 880, year: 2022),
      RevenueDataPoint(month: 'May', revenue: 10200.0, subscriptions: 920, year: 2022),
      RevenueDataPoint(month: 'Jun', revenue: 10800.0, subscriptions: 950, year: 2022),
      RevenueDataPoint(month: 'Jul', revenue: 11200.0, subscriptions: 980, year: 2022),
      RevenueDataPoint(month: 'Aug', revenue: 11800.0, subscriptions: 1020, year: 2022),
      RevenueDataPoint(month: 'Sep', revenue: 12200.0, subscriptions: 1050, year: 2022),
      RevenueDataPoint(month: 'Oct', revenue: 12800.0, subscriptions: 1080, year: 2022),
      RevenueDataPoint(month: 'Nov', revenue: 13200.0, subscriptions: 1120, year: 2022),
      RevenueDataPoint(month: 'Dec', revenue: 13800.0, subscriptions: 1150, year: 2022),
    ],
    2023: [
      RevenueDataPoint(month: 'Jan', revenue: 14200.0, subscriptions: 1180, year: 2023),
      RevenueDataPoint(month: 'Feb', revenue: 14800.0, subscriptions: 1220, year: 2023),
      RevenueDataPoint(month: 'Mar', revenue: 15200.0, subscriptions: 1250, year: 2023),
      RevenueDataPoint(month: 'Apr', revenue: 15800.0, subscriptions: 1280, year: 2023),
      RevenueDataPoint(month: 'May', revenue: 16200.0, subscriptions: 1320, year: 2023),
      RevenueDataPoint(month: 'Jun', revenue: 16800.0, subscriptions: 1350, year: 2023),
      RevenueDataPoint(month: 'Jul', revenue: 17200.0, subscriptions: 1380, year: 2023),
      RevenueDataPoint(month: 'Aug', revenue: 17800.0, subscriptions: 1420, year: 2023),
      RevenueDataPoint(month: 'Sep', revenue: 18200.0, subscriptions: 1450, year: 2023),
      RevenueDataPoint(month: 'Oct', revenue: 18800.0, subscriptions: 1480, year: 2023),
      RevenueDataPoint(month: 'Nov', revenue: 19200.0, subscriptions: 1520, year: 2023),
      RevenueDataPoint(month: 'Dec', revenue: 19800.0, subscriptions: 1550, year: 2023),
    ],
    2024: [
      RevenueDataPoint(month: 'Jan', revenue: 8500.0, subscriptions: 890, year: 2024),
      RevenueDataPoint(month: 'Feb', revenue: 10200.0, subscriptions: 920, year: 2024),
      RevenueDataPoint(month: 'Mar', revenue: 9800.0, subscriptions: 950, year: 2024),
      RevenueDataPoint(month: 'Apr', revenue: 11500.0, subscriptions: 1020, year: 2024),
      RevenueDataPoint(month: 'May', revenue: 13200.0, subscriptions: 1150, year: 2024),
      RevenueDataPoint(month: 'Jun', revenue: 12450.0, subscriptions: 1247, year: 2024),
      RevenueDataPoint(month: 'Jul', revenue: 13500.0, subscriptions: 1280, year: 2024),
      RevenueDataPoint(month: 'Aug', revenue: 14200.0, subscriptions: 1320, year: 2024),
      RevenueDataPoint(month: 'Sep', revenue: 13800.0, subscriptions: 1350, year: 2024),
      RevenueDataPoint(month: 'Oct', revenue: 14500.0, subscriptions: 1380, year: 2024),
      RevenueDataPoint(month: 'Nov', revenue: 15200.0, subscriptions: 1420, year: 2024),
      RevenueDataPoint(month: 'Dec', revenue: 14800.0, subscriptions: 1450, year: 2024),
    ],
  };

  static const List<RevenueDataPoint> monthlyTrends = [
    RevenueDataPoint(month: 'Jan', revenue: 8500.0, subscriptions: 890, year: 2024),
    RevenueDataPoint(month: 'Feb', revenue: 10200.0, subscriptions: 920, year: 2024),
    RevenueDataPoint(month: 'Mar', revenue: 9800.0, subscriptions: 950, year: 2024),
    RevenueDataPoint(month: 'Apr', revenue: 11500.0, subscriptions: 1020, year: 2024),
    RevenueDataPoint(month: 'May', revenue: 13200.0, subscriptions: 1150, year: 2024),
    RevenueDataPoint(month: 'Jun', revenue: 12450.0, subscriptions: 1247, year: 2024),
    RevenueDataPoint(month: 'Jul', revenue: 13500.0, subscriptions: 1280, year: 2024),
    RevenueDataPoint(month: 'Aug', revenue: 14200.0, subscriptions: 1320, year: 2024),
    RevenueDataPoint(month: 'Sep', revenue: 13800.0, subscriptions: 1350, year: 2024),
    RevenueDataPoint(month: 'Oct', revenue: 14500.0, subscriptions: 1380, year: 2024),
    RevenueDataPoint(month: 'Nov', revenue: 15200.0, subscriptions: 1420, year: 2024),
    RevenueDataPoint(month: 'Dec', revenue: 14800.0, subscriptions: 1450, year: 2024),
  ];

  static const List<QuickInsight> insights = [
    QuickInsight(
      title: 'Growth Rate',
      value: '15.2%',
      change: 15.2,
      isPositive: true,
      icon: 'trending_up',
    ),
    QuickInsight(
      title: 'New Users',
      value: '89',
      change: 23.0,
      isPositive: true,
      icon: 'people',
    ),
    QuickInsight(
      title: 'Avg. Revenue',
      value: '\$119',
      change: 8.5,
      isPositive: true,
      icon: 'attach_money',
    ),
    QuickInsight(
      title: 'Churn Rate',
      value: '2.1%',
      change: -0.3,
      isPositive: true,
      icon: 'schedule',
    ),
  ];

  // Simulate real-time data updates
  static RevenueMetrics getUpdatedMetrics() {
    final random = DateTime.now().millisecondsSinceEpoch % 100;
    return RevenueMetrics(
      monthlyRevenue: metrics.monthlyRevenue + (random * 10),
      yearlyRevenue: metrics.yearlyRevenue + (random * 100),
      activeSubscriptions: metrics.activeSubscriptions + (random % 10),
      monthlyChange: metrics.monthlyChange + (random % 5 - 2),
      yearlyChange: metrics.yearlyChange + (random % 3 - 1),
      newSubscriptions: metrics.newSubscriptions + (random % 5),
    );
  }

  static List<RevenueDataPoint> getUpdatedTrends() {
    final random = DateTime.now().millisecondsSinceEpoch % 100;
    return monthlyTrends.map((point) => RevenueDataPoint(
      month: point.month,
      revenue: point.revenue + (random * 50),
      subscriptions: point.subscriptions + (random % 20),
      year: point.year,
    )).toList();
  }

  // Get trends for a specific year
  static List<RevenueDataPoint> getTrendsForYear(int year) {
    return yearlyTrends[year] ?? [];
  }

  // Get available years
  static List<int> getAvailableYears() {
    return yearlyTrends.keys.toList()..sort();
  }

  // Get metrics for a specific date range
  static RevenueMetrics getMetricsForDateRange(DateTime? startDate, DateTime? endDate) {
    if (startDate == null || endDate == null) {
      return metrics;
    }

    // Calculate metrics based on date range
    // final daysDiff = endDate.difference(startDate).inDays;
    // final monthsDiff = (endDate.year - startDate.year) * 12 + (endDate.month - startDate.month);
    
    // Get trends for the date range to calculate actual metrics
    final trends = getTrendsForDateRange(startDate, endDate);
    
    if (trends.isEmpty) {
      return metrics;
    }
    
    // Calculate actual revenue and subscriptions from trends
    final totalRevenue = trends.fold<double>(0, (sum, trend) => sum + trend.revenue);
    final totalSubscriptions = trends.fold<int>(0, (sum, trend) => sum + trend.subscriptions);
    final avgRevenue = totalRevenue / trends.length;
    final avgSubscriptions = (totalSubscriptions / trends.length).round();
    
    // Calculate growth rate based on trends
    double growthRate = 0;
    if (trends.length > 1) {
      final firstRevenue = trends.first.revenue;
      final lastRevenue = trends.last.revenue;
      growthRate = ((lastRevenue - firstRevenue) / firstRevenue) * 100;
    }
    
    return RevenueMetrics(
      monthlyRevenue: avgRevenue,
      yearlyRevenue: totalRevenue,
      activeSubscriptions: avgSubscriptions,
      monthlyChange: growthRate,
      yearlyChange: growthRate * 0.8,
      newSubscriptions: (avgSubscriptions * 0.1).round(),
    );
  }

  // Get trends for a specific date range
  static List<RevenueDataPoint> getTrendsForDateRange(DateTime? startDate, DateTime? endDate) {
    if (startDate == null || endDate == null) {
      return monthlyTrends;
    }

    final startYear = startDate.year;
    final endYear = endDate.year;
    final startMonth = startDate.month;
    final endMonth = endDate.month;

    List<RevenueDataPoint> filteredTrends = [];

    for (int year = startYear; year <= endYear; year++) {
      final yearTrends = yearlyTrends[year] ?? [];
      
      for (int month = 0; month < yearTrends.length; month++) {
        final monthNumber = month + 1;
        
        // Check if this month is within the date range
        if (year == startYear && monthNumber < startMonth) continue;
        if (year == endYear && monthNumber > endMonth) continue;
        
        filteredTrends.add(yearTrends[month]);
      }
    }


    return filteredTrends;
  }

  // Get YTD trends (from start of year to current month - 1)
  static List<RevenueDataPoint> getYTDTrends() {
    final now = DateTime.now();
    final startOfYear = DateTime(now.year, 1, 1);
    final endOfYear = DateTime(now.year, now.month - 1, 31);
    
    return getTrendsForDateRange(startOfYear, endOfYear);
  }

  // Get metrics for YTD
  static RevenueMetrics getYTDMetrics() {
    final now = DateTime.now();
    final startOfYear = DateTime(now.year, 1, 1);
    final endOfYear = DateTime(now.year, now.month - 1, 31);
    
    return getMetricsForDateRange(startOfYear, endOfYear);
  }

}
