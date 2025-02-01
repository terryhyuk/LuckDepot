from fastapi import APIRouter, Depends
from pydantic import BaseModel
from joblib import load
# from datetime import datetime, date
import router.deliver as deliver
from database.conn.connection import db
from sqlalchemy.orm import Session

router = APIRouter()

# 머신러닝 모델 로드
model = load('./machine_learning/model/cluster_ny_gb.joblib')
# Feature: [['Ship Mode', 'year', 'month', 'Weekday', 'num_Postal Code', 'Hurricane', 'BadWeather']]


def get_prediction_features(order_id, session=Session):
    result = deliver.user_deliver(order_id=order_id, session=session)
    year = result['order_date']['year']
    month = result['order_date']['month']
    weekday = result['order_date']['weekday']
    ship_mode = result['delivery_type']
    address = result['address']
    postal_code = 0
    hurricane = 0
    badweather = 0
    
    return {
        "ship_mode": ship_mode,
        "year": year,
        "month": month,
        "weekday": weekday,
        "postal_code": postal_code,
        "hurricane": hurricane,
        "badweather": badweather
    }
    # year = result['order_date']['year']
    # month = result['order_date']['month']
    # weekday = result['order_date']['weekday']
    # ship_mode = result['delivery_type']

class InputFeatures(BaseModel):
    ship_mode: int
    year: int
    month: int
    weekday: int
    postal_code: int
    hurricane: int
    badweather: int

@router.get("/duration/{order_id}")
async def predict_duration(order_id: str, session : Session = Depends(db.session)):
    features = get_prediction_features(order_id,session=session)
    
    duration = model.predict([[
        features["ship_mode"],
        features["year"],
        features["month"],
        features["weekday"],
        features["postal_code"],
        features["hurricane"],
        features["badweather"]
    ]])
    
    return {"predicted_value": int(duration[0])}