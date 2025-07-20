import os
import uuid

from dotenv import load_dotenv
from fastapi import Depends, HTTPException, status
from fastapi.security import OAuth2PasswordBearer
from jose import JWTError, jwt
from sqlalchemy.orm import Session

from src.database import get_db
from src.auth import crud, models, ENV_PATH

# OAuth2PasswordBearer 是 FastAPI 的 token 抽取器
oauth2_scheme = OAuth2PasswordBearer(tokenUrl="token")

load_dotenv(dotenv_path=ENV_PATH)
# 你應該設定這些值為環境變數
SECRET_KEY = os.getenv("SECRET_KEY")
ALGORITHM = os.getenv("ALGORITHM")


def get_user_from_token(token: str, db: Session) -> models.User:
    try:
        payload = jwt.decode(token, SECRET_KEY, algorithms=[ALGORITHM])
        user_id = payload.get("sub")
        if user_id is None:
            raise
    except JWTError:
        raise

    user_id = uuid.UUID(user_id)  # to uuid
    user = crud.get_user(db, user_id=user_id)
    if user is None:
        raise
    return user


def get_current_user(
        token: str = Depends(oauth2_scheme),
        db: Session = Depends(get_db)
) -> models.User:
    return get_user_from_token(token, db)
