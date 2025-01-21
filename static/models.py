from datetime import datetime
from enum import Enum

from pydantic import Field
from pydantic.main import BaseModel
from pydantic.networks import EmailStr


class UserRegister(BaseModel):
    # pip install 'pydantic[email]'
    email: EmailStr = None
    pw: str = None

class AdminLogin(BaseModel):
    # pip install 'pydantic[email]'
    id: str = None
    pw: str = None

    class Config:
        from_attributes = True


class SnsType(str, Enum):
    email: str = "email"
    facebook: str = "facebook"
    google: str = "google"
    kakao: str = "kakao"


class Token(BaseModel):
    Authorization: str = None


class MessageOk(BaseModel):
    message: str = Field(default="OK")


class UserToken(BaseModel):
    id: str
    pw: str = None
    # email: str = None
    # name: Optional[str] = Field(None, description="User's name")
    # phone_number: Optional[str] = Field(None, description="User's phone number")
    # profile_img: Optional[str] = Field(None, description="Profile image URL")

    class Config:
        from_attributes = True


