from pathlib import Path

from fastapi import HTTPException, status, Request
from argon2 import PasswordHasher
import datetime
import os

from dotenv import load_dotenv
from jose import jwt

from src.auth import ENV_PATH

load_dotenv(dotenv_path=ENV_PATH)
ph = PasswordHasher()


def hash_password(raw_password: str) -> str:
    hashed_password = ph.hash(raw_password)
    return hashed_password


def verify_password(raw_password: str, hashed_password: str) -> bool:
    try:
        return ph.verify(hashed_password, raw_password)
    except Exception as e:
        print("驗證失敗：", str(e))
        return False


SECRET_KEY: str = os.getenv("SECRET_KEY")
ALGORITHM: str = os.getenv("ALGORITHM")
ACCESS_TOKEN_EXPIRE_MINUTES: int = int(os.getenv("ACCESS_TOKEN_EXPIRE_MINUTES", 30))
REFRESH_TOKEN_EXPIRE_DAYS: int = int(os.getenv("REFRESH_TOKEN_EXPIRE_DAYS", 30))


def create_access_token(data: dict, expires_delta: datetime.timedelta = None):
    to_encode = data.copy()
    expire = datetime.datetime.now(datetime.timezone.utc) + (expires_delta or datetime.timedelta(minutes=ACCESS_TOKEN_EXPIRE_MINUTES))
    to_encode.update({"exp": expire.timestamp()})  # JWT 要的是數字 timestamp

    return jwt.encode(to_encode, SECRET_KEY, algorithm=ALGORITHM)


def refresh_access_token(data: dict, expires_delta: datetime.timedelta = None):
    to_encode = data.copy()
    expire = datetime.datetime.now(datetime.timezone.utc) + (expires_delta or datetime.timedelta(days=ACCESS_TOKEN_EXPIRE_MINUTES))
    to_encode.update({"exp": expire.timestamp()})  # JWT 要的是數字 timestamp
    return jwt.encode(to_encode, SECRET_KEY, algorithm=ALGORITHM)
