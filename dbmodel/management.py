from sqlalchemy import Column,String, TIMESTAMP, Integer
from sqlalchemy.ext.declarative import declarative_base


Base = declarative_base()
class Management(Base) :
    
    __tablename__ = 'management' # 테이블명
    __table_args__ = {'schema': 'luckydepot'} # 스키마명 

    id = Column(Integer, primary_key=True, autoincrement=True) 
    manage_id = Column(String)
    product_id = Column(Integer) # 외래키 설정 product테이블의 id
    hub_id = Column(Integer) # 외래키 설정 hub 테이블의 id
    quantity = Column(Integer)
    change_date = Column(TIMESTAMP)