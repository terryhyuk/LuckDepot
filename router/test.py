from database.model.order import Order
from database.model.product import Product
from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session
from database.conn.connection import db
from starlette.responses import JSONResponse
from datetime import datetime
from sqlalchemy import func, cast, Integer, String,asc
from datetime import datetime, timedelta
from dateutil.relativedelta import relativedelta

router = APIRouter()

@router.get("/", status_code=200)
async def index(session: Session = Depends(db.session)):
    start_time = datetime.now()  # 요청 시작 시간 기록
    product = session.query(Product).all()


    return product


@router.get('/test1', status_code=200)
async def test(session : Session = Depends(db.session)):
    weekday_sales = session.query(
    func.to_char(Order.order_date, 'D').label('weekday'),  # 요일 추출 (1-7)
    func.sum(Order.price).label('weekday_sales')  # 요일별 매출
    ).filter(
        # 현재 날짜 기준 최근 3개월 데이터 필터링
        cast(func.substring(Order.id, 1, 4), Integer) >= 2501,  # 25년 1월부터
        cast(func.substring(Order.id, 1, 4), Integer) <= 2502   # 25년 2월까지
    ).group_by(
        func.to_char(Order.order_date, 'D')  # 요일별 그룹화
    ).order_by(
        func.to_char(Order.order_date, 'D')  # 요일순 정렬
    ).all()
    if not weekday_sales :
        raise HTTPException(status_code=400, detail='month_sales not found')
    return {'result' : 
                    {
                        "weekday_sales":[
                        {
                            'weekday' : sales[0],
                            'sales' : sales[1],
                        }
                        for sales in weekday_sales
                    ]
                    }
                }






@router.get('/test2', status_code=200)
async def test(session: Session = Depends(db.session)):
    # 현재 날짜 기준으로 이번달과 3개월 전 계산
    current_date = datetime.now()
    weekday_sales = session.query(
            # 요일 추출 (0~6)
            ((cast(func.extract('dow', Order.order_date), Integer) + 6) % 7).label('weekday'),
            func.sum(Order.price).label('daily_sales'),
        ).filter(
            cast(func.substring(Order.id, 1, 4), String).between(
                (current_date - relativedelta(months=3)).strftime('%y%m'),  # 3개월전 년 월
                current_date.strftime('%y%m') # 현재 년 월
            )
        ).group_by(
            func.extract('dow', Order.order_date)
        ).order_by(
            asc('weekday')
        ).all()

    if not weekday_sales:
        raise HTTPException(status_code=400, detail='weekday_sales not found')
    
    return {'result': {
        "weekday_sales": [
            {
                'weekday': sales[0],  # 0(월요일) ~ 6(일요일)
                'sales': sales[1],
            }
            for sales in weekday_sales
        ]
    }}
