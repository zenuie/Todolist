from fastapi import FastAPI

from src import middleware
from src.auth.routers import router as auth_router
from src.todos.routers import router as todo_router

app = FastAPI()

app.include_router(auth_router)
app.include_router(todo_router)

app.add_middleware(middleware_class=middleware.AuthMiddleware)
