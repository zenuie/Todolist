import uuid
from typing import Any

from sqlalchemy.orm import Session
from src.todos import models, schemas


# ------------Create-----------------


def create_user(db: Session, todo: models.Todo) -> models.Todo:
    db.add(todo)
    db.commit()
    db.refresh(todo)

    return todo


# ------------Create-----------------


# -------------Read------------------
def get_todo(db: Session, user_id: uuid.UUID) -> list[type[models.Todo]]:
    return db.query(models.Todo).filter(models.Todo.user_id == user_id).all()

# -------------Read------------------


# ------------Update-----------------


# ------------Update-----------------


# ------------Delete-----------------
# ------------Delete-----------------
