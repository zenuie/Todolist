import uuid
from typing import Any, List

from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy.orm import Session
from src.todos import models, schemas


# ------------Create-----------------


def create_todo(db: Session, qsTodo: models.Todo) -> models.Todo:
    db.add(qsTodo)
    db.commit()
    db.refresh(qsTodo)

    return qsTodo


# ------------Create-----------------


# -------------Read------------------
def get_todo(db: Session, user_id: uuid.UUID) -> list[type[models.Todo]]:
    return db.query(models.Todo).filter(models.Todo.user_id == user_id).all()


# -------------Read------------------


# ------------Update-----------------
def update_todos(db: Session, update_data: List[schemas.TodoUpdate]) -> List[models.Todo]:
    # 1. 先查詢所有要更新的 todo
    ids = [item.id for item in update_data]
    todos = db.query(models.Todo).filter(models.Todo.id.in_(ids)).all()
    todo_map = {todo.id: todo for todo in todos}

    updated_todos = []
    for item in update_data:
        todo = todo_map.get(item.id)
        if not todo:
            continue
        update_dict = item.model_dump(exclude_unset=True)
        for key, value in update_dict.items():
            if key != "id":
                setattr(todo, key, value)
        updated_todos.append(todo)
    db.commit()
    for todo in updated_todos:
        db.refresh(todo)
    return updated_todos


# ------------Update-----------------


# ------------Delete-----------------
def delete_todo(db: Session, user_id: uuid.UUID, todo_id: uuid.UUID) -> bool:
    todo = db.query(models.Todo).filter(
        models.Todo.user_id == user_id,
        models.Todo.id == todo_id
    ).first()
    if not todo:
        return False
    db.delete(todo)
    db.commit()
    return True
# ------------Delete-----------------
