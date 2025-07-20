from datetime import timedelta
from typing import Dict

from pydantic import UUID4
from sqlalchemy.orm import Session
from src.auth import models, schemas, crud
from src.auth.models import User
from src.auth.security import hash_password, verify_password, create_access_token, refresh_access_token


def get_user(db: Session, data: schemas.UserLogin, user_id: UUID4 = None) -> models.User:
    if data.username is None:
        raise ValueError("Either username must be provided")

    if data.username:
        user = crud.get_user_by_username(db, data.username)
    else:
        user = crud.get_user(db, user_id)
    return user


def register_user(db: Session, data: schemas.UserCreate) -> models.User:
    user = models.User(
        username=data.username,
        email=data.email,
        password=hash_password(data.password)
    )
    return crud.create_user(db, user)


def login_user(db: Session, data: schemas.UserCreate, expiry_minutes: int = 30) -> Dict:
    user = authenticate_user(db, data)
    token = create_access_token(
        data={"sub": str(user.id), "username": user.username},
        # expires_delta=timedelta(minutes=expiry_minutes)
    )
    refresh_token = refresh_access_token(data={"sub": str(user.id), "username": user.username})

    return {
        "access_token": token,
        "token_type": "bearer",
        "expires_in": expiry_minutes * 60,
        "refresh_token": refresh_token,
    }


def authenticate_user(db: Session, data: schemas.UserLogin) -> ValueError | User:
    user = get_user(db, data)
    if not user or not verify_password(data.password, user.password):
        return ValueError("Invalid username or password")

    return user


def change_user_password(db: Session, user: models.User, data: schemas.UserPasswordUpdate) -> models.User:
    if data.password != data.confirm_password:
        raise ValueError("Passwords do not match")
    user.password = hash_password(data.password)
    return crud.update_user_password(db, user, data)


def update_user_info(db: Session, user: models.User, data: schemas.UserUpdate) -> models.User:
    return crud.update_user(db, user, data)
