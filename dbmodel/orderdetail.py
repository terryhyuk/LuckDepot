from sqlalchemy import Column,String,Integer, ForeignKey
from sqlalchemy.orm import declarative_base, relationship


Base = declarative_base()
class OrderDetail(Base) :
    
    __tablename__ = 'orderdetail' # 테이블명
    __table_args__ = {'schema': 'luckydepot'} # 스키마명 

    id = Column(String, primary_key=True) 
    user_seq = Column(Integer,ForeignKey('user.seq')) # 외래키 user seq
    product_id = Column(Integer, ForeignKey('product.id')) # 외래키 product id
    price = Column(Integer)
    quantity = Column(Integer) 

    # user = relationship("User", back_populates="orderdetail")
    # product = relationship("Product", back_populates="orderdetail")
