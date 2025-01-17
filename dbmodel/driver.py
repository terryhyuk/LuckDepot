from sqlalchemy import Column,String, Integer
from sqlalchemy.ext.declarative import declarative_base


Base = declarative_base()
class Driver(Base) :
    
    __tablename__ = 'driver' # 테이블명
    __table_args__ = {'schema': 'luckydepot'} # 스키마명 

    id = Column(Integer, primary_key=True, autoincrement= True)
    name = Column(String)
    full_time = Column(String)

