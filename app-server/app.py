# coding: utf-8

from flask import Flask, jsonify, url_for, render_template, send_from_directory
from redis import Redis
import os

from models import CharityItem
from managers import RedisManager

app = Flask(__name__)
redis_manager = RedisManager()

@app.route("/")
def hello():
    data_dict = {"name": "watch"}
    return jsonify(data_dict)

@app.route("/charityitem/<major>/<minor>", methods=["GET"])
def charity_item(major, minor):
    data_dict = redis_manager.get_dict(major, minor)
    return jsonify(data_dict)

@app.route("/charityitems/<major>", methods=["GET"])
def charity_items(major):
    data_dicts = redis_manager.get_dicts(major)
    return jsonify(data_dicts)

@app.route("/image/<name>")
def image(name):
    filename="images/{}".format(name)
    return send_from_directory("static", filename)

def init_test_data():
    # add item1
    item = CharityItem(u"富士山寄付", u"富士山の登山道を改善する", u"富士山の登山道を改善する", "1.png", 3, 12, 1, 2000, 1700)
    dictionary = item.to_dict()
    redis_manager.set_dict(dictionary, item.major, item.minor)

    # add item2
    item = CharityItem(u"水族館存続のために！", u"水族館存続のために！", u"水族館存続のために！", "2.png", 2, 12, 2, 2500, 1700)
    dictionary = item.to_dict()
    redis_manager.set_dict(dictionary, item.major, item.minor)

    # add item3
    item = CharityItem(u"古民家の再活用のために！", u"古民家の再活用のために！", u"古民家の再活用のために！", "3.png", 1, 12, 3, 2000, 1500)
    dictionary = item.to_dict()
    redis_manager.set_dict(dictionary, item.major, item.minor)

    # add item4
    item = CharityItem(u"ゴミを無くして美しい山を取り戻したい！", u"ゴミを無くして美しい山を取り戻したい！", u"ゴミを無くして美しい山を取り戻したい！", "4.png", 4, 12, 4, 2000, 1300)
    dictionary = item.to_dict()
    redis_manager.set_dict(dictionary, item.major, item.minor)

    # add item5
    item = CharityItem(u"お酒作りの美味しい水を守りたい！", u"お酒作りの美味しい水を守りたい！", u"お酒作りの美味しい水を守りたい！", "5.png", 2, 12, 5, 2000, 1100)
    dictionary = item.to_dict()
    redis_manager.set_dict(dictionary, item.major, item.minor)

if __name__ == "__main__":
    init_test_data()
    app.run(host="0.0.0.0", debug=True)
    
