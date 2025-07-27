import uuid
from typing import List

from fastapi import APIRouter, Depends, HTTPException, status
from pydantic import UUID4
from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy.orm import Session
from starlette.requests import Request

from src.todos import schemas
from src.auth.decorator import login_required
from src.auth.dependencies import get_current_user
from src.database import get_db
from src.todos.services import get_todo_by_user, create_todo_by_user, update_todo_by_user, delete_todo_by_user

router = APIRouter(
    prefix="/todo",
    tags=["Todo"],
    responses={404: {"description": "Not found"}}
)


@router.get("/", response_model=List[schemas.Todo])
@login_required
async def todo(
        request: Request,
        db: Session = Depends(get_db),
):
    user_id = request.state.user.id
    todo_list: List[schemas.Todo] = get_todo_by_user(db, user_id)
    return todo_list


@router.post("/", response_model=schemas.Todo)
@login_required
async def todo(
        request: Request,
        todo_data: schemas.TodoCreate,
        db: AsyncSession = Depends(get_db),
):
    user_id = request.state.user.id
    todo_list: schemas.Todo = await create_todo_by_user(db, user_id, todo_data)
    return todo_list


@router.put("/", response_model=List[schemas.Todo])
@login_required
async def todo(
        request: Request,
        todo_datas: List[schemas.TodoUpdate],
        db: AsyncSession = Depends(get_db),
):
    user_id = request.state.user.id

    todo_list: schemas.Todo = await update_todo_by_user(db, user_id, todo_datas)
    return todo_list


@router.delete("/{todo_id}")
@login_required
async def delete_todo(
    request: Request,
    todo_id: uuid.UUID,
    db: Session = Depends(get_db),
):
    user_id = request.state.user.id
    success = await delete_todo_by_user(db, user_id, todo_id)
    if not success:
        raise HTTPException(status_code=404, detail="Todo not found")
    return {"detail": "Todo deleted"}
