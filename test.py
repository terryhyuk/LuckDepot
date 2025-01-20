from sqlalchemy import create_engine, MetaData, Table, Column, Integer, String
from sqlalchemy.orm import sessionmaker
from dbmodel.user import User
from dbmodel.category import Category
engine = create_engine('postgresql://postgres:qwer1234@192.168.50.38:5432/postgres') # 연결
# postgresql://유저이름:비밀번호@ip주소:port/데이터베이스이름

Session = sessionmaker(bind=engine)
session = Session()

# Select
def select():
    categorys = session.query(Category).all() 
    for category in categorys :
        print(category.name) 


# with 종료시 알아서 연결 종료
# def withSelect():
#     with Session() as session :
#         users = session.query(User).all()
#         for user in users :
#             print(user.id, user.name, user.login_type)





# Insert
def insert():
    newuser = Category(name = 'Chair')
    session.add(newuser)
    session.commit()
insert()

# # Delete 
# def delete():
#     session.query(User).filter_by(id = 'yubee123').delete()
#     session.commit()
#     session.close()

# # update
# # user = session.query(User).filter_by(id = 'kwanwoo123').first()
# # user.name = '김관우'
# # session.commit()

