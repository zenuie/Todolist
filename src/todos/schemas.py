from pydantic import BaseModel, UUID4


class Todo(BaseModel):
    title: str | None = None
    text: str | None = None
    completed: bool | None = None
    description: str | None = None

    class Config:
        from_attributes = True


class TodoGet(BaseModel):
    class Config:
        from_attributes = True


class TodoCreate(BaseModel):
    user_id: UUID4
    title: str
    description: str

    class Config:
        from_attributes = True


class TodoUpdate(BaseModel):
    user_id: UUID4
    title: str
    description: str
    completed: bool

    class Config:
        from_attributes = True


class TodoDelete(BaseModel):
    user_id: UUID4
    todo_id: UUID4

    class Config:
        from_attributes = True
