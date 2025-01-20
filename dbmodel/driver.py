from sqlalchemy import Column,String, Integer
from sqlalchemy.orm import declarative_base, relationship


Base = declarative_base()
class Driver(Base) :
    
    __tablename__ = 'driver' # 테이블명
    __table_args__ = {'schema': 'luckydepot'} # 스키마명 

    seq = Column(Integer, primary_key=True ,autoincrement=True)
    id = Column(Integer)
    name = Column(String)
    password = Column(String)
    full_time = Column(String)

    # deliver = relationship("Deliver", back_populates="driver")

