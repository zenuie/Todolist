from fastapi import APIRouter, Depends, HTTPException, status
from sqlalchemy.orm import Session
from starlette.requests import Request

from src.auth import schemas
from src.auth.decorator import login_required
from src.database import get_db
from src.auth.services.user_service import get_user, register_user, change_user_password, update_user_info, authenticate_user, login_user
from src.auth.dependencies import get_current_user  # 假設你有這個

router = APIRouter(
    prefix="/account",
    tags=["Account"],
    responses={404: {"description": "Not found"}}
)


@router.post("/register", response_model=schemas.User)
async def register(data: schemas.UserCreate, db: Session = Depends(get_db)):
    try:
        return register_user(db, data)
    except ValueError as e:
        raise HTTPException(status_code=400, detail=str(e))


@router.post("/login", response_model=schemas.Token)
async def login(request: Request, data: schemas.UserLogin, db: Session = Depends(get_db)):
    try:
        access_token = login_user(db, data)
        return access_token
    except ValueError as e:
        raise HTTPException(status_code=400, detail=str(e))
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))


@router.get("/user", response_model=schemas.User)
@login_required
async def get_user(request: Request):
    return request.state.user


@router.put("/user", response_model=schemas.User)
@login_required
async def update_user(
        data: schemas.UserUpdate,
        db: Session = Depends(get_db),
        current_user=Depends(get_current_user)
):
    return update_user_info(db, current_user, data)


@router.put("/user/change_password", response_model=schemas.User)
@login_required
async def change_password(
        data: schemas.UserPasswordUpdate,
        db: Session = Depends(get_db),
        current_user=Depends(get_current_user)
):
    try:
        return change_user_password(db, current_user, data)
    except ValueError as e:
        raise HTTPException(status_code=400, detail=str(e))
