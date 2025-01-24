from database.model.hub import Hub
from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session
from database.conn.connection import db

router =APIRouter()


@router.get('/', status_code=200)
async def hub(session : Session = Depends(db.session)):
    try :
        hubs = session.query(
            Hub.id,
            Hub.name,
            Hub.lat,
            Hub.lng,
            Hub.manager,
            Hub.phone,
            Hub.mail,
            Hub.start_time,
            Hub.end_time
            ).all()
        if not hubs :
            raise HTTPException(status_code=400, detail='hubs not found')
        return {'result' : [
            {
                'id' : hub[0],
                'name' : hub[1],
                'lat' : hub[2],
                'lng' : hub[3],
                'manager' : hub[4],
                'phone' : hub[5],
                'mail' : hub[6],
                'start_time' : hub[7],
                'end_time' : hub[8]
            }
        ]
        for hub in hubs
        }
    except Exception as e:
        return {'result' : e}