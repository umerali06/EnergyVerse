import re
from zoneinfo import available_timezones

# A small, real, energy-sector-relevant set -- not exhaustive, matches what the
# 3.3 admin/mobile Industry select actually presents.
INDUSTRY_CHOICES: tuple[str, ...] = (
    "Oil & Gas",
    "Electric Utility",
    "Renewable Energy",
    "Water Utility",
    "Mining",
    "Midstream / Pipeline",
    "Industrial Manufacturing",
    "Other",
)

_VALID_TIMEZONES = available_timezones()

# Permissive BCP-47 shape (language, optional region) -- not a fixed enum, since
# Intl/browsers already handle arbitrary valid tags; this just rejects garbage.
_LOCALE_PATTERN = re.compile(r"^[a-z]{2,3}(-[A-Z]{2})?$")


def is_valid_industry(value: str) -> bool:
    return value in INDUSTRY_CHOICES


def is_valid_timezone(value: str) -> bool:
    return value in _VALID_TIMEZONES


def is_valid_locale(value: str) -> bool:
    return bool(_LOCALE_PATTERN.match(value))
