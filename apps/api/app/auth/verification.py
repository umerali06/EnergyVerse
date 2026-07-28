from app.auth.links import generate_email_verification_link
from app.db.firestore import get_firestore_client
from app.db.repositories.users import UserRepository
from app.email.sender import EmailMessage, EmailSender, get_email_sender
from app.email.templates import render_verification_email
from app.models.base import CompanyScope
from app.models.entities import CurrentUser


class VerificationEmailService:
    def __init__(self, *, users: UserRepository, sender: EmailSender) -> None:
        self._users = users
        self._sender = sender

    async def send(self, current_user: CurrentUser) -> bool:
        if current_user.email_verified:
            return False
        scope = CompanyScope(company_id=current_user.company_id)
        user = await self._users.get(scope, current_user.uid)
        display_name = user.display_name if user is not None else current_user.email

        link = await generate_email_verification_link(current_user.email)
        rendered = render_verification_email(
            display_name=display_name,
            verification_link=link,
        )
        await self._sender.send(
            EmailMessage(
                to=current_user.email,
                subject=rendered.subject,
                html_body=rendered.html_body,
                text_body=rendered.text_body,
                inline_images=rendered.inline_images,
            )
        )
        return True


def get_verification_email_service() -> VerificationEmailService:
    return VerificationEmailService(
        users=UserRepository(get_firestore_client()),
        sender=get_email_sender(),
    )
