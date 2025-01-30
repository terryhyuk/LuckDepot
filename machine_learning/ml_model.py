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
