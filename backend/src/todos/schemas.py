from pydantic import BaseModel, UUID4


class Todo(BaseModel):
    id: UUID4
    title: str | None = None
    description: str | None = None
    complete: bool | None = None
    sort: int | None = None

    class Config:
        from_attributes = True


class TodoGet(BaseModel):
    class Config:
        from_attributes = True


class TodoCreate(BaseModel):
    title: str
    description: str
    sort: int

    class Config:
        from_attributes = True


class TodoUpdate(BaseModel):
    id: UUID4
    title: str
    description: str
    complete: bool
    sort: int

    class Config:
        from_attributes = True


class TodoDelete(BaseModel):
    user_id: UUID4
    todo_id: UUID4

    class Config:
        from_attributes = True
