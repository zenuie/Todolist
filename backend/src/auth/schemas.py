from typing import Optional

from pydantic import BaseModel, EmailStr, UUID4, field_validator


class User(BaseModel):
    id: UUID4
    username: str
    email: EmailStr

    class Config:
        from_attributes = True


class UserCreate(BaseModel):
    username: str
    email: EmailStr
    password: str
    confirm_password: str

    @field_validator('username', 'password', 'confirm_password')
    def not_empty(cls, v, field):
        if not v or not v.strip():
            raise ValueError(f'{field.field_name} 不能為空')
        return v

    @field_validator('confirm_password')
    def passwords_match(cls, v, values):
        if 'password' in values.data and v != values.data['password']:
            raise ValueError('密碼與確認密碼不一致')
        return v

    class Config:
        from_attributes = True


class UserUpdate(BaseModel):
    username: Optional[str] = None
    email: Optional[EmailStr] = None
    is_active: Optional[bool] = None

    class Config:
        from_attributes = True


class UserPasswordUpdate(BaseModel):
    password: str
    confirm_password: str

    class Config:
        from_attributes = True


class UserLogin(BaseModel):
    username: str
    password: str

    class Config:
        from_attributes = True


class UserLogout(BaseModel):
    id: UUID4
    username: str

    class Config:
        from_attributes = True


class Token(BaseModel):
    access_token: str
    token_type: str
    expires_in: int
    refresh_token: str

    class Config:
        from_attributes = True


class TokenData(BaseModel):
    username: str
    email: EmailStr
    password: str
    confirm_password: str

    class Config:
        from_attributes = True


class RefreshToken(BaseModel):
    token_type: str
    expires_in: int
    refresh_token: str

    class Config:
        from_attributes = True
