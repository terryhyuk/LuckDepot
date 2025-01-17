from sqlalchemy import Column,String, Integer
from sqlalchemy.ext.declarative import declarative_base


Base = declarative_base()
class User(Base) :
    
    __tablename__ = 'user' # 테이블명
    __table_args__ = {'schema': 'luckydepot'} # 스키마명 

    seq = Column(Integer, primary_key=True, autoincrement=True)
    id = Column(String)
    name = Column(String)
    login_type = Column(String)

