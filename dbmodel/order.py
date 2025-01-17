from sqlalchemy import Column,String, TIMESTAMP, Integer
from sqlalchemy.ext.declarative import declarative_base


Base = declarative_base()
class Order(Base) :
    
    __tablename__ = 'order' # 테이블명
    __table_args__ = {'schema': 'luckydepot'} # 스키마명 

    id = Column(String, primary_key=True) 
    product_id = Column(Integer) # 외래키 설정 product 테이블이 id
    user_seq = Column(Integer) # 외래키 설정 user 테이블의 seq
    address = Column(String)
    order_date = Column(TIMESTAMP)
    order_product = Column(String)