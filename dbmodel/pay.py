from sqlalchemy import Column,String, TIMESTAMP,Integer
from sqlalchemy.ext.declarative import declarative_base


Base = declarative_base()
class Pay(Base) :
    
    __tablename__ = 'pay' # 테이블명
    __table_args__ = {'schema': 'luckydepot'} # 스키마명 

    id = Column(String, primary_key=True) 
    order_id = Column(String) # 외래키 설정
    payment_type = Column(String)
    price = Column(Integer)
    payment_date = Column(TIMESTAMP)