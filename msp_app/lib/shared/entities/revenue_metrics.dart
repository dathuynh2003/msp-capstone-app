class RevenueMetrics {
  final double monthlyRevenue;
  final double yearlyRevenue;
  final int activeSubscriptions;
  final double monthlyChange;
  final double yearlyChange;
  final int newSubscriptions;

  const RevenueMetrics({
    required this.monthlyRevenue,
    required this.yearlyRevenue,
    required this.activeSubscriptions,
    required this.monthlyChange,
    required this.yearlyChange,
    required this.newSubscriptions,
  });

  RevenueMetrics copyWith({
    double? monthlyRevenue,
    double? yearlyRevenue,
    int? activeSubscriptions,
    double? monthlyChange,
    double? yearlyChange,
    int? newSubscriptions,
  }) {
    return RevenueMetrics(
      monthlyRevenue: monthlyRevenue ?? this.monthlyRevenue,
      yearlyRevenue: yearlyRevenue ?? this.yearlyRevenue,
      activeSubscriptions: activeSubscriptions ?? this.activeSubscriptions,
      monthlyChange: monthlyChange ?? this.monthlyChange,
      yearlyChange: yearlyChange ?? this.yearlyChange,
      newSubscriptions: newSubscriptions ?? this.newSubscriptions,
    );
  }
}

class RevenueDataPoint {
  final String month;
  final double revenue;
  final int subscriptions;
  final int year;

  const RevenueDataPoint({
    required this.month,
    required this.revenue,
    required this.subscriptions,
    required this.year,
  });

  RevenueDataPoint copyWith({
    String? month,
    double? revenue,
    int? subscriptions,
    int? year,
  }) {
    return RevenueDataPoint(
      month: month ?? this.month,
      revenue: revenue ?? this.revenue,
      subscriptions: subscriptions ?? this.subscriptions,
      year: year ?? this.year,
    );
  }
}

class QuickInsight {
  final String title;
  final String value;
  final double change;
  final bool isPositive;
  final String icon;

  const QuickInsight({
    required this.title,
    required this.value,
    required this.change,
    required this.isPositive,
    required this.icon,
  });

  QuickInsight copyWith({
    String? title,
    String? value,
    double? change,
    bool? isPositive,
    String? icon,
  }) {
    return QuickInsight(
      title: title ?? this.title,
      value: value ?? this.value,
      change: change ?? this.change,
      isPositive: isPositive ?? this.isPositive,
      icon: icon ?? this.icon,
    );
  }
}
