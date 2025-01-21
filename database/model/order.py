from sqlalchemy import Column,String, TIMESTAMP, Integer, VARCHAR, ForeignKey
from sqlalchemy.orm import relationship
from database.model.base import Base
class Order(Base) :
    
    __tablename__ = 'order' # 테이블명
    __table_args__ = {'schema': 'luckydepot'} # 스키마명 

    id = Column(VARCHAR, primary_key=True) 
    user_id = Column(Integer, ForeignKey('luckydepot.user.id')) # 외래키 user id
    payment_type = Column(String)
    price = Column(Integer)
    address = Column(String)
    order_date = Column(TIMESTAMP)
    order_product = Column(String)
    
    user = relationship("User", back_populates="order") # 관계 표시, sql쿼리 없이 관련된 테이블 접근 가능,  데이터 동기화

