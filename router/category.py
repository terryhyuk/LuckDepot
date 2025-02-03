from database.model.product import Product
from database.model.category import Category
from fastapi import APIRouter, Depends, HTTPException, UploadFile, File
from sqlalchemy.orm import Session
from database.conn.connection import db
from starlette.responses import FileResponse
from errors import exceptions as ex
# from static.models import 
import os, shutil

UPLOAD_FOLDER = 'crawling_img'

router = APIRouter()

"""
    get : 조회 // status:200
    post : 생성, 개인정보 조회 // status:201
    put : 수정 //    기존 리소스가 수정된 경우: 200 (OK)
                    전송 성공 후 자원이 생성됬을 경우: 201 (Created)
                    전송은 했지만 전송할 데이터가 없는 경우: 204 (No Content)
    delete : 삭제
"""

# 모든 상품 가져오는 API
@router.get("/", status_code=200)
async def index(session: Session = Depends(db.session)):
    """
    `All Category`\n
    DB에 저장된 모든 Category 정보 가져오기 \n
    :return:
    """
    category = session.query(Category).all()
    return {"result" :category}

# 모든 상품 가져오는 API
@router.post("/", status_code=200)
async def index(category: str=None, session: Session = Depends(db.session)):
    """
    `카테고리 추가하기`\n
    DB에 새로운 Category 입력 \n
    :return:
    """
    new_category = Category(
        name = category
    )
    session.add(new_category)
    session.commit()
    session.refresh(new_category)
    return {"result" :"Upload Success"}
