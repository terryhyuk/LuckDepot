from fastapi import APIRouter
from pydantic import BaseModel
from joblib import load
from datetime import datetime, date

router = APIRouter()

# 머신러닝 모델 로드
model = load('./model/cluster_ny_gb.joblib')
# Feature: [['Ship Mode', 'year', 'month', 'Weekday', 'num_Postal Code', 'Hurricane', 'BadWeather']]



class InputFeatures(BaseModel):
    ship_mode: int
    year: int
    month: int
    weekday: int
    postal_code: int
    hurricane: int
    badweather: int

@router.get("/duration")
async def predict(    
    ship_mode: int,
    year: int,
    month: int,
    weekday: int,
    postal_code: int,
    hurricane: int,
    badweather: int
):
    features = [[
        ship_mode,
        year,
        month,
        weekday,
        postal_code,
        hurricane,
        badweather
    ]]
    
    duration = model.predict(features)
    return {"predicted_value": int(duration[0])}
    

# def getDateInfo(selectDate:datetime):
#     """
#     날짜 정보를 리턴하는 함수
#     Parameter : datetime
#     return : 연도, 월, 일, 요일, 시간, 공휴일
#     """
#     # 데이터 추출
#     y = selectDate.year  # 연도
#     m = selectDate.month  # 월
#     d = selectDate.day  # 일
#     w = selectDate.weekday() # 요일
#     # 한국 공휴일 설정
#     weekend = 1 if selectDate.weekday() >= 5 else 0,
#     return (y,m,d,w,weekend)