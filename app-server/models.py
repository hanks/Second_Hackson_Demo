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
            "price": self.price,
            "description": self.description,
            "image_url": self.image_url,
            "minor": self.minor,
            "major": self.major,
            "priority": self.priority,
        }

    @classmethod
    def from_dict(cls, json_data):
        name = json_data["name"]
        price = int(json_data["price"])
        description = json_data["description"]
        image_url = json_data["image_url"]
        minor = int(json_data["minor"])
        major = int(json_data["major"])
        priority = int(json_data["priority"])

        return cls(name, price, description, image_url, major, minor, priority)

