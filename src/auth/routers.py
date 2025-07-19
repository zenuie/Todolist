from fastapi import APIRouter, Depends, HTTPException, status
from sqlalchemy.orm import Session

from src.auth import schemas
from src.auth.security import create_access_token
from src.database import get_db
from src.auth.services.user_service import get_user, register_user, change_user_password, update_user_info, authenticate_user, login_user
from src.auth.dependencies import get_current_user  # 假設你有這個

router = APIRouter(
    prefix="/auth",
    tags=["Auth"]
)


@router.post("/register", response_model=schemas.User)
def register(data: schemas.UserCreate, db: Session = Depends(get_db)):
    try:
        return register_user(db, data)
    except ValueError as e:
        raise HTTPException(status_code=400, detail=str(e))


@router.post("/login", response_model=schemas.Token)
def login(data: schemas.UserLogin, db: Session = Depends(get_db)):
    try:
        access_token = login_user(db, data)
        return access_token
    except ValueError as e:
        raise HTTPException(status_code=400, detail=str(e))
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))


@router.get("/me", response_model=schemas.User)
def get_me(current_user: schemas.User = Depends(get_current_user)):
    return current_user


@router.put("/me", response_model=schemas.User)
def update_me(
    data: schemas.UserUpdate,
    db: Session = Depends(get_db),
    current_user=Depends(get_current_user)
):
    return update_user_info(db, current_user, data)


@router.put("/me/password", response_model=schemas.User)
def change_password(
    data: schemas.UserPasswordUpdate,
    db: Session = Depends(get_db),
    current_user=Depends(get_current_user)
):
    try:
        return change_user_password(db, current_user, data)
    except ValueError as e:
        raise HTTPException(status_code=400, detail=str(e))
