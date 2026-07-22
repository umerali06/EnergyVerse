import 'package:fev_api_client/fev_api_client.dart';

CompanyProfile companyProfileFixture({
  String id = 'acme-energy',
  String name = 'Acme Energy',
  String? industry = 'Electric Utility',
  String timezone = 'America/Chicago',
  String locale = 'en-US',
  String? contactEmail = 'ops@acme.example.invalid',
  String? contactPhone = '+1-555-0100',
  String subscriptionTier = 'professional',
  String? logoUrl,
  DateTime? createdAt,
  int usersTotal = 12,
  int rolesTotal = 6,
}) {
  return CompanyProfile(
    (builder) {
      builder
        ..id = id
        ..name = name
        ..industry = industry
        ..timezone = timezone
        ..locale = locale
        ..contactEmail = contactEmail
        ..contactPhone = contactPhone
        ..subscriptionTier = subscriptionTier
        ..logoUrl = logoUrl
        ..createdAt = createdAt ?? DateTime.utc(2026, 1, 1)
        ..usersTotal = usersTotal
        ..rolesTotal = rolesTotal;
    },
  );
}
