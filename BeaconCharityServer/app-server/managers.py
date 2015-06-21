# coding: utf-8

from __future__ import division
from redis import Redis

class RedisManager(object):
    KEY_PREFIX = "BeaconCharity"

    def __init__(self):
        self.redis_instance = Redis(host="redismaster", port=6379)

    def _generate_key(self, *args):
        key_part = "-".join([str(item) for item in args])
        return "-".join([self.KEY_PREFIX, key_part])
        
    def set_dict(self, data_dict, *args):
        key = self._generate_key(*args)
        self.redis_instance.hmset(key, data_dict)

    def get_dict(self, *args):
        key = self._generate_key(*args)
        return self.redis_instance.hgetall(key)

    def get_dicts(self, major):
        keys = self.redis_instance.keys()
        
        result = []
        for key in keys:
            result.append(self.redis_instance.hgetall(key))
            
        # sort by accomplishment_rate
        sorted_result = sorted(result, key=lambda k: int(k["actual_money"]) / int(k["objective_money"]), reverse=True)
        
        return sorted_result
