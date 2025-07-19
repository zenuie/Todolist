import datetime
import uuid

from sqlalchemy.orm import Mapped, mapped_column

from src.database import Base

from sqlalchemy import Column, Integer, UUID, String, Boolean, DateTime, ForeignKey


class Todo(Base):
    __tablename__: str = "todos"
    # main
    id: Mapped[uuid.UUID] = mapped_column(primary_key=True, default=uuid.uuid4())
    user_id = Column(UUID(as_uuid=True), ForeignKey("users.id"), nullable=False)  # fk User

    title = Column(String, nullable=False)
    description = Column(String, nullable=False)
    complete = Column(Boolean, nullable=False)
    created_at = Column(DateTime, nullable=False, default=datetime.datetime.now())
    updated_at = Column(DateTime, nullable=False, default=datetime.datetime.now())


class TodoHistory(Base):
    __tablename__: str = "todohistory"
    id: Mapped[uuid.UUID] = mapped_column(primary_key=True, default=uuid.uuid4())
    user_id = Column(UUID(as_uuid=True), ForeignKey("users.id"), nullable=False)  # fk User
    todo_id = Column(UUID, ForeignKey("todos.id"))  # fk Todo
    created_at = Column(DateTime, nullable=False, default=datetime.datetime.now())
    updated_at = Column(DateTime, nullable=False, default=datetime.datetime.now())
