# coding: utf-8

class CharityItem(object):
    def __init__(self, name, short_desc, long_desc, image_name, rating, major, minor, objective_money, actual_money):
        self.name = name
        self.short_desc = short_desc
        self.long_desc = long_desc
        self.image_name = image_name
        self.rating = rating
        self.minor = minor
        self.major = major
        self.objective_money = objective_money
        self.actual_money = actual_money

    def to_dict(self):
        return {
            "name": self.name,
            "short_desc": self.short_desc,
            "long_desc": self.long_desc,
            "image_name": self.image_name,
            "minor": self.minor,
            "major": self.major,
            "rating": self.rating,
            "objective_money": self.objective_money,
            "actual_money": self.actual_money,
        }

    @property
    def accomplishment_rate(self):
        return self.actual_money / self.objective_money

    @classmethod
    def from_dict(cls, json_data):
        name = json_data["name"]x
        short_desc = int(json_data["short_desc"])
        long_desc = json_data["long_desc"]
        image_name = json_data["image_name"]
        minor = int(json_data["minor"])
        major = int(json_data["major"])
        rating = int(json_data["rating"])
        objective_money = int(json_data["objective_money"])
        actual_money = int(json_data["actual_money"])

        return cls(name, short_desc, long_desc, image_name, rating, major, minor, objective_money, actual_money)

