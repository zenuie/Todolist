from typing import List
import uuid

from pydantic.v1 import UUID4
from sqlalchemy.orm import Session

from src.todos import schemas, models, crud


def get_todo_by_user(db: Session, user_id: UUID4) -> models.Todo | List:
    if user_id is None:
        raise ValueError("User not found")

    todo = crud.get_todo(db, user_id)
    return todo
