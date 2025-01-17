from sqlalchemy import Column,String, TIMESTAMP, Integer
from sqlalchemy.ext.declarative import declarative_base


Base = declarative_base()
class Deliver(Base) :
    
    __tablename__ = 'deliver' # 테이블명
    __table_args__ = {'schema': 'luckydepot'} # 스키마명 

    id = Column(String, primary_key=True)
    pay_id = Column(String) # 외래키 설정 pay 테이블 id
    hub_id = Column(Integer) # 외래키 설정 hub 테이블 id
    truck_id = Column(String) # 외래키 설정 truck 테이블 id
    delivery_status = Column(String) 
    status_date = Column(TIMESTAMP)

