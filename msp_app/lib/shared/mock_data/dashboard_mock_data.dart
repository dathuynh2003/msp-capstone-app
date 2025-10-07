import '../entities/company.dart';
import '../entities/plan.dart';

class DashboardMockData {
  static final List<Plan> plans = [
    const Plan(
      id: 'p_free',
      name: 'Free',
      pricePerMonth: 0,
      maxUsers: 3,
      features: ['Basic usage', 'Community support'],
    ),
    const Plan(
      id: 'p_pro',
      name: 'Pro',
      pricePerMonth: 19,
      maxUsers: 25,
      features: ['Advanced analytics', 'Priority support', 'More storage'],
    ),
    const Plan(
      id: 'p_business',
      name: 'Business',
      pricePerMonth: 49,
      maxUsers: 100,
      features: ['SSO', 'Audit logs', 'Custom retention'],
    ),
  ];

  static final List<Company> companies = [
    const Company(
      id: 'c1',
      name: 'Acme Inc.',
      email: 'contact@acme.com',
      planId: 'p_pro',
      members: 18,
    ),
    const Company(
      id: 'c2',
      name: 'Globex',
      email: 'hello@globex.com',
      planId: 'p_business',
      members: 56,
    ),
    const Company(
      id: 'c3',
      name: 'Umbrella',
      email: 'support@umbrella.com',
      planId: 'p_free',
      members: 3,
    ),
  ];
}
