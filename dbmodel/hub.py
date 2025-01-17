
from sqlalchemy import Column,String, Double, Integer
from sqlalchemy.orm import declarative_base, relationship


Base = declarative_base()
class Hub(Base) :
    
    __tablename__ = 'hub' # 테이블명
    __table_args__ = {'schema': 'luckydepot'} # 스키마명 

    id = Column(Integer, primary_key=True, autoincrement=True) 
    name = Column(String)
    lat = Column(Double)
    lng = Column(Double)
    
    deliver = relationship("Deliver", back_populates="hub")
    managements = relationship("Management", back_populates="hub")


