from dataclasses import dataclass
from importlib import resources
from typing import Final

# Brand tokens mirrored from apps/mobile/lib/design_system/tokens_generated.dart
# (DsColors.accent500 / primary900 / primary800) so transactional email matches
# the in-app palette instead of drifting from it.
_ACCENT = "#FB4402"
_NAVY_900 = "#001A49"
_NAVY_800 = "#002865"
_INK_MUTED = "#5B6B85"
_BORDER = "#E3E8F0"
_BACKGROUND = "#F1F4F9"

LOGO_CONTENT_ID: Final = "fev-logo"


def _logo_bytes() -> bytes:
    return resources.files("app.email.assets").joinpath("logo.png").read_bytes()


@dataclass(frozen=True)
class RenderedEmail:
    subject: str
    html_body: str
    text_body: str
    inline_images: dict[str, bytes]


def _base_layout(*, preheader: str, body_html: str) -> str:
    return f"""\
<!doctype html>
<html lang="en">
  <head>
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <meta name="color-scheme" content="light" />
  </head>
  <body style="margin:0; padding:0; background-color:{_BACKGROUND}; font-family:'Segoe UI', Roboto, Helvetica, Arial, sans-serif;">
    <div style="display:none; max-height:0; overflow:hidden; opacity:0;">{preheader}</div>
    <table role="presentation" width="100%" cellpadding="0" cellspacing="0" style="background-color:{_BACKGROUND}; padding:32px 16px;">
      <tr>
        <td align="center">
          <table role="presentation" width="480" cellpadding="0" cellspacing="0" style="max-width:480px; width:100%; background-color:#FFFFFF; border-radius:16px; overflow:hidden; border:1px solid {_BORDER};">
            <tr>
              <td style="background-color:{_NAVY_900}; padding:28px 32px; text-align:center;">
                <img src="cid:{LOGO_CONTENT_ID}" alt="Flacron EnergyVerse" width="200" style="display:block; margin:0 auto; max-width:200px; height:auto;" />
              </td>
            </tr>
            <tr>
              <td style="padding:32px;">
                {body_html}
              </td>
            </tr>
            <tr>
              <td style="padding:20px 32px; border-top:1px solid {_BORDER}; text-align:center;">
                <p style="margin:0; font-size:12px; line-height:18px; color:{_INK_MUTED};">
                  Flacron EnergyVerse &middot; Powering today. Sustaining tomorrow.
                </p>
              </td>
            </tr>
          </table>
        </td>
      </tr>
    </table>
  </body>
</html>
"""


def _button(*, label: str, href: str) -> str:
    return f"""\
<table role="presentation" cellpadding="0" cellspacing="0" style="margin:28px 0;">
  <tr>
    <td style="border-radius:10px; background-color:{_ACCENT};">
      <a href="{href}" target="_blank"
         style="display:inline-block; padding:14px 28px; font-size:15px; font-weight:600; color:#FFFFFF; text-decoration:none; border-radius:10px;">
        {label}
      </a>
    </td>
  </tr>
</table>
"""


def render_verification_email(*, display_name: str, verification_link: str) -> RenderedEmail:
    body_html = f"""\
<h1 style="margin:0 0 12px; font-size:20px; line-height:28px; color:{_NAVY_900};">Verify your email</h1>
<p style="margin:0 0 4px; font-size:15px; line-height:24px; color:{_NAVY_800};">Hi {display_name},</p>
<p style="margin:0 0 4px; font-size:15px; line-height:24px; color:{_INK_MUTED};">
  Confirm your email address to finish setting up your Flacron EnergyVerse account.
</p>
{_button(label="Verify email address", href=verification_link)}
<p style="margin:0; font-size:13px; line-height:20px; color:{_INK_MUTED};">
  If the button doesn't work, copy and paste this link into your browser:<br />
  <a href="{verification_link}" style="color:{_ACCENT}; word-break:break-all;">{verification_link}</a>
</p>
<p style="margin:20px 0 0; font-size:13px; line-height:20px; color:{_INK_MUTED};">
  If you didn't create this account, you can safely ignore this email.
</p>
"""
    text_body = (
        f"Hi {display_name},\n\n"
        "Confirm your email address to finish setting up your Flacron EnergyVerse "
        "account by opening this link:\n\n"
        f"{verification_link}\n\n"
        "If you didn't create this account, you can safely ignore this email.\n"
    )
    return RenderedEmail(
        subject="Verify your email for Flacron EnergyVerse",
        html_body=_base_layout(
            preheader="Confirm your email address to finish setting up your account.",
            body_html=body_html,
        ),
        text_body=text_body,
        inline_images={LOGO_CONTENT_ID: _logo_bytes()},
    )
