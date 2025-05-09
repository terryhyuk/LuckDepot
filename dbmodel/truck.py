from sqlalchemy import Column,String
from sqlalchemy.orm import declarative_base, relationship

Base = declarative_base()
class Truck(Base) :
    
    __tablename__ = 'truck' # 테이블명
    __table_args__ = {'schema': 'luckydepot'} # 스키마명 

    id = Column(String, primary_key=True) 
    poissession = Column(String)

    deliver = relationship("Deliver", back_populates="truck")


