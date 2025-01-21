from database.model.user import User
from fastapi import APIRouter, Depends
from sqlalchemy.orm import Session
from database.conn.connection import db
from starlette.responses import JSONResponse
from datetime import datetime

router = APIRouter()

@router.get("/", status_code=200)
async def index(session: Session = Depends(db.session)):
    start_time = datetime.now()  # 요청 시작 시간 기록
    user = User(id='jangbee', name='장비', login_type='google')
    session.add(user)
    session.commit()
    session.close()
    current_time = datetime.now()

    # 요청 소요 시간 계산
    elapsed_time = (datetime.now() - start_time).total_seconds()

    return JSONResponse(
        status_code=200,
        content=dict(
            msg="SUCCESS",
            current_time=current_time.strftime('%Y.%m.%d %H:%M:%S'),
            elapsed_time=f"{elapsed_time:.3f} seconds"
        )
    )
