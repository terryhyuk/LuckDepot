from database.model.user import User
from database.model.order import Order
from fastapi import APIRouter, Depends
from sqlalchemy.orm import Session
from sqlalchemy import desc, func
from database.conn.connection import db
from datetime import datetime


router = APIRouter()

# 단일 주문 조회
@router.get('/select/{user_seq}')
async def order_select(user_seq : str, session : Session = Depends(db.session)):
    try :
        order = session.query(Order).filter(Order.user_seq == user_seq).all()
        session.close()
        return {'result' : order}
    except Exception as e: 
        print('orders error',e)
        session.close()
        return {'results' : e}
    


@router.get("/select_all")
async def get_orders(session: Session = Depends(db.session)):
    try:
        orders = session.query(
            User.name,
            User.id,
            func.sum(Order.price).label('total_price'),
            func.count(Order.user_seq).label('order_count'),
            func.max(Order.order_date).label('recent_order_date') ,
            func.sum(func.sum(Order.price)).over().label('total_sum'),
            func.avg(func.sum(Order.price)).over().label('total_avg')
        ).join(
            User,
            Order.user_seq == User.seq
        ).group_by(
            Order.user_seq,
            User.seq
        ).order_by(
            desc('total_price')
        ).all()
        
        return { "result": 
                [
                    {
                    "user_seq": order[0],
                    "user_name": order[1],
                    "total_price": order[2],
                    'order_count' : order[3],
                    'recent_order_date' : order[4].strftime('%Y-%m-%d')
                    }
                for order in orders
                ],
                'sum': orders[0][5],
                'avg' : round(orders[0][6])
            }
    except Exception as e:
        session.close()
        print(e)
        return {'result' : e}


@router.get('/insert')
async def insert(session : Session = Depends(db.session), id : str = None, user_seq : int = None, payment_type : str = None, price : int = None, address : str = None, order_product : str = None ):
    try :
        new_order = Order(
            id  = id,
            user_seq = user_seq,
            payment_type = payment_type,
            price = price,
            address = address,
            order_date = datetime.now(),
            order_product  = order_product
        )
        session.add(new_order)
        session.commit()
        session.close()
        return {'result' : 'ok'}
    except Exception as e:
        print(e)
        session.close()
        return {'result' : e}


@router.delete('/delete')
async def delete(session : Session = Depends(db.session), order_id : str = None):
    try :
        order = session.query(Order).filter(Order.id == order_id).first()
        if not order :
            print('주문내역이 없습니다.')
            return {'result' : '주문내역이 없습니다'}
        session.delete(order)
        session.commit()
        session.close()
        return {'result' : 'ok'}
    except Exception as e:
        print('주문 삭제 에러' , e)
        session.close()
        return {'result' : e}



