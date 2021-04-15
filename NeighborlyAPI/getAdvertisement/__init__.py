import azure.functions as func
import logging
import json
import os
import pymongo
from bson.json_util import dumps
from bson.objectid import ObjectId

def main(req: func.HttpRequest) -> func.HttpResponse:

    # example call http://localhost:7071/api/getAdvertisement/?id=5eb6cb8884f10e06dc6a2084

    id = req.params.get('id')
    print("--------------->", id)
    
    if id:
        try:
            url = os.environ['ConnectionStrings']
            client = pymongo.MongoClient(url)
            database = client['mongodb20210411']
            collection = database['adcollection20210411']
            query = {'_id': ObjectId(id)}
            result = collection.find_one(query)
            print(result)
            print("----------result--------")
            result = dumps(result)
            print(result)
            return func.HttpResponse(result, mimetype="application/json", charset='utf-8')
        except Exception as e:
            logging.error(e)   
            return func.HttpResponse("Database connection error.", status_code=500)

    else:
        return func.HttpResponse("Please pass an id parameter in the query string.", status_code=400)