from sqlalchemy import Column,String, Integer
from sqlalchemy.orm import declarative_base, relationship


Base = declarative_base()
class Product(Base) :
    
    __tablename__ = 'product' # 테이블명
    __table_args__ = {'schema': 'luckydepot'} # 스키마명 

    id = Column(Integer, primary_key=True, autoincrement=True)
    name = Column(String)
    price = Column(Integer)
    image = Column(String)
    quantity = Column(Integer)

    # orderdetail = relationship("OrderDetail", back_populates="product")
    # management = relationship("Management", back_populates="product")


