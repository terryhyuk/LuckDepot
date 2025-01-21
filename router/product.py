from database.model.product import Product
from database.model.category import Category
from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session
from database.conn.connection import db
from starlette.responses import JSONResponse
from errors import exceptions as ex
from static.models import ProductCreate


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
    `All Product`\n
    DB에 저장된 모든 Product 정보 가져오기 \n
    :return:
    """
    product = session.query(Product).all()
    return {"result" :product}

# 상품 하나의 정보 가져오는 API
@router.get("/{product_id}", status_code=200)
async def get_product_detail(product_id: int, session: Session = Depends(db.session)):
    """
    `Product by ID`\n
    ID와 일치하는 Product 정보 가져오기 \n
    :return:
    """
    product = session.query(Product).filter(Product.id == product_id).first()
    return {"result" :product}

# 새로운 상품을 등록하는 API
@router.post("/", status_code=201)
async def create_product(product: ProductCreate, session: Session = Depends(db.session)):
    """
    `상품 등록`\n
    서비스에 새로운 상품 등록 \n
    """
    try:
        # category_id 유효성 확인
        category = session.query(Category).filter(Category.id == product.category_id).first()
        if not category:
            raise HTTPException(status_code=400, detail="Invalid category_id. Category not found.")

        # 새로운 Product 생성
        new_product = Product(
            name=product.name,
            price=product.price,
            image=product.image,
            quantity=product.quantity,
            category_id=product.category_id
        )
        session.add(new_product)
        session.commit()
        session.refresh(new_product)

        return {"result": "생성이 성공적으로 완료되었습니다."}
    
    except Exception as e:
        import traceback
        traceback.print_exc()  # 전체 예외 출력
        raise HTTPException(status_code=500, detail=str(e))  # 원래 에러 메시지 반환




# 상품 재고 수정하는 API
@router.put("/{product_id}")
async def update_product_quantity(product_id: int, quantity: int, session: Session = Depends(db.session)):
    """
    `재고 수정`\n
    ID와 일치하는 Product quantity 수정하기 \n
    :return:
    """
    try:
        product = session.query(Product).filter(Product.id == product_id).first()
        if not product:
            raise ex.UpdateDataNotFoundEx() 

        product.quantity = quantity
        session.commit()
        session.refresh(product) 
        return {"result": "수정이 성공적으로 완료되었습니다."}
    
    except ex.APIException as api_ex:
        raise api_ex
    
    except Exception as e:
        raise ex.SqlFailureEx(ex=e)
    

@router.delete("/{product_id}")
async def remove_product(product_id: int, session: Session = Depends(db.session)):
    """
    `상품 삭제`\n
    ID와 일치하는 Product 삭제하기 \n
    :return:
    """
    try:
        product = session.query(Product).filter(Product.id == product_id).first()
        if not product:
            raise ex.DeleteDataNotFoundEx() 

        # 데이터 삭제
        session.delete(product)
        session.commit()
        return {"result": "삭제가 성공적으로 완료되었습니다."}
    
    except ex.APIException as api_ex:
        raise api_ex
    
    except Exception as e:
        raise ex.SqlFailureEx(ex=e)
