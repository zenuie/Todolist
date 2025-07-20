from typing import List

from fastapi import APIRouter, Depends, HTTPException, status
from sqlalchemy.orm import Session
from starlette.requests import Request

from src.todos import schemas
from src.auth.decorator import login_required
from src.auth.dependencies import get_current_user
from src.database import get_db
from src.todos.services import get_todo_by_user

router = APIRouter(
    prefix="/todo",
    tags=["Todo"],
    responses={404: {"description": "Not found"}}
)


@router.get("/", response_model=List[schemas.Todo])
@login_required
def todo(
        request: Request,
        db: Session = Depends(get_db),
):
    user_id = request.state.user.id
    todo_list: List[schemas.Todo] = get_todo_by_user(db, user_id)
    return todo_list


@router.post("/", response_model=List[schemas.Todo])
@login_required
def todo(
        request: Request,
        db: Session = Depends(get_db),
):
    return request.state.user


@router.put("/", response_model=schemas.Todo)
@login_required
def todo(
        request: Request,
        db: Session = Depends(get_db),
):
    return


@router.delete("/", response_model=schemas.Todo)
@login_required
def todo(
        request: Request,
        db: Session = Depends(get_db),
):
    return
