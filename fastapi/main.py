from sqlalchemy import create_engine, MetaData, Table, Column, Integer, String
from sqlalchemy.orm import sessionmaker
from dbmodel.user import User
from fastapi import FastAPI
engine = create_engine('postgresql://postgres:qwer1234@192.168.50.38:5432/postgres') # 연결
# postgresql://유저이름:비밀번호@ip주소:port/데이터베이스이름


app = FastAPI()

# Select
@app.get("/test")
async def select():
    Session = sessionmaker(bind=engine)
    session = Session()
    users = session.query(User).all() 
    for user in users :
        print(user.name) 


# with 종료시 알아서 연결 종료
# def withSelect():
#     with Session() as session :
#         users = session.query(User).all()
#         for user in users :
#             print(user.id, user.name, user.login_type)





if __name__ == "__main__":
    import uvicorn 
    uvicorn.run(app=app, host='0.0.0.0', port=8000)