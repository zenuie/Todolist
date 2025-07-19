import datetime
import uuid
from sqlalchemy.orm import Mapped, mapped_column

from src.database import Base

from sqlalchemy import Column, UUID, String, Boolean, DateTime


class User(Base):
    __tablename__: str = "users"
    # main
    id: Mapped[uuid.UUID] = mapped_column(primary_key=True, default=uuid.uuid4)
    username = Column(String, nullable=False, unique=True)
    password = Column(String, nullable=False)
    email = Column(String, nullable=False, unique=True)
    is_active = Column(Boolean, nullable=False, default=False)

    # sup
    created_at = Column(DateTime, nullable=False, default=datetime.datetime.now())
    updated_at = Column(DateTime, nullable=False, default=datetime.datetime.now())

