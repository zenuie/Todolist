# 資料庫url
from sqlalchemy import create_engine
from sqlalchemy.orm import sessionmaker, declarative_base, Session

SQLALCHEMY_DATABASE_URL = "sqlite:///./database.db"

# 使用什麼連線
engine = create_engine(
    SQLALCHEMY_DATABASE_URL, connect_args={"check_same_thread": False}  # sqlite 取消thread
)

# session
SessionLocal = sessionmaker(autocommit=False, autoflush=False, bind=engine)

# declarative base
Base = declarative_base()  # 給model引用


def get_db() -> Session:
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()
