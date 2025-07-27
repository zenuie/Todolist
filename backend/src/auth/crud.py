import uuid
from sqlalchemy.orm import Session
from src.auth import models, schemas


# ------------Create-----------------


def create_user(db: Session, user: models.User) -> models.User:
    db.add(user)
    db.commit()
    db.refresh(user)

    return user


# ------------Create-----------------


# -------------Read------------------
def get_user(db: Session, user_id: uuid.UUID) -> models.User | None:
    return db.query(models.User).filter(models.User.id == user_id).first()


def get_user_by_email(db: Session, email: str) -> models.User | None:
    return db.query(models.User).filter(models.User.email == email).first()


def get_user_by_username(db: Session, username: str) -> models.User | None:
    return db.query(models.User).filter(models.User.username == username).first()


# -------------Read------------------


# ------------Update-----------------
def update_user(db: Session, user: models.User, update_data: schemas.UserUpdate) -> models.User:
    data = update_data.model_dump(exclude_unset=True)
    for key, value in data.items():
        setattr(user, key, value)

    db.add(user)
    db.commit()
    db.refresh(user)
    return user


def update_user_password(db: Session, user: models.User, update_data: schemas.UserPasswordUpdate) -> models.User:
    data = update_data.model_dump(exclude_unset=True)
    for key, value in data.items():
        setattr(user, key, value)
    db.add(user)
    db.commit()
    db.refresh(user)
    return user


# ------------Update-----------------


# ------------Delete-----------------
def delete_user(db: Session, user_id: uuid.UUID) -> None:
    db.query(models.User).filter(models.User.id == user_id).delete()
# ------------Delete-----------------
