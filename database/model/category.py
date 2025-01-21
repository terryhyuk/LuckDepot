from sqlalchemy import Column,String, TIMESTAMP, Integer, ForeignKey
from sqlalchemy.orm import declarative_base,relationship


Base = declarative_base()
class Category(Base) :
    
    __tablename__ = 'category' # 테이블명
    __table_args__ = {'schema': 'luckydepot'} # 스키마명 

    id = Column(Integer, primary_key=True, nullable=False, autoincrement=True)
    name = Column(String)

    product = relationship("Product", back_populates="category")

